import 'package:cloud_firestore/cloud_firestore.dart';

class StudentModel {
  String? name;
  int? age;
  String? imageUrl;
  String? id;
  DateTime? createdAt;

  StudentModel(
      {this.name, this.age, this.imageUrl, this.id,  this.createdAt});

  factory StudentModel.fromJson(DocumentSnapshot json) {
    return StudentModel(
      name: json['name'],
      age: json['age'],
      imageUrl: json['imageUrl'],
      id: json['id'],
      createdAt: json['createdAt'].toDate(),
    );
  }
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'age': age,
      'imageUrl': imageUrl,
      'id': id,
      'createdAt': createdAt,
    };
  }
}
