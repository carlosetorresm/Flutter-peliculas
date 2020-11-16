import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:practica2/src/models/user_dao.dart';
import 'package:practica2/src/network/api_login.dart';
import 'package:practica2/src/screen/dashboard.dart';

class Login extends StatefulWidget {
  Login({Key key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  ApiLogin httpLogin = ApiLogin();

  @override
  Widget build(BuildContext context) {
    TextEditingController txtUser = TextEditingController();
    TextEditingController txtPass = TextEditingController();
    final logo = Image.network(
        'http://itcelaya.edu.mx/jornadabioquimica/wp-content/uploads/2019/07/cropped-LOGO-ITC.png',
        width: 180,
        height: 120);
    final txtEmail = TextFormField(
        controller: txtUser,
        keyboardType: TextInputType.emailAddress,
        decoration: InputDecoration(
          hintText: 'Introduce el email',
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
          contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
        ));
    final txtPwd = TextFormField(
      controller: txtPass,
      keyboardType: TextInputType.text,
      obscureText: true,
      decoration: InputDecoration(
        hintText: 'Introduce el password',
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
        contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      ),
    );
    final loginButton = RaisedButton(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: Text(
          'Validar',
          style: TextStyle(color: Colors.white),
        ),
        color: Colors.lightBlue,
        onPressed: () async {
          UserDAO objUser =
              UserDAO(username: txtUser.text, pwduser: txtPass.text);
          final token = await httpLogin.validateUser(objUser);
          if (token != null)
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => Dashboard()));
          else {
            showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text('Error Sign In'),
                    content: Text('The credentials are incorrect'),
                    actions: <Widget>[
                      FlatButton(
                        child: Text('Close'),
                        onPressed: () => Navigator.of(context).pop(),
                      )
                    ],
                  );
                });
          }
        });

    return Stack(
      alignment: Alignment.bottomCenter,
      children: <Widget>[
        //Widget para cargar la imagen de fondo
        Container(
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage('assets/fondo.jpg'),
                    fit: BoxFit.fitHeight))),
        Card(
          color: Colors.white70,
          margin: EdgeInsets.all(30.0),
          elevation: 8.0,
          child: Padding(
            padding: EdgeInsets.all(10),
            child: ListView(
              shrinkWrap: true,
              children: <Widget>[
                txtEmail,
                SizedBox(height: 10),
                txtPwd,
                SizedBox(height: 10),
                loginButton,
              ],
            ),
          ),
        ),
        Positioned(child: logo, top: 235),
        Positioned(top: 350, child: CircularProgressIndicator())
      ],
    );
  }
}
