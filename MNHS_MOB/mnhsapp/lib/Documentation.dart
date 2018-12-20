import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
class Documentation extends StatefulWidget{
  @override
  DocumentationState createState() {
    return new DocumentationState();
  }
}

class DocumentationState extends State<Documentation> {
  var result;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getResult();
  }
  Future<String> getResult() async{
    result= await http.get("http://mnhsapi.herokuapp.com/docs");
    return result.body.toString();

  }
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Center(child: Text('Documentation')),
          backgroundColor: Colors.blue[900],
        ),
        body: FutureBuilder(
            future: getResult(),
            builder: (context,snapshot){
              if(snapshot.hasData){
                return ListView(
                  children: <Widget>[
                    new Container(
                      padding: const EdgeInsets.fromLTRB(16.0, 25.0, 10.0, 10.0),
                      child: new RichText(
                        text: TextSpan(
                            text: '${snapshot.data}',
                            style: TextStyle(color: Colors.black,fontSize: 20.0)

                        ),
                      ),
                    )
                  ],


                );
              }
              else{
                return Center(child: CircularProgressIndicator());
              }
            }
        ),

      ),
    );
  }
}