class AccountingModel {
  int? id;
  DateTime date;
  int category;
  List<int> tags;
  double amount;
  String note;

  AccountingModel({
    this.id,
    required this.date,
    required this.category,
    required this.tags,
    required this.amount,
    required this.note,
  });

  Map<String, dynamic> toMap() {
    String tagString = tags.toString();

    return {
      'date': date.millisecondsSinceEpoch,
      'category': category,
      'tags': tagString.replaceAll('[', '').replaceAll(']', ''),
      'amount': amount.toString(),
      'note': note,
    };
  }

  @override
  String toString() {
    return 'id : $id\ndate : $date \ncategory : $category\ntags : $tags\namount : $amount\nnote : $note';
  }
}
