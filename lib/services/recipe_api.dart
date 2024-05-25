import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:recipe_swiper/models/recipe.dart';


class RecipeApi {
  static Future<List<Recipe>> getRecipe() async {
    var uri = Uri.https('yummly2.p.rapidapi.com', '/feeds/list',
        {"limit": "18", "start": "0", "tag": "list.recipe.popular"});


    final response = await http.get(uri, headers: {
      "x-rapidapi-key": "d3ea125db4mshb5f6477f6e33a30p1550d6jsn4e905869e579",
      "x-rapidapi-host": "yummly2.p.rapidapi.com",
      "useQueryString": "true"
    });


    if (response.statusCode == 200) {
      Map data = jsonDecode(response.body);
      List _temp = [];


      for (var i in data['feed']) {
        _temp.add(i['content']['details']);
      }


      return Recipe.recipesFromSnapshot(_temp);
    } else {
      throw Exception('Failed to load recipes');
    }
  }
}

