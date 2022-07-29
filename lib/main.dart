import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hundred_prisoners_problem/classes/prisoner_problem.dart';
import 'package:hundred_prisoners_problem/widgets/chart_widget.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';
import 'package:charts_flutter/flutter.dart' as charts;

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
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'The 100 Prisoners Problem'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  int numberOfTests = 100;
  int numberOfPrisoners = 100;
  bool calculating = false;
  int successRandom = 0;
  int totalRandom = 0;
  int successStrategy= 0;
  int totalStrategy = 0;
  String lastRun = "";
  int lastSuccess=0;
  int lastTotal= 0;
  List<int> countOfPrisonersFoundNumberRandom = [];
  List<int> countOfPrisonersFoundNumberStrategy =[];

  resetState(){
    successRandom = 0;
     totalRandom = 0;
     successStrategy= 0;
     totalStrategy = 0;
     lastRun = "";
     lastSuccess=0;
     lastTotal= 0;
    countOfPrisonersFoundNumberRandom = List.filled(numberOfPrisoners, 0);
    countOfPrisonersFoundNumberStrategy = List.filled(numberOfPrisoners, 0);
  }

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
        resetState();
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
        resetState();
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
                lastRun.isEmpty? Container(): Text("Last Run $lastRun, Survived $lastSuccess out of $lastTotal runs"),
                const SizedBox(height: 20,),
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
                ),
                Container(
                    width: 700,
                    height: 400,
                    child: InitialSelection(randomSeriesList: countOfPrisonersFoundNumberRandom, animate: true, strategySeriesList: countOfPrisonersFoundNumberStrategy,))
              ],
            ),
          ],
        ),
      ),
     );
  }


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
      (result.prisonersFoundNumber);
      setState(() {
        lastRun = "Random";
        lastSuccess = result.survive;
        lastTotal = result.total;
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
        lastRun = "Strategy";
        lastSuccess = result.survive;
        lastTotal = result.total;

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

  setRandomDataForChart(List<int> prisonersFoundNumber){
    prisonersFoundNumber.forEach((element) {
      countOfPrisonersFoundNumberRandom[element] = countOfPrisonersFoundNumberRandom[element] +1;
    });
  }
  setStrategyDataForChart(List<int> prisonersFoundNumber){
    prisonersFoundNumber.forEach((element) {
      countOfPrisonersFoundNumberStrategy[element] = countOfPrisonersFoundNumberStrategy[element] +1;
    });
  }

}



