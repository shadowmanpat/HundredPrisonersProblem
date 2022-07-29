import 'dart:math';

import 'package:hundred_prisoners_problem/helper/random_array.dart';

class PrisonerProblem {
  var randomArray = getRandomArray();


  PrisonerProblem(){
    // startRandom(randomArray);
    startStrategy(randomArray);
    // pickStrategy(0, randomArray);
    // for (int prisoner = 0; prisoner < 1000; prisoner++) {
    //   startRandom(randomArray);
    // }
  }

  bool startRandom(List<int> randomArray){
    List<bool> result = [];
    for (int prisoner = 0; prisoner < prisoners; prisoner++) {
      var pickedArray = pickRandom(randomArray);
      result.add(pickedArray.contains(prisoner));
    }
    if (result.contains(false)){
      print("die");
      return true;
    } else{
      print("survive");
      return false;
    }
  }
  bool startStrategy(List<int> randomArray){
    List<bool> result = [];
    for (int prisoner = 0; prisoner < prisoners; prisoner++) {
      var pickedArray = pickStrategy(prisoner,randomArray);
      result.add(pickedArray.contains(prisoner));
    }
    if (result.contains(false)){
      print("die");
      return true;
    } else{
      print("survive");
      return false;
    }
  }



  List<int> pickStrategy(int prisoner,List<int> randomArray){
    List<int> pickedArray = [];
    var itemToPick = prisoner;
    for (int pick = 0; pick < tries; pick++) {
      pickedArray.add(randomArray[itemToPick]);
      itemToPick = randomArray[itemToPick];
    }
    return pickedArray;
  }
  List<int> pickRandom(List<int> randomArray) {
    var tempArray = List.from(randomArray);
    List<int> pickedArray = [];
    for (int pick = 0; pick < tries; pick++) {
      final random = Random();
      var i = random.nextInt(tempArray.length);
      pickedArray.add(tempArray[i]);
      tempArray.removeAt(i);
    }
    return pickedArray;
  }
}



