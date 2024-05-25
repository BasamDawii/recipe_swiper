import 'package:flutter/material.dart';
import 'package:recipe_swiper/models/recipe.dart';
import 'package:recipe_swiper/services/recipe_api.dart';
import 'package:supabase_flutter/supabase_flutter.dart';


class RecipeProvider with ChangeNotifier {
  List<Recipe> _recipes = [];
  List<Recipe> _favoriteRecipes = [];
  bool _isLoading = true;
  bool _isFavoriteLoading = false;


  Recipe? _currentOptionA;
  Recipe? _currentOptionB;


  List<Recipe> get recipes => _recipes;
  List<Recipe> get favoriteRecipes => _favoriteRecipes;
  bool get isLoading => _isLoading;
  bool get isFavoriteLoading => _isFavoriteLoading;
  Recipe? get currentOptionA => _currentOptionA;
  Recipe? get currentOptionB => _currentOptionB;


  RecipeProvider() {
    getRecipes();
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
      _favoriteRecipes = _recipes.where((recipe) => favoriteRecipeIds.contains(recipe.id)).toList();
    } catch (e) {
      print('Error fetching favorite recipes: $e');
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
      notifyListeners();
    } catch (e) {
      print('Error adding favorite recipe: $e');
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
      notifyListeners();
    } catch (e) {
      print('Error removing favorite recipe: $e');
    }
  }


  Future<void> getRecipes() async {
    try {
      _isLoading = true;
      notifyListeners();


      _recipes = await RecipeApi.getRecipe();
      _isLoading = false;
      _setNextOptions();


      // Fetch favorite recipes after fetching all recipes
      await getFavoriteRecipes();
    } catch (e) {
      _isLoading = false;
      print('Error fetching recipes: $e');
      rethrow;
    } finally {
      notifyListeners();
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


  void handleOptionSelected(Recipe selectedRecipe) {
    _setNextOptions();
    notifyListeners();
  }
}

