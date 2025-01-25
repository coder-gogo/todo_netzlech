import 'package:flutter/material.dart';
import 'package:todo_netzlech/utils/shimmer/shimmer.dart';

class ShimmerTaskCard extends StatelessWidget {
  const ShimmerTaskCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          // Shimmer for Checkbox Icon
          Shimmer.fromColors(
            baseColor: Colors.blue[100]!,
            highlightColor: Colors.blue[50]!,
            child: Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                color: Colors.blue[100],
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
          const SizedBox(width: 16),
          // Shimmer for Texts
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Shimmer.fromColors(
                  baseColor: Colors.grey[300]!,
                  highlightColor: Colors.grey[100]!,
                  child: Container(
                    height: 16,
                    color: Colors.grey,
                    margin: const EdgeInsets.only(bottom: 8),
                  ),
                ),
                Shimmer.fromColors(
                  baseColor: Colors.grey[300]!,
                  highlightColor: Colors.grey[100]!,
                  child: Container(
                    height: 12,
                    color: Colors.grey,
                    width: 150,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
