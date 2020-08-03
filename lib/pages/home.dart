import 'package:flutter/material.dart';
import './form.dart';
import '../helper/db_helper.dart';
import 'package:flutter_alert/flutter_alert.dart';
class Homepage extends StatefulWidget {
  @override
  _HomepageState createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  final _key = GlobalKey<ScaffoldState>();
  final database = Dbhelper.instance;
  List<Map<String,dynamic>> _data=[];
  void pindah(){
    Navigator.of(context).push(MaterialPageRoute(builder: (_)=>FormPage()));

  }
  var myArray =[
    {
      "title":"My frist",
      "sub":"This is object"
    },
    {
      "title":"My second",
      "sub":"This is next object"
    }
  ];
  Future _onRefresh() async {
    await _queryAll();
  }
  Future _queryAll() async{
    final datarows = await database.fetchData();
    setState(() {
    _data = datarows;  
    });
    print(_data);
  }

  Future _dummy() async{
    List<Map<String,dynamic>> _sample = List.generate(5, (index) {
      return{
        "title":"judul ${index.toString()}",
        "desc":'sub jul ${index.toString()}'
      };
    });
    _sample.forEach((data) async{
      await database.insert(data);
     });
  }
    _delete(int id)async{
       await database.delete(id);
       _queryAll();
     }
     _myAlert(BuildContext context){
       showAlert(context: context,title: "Berhasil");
     }
  @override
  void initState() {
    _queryAll();
    // _dummy();
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
        
        title: Text("Activity",style: TextStyle(color: Colors.black,fontWeight: FontWeight.w900)),
        centerTitle: true,
        backgroundColor: Colors.red,
      ),
      body: RefreshIndicator(
        onRefresh: _onRefresh,
              child: ListView.builder(
          itemCount: _data.length,
  
          itemBuilder: (_,i){
            return  Padding(
              padding: EdgeInsets.only(top: i==0?10.0:0),
              child: Card(
                color: Colors.red,
                child: ListTile(
                  leading: Checkbox(value: _data[i]["done"]==0?false:true, onChanged: (val) async{
                    await database.update({
                      "id":_data[i]["id"],
                      "done":val?1:0
                    });
                    _queryAll();
                  },checkColor: Colors.blue,),
                  title: Text(_data[i]["title"],style: TextStyle(color:Colors.white),),
                  subtitle: Text(_data[i]["desc"],style: TextStyle(color:Colors.white)),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                        IconButton(icon: Icon(Icons.edit),  onPressed: () async {
                          var data = await Navigator.of(context).push(
                             MaterialPageRoute(builder: (_)=>FormPage(data:_data[i]))
                            );
                          if(data != null){
                            _queryAll();
                            _myAlert(context);
                          }
                          },),
                        IconButton(icon: Icon(Icons.delete),onPressed: () => showAlert(
                          context:context,
                          title:"Yakin bosqu?",
                          actions:[
                            AlertAction(text:"Ngga",onPressed:null),
                            AlertAction(text:"Ya",onPressed: () => _delete(_data[i]["id"])),
                          ]
                          )
                          ),
                  ],),
                ),
              ),
            );
          
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async { 
          // Navigator.of(context).pushNamed("/form");
         var data = await Navigator.of(context).push(
            MaterialPageRoute(builder: (_)=>FormPage())
          );
          if(data != null){
            _queryAll();
            _myAlert(context);
          }
        },
        child: Icon(Icons.add),
        
        ) ,
    );
  }
}