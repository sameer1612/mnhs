import 'package:flutter/material.dart';
import 'dart:async';
import 'package:barcode_scanner/HomeBody.dart';
import 'package:barcode_scan/barcode_scan.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:geolocator/geolocator.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:barcode_scanner/Documentation.dart';
import 'package:barcode_scanner/Support.dart';
import 'package:barcode_scanner/FAQs.dart';

class ScanLoc extends StatefulWidget {
  String w;
  ScanLoc({this.w});


  // This widget is the root of your application.
  @override
  ScanLocState createState() {
    return new ScanLocState();
  }
}

class ScanLocState extends State<ScanLoc> {


  Position currentLocation;
  Position lastLocation;
  StreamSubscription<Position> positionStream;

  String error;
  String barcode = "";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initPlatformState();
    var geolocator = Geolocator();
    var locationOptions = LocationOptions(accuracy: LocationAccuracy.high, distanceFilter: 5);

    positionStream = geolocator.getPositionStream(locationOptions).listen(
            (Position position) {
          if(position != null){
            setState(() {
              currentLocation = position;

            });
          }
        });

  }
  void initPlatformState() async{
    Position cur_position;

    try{
      cur_position = await Geolocator().getCurrentPosition(desiredAccuracy: LocationAccuracy.high);


      error = "";
    }on PlatformException catch(e){
      if(e.code == 'PERMISSION_DENIED'){
        error = 'PERMISSION_DENIED';
      }
      else if(e.code == 'PERMISSION_DENIED_NEVER_ASK'){
        error = 'Permission denied - please ask the user to enable it from the app settings';
        cur_position = null;

      }
    }
    setState(() {
      currentLocation = cur_position;

    });

  }
  void post() async {

    var result = await http.post(
        "https://nazarethmokama.org/mnhs/insertPackage.php",
        body: {
          "pid": barcode,"scanid":"${widget.w}","latitude":"${currentLocation.latitude}",
          "longitude":"${currentLocation.longitude}",
        }
    );
    await snackbar();

  }
  Future snackbar() async{
    Fluttertoast.showToast(
        msg: "Successfully inserted",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIos: 1,
        backgroundColor: Colors.blueAccent,
        textColor: Colors.white
    );

  }

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      home: new Scaffold(
          appBar: new AppBar(
            title: Text('Scan Barcode'),
            backgroundColor: Colors.purple,
          ),
          drawer: new Drawer(
            child: Container(
              color:Colors.purple,
              child: ListView(
                children: <Widget>[
                  Container(
                    child: new UserAccountsDrawerHeader(
                        accountName: new Text("${widget.w}",style: TextStyle(color: Colors.white,fontSize: 16.0),),
                        decoration: new BoxDecoration(
                          color: Color.fromRGBO(102, 0, 102, 0.5)
                        ),
                        accountEmail: new Text("admin256@gmail.com",style: TextStyle(color: Colors.white,fontSize: 16.0),),
                        currentAccountPicture: new CircleAvatar(
                          backgroundImage: new NetworkImage('https://i1.wp.com/www.winhelponline.com/blog/wp-content/uploads/2017/12/user.png?fit=256%2C256&quality=100&ssl=1'),
                        ),

                    ),
                  ),


                  new ListTile(
                    title: new Text('Documentation',style: TextStyle(fontSize: 16.0,color: Colors.black),),
                    onTap: (){
                      Navigator.push(context, new MaterialPageRoute(
                          builder: (BuildContext context) => new Documentation()
                      ));
                    },
                  ),
                  new ListTile(
                    title: new Text('Support',style: TextStyle(fontSize: 16.0,color: Colors.black)),
                    onTap: (){
                      Navigator.push(context, new MaterialPageRoute(
                          builder: (BuildContext context) => new Support()
                      ));
                    },
                  ),
                  new ListTile(
                    title: new Text('FAQs',style: TextStyle(fontSize: 16.0,color: Colors.black)),
                    onTap: (){
                      Navigator.push(context, new MaterialPageRoute(
                          builder: (BuildContext context) => new FAQs()
                      ));
                    },
                  ),

                  new ListTile(
                    title: new Text('Logout',style: TextStyle(fontSize: 16.0,color: Colors.black)),
                    onTap: (){
                      Navigator.push(context, new MaterialPageRoute(
                          builder: (BuildContext context) => new HomeBody()
                      ));
                    },
                  ),

                ],

              ),
            ),
          ),
          body: Container(
            decoration: new BoxDecoration(
                image: DecorationImage(
                    image: ExactAssetImage('assets/s4.jpg'),
                    fit: BoxFit.cover
                )
            ),

            child: ListView(
              children: <Widget>[
                new Center(
                  child: new Column(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: new Container(
                          child: new RaisedButton(
                            color: Colors.red,
                              onPressed: barcodeScanning, child: new Text("Capture image",
                            style: TextStyle(
                                fontSize: 20.0,
                                fontStyle: FontStyle.italic,
                                fontWeight: FontWeight.bold,
                                color: Colors.white
                            ),)),
                          padding: const EdgeInsets.all(8.0),
                        ),
                      ),

                      new Text("Code after Scan : " + barcode,
                      style: TextStyle(fontSize: 16.0,fontWeight: FontWeight.bold,
                      color: Colors.black87),),
                      SizedBox(height: 270.0),



                      new Text("Match captured code",
                        style: TextStyle(fontSize: 16.0,fontWeight: FontWeight.bold,
                            color: Colors.black87),),

                      new Container(

                        child: new RaisedButton(
                            color: Colors.green,
                            onPressed:post , child: new Text("Confirm submission",
                          style: TextStyle(
                            fontSize: 20.0,
                            fontStyle: FontStyle.italic,
                            fontWeight: FontWeight.bold,
                            color: Colors.white
                        ),)),
                        padding: const EdgeInsets.all(8.0),
                      ),
                      new Padding(
                        padding: const EdgeInsets.all(8.0),
                      ),


                    ],
                  ),
                ),
              ],
            ),
          )),
    );
  }

  Future barcodeScanning() async {
    try {
      barcode = await BarcodeScanner.scan();
      setState(() => this.barcode = barcode);
    } on PlatformException catch(e){
      if(e.code == BarcodeScanner.CameraAccessDenied){
        setState((){
          this.barcode = 'No camera permission!';
        });
      } else {
        setState(() => this.barcode = 'Unknown error: $e');
      }
    } on FormatException {
      setState(() => this.barcode =
      'Nothing captured.');
    }catch(e){
      setState(() => this.barcode = 'Unknown error: $e');
    }

  }
}

