// const prisoners = 100;
// const tries = prisoners/2;

List<int> getRandomArray(int prisoners){
  List<int> original = Iterable<int>.generate(prisoners).toList();
  List<int> randomArray = [];
  while(original.isNotEmpty){
    var randomItem = (original..shuffle()).first;
    randomArray.add(randomItem);
    original.remove(randomItem);
  }
  return randomArray;
}