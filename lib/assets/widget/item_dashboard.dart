import 'package:flutter/material.dart';

class ItemDashboard extends StatelessWidget {
  final String title, image;
  final VoidCallback onTap; // Add this line

  const ItemDashboard({
    super.key,
    required this.title,
    required this.image,
    required this.onTap, // Add this line
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector( // Wrap the container in GestureDetector
      onTap: onTap, // Call the callback when tapped
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              offset: const Offset(0, 5),
              color: Theme.of(context).colorScheme.primary.withOpacity(.2),
              spreadRadius: 2,
              blurRadius: 5,
            )
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'lib/assets/images/$image',
              height: 60,
              fit: BoxFit.cover,
            ),
            const SizedBox(height: 10),
            Text(
              title,
              style: Theme.of(context).textTheme.titleMedium,
            )
          ],
        ),
      ),
    );
  }
}
