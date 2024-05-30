import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:recipe_swiper/l10n/l10n.dart';
import 'package:recipe_swiper/providers/recipe_provider.dart';
import 'package:recipe_swiper/views/widgets/recipe_card.dart';

import '../providers/localization_provider.dart';

class FavoritesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final recipeProvider = Provider.of<RecipeProvider>(context);
    final localizationProvider = Provider.of<LocalizationProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          L10n.translate('favorites')!,
          style: TextStyle(color: Color(0xFFECF0F1)),
        ),
        backgroundColor: Color(0xFF657990),
      ),
      body: Container(
        color: Color(0xFF2C3E50),
        child: recipeProvider.isFavoriteLoading
            ? Center(child: CircularProgressIndicator())
            : recipeProvider.favoriteRecipes.isEmpty
            ? Center(
          child: Text(
            L10n.translate('no_more_recipes')!,
            style: TextStyle(fontSize: 18, color: Color(0xFFECF0F1)),
          ),
        )
            : ListView.builder(
          itemCount: recipeProvider.favoriteRecipes.length,
          itemBuilder: (context, index) {
            final recipe = recipeProvider.favoriteRecipes[index];
            return Stack(
              children: [
                RecipeCard(
                  title: recipe.name,
                  cookTime: recipe.totalTime,
                  rating: recipe.rating.toString(),
                  thumbnailUrl: recipe.imageUrl,
                  recipe: recipe,
                ),
                Positioned(
                  top: 10,
                  right: 10,
                  child: IconButton(
                    icon: Icon(
                      Icons.favorite,
                      color: Color(0xFFF44336),
                    ),
                    onPressed: () {
                      recipeProvider.removeFavoriteRecipe(
                          context, recipe);
                    },
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
