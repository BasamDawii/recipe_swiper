import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:recipe_swiper/models/recipe.dart';


class RecipeApi {
  static Future<List<Recipe>> getRecipe() async {
    var uri = Uri.https('www.themealdb.com', '/api/json/v1/1/random.php');


    final response = await http.get(uri);


    if (response.statusCode == 200) {
      Map data = jsonDecode(response.body);
      List _temp = data['meals'];


      return Recipe.recipesFromSnapshot(_temp);
    } else {
      throw Exception('Failed to load recipes');
    }
  }


  static Future<List<Recipe>> searchRecipes(String query) async {
    var uri = Uri.https('www.themealdb.com', '/api/json/v1/1/search.php', {'s': query});


    final response = await http.get(uri);


    if (response.statusCode == 200) {
      Map data = jsonDecode(response.body);
      List _temp = data['meals'];


      return Recipe.recipesFromSnapshot(_temp);
    } else {
      throw Exception('Failed to load recipes');
    }
  }


  static Future<Recipe> getRecipeById(String id) async {
    var uri = Uri.https('www.themealdb.com', '/api/json/v1/1/lookup.php', {'i': id});


    final response = await http.get(uri);


    if (response.statusCode == 200) {
      Map data = jsonDecode(response.body);
      return Recipe.fromJson(data['meals'][0]);
    } else {
      throw Exception('Failed to load recipe');
    }
  }
}

