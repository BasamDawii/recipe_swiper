import 'package:flutter/material.dart';
import 'package:recipe_swiper/models/recipe.dart';
import 'package:recipe_swiper/services/recipe_api.dart';
import 'package:supabase_flutter/supabase_flutter.dart';


import '../views/widgets/message_banner.dart';


class RecipeProvider with ChangeNotifier {
  List<Recipe> _recipes = [];
  List<Recipe> _favoriteRecipes = [];
  bool _isLoading = true;
  bool _isFavoriteLoading = false;


  Recipe? _currentOptionA;
  Recipe? _currentOptionB;
  String? _message;
  MessageType? _messageType;




  List<Recipe> get recipes => _recipes;
  List<Recipe> get favoriteRecipes => _favoriteRecipes;
  bool get isLoading => _isLoading;
  bool get isFavoriteLoading => _isFavoriteLoading;
  Recipe? get currentOptionA => _currentOptionA;
  Recipe? get currentOptionB => _currentOptionB;
  String? get message => _message;
  MessageType? get messageType => _messageType;


  RecipeProvider() {
    getRecipes();
  }
  void _setMessage(String message, MessageType type) {
    _message = message;
    _messageType = type;
    notifyListeners();
  }


  Future<void> getFavoriteRecipes() async {
    final userId = Supabase.instance.client.auth.currentUser?.id;
    if (userId == null) return;


    try {
      _isFavoriteLoading = true;
      notifyListeners();


      final response = await Supabase.instance.client
          .from('favorites')
          .select('recipe_id')
          .eq('user_id', userId);


      List<String> favoriteRecipeIds = response.map((item) => item['recipe_id'] as String).toList();
      List<Recipe> favoriteRecipes = [];
      for (String id in favoriteRecipeIds) {
        Recipe recipe = await RecipeApi.getRecipeById(id);
        favoriteRecipes.add(recipe);
      }
      _favoriteRecipes = favoriteRecipes;
    } catch (e) {
      _setMessage('Error fetching favorite recipes: $e', MessageType.error);
    } finally {
      _isFavoriteLoading = false;
      notifyListeners();
    }
  }


  Future<void> addFavoriteRecipe(Recipe recipe) async {
    final userId = Supabase.instance.client.auth.currentUser?.id;
    if (userId == null) return;


    try {
      await Supabase.instance.client
          .from('favorites')
          .insert({
        'user_id': userId,
        'recipe_id': recipe.id,
      });


      _favoriteRecipes.add(recipe);
      _setMessage('Recipe added to favorites', MessageType.success);
      notifyListeners();
    } catch (e) {
      _setMessage('Error adding favorite recipe: $e', MessageType.error);
    }
  }


  Future<void> removeFavoriteRecipe(Recipe recipe) async {
    final userId = Supabase.instance.client.auth.currentUser?.id;
    if (userId == null) return;


    try {
      await Supabase.instance.client
          .from('favorites')
          .delete()
          .eq('user_id', userId)
          .eq('recipe_id', recipe.id);


      _favoriteRecipes.remove(recipe);
      _setMessage('Recipe removed from favorites', MessageType.success);
      notifyListeners();
    } catch (e) {
      _setMessage('Error removing favorite recipe: $e', MessageType.error);
    }
  }


  Future<void> getRecipes() async {
    try {
      _isLoading = true;
      notifyListeners();


      _recipes = [];
      _recipes.addAll(await RecipeApi.getRecipe());
      _recipes.addAll(await RecipeApi.getRecipe());


      _isLoading = false;
      _setNextOptions();


      await getFavoriteRecipes();
    } catch (e) {
      _isLoading = false;
      _setMessage('Error fetching recipes: $e', MessageType.error);
      rethrow;
    } finally {
      notifyListeners();
    }
  }


  Future<void> fetchNewRecipes() async {
    try {
      List<Recipe> newRecipes = [];
      newRecipes.addAll(await RecipeApi.getRecipe());
      newRecipes.addAll(await RecipeApi.getRecipe());


      _recipes = newRecipes;
      _setNextOptions();
    } catch (e) {
      _setMessage('Error fetching new recipes: $e', MessageType.error);
    }
  }


  void _setNextOptions() {
    if (_recipes.length >= 2) {
      _currentOptionA = _recipes.removeAt(0);
      _currentOptionB = _recipes.removeAt(0);
    } else {
      _currentOptionA = null;
      _currentOptionB = null;
    }
    notifyListeners();
  }


  void handleOptionSelected(Recipe selectedRecipe) async {
    await fetchNewRecipes();
    notifyListeners();
  }
  void clearMessage() {
    _message = null;
    _messageType = null;
    notifyListeners();
  }
}

