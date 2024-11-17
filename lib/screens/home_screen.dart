import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:garagegrove_esteticaautomotiva/screens/profile_screen.dart';
import 'package:garagegrove_esteticaautomotiva/screens/booking_screen.dart';
import 'package:garagegrove_esteticaautomotiva/screens/login_screen.dart';
import 'about_screen.dart';


class HomeScreen extends StatefulWidget {
  final String nomeUsuario;
  final String email;
  final String tipoCadastro;

  const HomeScreen({super.key,
    required this.nomeUsuario,
    required this.email,
    required this.tipoCadastro,
  });

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late String _selectedTitle;

  @override
  void initState() {
    super.initState();
    _selectedTitle = 'Agendamentos';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_selectedTitle),
      ),
      drawer: _buildDrawer(),
      body: _buildBody(),
    );
  }

  Widget _buildDrawer() {
    return Drawer(
      child: Column(
        children: [
          UserAccountsDrawerHeader(
            accountName: Text(widget.nomeUsuario),
            accountEmail: Text(widget.email),
            currentAccountPicture: CircleAvatar(
              child: Text(
                widget.nomeUsuario.isNotEmpty
                    ? widget.nomeUsuario[0].toUpperCase()
                    : '',
                style: TextStyle(fontSize: 40),
              ),
            ),
          ),
          ListTile(
            leading: Icon(Icons.person),
            title: Text('Perfil'),
            onTap: () {
              setState(() {
                _selectedTitle = widget.tipoCadastro == 'cliente'
                    ? 'Perfil Cliente'
                    : 'Perfil Lava-Jato';
              });
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) =>
                    ProfileScreen(
                      tipoCadastro: widget.tipoCadastro,
                      name: widget.nomeUsuario,
                      email: widget.email,
                    ),
              ));
            },
          ),
          ListTile(
            leading: Icon(Icons.calendar_today),
            title: Text('Agendamentos'),
            onTap: () {
              setState(() {
                _selectedTitle = 'Agendamentos';
              });
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => BookingScreen(),
              ));
            },
          ),
          ListTile(
            leading: Icon(Icons.info),
            title: Text('Sobre'),
            onTap: () {
              setState(() {
                _selectedTitle = 'Sobre';
              });
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => AboutScreen(),
              ));
            },
          ),
          ListTile(
            leading: Icon(Icons.logout),
            title: Text('Logout'),
            onTap: () async {
              await FirebaseAuth.instance.signOut();
              Navigator.of(context).pushReplacement(MaterialPageRoute(
                builder: (context) => LoginScreen(),
              ));
            },
          ),
        ],
      ),
    );
  }

  Widget _buildBody() {
    switch (_selectedTitle) {
      case 'Perfil Cliente':
      case 'Perfil Lava-Jato':
        return ProfileScreen(
          tipoCadastro: widget.tipoCadastro,
          name: widget.nomeUsuario,
          email: widget.email,
        );
      case 'Agendamentos':
        return BookingScreen();
      case 'Sobre':
        return AboutScreen();
      default:
        return Center(child: Text('Selecione uma opção no menu.'));
    }
  }
}