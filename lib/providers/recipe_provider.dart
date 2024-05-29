import 'package:flutter/material.dart';
import 'package:recipe_swiper/models/recipe.dart';
import 'package:recipe_swiper/services/recipe_api.dart';
import 'package:supabase_flutter/supabase_flutter.dart';


import '../views/widgets/message_banner.dart';


class RecipeProvider with ChangeNotifier {
  List<Recipe> _recipes = [];
  List<Recipe> _favoriteRecipes = [];
  List<Recipe> _searchResults = [];
  bool _isSearchLoading = false;
  bool _isLoading = true;
  bool _isFavoriteLoading = false;


  Recipe? _currentRecipe;




  List<Recipe> get searchResults => _searchResults;
  bool get isSearchLoading => _isSearchLoading;
  List<Recipe> get recipes => _recipes;
  List<Recipe> get favoriteRecipes => _favoriteRecipes;
  bool get isLoading => _isLoading;
  bool get isFavoriteLoading => _isFavoriteLoading;
  Recipe? get currentRecipe => _currentRecipe;


  void init(BuildContext context) {
    getRecipes(context);
  }


  Future<void> searchRecipes(String query) async {
    try {
      _isSearchLoading = true;
      notifyListeners();


      List<Recipe> results = await RecipeApi.searchRecipes(query);
      _searchResults = results;
    } catch (e) {
      print('Error searching recipes: $e');
    } finally {
      _isSearchLoading = false;
      notifyListeners();
    }
  }
  void clearSearchResults() {
    _searchResults = [];
    notifyListeners();
  }


  void _setMessage(BuildContext context, String message, MessageType type) {
    final color = _getMessageColor(type);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: color,
      ),
    );
  }


  Color _getMessageColor(MessageType type) {
    switch (type) {
      case MessageType.error:
        return Colors.red;
      case MessageType.success:
        return Colors.green;
      default:
        return Colors.blue;
    }
  }


  Future<void> getFavoriteRecipes(BuildContext context) async {
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
      _setMessage(context, 'Error fetching favorite recipes: $e', MessageType.error);
    } finally {
      _isFavoriteLoading = false;
      notifyListeners();
    }
  }


  Future<void> addFavoriteRecipe(BuildContext context, Recipe recipe) async {
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
      _setMessage(context, 'Recipe added to favorites', MessageType.success);
      notifyListeners();
    } catch (e) {
      _setMessage(context, 'Error adding favorite recipe: $e', MessageType.error);
    }
  }


  Future<void> removeFavoriteRecipe(BuildContext context, Recipe recipe) async {
    final userId = Supabase.instance.client.auth.currentUser?.id;
    if (userId == null) return;


    try {
      await Supabase.instance.client
          .from('favorites')
          .delete()
          .eq('user_id', userId)
          .eq('recipe_id', recipe.id);


      _favoriteRecipes.remove(recipe);
      _setMessage(context, 'Recipe removed from favorites', MessageType.success);
      notifyListeners();
    } catch (e) {
      _setMessage(context, 'Error removing favorite recipe: $e', MessageType.error);
    }
  }


  Future<void> getRecipes(BuildContext context) async {
    try {
      _isLoading = true;
      notifyListeners();


      List<Recipe> newRecipes = await RecipeApi.getRecipe();
      _recipes.addAll(newRecipes);


      _isLoading = false;
      _setNextRecipe(context);


      await getFavoriteRecipes(context);
    } catch (e) {
      _isLoading = false;
      _setMessage(context, 'Error fetching recipes: $e', MessageType.error);
      rethrow;
    } finally {
      notifyListeners();
    }
  }


  Future<void> fetchNewRecipe(BuildContext context) async {
    try {
      List<Recipe> newRecipes = await RecipeApi.getRecipe();
      _recipes.addAll(newRecipes);
    } catch (e) {
      _setMessage(context, 'Error fetching new recipes: $e', MessageType.error);
    }
  }


  void _setNextRecipe(BuildContext context) async {
    if (_recipes.isNotEmpty) {
      _currentRecipe = _recipes.removeAt(0);
    } else {
      await fetchNewRecipe(context);
      if (_recipes.isNotEmpty) {
        _currentRecipe = _recipes.removeAt(0);
      } else {
        _currentRecipe = null;
      }
    }
    notifyListeners();
  }


  void handleSwipeRight(BuildContext context) async {
    if (_currentRecipe != null) {
      await addFavoriteRecipe(context, _currentRecipe!);
    }
    _setNextRecipe(context);
  }


  void handleSwipeLeft(BuildContext context) {
    _setNextRecipe(context);
  }
}

