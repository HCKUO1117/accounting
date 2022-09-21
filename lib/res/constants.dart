import 'package:accounting/db/category_model.dart';

class Constants {
  static const String hadOpen = 'hadOpen';

  static List<CategoryModel> defaultCategories = [
    CategoryModel(type: CategoryType.income, icon: 'directions_car', name: '')
  ];
}
