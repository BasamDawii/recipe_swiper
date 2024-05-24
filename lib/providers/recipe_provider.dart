import 'package:flutter/material.dart';
import 'package:recipe_swiper/models/recipe.dart';
import 'package:recipe_swiper/services/recipe_api.dart';

class RecipeProvider with ChangeNotifier {
  List<Recipe> _recipes = [];
  bool _isLoading = true;

  Recipe? _currentOptionA;
  Recipe? _currentOptionB;

  List<Recipe> get recipes => _recipes;
  bool get isLoading => _isLoading;
  Recipe? get currentOptionA => _currentOptionA;
  Recipe? get currentOptionB => _currentOptionB;

  RecipeProvider() {
    getRecipes();
  }

  Future<void> getRecipes() async {
    try {
      _recipes = await RecipeApi.getRecipe();
      _isLoading = false;
      _setNextOptions();
    } catch (e) {
      _isLoading = false;
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
