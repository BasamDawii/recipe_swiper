import 'package:flutter/material.dart';
import 'package:recipe_swiper/l10n/l10n.dart';
import 'package:recipe_swiper/models/recipe.dart';
import 'package:url_launcher/url_launcher.dart';

class RecipeDetailPage extends StatelessWidget {
  final Recipe recipe;

  const RecipeDetailPage({Key? key, required this.recipe}) : super(key: key);

  Future<void> _launchURL(String urlString) async {
    final Uri url = Uri.parse(urlString);
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(recipe.name),
        backgroundColor: Color(0xFFFFFFFF),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            Card(
              elevation: 5,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: Image.network(recipe.imageUrl, fit: BoxFit.cover),
              ),
            ),
            SizedBox(height: 16),
            Text(
              recipe.name,
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Color(0xFF34495E),
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 8),
            Text(
              'Rating: ${recipe.rating}',
              style: TextStyle(
                fontSize: 18,
                color: Color(0xFF16A085),
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 8),
            Text(
              'Total Time: ${recipe.totalTime}',
              style: TextStyle(
                fontSize: 18,
                color: Color(0xFF16A085),
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 16),
            Text(
              'Instructions',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Color(0xFF34495E),
              ),
            ),
            SizedBox(height: 8),
            Text(
              recipe.instructions,
              style: TextStyle(fontSize: 16, color: Color(0xFF34495E)),
            ),
            SizedBox(height: 16),
            if (recipe.youtubeUrl.isNotEmpty)
              TextButton(
                onPressed: () {
                  _launchURL(recipe.youtubeUrl);
                },
                child: Text(L10n.translate('watch_on_youtube')!),
                style: TextButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Color(0xFFFF6F61),
                  padding: EdgeInsets.symmetric(vertical: 12, horizontal: 24),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
