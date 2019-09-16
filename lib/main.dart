
import 'package:flutter/material.dart';
//mport 'dart:io';
import 'dart:async';
import 'package:uuid/uuid.dart';
//import 'package:location/location.dart';
import 'package:geolocator/geolocator.dart';



void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  double _counter1 = 1.2;
  double _counter2 =1.333;
  int gpscounter = 0;
  double _vel=0.0;
  int speedPeriod=1;
  

void genUUID(){
  var uuidd = new Uuid();
  var ww;
  ww = uuidd.v4();
  print('AutoRender now ...$ww');
}   
void autoRender() async {
  print('i am in AutoRender ');
  while (true) {
    await Future.delayed(Duration(seconds: 4), () {
      print('AutoRender now ... ');
      genUUID();
     // _incrementCounter()
     setState((){
       _counter++;
     });
    });
  }
}

void getGPSPersistence() async {
  
var geolocator = Geolocator();
var locationOptions = LocationOptions(accuracy: LocationAccuracy.high, distanceFilter: 10);
int gcounter=0;
StreamSubscription<Position> positionStream = geolocator.getPositionStream(locationOptions).listen(
    (Position position) {
        print(position == null ? 'Unknown' : position.latitude.toString() + ', ' + position.longitude.toString());
        print('------ Persistence lat: $position.latitude');
        print('------ Persistence lon: $position.longitude');
        gcounter= gcounter +1;
        print('------ Persistence gps counter: $gpscounter');
    });
   
}
Future<double> velocity (double oldLat, double oldLon, double curLat, double curLon, int speedPeriod) async {
  //double distanceInMeters =  await Geolocator().distanceBetween(oldLat, oldLon, curLat, curLon);
   double distanceInMeters =  await Geolocator().distanceBetween(oldLat, oldLon,  curLat, curLon);

  //double distanceInMeters = 0.333123;
  print ('---- distance $distanceInMeters');
  //(km/hr)
  return double.parse((3.6 * distanceInMeters / speedPeriod).toStringAsFixed(2)); 
} 
void getGPS()async{

 int gcounter=0; 
 var oldLat;
 var oldLon;
 var curLat;
 var curLon;
 //GeolocationStatus geolocationStatus  = await Geolocator().checkGeolocationPermissionStatus();
 //print('$geolocationStatus');
 /*
  Position position1 = await Geolocator().getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
   print('lat: $position1.latitude');
  print('lat: $position1.longitude');
  */
 getGPSPersistence();

  Position positiontmp = await Geolocator().getLastKnownPosition(desiredAccuracy: LocationAccuracy.high);
  curLat = double.parse(positiontmp.latitude. toStringAsFixed(5));
  curLon = double.parse(positiontmp.longitude.toStringAsFixed(5));

 while (true) {
   print ('get gps  ....');
  oldLat = curLat;
  oldLon = curLon;
  Position position = await Geolocator().getLastKnownPosition(desiredAccuracy: LocationAccuracy.high);
  
  print('lat: $position.latitude');
  print('lon: $position.longitude');
  gcounter=gcounter+1;
 
  curLat = double.parse(position.latitude. toStringAsFixed(5));
  curLon = double.parse(position.longitude.toStringAsFixed(5));
  _vel = await velocity(oldLat, oldLon, curLat, curLon, speedPeriod);
  //Future.delayed(const Duration(seconds: 1), () => velocity(oldLat, oldLon, curLat, curLon));

      setState(()  {
        _counter1= curLat;
        _counter2= curLon; 
        gpscounter = gcounter;
      });
  await Future.delayed(Duration(seconds: speedPeriod), () {
  print('wait');
  });
 }


}
  void _incrementCounter() {
    getGPS();
    setState(()  {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
  //  while (true){
      _counter++;
   //   sleep(const Duration(seconds:3));
   //  autoRender();
   //   }
    });
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          // Column is also layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          //
          // Invoke "debug painting" (press "p" in the console, choose the
          // "Toggle Debug Paint" action from the Flutter Inspector in Android
          // Studio, or the "Toggle Debug Paint" command in Visual Studio Code)
          // to see the wireframe for each widget.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.display1,
            ),
               Text(
              '$_counter1',
              style: Theme.of(context).textTheme.display1,
            ),
                Text(
              '$_counter2',
              style: Theme.of(context).textTheme.display1,
            ),
                Text(
              '$gpscounter',
              style: Theme.of(context).textTheme.display1,
            ),
                Text(
              '$_vel',
              style: Theme.of(context).textTheme.display1,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
