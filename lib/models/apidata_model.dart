

// creating a model
class ApiDataModel {
  int? id;
  String? title;
  double? price;
  String? description;
  String? category;
  String? image;

  ApiDataModel({
    this.id,
    this.title,
    this.price,
    this.description,
    this.category,
    this.image,
  });

  factory ApiDataModel.fromJson(Map<String, dynamic> json) {
    return ApiDataModel(
      id: json['id'],
      title: json['title'],
      price: json['price']?.toDouble(),
      description: json['description'],
      category: json['category'],
      image: json['image'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'price': price,
      'description': description,
      'category': category,
      'image': image,
    };
  }
}
