class TagModel {
  int? id;
  String icon;
  String name;

  TagModel({
    this.id,
    required this.icon,
    required this.name,
  });

  Map<String, dynamic> toMap() {
    return {
      'icon': icon,
      'name': name,
    };
  }

  @override
  String toString() {
    return 'id : $id\nicon : $icon \nname : $name';
  }
}
