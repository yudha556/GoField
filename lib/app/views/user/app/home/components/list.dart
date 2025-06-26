import 'package:flutter/material.dart';
import 'package:gofield/app/views/user/app/home/components/tabView.dart';
import 'package:gofield/core/components/components.dart';

class ListPage extends StatelessWidget {
  const ListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          TabViewHome(
            onTabChanged: (index) {
              // Handle tab changes here
            },
          ),
          Expanded(
            child: GlobalCardGrid(
              crossAxisCount: 2,
              spacing: 12,
              runSpacing: 12,
              padding: const EdgeInsets.all(16),
              children: List.generate(
                10, // Replace with your actual item count
                (index) => GlobalCard(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Image section
                      Expanded(
                        flex: 3,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.asset(
                            'assets/images/contoh.jpg',
                            fit: BoxFit.cover,
                            width: double.infinity,
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      
                      // Content section
                      Expanded(
                        flex: 2,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            // Product title
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween
                              childern [
                                
                                Text(
                                  'Glagah Futsal',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600
                                  )
                                ),
                                  
                                
                              ]
                            ),
                            
                            // Price and rating section
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '\$${(99.99 + index * 10).toStringAsFixed(2)}',
                                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                                    color: Theme.of(context).primaryColor,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Row(
                                  children: [
                                    const Icon(Icons.star, size: 14, color: Colors.amber),
                                    const SizedBox(width: 2),
                                    Expanded(
                                      child: Text(
                                        '4.${5 + index % 5} (${123 + index * 10})',
                                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                          fontSize: 11,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
