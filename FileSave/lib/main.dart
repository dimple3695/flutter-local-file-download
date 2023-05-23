import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a blue toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
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
  String imgurl = "https://www.fluttercampus.com/img/banner.png";
  late String _localPath;

  @override
  void initState() {
    super.initState();
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
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text("Download Image/Video"),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image.network(
              imgurl,
              height: 150,
            ),
            Divider(),
            ElevatedButton(
              onPressed: () async {
                _saveImage();
              },
              child: Text("Download"),
            )
          ],
        ),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  _saveImage() async {
    //ask for permission
    Map<Permission, PermissionStatus> statuses = await [
      Permission.manageExternalStorage,
      Permission.storage,
    ].request();
    if (statuses[Permission.manageExternalStorage]!.isDenied) {
      //check each permission status after.
      print("ExternalStorage permission is denied.");
    } else if (statuses[Permission.storage]!.isDenied) {
      //check each permission status after.
      print("Storage permission is denied.");
    } else {
      //permission Granted
      await _prepareSaveDir();
      //download file & save in download directory
      try {
        await Dio().download(imgurl, "$_localPath banner.png",
            onReceiveProgress: (received, total) {
          if (total != -1) {
            print((received / total * 100).toStringAsFixed(0) + "%");
            //you can build progressbar feature too
          }
        });
        print("Image is saved to download folder.");
      } on DioError catch (e) {
        print("Download Failed.\n\n" + e.toString());
      }
    }
  }

  Future<void> _prepareSaveDir() async {
    Directory? directory;
    //find local path
    try {
      if (Platform.isIOS) {
        directory = await getApplicationDocumentsDirectory();
        _localPath =  directory.path + Platform.pathSeparator + 'Download';
      } else {
        directory = Directory('/storage/emulated/0/Download/');
        if (!await directory.exists())
          directory = await getExternalStorageDirectory();
        _localPath = directory!.path;
      }
    } catch (err, stack) {
      print("Cannot get download folder path");
    }
    final savedDir = Directory(_localPath);
    bool hasExisted = await savedDir.exists();
    if (!hasExisted) {
      savedDir.create();
    }
  }
}
