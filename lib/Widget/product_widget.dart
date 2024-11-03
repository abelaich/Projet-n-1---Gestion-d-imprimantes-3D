import 'package:flutter/material.dart';
import 'package:project_n1/resources/app_colors.dart';
import 'package:project_n1/data/product.dart';

class ProductWidget extends StatelessWidget {
  final Product product;

  const ProductWidget({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: AppColors.secondaryColor, // Fond blanc pour la carte
      margin: const EdgeInsets.all(8.0),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Image.asset(
              product.image,
              width: 60,
              height: 60,
              fit: BoxFit.cover, // Ajustement de l'image
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${product.title} #${product.id}', // Titre et ID sur la même ligne
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'Date: ${product.date.toLocal().toString().split(' ')[0]}',
                    style: const TextStyle(
                      fontSize: 14,
                      color: AppColors.primaryColor, // Couleur plus légère pour la date
                    ),
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.arrow_forward_ios,
              color: AppColors.accentColor, // Couleur de la flèche
              size: 16, // Taille de la flèche
            ),
          ],
        ),
      ),
    );
  }
}

