import 'package:movies_mim/authentication_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SignInPageState extends State<SignInPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  bool signIn = true;
  @override
  Widget build(BuildContext context) {
      final node = FocusScope.of(context);
      return Scaffold(
          body: Container (
              decoration: BoxDecoration(
                  image: new DecorationImage(image: new AssetImage("lib/assets/images/login.png"), fit: BoxFit.cover)),
              child: Form(
                key: formKey,
                child: Container(
                  margin: const EdgeInsets.only(left: 50.0, right: 50.0, top: 160.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget> [
                      TextFormField(
                        onEditingComplete: () => node.nextFocus(),
                        validator: (text) {
                          if(text.trim().isEmpty || text.trim().indexOf("@") == -1 || text.trim() == null)
                            return "Wprowadzono nieprawidłowe dane";
                          return null;
                        },
                        controller: emailController,
                        decoration: InputDecoration(
                          contentPadding: new EdgeInsets.fromLTRB(0, 30,0,20),
                          labelStyle: TextStyle(color: Colors.black87),
                          labelText: "Email",
                        ),
                      ),
                      TextFormField(
                        validator: (text) {
                          if(text.trim().isEmpty || text.trim().length < 6 || text.trim() == null)
                            return "Wprowadzono nieprawidłowe dane";
                          return null;
                        },
                        obscureText: true,
                        controller: passwordController,
                        decoration: InputDecoration(
                          contentPadding: new EdgeInsets.fromLTRB(0, 30,0,20),
                          labelStyle: TextStyle(color: Colors.black87),
                          labelText: "Hasło",
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.fromLTRB(0, 50, 0, 20),
                        // ignore: deprecated_member_use
                        child: RaisedButton(
                          onPressed: () {
                            if(formKey.currentState.validate()) {
                              if(signIn) {
                              context.read<AuthenticationService>().signIn(
                                  email: emailController.text.trim(),
                                  password: passwordController.text.trim());}
                              else {
                                context.read<AuthenticationService>().signUp(
                                    email: emailController.text.trim(),
                                    password: passwordController.text.trim());
                              }
                            }
                          },
                          child: Text(signIn ? "Zaloguj" : "Zarejestruj"),
                          textColor: Colors.white,
                          color: Color.fromARGB(500,230, 57, 70),
                          padding: EdgeInsets.fromLTRB(12, 12, 12, 12),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(signIn ? "Nie masz konta? ": "Masz już konto?"),
                          GestureDetector(
                              onTap: signInFun,
                              child: Text( signIn ?
                                "Zarejestruj się" : "Zaloguj się",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              )
                          )
                        ],
                      )
                    ],
                  ),
                ),
              )
          )
      );
    }
    void signInFun() {
    setState(() {
      signIn = !signIn;
    }
    );
  }
  }
class SignInPage extends StatefulWidget {

  @override
  State<StatefulWidget> createState() => SignInPageState();
}