import 'dart:async';
import 'package:flutter/material.dart';
import 'package:barcode_scanner/scan_loc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;

class HomeBody extends StatefulWidget{
  @override
  HomeBodyState createState() {
    return new HomeBodyState();
  }
}

class HomeBodyState extends State<HomeBody> {


  final textController1=TextEditingController();
  final textController2=TextEditingController();
  var result;
  int success;
  @override
  void initState(){
    super.initState();
    success=0;

  }


  @override
  void dispose(){
    textController1.dispose();
    textController2.dispose();
    success = 0;
    super.dispose();
  }



  void post() async {
    String t1=textController1.text;
    String t2=textController2.text;

   result = await http.get("https://nazarethmokama.org/mnhs/verifyUser.php?uname=${t1}&upass=${t2}");

    String res = result.body.toString();

    if(res=="1"){
      Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (BuildContext context) => ScanLoc(w:t1)));
    }
    else{
      await snackbar();
    }

  }
  Future snackbar() async{
    Fluttertoast.showToast(
        msg: "Login Failed! Invalid username or password",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.TOP,
        timeInSecForIos: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white
    );

  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: new BoxDecoration(
          image: DecorationImage(
              image: ExactAssetImage('assets/t2.jpg'),
              fit: BoxFit.cover
          )
        ),


        child: Padding(
          padding: const EdgeInsets.all(50.0),
          child: ListView(
            children:<Widget>[
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[

                  SizedBox(height:60.0),
                  Text("LOGIN",
                    style: TextStyle(
                        color: Colors.deepOrangeAccent,
                        fontSize: 35.0,
                        fontWeight: FontWeight.bold
                    ),),
                  SizedBox(height: 120.0),
                  TextField(
                    controller: textController1,
                    decoration: InputDecoration(
                        border: UnderlineInputBorder(
                            borderRadius: BorderRadius.circular(20.0)
                        ),
                        hintText: "username:",
                        filled: true,
                        fillColor: Colors.grey[200],
                        contentPadding: EdgeInsets.symmetric(
                            horizontal: 30.0,
                            vertical: 10.0
                        )
                    ),
                    /*onChanged: (text){
                    print(text);
                  },*/
                  ),

                  SizedBox(height: 20.0),
                  TextField(
                    controller: textController2,
                    decoration: InputDecoration(
                        border: UnderlineInputBorder(
                            borderRadius: BorderRadius.circular(20.0)
                        ),
                        hintText:"password:",
                        filled: true,
                        fillColor: Colors.grey[200],
                        contentPadding: EdgeInsets.symmetric(
                            horizontal: 30.0,
                            vertical: 10.0
                        )
                    ),
                    /*onChanged: (text){
                    print(text);
                  },*/
                  ),
                  SizedBox(height: 10.0),
                  RaisedButton(
                    padding: EdgeInsets.symmetric(horizontal: 60.0),
                    color: Colors.amberAccent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(40.0),
                    ),
                    child: Text("Proceed",style: TextStyle(fontSize: 16.0,color: Colors.red),),
                    onPressed: () async{
                      await post();
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}





