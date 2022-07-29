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
        new charts.InitialSelection(selectedDataConfig: [
          new charts.SeriesDatumConfig<String>('Propabiliy', '# prisoners who found their number')
        ])
      ],
    );
  }

  /// Create one series with sample hard coded data.
  List<charts.Series<OrdinalSales, String>> createData() {
    List<OrdinalSales> strategyList = [];
    List<OrdinalSales> randomList = [];
    for (int position = 0; position < strategySeriesList.length; position++) {
     strategyList.add(OrdinalSales("$position", strategySeriesList[position]));
    }
    for (int position = 0; position < randomSeriesList.length; position++) {
      randomList.add(OrdinalSales("$position", randomSeriesList[position]));
    }

    var strategyChartItems = new charts.Series<OrdinalSales, String>(
      id: 'Sales',
      colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
      domainFn: (OrdinalSales sales, _) => sales.year,
      measureFn: (OrdinalSales sales, _) => sales.sales,
      data: strategyList,
    );
    var randomChartItems = new charts.Series<OrdinalSales, String>(
      id: 'Sales',
      colorFn: (_, __) => charts.MaterialPalette.red.shadeDefault,
      domainFn: (OrdinalSales sales, _) => sales.year,
      measureFn: (OrdinalSales sales, _) => sales.sales,
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
class OrdinalSales {
  final String year;
  final int sales;

  OrdinalSales(this.year, this.sales);
}