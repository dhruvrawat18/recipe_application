import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:recipe_app/models/recipe_model.dart';
import 'package:recipe_app/views/recipe_view.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<RecipeModel> recipes = new List<RecipeModel>();
  TextEditingController textEditingController = new TextEditingController();

  String applicationId = "YOUR APP ID";
  String applicationKey = "Your Applicartion Key";

  getRecipes(String query) async {
    String url =
        "https://api.edamam.com/search?q=$query&app_id=$applicationId&app_key=$applicationKey";

    recipes.clear();
    var response = await http.get(url);
    Map<String, dynamic> jsonData = jsonDecode(response.body);
    jsonData["hits"].forEach((element) {
      RecipeModel recipeModel = new RecipeModel();
      recipeModel = RecipeModel.fromMap(element["recipe"]);
      setState(() {
        recipes.add(recipeModel);
      });
    });

    print(recipes.toString());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Stack(
            children: [
              Image.network(
                  "https://images.unsplash.com/photo-1458253756247-1e4ed949191b?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&w=1000&q=80"),
              Padding(
                padding:
                    EdgeInsets.only(top: 40, bottom: 10, left: 50, right: 50),
                child: Column(
                  children: [
                    Text(
                      'What do you\n want to cook?',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.poppins(
                          fontSize: 40,
                          color: Colors.white,
                          fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Text(
                      'Enter the ingredients\n you have and wait for a masterpiece!',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.poppins(
                          fontSize: 16,
                          color: Colors.white,
                          fontWeight: FontWeight.w200),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                      // topLeft: Radius.circular(),
                      // topRight: Radius.circular(),
                      ),
                ),
                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(right: 20, left: 20, top: 20),
                      child: Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 30, vertical: 5),
                        decoration: BoxDecoration(
                          color: Colors.orange,
                          borderRadius: BorderRadius.all(
                            Radius.circular(30),
                          ),
                        ),
                        width: MediaQuery.of(context).size.width,
                        child: Row(
                          children: [
                            Expanded(
                              child: TextField(
                                controller: textEditingController,
                                style: GoogleFonts.poppins(
                                  color: Colors.white,
                                ),
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: "Ingredient goes here",
                                  hintStyle: GoogleFonts.poppins(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w100),
                                ),
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                if (textEditingController.text.isNotEmpty) {
                                  FocusScope.of(context).unfocus();
                                  getRecipes(textEditingController.text);
                                  print("searching");
                                } else {
                                  print("search box is empty");
                                }
                              },
                              child: Container(
                                child: Icon(
                                  Icons.search,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Container(
                      child: GridView(
                          physics: ScrollPhysics(),
                          shrinkWrap: true,
                          scrollDirection: Axis.vertical,
                          gridDelegate:
                              SliverGridDelegateWithMaxCrossAxisExtent(
                            maxCrossAxisExtent: 350,
                            mainAxisSpacing: 20.0,
                          ),
                          children: List.generate(recipes.length, (index) {
                            return GridTile(
                              child: RecipeTile(
                                title: recipes[index].label,
                                url: recipes[index].image,
                                source: recipes[index].source,
                                postUrl: recipes[index].url,
                              ),
                            );
                          })),
                    ),
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}

class RecipeTile extends StatefulWidget {
  final String url, source, title, postUrl;
  RecipeTile({this.url, this.source, this.postUrl, this.title});

  @override
  _RecipeTileState createState() => _RecipeTileState();
}

class _RecipeTileState extends State<RecipeTile> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => RecipeView(
                      postUrl: widget.postUrl,
                    )));
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 0),
          child: Column(
            children: [
              Expanded(
                  child: ClipRRect(
                borderRadius: BorderRadius.circular(12.0),
                child: Image.network(
                  widget.url,
                  fit: BoxFit.cover,
                  scale: 2.0,
                ),
              )),
              SizedBox(
                height: 10,
              ),
              Text(
                widget.title,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(fontSize: 18),
              ),
              SizedBox(
                height: 5,
              ),
              Text(
                widget.source,
                style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w300, fontSize: 12),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
