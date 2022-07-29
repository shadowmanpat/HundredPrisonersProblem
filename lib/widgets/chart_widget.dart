/// Example of adding an initial selection behavior.
///
/// This example adds initial selection to a bar chart, but any chart can use
/// the initial selection behavior.
///
/// Initial selection is only set on the very first draw and will not be set
/// again in subsequent draws unless the behavior is reconfigured.
///
/// The selection will remain on the chart unless another behavior is added
/// that updates the selection.

import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';

class InitialSelection extends StatelessWidget {
  final  List<int> randomSeriesList;
  final  List<int> strategySeriesList;
  final bool animate;

  InitialSelection( {required this.randomSeriesList,required this.strategySeriesList,required this.animate});

  // /// Creates a [BarChart] with initial selection behavior.
  // factory InitialSelection.withSampleData() {
  //   return InitialSelection(s
  //     createSampleData(),
  //     // Disable animations for image tests.
  //     animate: false,
  //   );
  // }


  @override
  Widget build(BuildContext context) {
    return charts.BarChart(
     //  primaryMeasureAxis: charts.NumericAxisSpec(
     //   tickFormatterSpec: charts.BasicNumericTickFormatterSpec((num? value) {
     //     print("value $value");
     //     return "value";
     //   }),
     // ),
        barGroupingType: charts.BarGroupingType.grouped,
        primaryMeasureAxis: new charts.NumericAxisSpec(
            tickProviderSpec:
            new charts.BasicNumericTickProviderSpec(desiredTickCount: 6,
            )),
      domainAxis: new charts.OrdinalAxisSpec(
          showAxisLine: true,
          // But don't draw anything else.
         ),
      createData(),
      animate: animate,
      behaviors: [
        // Initial selection can be configured by passing in:
        //
        // A list of datum config, specified with series ID and domain value.
        // A list of series config, which is a list of series ID(s).
        //
        // Initial selection can be applied to any chart type.
        //
        // [BarChart] by default includes behaviors [SelectNearest] and
        // [DomainHighlighter]. So this behavior shows the initial selection
        // highlighted and when another datum is tapped, the selection changes.
        new charts.InitialSelection(
            selectedDataConfig: [
          new charts.SeriesDatumConfig<String>('Propabiliy', '# prisoners who found their number')
        ])
      ],
    );
  }

  /// Create one series with sample hard coded data.
  List<charts.Series<DataPoint, String>> createData() {
    List<DataPoint> strategyList = [];
    List<DataPoint> randomList = [];
    int strategySum = strategySeriesList.fold<int>(0, (int sum, int item) => sum + item);
    int randomSum = randomSeriesList.fold<int>(0, (int sum, int item) => sum + item);

    if (strategySum>0){
      for (int position = 0; position < strategySeriesList.length; position++) {
        strategyList.add(DataPoint("$position", (strategySeriesList[position]/strategySum)*100));
      }
    }
    if (randomSum>0){
      for (int position = 0; position < randomSeriesList.length; position++) {
        randomList.add(DataPoint("$position", (randomSeriesList[position]/randomSum)*100));
      }
    }


    var strategyChartItems = new charts.Series<DataPoint, String>(
      id: 'Strategy',
      colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
      domainFn: (DataPoint sales, _) => sales.number,
      measureFn: (DataPoint sales, _) => sales.sales,
      data: strategyList,
    );
    var randomChartItems = new charts.Series<DataPoint, String>(
      id: 'Random',
      colorFn: (_, __) => charts.MaterialPalette.red.shadeDefault,
      domainFn: (DataPoint sales, _) => sales.number,
      measureFn: (DataPoint sales, _) => sales.sales,
      data: randomList,
    );
    // strategySeriesList.toList().addAll(randomChartItems);
    return [
      strategyChartItems,
      randomChartItems
    ];
  }
}


/// Sample ordinal data type.
class DataPoint {
  final String number;
  final double sales;

  DataPoint(this.number, this.sales);
}