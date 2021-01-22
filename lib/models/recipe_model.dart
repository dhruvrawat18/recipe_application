class RecipeModel {
  String label;
  String image;
  String url;
  String source;

  RecipeModel({this.image, this.label, this.source, this.url});

  factory RecipeModel.fromMap(Map<String, dynamic> parsedJson) {
    return RecipeModel(
        url: parsedJson["url"],
        image: parsedJson["image"],
        label: parsedJson["label"],
        source: parsedJson["source"]);
  }
}
