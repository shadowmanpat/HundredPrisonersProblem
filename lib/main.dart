import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hundred_prisoners_problem/classes/prisoner_problem.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widyoget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
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
      home: const MyHomePage(title: 'The 100 Prisoners Problem'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

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
  int numberOfTests = 100;
  int numberOfPrisoners = 100;
  late TextEditingController prisonerController;
  late TextEditingController testsController;


  YoutubePlayerController _controller = YoutubePlayerController(
    initialVideoId: 'iSNsgj1OCLA',
    params: const YoutubePlayerParams(
      // playlist: ['nPt8bK2gbaU', 'gQDByCdjUXw'], // Defining custom playlist
      showControls: true,
      showFullscreenButton: true,
    ),
  );
  @override
  void initState() {
    prisonerController = TextEditingController(text: "$numberOfPrisoners")
      ..addListener(() {
        try{
          numberOfPrisoners = int.parse(prisonerController.value.text);
        }catch(e){
          prisonerController.text = "0";
          numberOfPrisoners = 0;
        }

        setState(() {});
      });
    testsController = TextEditingController(text: "$numberOfTests")
      ..addListener(() {
        try{
          numberOfTests = int.parse(testsController.value.text);
        }catch(e){
          testsController.text = "0";
          numberOfTests = 0;
        }
        setState(() {});
      });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: SingleChildScrollView(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  width: 600,
                  child: YoutubePlayerIFrame(
                    controller: _controller,
                    aspectRatio: 16 / 9,
                  ),
                ),
                Container(
                  width: 200,
                  child: TextField(
                    controller: prisonerController,
                    decoration: const InputDecoration(labelText: "Number of Prisoners"),
                    keyboardType: TextInputType.number,
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.digitsOnly,
                    ], // Only numbers can be entered
                  ),
                ),
                const SizedBox(height: 20,),
                Container(
                  width: 200,
                  child: TextField(
                    controller: testsController,
                    decoration: const InputDecoration(labelText: "Number of tests"),
                    keyboardType: TextInputType.number,
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.digitsOnly,
                    ], // Only numbers can be entered
                  ),
                ),
                const SizedBox(height: 20,),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ElevatedButton(
                      onPressed: calculating ? null : startRandom,
                      child: const Text('Run Random'),
                    ),
                     const SizedBox(width: 20,),
                     ElevatedButton(
                      onPressed:  calculating ? null : startStrategy,
                      child: const Text('Run Strategy'),

                    ),
                  ],
                ),
                const SizedBox(height: 20,),
                calculating ? const Text("Calculating..."): Container(),
                Row(
                  children: [
                   Column(
                     children: [
                       Text("Possibility to survive: ${successRandom/totalRandom}"),
                       Text("Survived: $successRandom"),
                       Text("Tests: $totalRandom")
                     ],
                   ),
                    const SizedBox(width: 20,),
                    Column(
                      children: [
                        Text("Possibility to survive: ${successStrategy/totalStrategy}"),
                        Text("Survived: $successStrategy"),
                        Text("Tests: $totalStrategy")
                      ],
                    )
                  ],
                )
              ],
            ),
          ],
        ),
      ),
     );
  }


  bool calculating = false;
  int successRandom = 0;
  int totalRandom = 0;
  int successStrategy= 0;
  int totalStrategy = 0;

  Future<void> startRandom() async {
    if (numberOfTests == 0 || numberOfPrisoners == 0){
      Fluttertoast.showToast(
          msg: "Please number of prisoners or number of tests",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 2,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          webBgColor : "#ff0000",
          webPosition: "center",
          fontSize: 16.0
      );
      return;
    }

    setState(() {
      calculating = true;
    });

    Timer(const Duration(seconds: 1), () async {
      var result = await PrisonerProblem(numberOfPrisoners: numberOfPrisoners, numberOfTest: numberOfTests ).startRandom();
      print("result random ${result.survive} ${result.total}");

      setState(() {
        successRandom = successRandom +result.survive;
        totalRandom= totalRandom +result.total;
        calculating = false;
      });
    });
  }

  Future<void> startStrategy() async {
    if (numberOfTests == 0 || numberOfPrisoners == 0){
      Fluttertoast.showToast(
          msg: "Please number of prisoners or number of tests",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          webBgColor : "#ff0000",
          webPosition: "center",
          fontSize: 16.0
      );
      return;
    }
    setState(() {
      calculating = true;
    });
    Timer(const Duration(seconds: 1), () async {
      var result = await PrisonerProblem(numberOfPrisoners: numberOfPrisoners, numberOfTest: numberOfTests ).startStrategy();
      print("result strategy ${result.survive} ${result.total}");
      setState(() {
        successStrategy = successStrategy +result.survive;
        totalStrategy = totalStrategy +result.total;
        calculating = false;
      });
    });

  }

  @override
  void dispose() {
    prisonerController.dispose();
    testsController.dispose();
    super.dispose();
  }
}
