// home_page.dart
import 'package:flutter/material.dart';
import 'package:recipe_swiper/models/recipe.api.dart';
import 'package:recipe_swiper/models/recipe.dart';
import 'package:recipe_swiper/views/widgets/recipe_card.dart';
import 'package:recipe_swiper/views/widgets/would_you_rather_widget.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Recipe> _recipes = [];
  bool _isLoading = true;

  Recipe? _currentOptionA;
  Recipe? _currentOptionB;

  @override
  void initState() {
    super.initState();
    getRecipes();
  }

  Future<void> getRecipes() async {
    var recipes = await RecipeApi.getRecipe();
    setState(() {
      _recipes = recipes;
      _isLoading = false;
      _setNextOptions(); // Set the first pair of options
    });
  }

  void _setNextOptions() {
    // Simple logic to cycle through recipes two at a time
    // You might want to add more complex logic to ensure good variety and that recipes aren't repeated too often
    if (_recipes.isNotEmpty) {
      _currentOptionA = _recipes.removeAt(0);
      _currentOptionB = _recipes.removeAt(0);
    }
  }

  void _handleOptionSelected(Recipe selectedRecipe) {
    setState(() {
      // Add logic to handle the selection, e.g., save the user's preference

      // Replace with the next recipes
      _setNextOptions();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Would You Rather - Food Edition'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _currentOptionA == null || _currentOptionB == null
          ? const Center(child: Text('No more recipes!'))
          : WouldYouRatherWidget(
        optionA: _currentOptionA!,
        optionB: _currentOptionB!,
        onOptionSelected: _handleOptionSelected,
      ),
    );
  }
}
