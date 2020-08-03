import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' show Client,Response;
import 'package:flutter_alert/flutter_alert.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _key = GlobalKey<ScaffoldState>(); 
  final _form = GlobalKey<FormState>(); 
  Client http = new Client();
  FlutterSecureStorage storage = new FlutterSecureStorage();
  bool load = false;
  String _mail;
  String _pass;
  _login() async {
    setState(() {
      load = true;
    });
    // ---- Buat Cek API dimatiin dulu
    // final response = await http.post("http://unitycode.site/flutter/api/Auth/login",body: jsonEncode({
    //     "email":_mail,
    //     "password":_pass,
    //     "token":"TOKEN"
    //   }),
    //   headers: {
    //     "Content-type":"application/json",
    //     "Accept":"application/json"
    //   });
    //   print(response.body);
    //   if (response.statusCode == 200){
    //     final data = jsonDecode(response.body);
    //     print(data['data']['access_token']);
        await storage.write(key: "token", value: _mail);
        Navigator.pushReplacementNamed(context, "/home");
    //   }else{
    //     showAlert(context:context,title:jsonDecode(response.body)['message']);
    //   }
          setState(() {
      load = false;
    });

  }
  _checkLogin(BuildContext context) async {
    var token = await storage.read(key: "token");
    if (token != null){
      Navigator.pushReplacementNamed(context, "/home");
    }
  }
  @override
  void initState() {
    _checkLogin(context);
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
      return Scaffold(
      key:_key,
      appBar: AppBar(
        title: Text("Login",style: TextStyle(color: Colors.black)),
        centerTitle: true,
        backgroundColor: Colors.red,
      ),
      body: LoadingOverlay(
        isLoading: load,
              child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Form(
            key: _form,
              child: ListView(
              children: <Widget>[
                TextFormField(
                  onSaved: (val){
                        setState(() {
                          _mail=val;
                        });
                    },
                  validator: (val){
                    if (val.isEmpty){
                      return "Jangan kosong goblok";
                    }
                  },
                  decoration: InputDecoration(
                    labelText:"Username"
                  ),
                ),
                        TextFormField(
                          onSaved: (val){
                        setState(() {
                          _pass=val;
                        });
                    },
                  validator: (val){
                    if (val.isEmpty){
                      return "Jangan kosong goblok";
                    }
                  },
                  decoration: InputDecoration(
                    labelText:"Password",
                    suffixIcon: IconButton(icon: Icon(Icons.remove_red_eye), onPressed: ()=> null)
                  ),
                ),
                RaisedButton(
                  color: Colors.black,
                  colorBrightness: Brightness.dark,
                  child: Text("Simpanan"),
                  onPressed: () => {
                  if(_form.currentState.validate()){
                      _form.currentState.save(),
                      _login(),
                    // Navigator.pushReplacementNamed(context, "/home")
                  }
                  },
                )
              ],
            ),
          ),
        ),
      ) ,
    );
  }
}