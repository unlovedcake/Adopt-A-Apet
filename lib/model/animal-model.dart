class AnimalModel {
  String? API;
  String? Description;
  String? Auth;
  bool? HTTPS;
  String? Cors;
  String? Link;
  String? Category;

  AnimalModel({
    this.API,
    this.Description,
    this.Auth,
    this.HTTPS,
    this.Cors,
    this.Link,
    this.Category,
  });

// receiving data from server
  factory AnimalModel.fromMap(map) {
    return AnimalModel(
      API: map['API'],
      Description: map['Description'],
      Auth: map['AUTH'],
      HTTPS: map['HTTPS'],
      Cors: map['Cors'],
      Link: map['Link'],
      Category: map['Category'],
    );
  }
}
