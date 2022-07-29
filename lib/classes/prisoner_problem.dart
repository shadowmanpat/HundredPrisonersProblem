import 'dart:math';

import 'package:hundred_prisoners_problem/helper/random_array.dart';

class PrisonerProblemResult{
  int survive;
  int total;
  PrisonerProblemResult({required this.survive,required this.total});


}
class PrisonerProblem {
  int numberOfTest;
  int numberOfPrisoners;
  double get numberOfTries => numberOfPrisoners/2;
  PrisonerProblem({required this.numberOfTest, required this.numberOfPrisoners}){

  }

  Future<PrisonerProblemResult> startStrategy() async{
    List<bool> results = [];
    for (int prisoner = 0; prisoner < numberOfTest; prisoner++) {
      var result = _startStrategySingle();
      results.add(result);
    }
    int survive = results.where((element) => element == true).length;

    return PrisonerProblemResult(survive: survive, total: numberOfTest);
  }
  Future<PrisonerProblemResult> startRandom() async{
    List<bool> results = [];
    for (int prisoner = 0; prisoner < numberOfTest; prisoner++) {
      var result = _startRandomSingle();
      results.add(result);
    }
    int survive = results.where((element) => element == true).length;
    return PrisonerProblemResult(survive: survive, total: numberOfTest);
  }

  bool _startRandomSingle(){
    List<bool> result = [];
    var randomArray = getRandomArray(numberOfPrisoners);
    for (int prisoner = 0; prisoner < numberOfPrisoners; prisoner++) {
      var pickedArray = _pickRandom(randomArray);
      result.add(pickedArray.contains(prisoner));
    }
    if (result.contains(false)){
      return false;
    } else{
      return true;
    }
  }
  bool _startStrategySingle(){
    List<bool> result = [];
    var randomArray = getRandomArray(numberOfPrisoners);
    for (int prisoner = 0; prisoner < numberOfPrisoners; prisoner++) {
      var pickedArray = pickStrategy(prisoner,randomArray);
      result.add(pickedArray.contains(prisoner));
    }
    if (result.contains(false)){
      return false;
    } else{
      return true;
    }
  }



  List<int> pickStrategy(int prisoner,List<int> randomArray){

    List<int> pickedArray = [];
    var itemToPick = prisoner;
    for (int pick = 0; pick < numberOfTries; pick++) {
      pickedArray.add(randomArray[itemToPick]);
      itemToPick = randomArray[itemToPick];
    }
    return pickedArray;
  }
  List<int> _pickRandom(List<int> randomArray) {
    var tempArray = List.from(randomArray);
    List<int> pickedArray = [];
    for (int pick = 0; pick < numberOfTries; pick++) {
      final random = Random();
      var i = random.nextInt(tempArray.length);
      pickedArray.add(tempArray[i]);
      tempArray.removeAt(i);
    }
    return pickedArray;
  }
}




