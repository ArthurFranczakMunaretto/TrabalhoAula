import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class User {
  final String nome;
  final String email;
  final String tipoDeAcesso;

  User({required this.nome, required this.email, required this.tipoDeAcesso});
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primaryColor: Colors.lightGreen, // Cor primária
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            primary: Colors.green, // Cor do botão
          ),
        ),
      ),
      home: LoginPage(),
    );
  }
}

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _nomeController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  String _tipoAcesso = "1"; // Inicializa com "1"

  void _navigateToUserInfo(User user) {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => UserInfoPage(user: user),
      ),
    );
  }

  Future<void> _showTipoAcessoDialog() async {
    String? selectedTipoAcesso = await showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Escolha o Tipo de Acesso'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: Text('Opção 1'),
                onTap: () {
                  Navigator.of(context).pop("1");
                },
              ),
              ListTile(
                title: Text('Opção 2'),
                onTap: () {
                  Navigator.of(context).pop("2");
                },
              ),
              ListTile(
                title: Text('Opção 3'),
                onTap: () {
                  Navigator.of(context).pop("3");
                },
              ),
            ],
          ),
        );
      },
    );

    if (selectedTipoAcesso != null) {
      setState(() {
        _tipoAcesso = selectedTipoAcesso;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.green, Colors.lightGreen],
          ),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Icon(
                    Icons.account_circle,
                    size: 100.0,
                    color: Colors.white, // Cor do ícone
                  ),
                  SizedBox(height: 20.0),
                  TextFormField(
                    controller: _nomeController,
                    style: TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      labelText: 'Nome',
                      labelStyle: TextStyle(color: Colors.white),
                      prefixIcon: Icon(Icons.person, color: Colors.white),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor, insira o nome';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 20.0),
                  TextFormField(
                    controller: _emailController,
                    style: TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      labelText: 'Email',
                      labelStyle: TextStyle(color: Colors.white),
                      prefixIcon: Icon(Icons.email, color: Colors.white),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor, insira o email';
                      }
                      if (!RegExp(r'^[\w-]+(\.[\w-]+)*@([\w-]+\.)+[a-zA-Z]{2,7}$').hasMatch(value)) {
                        return 'Favor colocar um email válido';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 20.0),
                  GestureDetector(
                    onTap: _showTipoAcessoDialog,
                    child: AbsorbPointer(
                      child: TextFormField(
                        controller: TextEditingController(text: _tipoAcesso),
                        style: TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          labelText: 'Tipo de Acesso',
                          labelStyle: TextStyle(color: Colors.white),
                          prefixIcon: Icon(Icons.security, color: Colors.white),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 20.0),
                  ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        final user = User(
                          nome: _nomeController.text,
                          email: _emailController.text,
                          tipoDeAcesso: _tipoAcesso,
                        );
                        _navigateToUserInfo(user);
                      }
                    },
                    child: Text('Acessar'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class UserInfoPage extends StatefulWidget {
  final User user;

  UserInfoPage({required this.user});

  @override
  _UserInfoPageState createState() => _UserInfoPageState();
}

class _UserInfoPageState extends State<UserInfoPage> {
  bool _showInfo = true;

  void _showConfirmationDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Confirmar Ocultar Informações'),
        content: Text('Tem certeza de que deseja ocultar as informações do usuário?'),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Fechar o diálogo
            },
            child: Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                _showInfo = false;
              });
              Navigator.of(context).pop(); // Fechar o diálogo
            },
            child: Text('Confirmar'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final obscuredEmail = _showInfo
        ? widget.user.email
        : '*' * widget.user.email.length; // Oculta o email com "*"

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.user.nome),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.green, Colors.lightGreen],
          ),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Card(
              elevation: 5.0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    if (_showInfo) ...[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Icon(
                            Icons.person,
                            size: 36.0,
                            color: Theme.of(context).primaryColor, // Cor do ícone
                          ),
                          SizedBox(width: 8.0), // Espaçamento entre o ícone e o texto
                          Text(
                            'Nome: ${widget.user.nome}',
                            style: TextStyle(
                              color: Theme.of(context).primaryColor, // Cor do texto
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Icon(
                            Icons.email,
                            size: 36.0,
                            color: Theme.of(context).primaryColor, // Cor do ícone
                          ),
                          SizedBox(width: 8.0), // Espaçamento entre o ícone e o texto
                          Text(
                            'Email: $obscuredEmail', // Usa o email obscurecido
                            style: TextStyle(
                              color: Theme.of(context).primaryColor, // Cor do texto
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Icon(
                            Icons.security,
                            size: 36.0,
                            color: Theme.of(context).primaryColor, // Cor do ícone
                          ),
                          SizedBox(width: 8.0), // Espaçamento entre o ícone e o texto
                          Text(
                            'Tipo de Acesso: ${widget.user.tipoDeAcesso}',
                            style: TextStyle(
                              color: Theme.of(context).primaryColor, // Cor do texto
                            ),
                          ),
                        ],
                      ),
                    ],
                    ElevatedButton(
                      onPressed: () {
                        if (_showInfo) {
                          _showConfirmationDialog();
                        } else {
                          setState(() {
                            _showInfo = true;
                          });
                        }
                      },
                      child: Text(_showInfo ? 'Ocultar Informações' : 'Exibir Informações'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
