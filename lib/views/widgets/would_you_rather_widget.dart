import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:recipe_swiper/models/recipe.dart';
import 'package:recipe_swiper/providers/recipe_provider.dart';
import 'package:recipe_swiper/views/widgets/recipe_card.dart';


class WouldYouRatherWidget extends StatelessWidget {
  final Recipe optionA;
  final Recipe optionB;
  final Function(Recipe) onOptionSelected;


  const WouldYouRatherWidget({
    Key? key,
    required this.optionA,
    required this.optionB,
    required this.onOptionSelected,
  }) : super(key: key);


  @override
  Widget build(BuildContext context) {
    final recipeProvider = Provider.of<RecipeProvider>(context);


    return Column(
      children: <Widget>[
        Expanded(
          child: GestureDetector(
            onTap: () => onOptionSelected(optionA),
            child: Stack(
              children: [
                Positioned.fill(
                  child: RecipeCard(
                    title: optionA.name,
                    cookTime: optionA.totalTime,
                    rating: optionA.rating.toString(),
                    thumbnailUrl: optionA.imageUrl,
                    recipe: optionA, // Pass the recipe object
                  ),
                ),
                Align(
                  alignment: Alignment.topRight,
                  child: IconButton(
                    icon: Icon(
                      Icons.favorite_border,
                      color: Colors.red,
                    ),
                    onPressed: () => recipeProvider.addFavoriteRecipe(optionA),
                  ),
                ),
              ],
            ),
          ),
        ),
        Container(
          color: Colors.black,
          child: Center(
            child: Text(
              'OR',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ),
        Expanded(
          child: GestureDetector(
            onTap: () => onOptionSelected(optionB),
            child: Stack(
              children: [
                Positioned.fill(
                  child: RecipeCard(
                    title: optionB.name,
                    cookTime: optionB.totalTime,
                    rating: optionB.rating.toString(),
                    thumbnailUrl: optionB.imageUrl,
                    recipe: optionB,
                  ),
                ),
                Align(
                  alignment: Alignment.topRight,
                  child: IconButton(
                    icon: Icon(
                      Icons.favorite_border,
                      color: Colors.red,
                    ),
                    onPressed: () => recipeProvider.addFavoriteRecipe(optionB),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

