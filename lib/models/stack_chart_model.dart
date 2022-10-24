import 'package:accounting/db/category_model.dart';
import 'package:accounting/screens/chart/chart_screen.dart';

class StackChartModel {
  CategoryModel model;
  List<ChartData> dataList;

  StackChartModel({
    required this.model,
    required this.dataList,
  });
}
