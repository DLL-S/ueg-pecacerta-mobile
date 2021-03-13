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

class AdicionarClienteTela extends StatefulWidget {
  @override
  _AdicionarClienteTelaState createState() => _AdicionarClienteTelaState();
}

class _AdicionarClienteTelaState extends State<AdicionarClienteTela> {
  ClienteController clienteController = new ClienteController();
  Cliente cliente = Cliente();
  Endereco enderecoCliente = Endereco();

  //Chave de identificação do Form e controllers dos texts fields
  GlobalKey<FormState> _formKeyCliente = GlobalKey<FormState>();
  TextEditingController _campoNomeCliente = TextEditingController();
  TextEditingController _campoCPFCNPJ = TextEditingController();
  String _data;
  TextEditingController _dataText =
      TextEditingController(text: UtilData.obterDataDDMMAAAA(DateTime.now()));
  TextEditingController _campoEmailCliente = TextEditingController();
  TextEditingController _campoTelefoneCliente = TextEditingController();
  TextEditingController _campoLogradouroCliente = TextEditingController();
  TextEditingController _campoNumeroCliente = TextEditingController();
  TextEditingController _campoComplementoCliente = TextEditingController();
  TextEditingController _campoBairroCliente = TextEditingController();
  TextEditingController _campoCidadeCliente = TextEditingController();
  TextEditingController _campoEstadoCliente = TextEditingController();
  TextEditingController _campoCEPCliente = TextEditingController();
  //Controle checkbox
  bool _selPF, _selPJ;

  //Mostra Calendario

  @override
  void initState() {
    _selPJ = false;
    _selPF = false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    AlertDialog alert = AlertDialog(
      title: Text("Confirmação"),
      content: Text("Deseja confirmar a inserção do cliente?"),
      actions: [
        TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text("Cancelar")),
        TextButton(
            onPressed: () async {
              await clienteController.incluirCliente(cliente);
              _formKeyCliente.currentState.reset();
              Navigator.pop(context);
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => ClienteTela()));
            },
            child: Text("Confirmar"))
      ],
    );
    return Scaffold(
      appBar: AppBar(
        title: Text("Novo Cliente"),
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

                cliente.dataNascFund = _data;

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
                              lastDate: DateTime.now());

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
