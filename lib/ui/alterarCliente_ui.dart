import 'package:cpfcnpj/cpfcnpj.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:brasil_fields/brasil_fields.dart';
import 'package:peca_certa_app/controller/clienteController.dart';
import 'package:peca_certa_app/models/Cliente.dart';
import 'package:peca_certa_app/models/Endereco.dart';
import 'package:peca_certa_app/ui/clientes_ui.dart';

class AlterarClienteTela extends StatefulWidget {
  @override
  _AlterarClienteTelaState createState() => _AlterarClienteTelaState();
  AlterarClienteTela({this.idCliente});
  final Cliente idCliente;
}

class _AlterarClienteTelaState extends State<AlterarClienteTela> {
  ClienteController clienteController = new ClienteController();
  Cliente cliente = Cliente();
  Endereco enderecoCliente = Endereco();

  //Chave de identificação do Form e controllers dos texts fields
  GlobalKey<FormState> _formKeyCliente = GlobalKey<FormState>();

  //Controle checkbox
  bool _selPF, _selPJ;

  //Mostra Calendario

  @override
  void initState() {
    if (widget.idCliente.tipoCliente == "PESSOA_FISICA") {
      _selPF = true;
      _selPJ = false;
    } else if (widget.idCliente.tipoCliente == "PESSOA_JURIDICA") {
      _selPJ = true;
      _selPF = false;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    TextEditingController _campoNomeCliente =
        TextEditingController(text: widget.idCliente.nome);
    TextEditingController _campoCPFCNPJ = TextEditingController(
        text: widget.idCliente.tipoCliente == 'PESSOA_FISICA'
            ? UtilBrasilFields.obterCpf(widget.idCliente.cpfCnpj)
            : UtilBrasilFields.obterCnpj(widget.idCliente.cpfCnpj));
    String _data;
    TextEditingController _dataText = TextEditingController(
        text: widget.idCliente.dataNascFund.substring(8, 10) +
            "/" +
            widget.idCliente.dataNascFund.substring(5, 7) +
            "/" +
            widget.idCliente.dataNascFund.substring(0, 4));
    TextEditingController _campoEmailCliente =
        TextEditingController(text: widget.idCliente.email);
    TextEditingController _campoTelefoneCliente = TextEditingController(
        text: UtilBrasilFields.obterTelefone(widget.idCliente.telefone));
    TextEditingController _campoLogradouroCliente =
        TextEditingController(text: widget.idCliente.endereco.logradouro);
    TextEditingController _campoNumeroCliente =
        TextEditingController(text: widget.idCliente.endereco.numero);
    TextEditingController _campoComplementoCliente =
        TextEditingController(text: widget.idCliente.endereco.complemento);
    TextEditingController _campoBairroCliente =
        TextEditingController(text: widget.idCliente.endereco.bairro);
    TextEditingController _campoCidadeCliente =
        TextEditingController(text: widget.idCliente.endereco.cidade);
    TextEditingController _campoEstadoCliente =
        TextEditingController(text: widget.idCliente.endereco.estado);
    TextEditingController _campoCEPCliente =
        TextEditingController(text: widget.idCliente.endereco.cep);

    AlertDialog alert = AlertDialog(
      title: Text("Confirmação"),
      content: Text("Deseja confirmar a alteração do cliente?"),
      actions: [
        TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text("Cancelar")),
        TextButton(
            onPressed: () async {
              await clienteController.alterarCliente(cliente);
              Navigator.pop(context);
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => ClienteTela()));
            },
            child: Text("Confirmar"))
      ],
    );
    return Scaffold(
      appBar: AppBar(
        title: Text("Detalhes do Cliente"),
        centerTitle: true,
        backgroundColor: Theme.of(context).primaryColor,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: <Widget>[
          GestureDetector(
            child: Container(
              padding: EdgeInsets.only(right: 20),
              child: Icon(Icons.check_rounded),
            ),
            onTap: () async {
              if (_formKeyCliente.currentState.validate()) {
                cliente.codigo = widget.idCliente.codigo;
                cliente.ativo = true;
                cliente.nome = _campoNomeCliente.text;
                _selPF == true
                    ? cliente.tipoCliente = "PESSOA_FISICA"
                    : cliente.tipoCliente = "PESSOA_JURIDICA";

                if (_selPF == true && CPF.isValid(_campoCPFCNPJ.text)) {
                  cliente.cpfCnpj = _campoCPFCNPJ.text.substring(0, 3) +
                      _campoCPFCNPJ.text.substring(4, 7) +
                      _campoCPFCNPJ.text.substring(8, 11) +
                      _campoCPFCNPJ.text.substring(12, 14);
                } else if (_selPJ == true && CNPJ.isValid(_campoCPFCNPJ.text)) {
                  cliente.cpfCnpj = _campoCPFCNPJ.text.substring(0, 2) +
                      _campoCPFCNPJ.text.substring(3, 6) +
                      _campoCPFCNPJ.text.substring(7, 10) +
                      _campoCPFCNPJ.text.substring(11, 15) +
                      _campoCPFCNPJ.text.substring(16, 18);
                }
                if (_data != null) {
                  cliente.dataNascFund = _data;
                } else {
                  cliente.dataNascFund =
                      widget.idCliente.dataNascFund.substring(0, 4) +
                          "-" +
                          widget.idCliente.dataNascFund.substring(5, 7) +
                          "-" +
                          widget.idCliente.dataNascFund.substring(8, 10);
                }

                cliente.email = _campoEmailCliente.text;

                cliente.telefone = UtilBrasilFields.extrairTelefone(
                    _campoTelefoneCliente.text);

                enderecoCliente.logradouro = _campoLogradouroCliente.text;

                enderecoCliente.numero = _campoNumeroCliente.text;

                enderecoCliente.complemento = _campoComplementoCliente.text;

                enderecoCliente.bairro = _campoBairroCliente.text;

                enderecoCliente.cep = _campoCEPCliente.text;

                enderecoCliente.cidade = _campoCidadeCliente.text;

                enderecoCliente.estado = _campoEstadoCliente.text;

                cliente.endereco = enderecoCliente;

                showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return alert;
                    });
              }
            },
          ),
        ],
      ),
      body: Form(
        key: _formKeyCliente,
        child: SingleChildScrollView(
            padding: EdgeInsets.all(15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 20,
                ),
                Text("Tipo Cliente:"),
                Row(
                  children: <Widget>[
                    Text("Pessoa Física"),
                    Checkbox(
                        value: _selPF,
                        onChanged: (bool isMarked) {
                          setState(() {
                            _selPF = isMarked;
                            _selPF == true ? _selPJ = false : _selPJ = false;
                          });
                        }),
                    Text(
                      "Pessoa Jurídica ",
                    ),
                    Checkbox(
                        value: _selPJ,
                        onChanged: (bool isMarked) {
                          setState(() {
                            _selPJ = isMarked;
                            _selPJ == true ? _selPF = false : _selPF = false;
                          });
                        })
                  ],
                ),
                Row(
                  children: <Widget>[],
                ),
                TextFormField(
                  controller: _campoNomeCliente,
                  validator: (value) {
                    return value.isNotEmpty ? null : "Campo Obrigatório.";
                  },
                  decoration: InputDecoration(
                      hintText: _selPJ ? "Razão Social" : "Nome Completo"),
                  maxLength: 60,
                ),
                TextFormField(
                  controller: _campoCPFCNPJ,
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    _selPJ == true ? CnpjInputFormatter() : CpfInputFormatter(),
                  ],
                  validator: (value) {
                    return value.isNotEmpty ? null : "Campo Obrigatório";
                  },
                  maxLength: _selPJ == true ? 18 : 14,
                  decoration: InputDecoration(
                      hintText: _selPJ == true ? "CNPJ" : "CPF"),
                ),
                Row(
                  children: <Widget>[
                    Text(_selPJ == true
                        ? "Data de Fundação: "
                        : "Data de Nascimento: "),
                    IconButton(
                        icon: Icon(Icons.date_range),
                        onPressed: () async {
                          final data = await showDatePicker(
                              context: context,
                              initialDate: DateTime.now(),
                              firstDate: DateTime(1900),
                              lastDate: DateTime.now(),
                              builder: (BuildContext context, Widget child) {
                                return Theme(
                                  data: ThemeData.light().copyWith(
                                    colorScheme: ColorScheme.light().copyWith(
                                      primary: Theme.of(context).primaryColor,
                                    ),
                                  ),
                                  child: child,
                                );
                              });

                          if (data != null) {
                            final _newData =
                                DateFormat('yyyy-MM-dd').format(data);
                            _data = _newData;
                            _dataText.text = UtilData.obterDataDDMMAAAA(data);
                          }
                        }),
                    Container(
                      width: 150,
                      child: TextField(
                        decoration: InputDecoration(border: InputBorder.none),
                        controller: _dataText,
                        readOnly: true,
                      ),
                    )
                  ],
                ),
                TextFormField(
                  controller: _campoEmailCliente,
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    return value.isNotEmpty ? null : "Campo Obrigatório.";
                  },
                  decoration: InputDecoration(hintText: "E-mail"),
                  maxLength: 40,
                ),
                TextFormField(
                  controller: _campoTelefoneCliente,
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    return value.isNotEmpty ? null : "Campo Obrigatório.";
                  },
                  decoration: InputDecoration(hintText: "Telefone"),
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    TelefoneInputFormatter()
                  ],
                  maxLength: 15,
                ),
                Text("Endereço: "),
                SizedBox(
                  height: 10,
                ),
                Container(
                  child: Column(
                    children: <Widget>[],
                  ),
                ),
                TextFormField(
                  controller: _campoLogradouroCliente,
                  validator: (value) {
                    return value.isNotEmpty ? null : "Campo Obrigatório.";
                  },
                  decoration: InputDecoration(hintText: "Logradouro"),
                  maxLength: 40,
                ),
                Row(
                  children: <Widget>[
                    Container(
                      width: 100,
                      child: TextFormField(
                        controller: _campoNumeroCliente,
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          return value.isNotEmpty ? null : "Campo Obrigatório.";
                        },
                        decoration: InputDecoration(hintText: "Nº"),
                        maxLength: 10,
                      ),
                    ),
                    SizedBox(
                      width: 30,
                    ),
                    Container(
                      width: 200,
                      child: TextFormField(
                        controller: _campoComplementoCliente,
                        validator: (value) {
                          return value.isNotEmpty ? null : "Campo Obrigatório.";
                        },
                        decoration: InputDecoration(hintText: "Complemento"),
                        maxLength: 30,
                      ),
                    ),
                  ],
                ),
                TextFormField(
                  controller: _campoBairroCliente,
                  validator: (value) {
                    return value.isNotEmpty ? null : "Campo Obrigatório.";
                  },
                  decoration: InputDecoration(hintText: "Bairro"),
                  maxLength: 30,
                ),
                TextFormField(
                  controller: _campoCidadeCliente,
                  validator: (value) {
                    return value.isNotEmpty ? null : "Campo Obrigatório.";
                  },
                  decoration: InputDecoration(hintText: "Cidade"),
                  maxLength: 30,
                ),
                TextFormField(
                  controller: _campoEstadoCliente,
                  validator: (value) {
                    return value.isNotEmpty ? null : "Campo Obrigatório.";
                  },
                  decoration: InputDecoration(hintText: "Estado"),
                  maxLength: 30,
                ),
                TextFormField(
                  controller: _campoCEPCliente,
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    return value.isNotEmpty ? null : "Campo Obrigatório.";
                  },
                  decoration: InputDecoration(hintText: "CEP"),
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    CepInputFormatter()
                  ],
                  maxLength: 10,
                )
              ],
            )),
      ),
    );
  }
}
