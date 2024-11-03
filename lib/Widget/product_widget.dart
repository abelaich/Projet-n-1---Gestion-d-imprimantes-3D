import 'package:flutter/material.dart';
import 'package:project_n1/resources/app_colors.dart';
import 'package:project_n1/data/product.dart';

class ProductWidget extends StatelessWidget {
  final Product product;

  const ProductWidget({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: AppColors.secondaryColor,
      margin: const EdgeInsets.all(8.0), // Margin around the card
      elevation: 4, // Elevation to create a shadow effect
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Image.asset(
              product.image,
              width: 60,
              height: 60,
              fit: BoxFit.cover, // Fitting the image within the defined dimensions
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start, // Aligning text to the start (left)
                children: [
                  Text(
                    '${product.title} #${product.id}',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'Start Date: ${product.date.toLocal().toString().split(' ')[0]}',
                    style: const TextStyle(
                      fontSize: 14,
                      color: AppColors.primaryColor,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.arrow_forward_ios, // Arrow icon indicating forward navigation
              color: AppColors.accentColor,
              size: 16,
            ),
          ],
        ),
      ),
    );
  }
}
