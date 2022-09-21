enum CategoryType {
  income,
  expenditure,
}

extension CategoryTypeEx on CategoryType {
  String get text {
    switch (this) {
      case CategoryType.income:
        return 'income';
      case CategoryType.expenditure:
        return 'expenditure';
    }
  }
}

class CategoryModel {
  int? id;
  CategoryType type;
  String icon;
  String name;

  CategoryModel({
    this.id,
    required this.type,
    required this.icon,
    required this.name,
  });

  Map<String, dynamic> toMap() {
    return {
      'icon': icon,
      'name': name,
      'type':type.text
    };
  }

  @override
  String toString() {
    return 'id : $id\nicon : $icon \nname : $name \ntype : ${type.text}';
  }
}
