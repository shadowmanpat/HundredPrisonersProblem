import 'dart:math';

import 'package:hundred_prisoners_problem/helper/random_array.dart';

class PrisonerProblemResult{
  int survive;
  int total;
  List<int> prisonersFoundNumber;
  PrisonerProblemResult({required this.survive,required this.total, required this.prisonersFoundNumber});


}
class PrisonerProblem {
  int numberOfTest;
  int numberOfPrisoners;
  double get numberOfTries => numberOfPrisoners/2;
  PrisonerProblem({required this.numberOfTest, required this.numberOfPrisoners}){

  }

  Future<PrisonerProblemResult> startStrategy() async{
    List<bool> results = [];
    List<int> prisonersFoundNumber = [];
    for (int prisoner = 0; prisoner < numberOfTest; prisoner++) {
      var result = _startStrategySingle();
      results.add(result.success);
      prisonersFoundNumber.add(result.prisonersFoundNumber);
    }
    int survive = results.where((element) => element == true).length;

    return PrisonerProblemResult(survive: survive, total: numberOfTest,prisonersFoundNumber: prisonersFoundNumber);
  }
  Future<PrisonerProblemResult> startRandom() async{
    List<bool> results = [];
    List<int> prisonersFoundNumber = [];
    for (int prisoner = 0; prisoner < numberOfTest; prisoner++) {
      var result = _startRandomSingle();
      results.add(result.success);
      prisonersFoundNumber.add(result.prisonersFoundNumber);
    }
    int survive = results.where((element) => element == true).length;
    return PrisonerProblemResult(survive: survive, total: numberOfTest, prisonersFoundNumber: prisonersFoundNumber);
  }

  RoundResult _startRandomSingle(){
    List<bool> result = [];
    var randomArray = getRandomArray(numberOfPrisoners);
    for (int prisoner = 0; prisoner < numberOfPrisoners; prisoner++) {
      var pickedArray = _pickRandom(randomArray);
      result.add(pickedArray.contains(prisoner));
    }
    var prisonersFoundNumber = result.where((element) => element == true).length;
    return RoundResult(prisonersFoundNumber, !result.contains(false));
  }
  RoundResult _startStrategySingle(){
    List<bool> result = [];
    var randomArray = getRandomArray(numberOfPrisoners);
    for (int prisoner = 0; prisoner < numberOfPrisoners; prisoner++) {
      var pickedArray = pickStrategy(prisoner,randomArray);
      result.add(pickedArray.contains(prisoner));
    }
    var prisonersFoundNumber = result.where((element) => element == true).length;
    return RoundResult(prisonersFoundNumber,!result.contains(false));
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
class RoundResult {
  final int prisonersFoundNumber;
  final bool success;

  RoundResult(this.prisonersFoundNumber, this.success);
}




