import 'package:flutter/material.dart';

class RecordTagModel {
  int? id;
  int recordId;
  int tagId;

  RecordTagModel({
    this.id,
    required this.recordId,
    required this.tagId,
  });

  Map<String, dynamic> toMap() {
    return {
      'recordId':recordId,
      'tagId':tagId,
    };
  }

  factory RecordTagModel.fromJson(Map json){
    return RecordTagModel(
      recordId: json['recordId'],
      tagId: json['tagId'],
    );
  }

  @override
  String toString() {
    return '\nid : $id\nrecordId : $recordId \ntagId : $tagId';
  }
}
