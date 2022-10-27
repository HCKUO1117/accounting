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

  factory AccountingModel.fromJson(Map json) {
    List<int> tags = [];
    if (json['tags'].toString().isNotEmpty) {
      tags = [
        for (var element in json['tags'].toString().split(',')) int.parse(element)
      ];
    }

    return AccountingModel(
      date: DateTime.fromMillisecondsSinceEpoch(json['date']),
      category: json['category'],
      tags: tags,
      amount: double.parse(json['amount']),
      note: json['note'],
    );
  }

  @override
  String toString() {
    return 'id : $id\ndate : $date \ncategory : $category\ntags : $tags\namount : $amount\nnote : $note';
  }
}
