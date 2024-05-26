import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:recipe_swiper/providers/recipe_provider.dart';
import 'package:recipe_swiper/views/widgets/recipe_card.dart';


class FavoritesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final recipeProvider = Provider.of<RecipeProvider>(context);


    return Scaffold(
      appBar: AppBar(
        title: Text('Favorite Recipes'),
      ),
      body: recipeProvider.isFavoriteLoading
          ? Center(child: CircularProgressIndicator())
          : recipeProvider.favoriteRecipes.isEmpty
          ? Center(child: Text('No favorite recipes yet!'))
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
                recipe: recipe, // Add this line to pass the recipe object
              ),
              Align(
                alignment: Alignment.topRight,
                child: IconButton(
                  icon: Icon(Icons.favorite),
                  onPressed: () {
                    recipeProvider.removeFavoriteRecipe(recipe);
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

