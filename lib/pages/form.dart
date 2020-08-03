import 'package:flutter/material.dart';
import '../helper/db_helper.dart';
class FormPage extends StatefulWidget {
  final Map<String,dynamic> data;
  FormPage({this.data});
  @override
  _FormPageState createState() => _FormPageState();
}

class _FormPageState extends State<FormPage> {
  final _key = GlobalKey<ScaffoldState>(); 
  final _form = GlobalKey<FormState>(); 
  final database = Dbhelper.instance;
  String _judul;
  String _desc;
  _simpan()async{
    if (widget.data == null){
      print("tambah");
      await database.insert({
        "title":_judul,
        "desc":_desc
      });
    }else{
      print("edit");
      await database.update({
        "id":widget.data['id'],
        "title":_judul,
        "desc":_desc
      });
    }
     Navigator.pop(context,true);
  }
  @override
  void initState() {
    if (widget.data != null){
      setState(() {
        _judul = widget.data["title"];
        _desc = widget.data["desc"];
      });
    }
    super.initState();
  }
  @override
  void dispose() {
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
      return Scaffold(
      key:_key,
      appBar: AppBar(
        title: Text(widget.data==null?"Tambah":"Edit",style: TextStyle(color: Colors.black,fontWeight: FontWeight.w900)),
        centerTitle: true,
        backgroundColor: Colors.red,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Form(
          key: _form,
            child: ListView(
            children: <Widget>[
              TextFormField(
                initialValue: _judul,
                onSaved: (val){
                      setState(() {
                        _judul=val;
                      });
                  },
                validator: (val){
                  if (val.isEmpty){
                    return "Jangan kosong goblok";
                  }
                },
                decoration: InputDecoration(
                  labelText:"Title"
                ),
              ),
                TextFormField(
                  initialValue: _desc,
                  onSaved: (val){
                      setState(() {
                        _desc=val;
                      });
                  },
                  validator: (val){
                  if (val.isEmpty){

                    return "Jangan kosong goblok";
                  }
                },
                decoration: InputDecoration(
                  labelText:"Desc"
                ),
              ),
              
              RaisedButton(
                color: Colors.black,
                colorBrightness: Brightness.dark,
                child: Text("Simpanan"),
                onPressed: () => {
                if(_form.currentState.validate()){
                    _form.currentState.save(),
                    _simpan()
                }
                },
              )
            ],
          ),
        ),
      ) ,
    );
  }
}