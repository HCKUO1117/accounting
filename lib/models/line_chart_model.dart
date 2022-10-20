import 'package:accounting/db/category_model.dart';
import 'package:accounting/screens/chart/chart_screen.dart';

class LineChartModel {
  CategoryModel model;
  List<SalesData> dataList;

  LineChartModel({
    required this.model,
    required this.dataList,
  });
}
