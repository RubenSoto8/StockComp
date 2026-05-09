import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/component.dart';

class InventoryCard extends StatelessWidget {
  final Component component;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;
  final VoidCallback onLongPress;

  const InventoryCard({
    super.key,
    required this.component,
    required this.onIncrement,
    required this.onDecrement,
    required this.onLongPress,
  });

  Color _quantityColor() {
    if (component.quantity == 0) return Colors.red;
    if (component.quantity <= 5) return const Color(0xFFFFC107);
    return const Color(0xFF00B4D8);
  }

  Color _cardColor() {
    if (component.quantity == 0) return const Color(0xFF2A1A1A);
    return const Color(0xFF1A1A2E);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPress: onLongPress,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: _cardColor(),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.white12),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    component.name,
                    style: GoogleFonts.nunito(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    component.category,
                    style: GoogleFonts.nunito(
                      color: Colors.white54,
                      fontSize: 13,
                    ),
                  ),
                  if (component.notes != null && component.notes!.isNotEmpty)
                    Text(
                      component.notes!,
                      style: GoogleFonts.nunito(
                        color: Colors.white38,
                        fontSize: 12,
                      ),
                    ),
                ],
              ),
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  onPressed: component.quantity > 0 ? onDecrement : null,
                  icon: Icon(
                    Icons.remove_circle_outline,
                    color: component.quantity > 0
                        ? Colors.white70
                        : Colors.white24,
                  ),
                ),
                Text(
                  '${component.quantity}',
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  style: GoogleFonts.nunito(
                    color: _quantityColor(),
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  onPressed: onIncrement,
                  icon: const Icon(
                    Icons.add_circle_outline,
                    color: Color(0xFF00B4D8),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}