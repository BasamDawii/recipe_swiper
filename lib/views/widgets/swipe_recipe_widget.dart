import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:recipe_swiper/providers/recipe_provider.dart';
import 'package:recipe_swiper/views/widgets/recipe_card.dart';


class SwipeRecipeWidget extends StatefulWidget {
  @override
  _SwipeRecipeWidgetState createState() => _SwipeRecipeWidgetState();
}


class _SwipeRecipeWidgetState extends State<SwipeRecipeWidget> with SingleTickerProviderStateMixin {
  Offset _dragStart = Offset.zero;
  Offset _dragEnd = Offset.zero;
  bool _isDragging = false;
  double _swipeProgress = 0.0;
  late AnimationController _animationController;
  late Animation<double> _animation;


  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 300),
    );
    _animation = Tween<double>(begin: 0, end: 1).animate(_animationController)
      ..addListener(() {
        setState(() {});
      });
  }


  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }


  void _onPanStart(DragStartDetails details) {
    _dragStart = details.localPosition;
    _isDragging = true;
  }


  void _onPanUpdate(DragUpdateDetails details) {
    _dragEnd = details.localPosition;
    _swipeProgress = (_dragEnd.dx - _dragStart.dx) / MediaQuery.of(context).size.width;
    setState(() {});
  }


  void _onPanEnd(DragEndDetails details) {
    final dragDistance = _dragEnd.dx - _dragStart.dx;
    final threshold = MediaQuery.of(context).size.width * 0.3;


    if (dragDistance > threshold || dragDistance < -threshold) {
      _animationController.forward().then((_) {
        _swipeComplete(context, right: dragDistance > threshold);
      });
    } else {
      setState(() {
        _isDragging = false;
        _dragStart = Offset.zero;
        _dragEnd = Offset.zero;
        _swipeProgress = 0.0;
      });
    }
  }


  void _swipeComplete(BuildContext context, {required bool right}) {
    final recipeProvider = Provider.of<RecipeProvider>(context, listen: false);
    if (right) {
      recipeProvider.handleSwipeRight(context);
    } else {
      recipeProvider.handleSwipeLeft(context);
    }
    _animationController.reset();
    setState(() {
      _isDragging = false;
      _dragStart = Offset.zero;
      _dragEnd = Offset.zero;
      _swipeProgress = 0.0;
    });
  }


  @override
  Widget build(BuildContext context) {
    final recipeProvider = Provider.of<RecipeProvider>(context);


    return recipeProvider.isLoading
        ? Center(child: CircularProgressIndicator())
        : recipeProvider.currentRecipe == null
        ? Center(child: Text('No more recipes!'))
        : GestureDetector(
      onPanStart: _onPanStart,
      onPanUpdate: _onPanUpdate,
      onPanEnd: _onPanEnd,
      child: AnimatedBuilder(
        animation: _animationController,
        builder: (context, child) {
          final progress = _isDragging ? _swipeProgress : _animation.value;
          return Transform.translate(
            offset: Offset(progress * MediaQuery.of(context).size.width, 0),
            child: Transform.scale(
              scale: 1.0 - progress.abs() * 0.3,
              child: Transform.rotate(
                angle: progress * 0.3,
                child: Opacity(
                  opacity: 1.0 - progress.abs(),
                  child: RecipeCard(
                    title: recipeProvider.currentRecipe!.name,
                    cookTime: recipeProvider.currentRecipe!.totalTime,
                    rating: recipeProvider.currentRecipe!.rating.toString(),
                    thumbnailUrl: recipeProvider.currentRecipe!.imageUrl,
                    recipe: recipeProvider.currentRecipe!,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

