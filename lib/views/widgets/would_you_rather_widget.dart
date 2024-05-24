import 'package:flutter/material.dart';
import 'package:recipe_swiper/models/recipe.dart';
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
    return Column(
      children: <Widget>[
        Expanded(
          child: GestureDetector(
            onTap: () => onOptionSelected(optionA),
            child: RecipeCard(
              title: optionA.name,
              cookTime: optionA.totalTime,
              rating: optionA.rating.toString(),
              thumbnailUrl: optionA.images,
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
            child: RecipeCard(
              title: optionB.name,
              cookTime: optionB.totalTime,
              rating: optionB.rating.toString(),
              thumbnailUrl: optionB.images,
            ),
          ),
        ),
      ],
    );
  }
}
