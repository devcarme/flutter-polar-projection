import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:proj4dart/proj4dart.dart' as proj4;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter polar projection',
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
      home: const MyHomePage(title: 'Flutter polar projection'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  String initText = 'Map centered to';
  // Define start center
  proj4.Point point = proj4.Point(x: 65.05166470332148, y: -19.171744826394896);

  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
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
    var resolutions = <double>[
      32768,
      16384,
      8192,
      4096,
      2048,
      1024,
      512,
      256,
      128
    ];
    var maxZoom = (resolutions.length - 1).toDouble();

    var epsg3413CRS = Proj4Crs.fromFactory(
      code: 'EPSG:3413',
      proj4Projection: proj4.Projection.add('EPSG:3413',
          '+proj=stere +lat_0=90 +lat_ts=70 +lon_0=-45 +k=1 +x_0=0 +y_0=0 +datum=WGS84 +units=m +no_defs'),
      resolutions: resolutions,
    );

    return FlutterMap(
      options: MapOptions(
        center: LatLng(65.05166470332148, -19.171744826394896),
        zoom: 1,
        crs: epsg3413CRS,
        maxZoom: maxZoom,
      ),
      children: [
        TileLayer(
          wmsOptions: WMSTileLayerOptions(
            // Set the WMS layer's CRS too
            crs: epsg3413CRS,
            baseUrl:
                //North
                'https://www.gebco.net/data_and_products/gebco_web_services/north_polar_view_wms/mapserv?',
            layers: ['gebco_north_polar_view'],
          ),
        ),
        MarkerLayer(
          markers: [
            Marker(
              point: LatLng(64.045691, -22.678106),
              width: 80,
              height: 80,
              builder: (context) => const Icon(
                Icons.location_on,
                color: Colors.blue,
                size: 40,
              ),
            ),
            Marker(
              point: LatLng(51.5287718, -0.2416805),
              width: 80,
              height: 80,
              builder: (context) => const Icon(
                Icons.location_on,
                color: Colors.blue,
                size: 40,
              ),
            ),
            Marker(
              point: LatLng(59.823567, -43.585796),
              width: 80,
              height: 80,
              builder: (context) => const Icon(
                Icons.location_on,
                color: Colors.blue,
                size: 40,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
