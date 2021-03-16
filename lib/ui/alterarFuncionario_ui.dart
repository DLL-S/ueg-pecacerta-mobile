import 'package:cpfcnpj/cpfcnpj.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:brasil_fields/brasil_fields.dart';
import 'package:peca_certa_app/controller/funcionarioController.dart';
import 'package:peca_certa_app/models/Endereco.dart';
import 'package:peca_certa_app/models/Funcionario.dart';
import 'package:peca_certa_app/ui/funcionarios_ui.dart';

class AlterarFuncionarioTela extends StatefulWidget {
  @override
  _AlterarFuncionarioTelaState createState() => _AlterarFuncionarioTelaState();
  AlterarFuncionarioTela({this.idFuncionario});
  final Funcionario idFuncionario;
}

class _AlterarFuncionarioTelaState extends State<AlterarFuncionarioTela> {
  FuncionarioController funcionarioController = new FuncionarioController();
  Funcionario funcionario = Funcionario();
  Endereco enderecoCliente = Endereco();

  //Chave de identificação do Form e controllers dos texts fields
  GlobalKey<FormState> _formKeyCliente = GlobalKey<FormState>();

//Controle checkbox
  bool _selAt, _selGe;

  @override
  void initState() {
    if (widget.idFuncionario.tipoDeFuncionario == "Atendente") {
      _selAt = true;
      _selGe = false;
    } else if (widget.idFuncionario.tipoDeFuncionario == "Gerente") {
      _selGe = true;
      _selAt = false;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    TextEditingController _campoNomeCliente =
        TextEditingController(text: widget.idFuncionario.nome);
    TextEditingController _campoCPFCNPJ = TextEditingController(
        text: UtilBrasilFields.obterCpf(widget.idFuncionario.cpf));
    String _data;
    TextEditingController _dataText = TextEditingController(
        text: widget.idFuncionario.dataNasc.substring(8, 10) +
            "/" +
            widget.idFuncionario.dataNasc.substring(5, 7) +
            "/" +
            widget.idFuncionario.dataNasc.substring(0, 4));
    TextEditingController _campoEmailCliente =
        TextEditingController(text: widget.idFuncionario.email);
    TextEditingController _campoTelefoneCliente = TextEditingController(
        text: UtilBrasilFields.obterTelefone(widget.idFuncionario.telefone));
    TextEditingController _campoLogradouroCliente =
        TextEditingController(text: widget.idFuncionario.endereco.logradouro);
    TextEditingController _campoNumeroCliente =
        TextEditingController(text: widget.idFuncionario.endereco.numero);
    TextEditingController _campoComplementoCliente =
        TextEditingController(text: widget.idFuncionario.endereco.complemento);
    TextEditingController _campoBairroCliente =
        TextEditingController(text: widget.idFuncionario.endereco.bairro);
    TextEditingController _campoCidadeCliente =
        TextEditingController(text: widget.idFuncionario.endereco.cidade);
    TextEditingController _campoEstadoCliente =
        TextEditingController(text: widget.idFuncionario.endereco.estado);
    TextEditingController _campoCEPCliente =
        TextEditingController(text: widget.idFuncionario.endereco.cep);

    AlertDialog alert = AlertDialog(
      title: Text("Confirmação"),
      content: Text("Deseja confirmar a alteração do funcionário?"),
      actions: [
        TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text("Cancelar")),
        TextButton(
            onPressed: () async {
              await funcionarioController.alterarFuncionario(funcionario);
              Navigator.pop(context);
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => FuncionarioTela()));
            },
            child: Text("Confirmar"))
      ],
    );
    return Scaffold(
      appBar: AppBar(
        title: Text("Detalhes do Funcionário"),
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
                funcionario.codigo = widget.idFuncionario.codigo;
                funcionario.ativo = true;
                if (_selAt == true) {
                  funcionario.tipoDeFuncionario = "Atendente";
                }
                if (_selGe == true) {
                  funcionario.tipoDeFuncionario = "Gerente";
                }
                funcionario.nome = _campoNomeCliente.text;

                if (CPF.isValid(_campoCPFCNPJ.text)) {
                  funcionario.cpf = _campoCPFCNPJ.text.substring(0, 3) +
                      _campoCPFCNPJ.text.substring(4, 7) +
                      _campoCPFCNPJ.text.substring(8, 11) +
                      _campoCPFCNPJ.text.substring(12, 14);
                }

                if (_data != null) {
                  funcionario.dataNasc = _data;
                } else {
                  funcionario.dataNasc =
                      widget.idFuncionario.dataNasc.substring(0, 4) +
                          "-" +
                          widget.idFuncionario.dataNasc.substring(5, 7) +
                          "-" +
                          widget.idFuncionario.dataNasc.substring(8, 10);
                }

                funcionario.email = _campoEmailCliente.text;

                funcionario.telefone = UtilBrasilFields.extrairTelefone(
                    _campoTelefoneCliente.text);

                enderecoCliente.logradouro = _campoLogradouroCliente.text;

                enderecoCliente.numero = _campoNumeroCliente.text;

                enderecoCliente.complemento = _campoComplementoCliente.text;

                enderecoCliente.bairro = _campoBairroCliente.text;

                enderecoCliente.cep = _campoCEPCliente.text;

                enderecoCliente.cidade = _campoCidadeCliente.text;

                enderecoCliente.estado = _campoEstadoCliente.text;

                funcionario.endereco = enderecoCliente;

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
                  height: 10,
                ),
                Row(
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Text("Atendente"),
                        Checkbox(
                            value: _selAt,
                            onChanged: (bool isMarked) {
                              setState(() {
                                _selAt = isMarked;
                                _selAt == true
                                    ? _selGe = false
                                    : _selGe = false;
                              });
                            }),
                        Text(
                          "Gerente",
                        ),
                        Checkbox(
                            value: _selGe,
                            onChanged: (bool isMarked) {
                              setState(() {
                                _selGe = isMarked;
                                _selGe == true
                                    ? _selAt = false
                                    : _selAt = false;
                              });
                            })
                      ],
                    )
                  ],
                ),
                TextFormField(
                  controller: _campoNomeCliente,
                  validator: (value) {
                    return value.isNotEmpty ? null : "Campo Obrigatório.";
                  },
                  decoration: InputDecoration(hintText: "Nome Completo"),
                  maxLength: 60,
                ),
                TextFormField(
                  controller: _campoCPFCNPJ,
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    CpfInputFormatter(),
                  ],
                  validator: (value) {
                    return value.isNotEmpty ? null : "Campo Obrigatório";
                  },
                  maxLength: 14,
                  decoration: InputDecoration(hintText: "CPF"),
                ),
                Row(
                  children: <Widget>[
                    Text("Data de Nascimento: "),
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
