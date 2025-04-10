// lib/widgets/terms/term_actions.dart
import 'package:flutter/material.dart';
import '../../config/theme.dart';

class TermActions extends StatelessWidget {
  final VoidCallback onDetectTerms;
  final VoidCallback onTranslate;
  final VoidCallback onAddNewTerm;

  const TermActions({
    super.key,
    required this.onDetectTerms,
    required this.onTranslate,
    required this.onAddNewTerm,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // Search field
        Expanded(
          child: TextField(
            decoration: InputDecoration(
              hintText: 'Search',
              hintStyle: TextStyle(
                color: AppTheme.textTertiaryColor,
                fontSize: 14,
              ),
              prefixIcon: Icon(
                Icons.search,
                color: AppTheme.textSecondaryColor,
                size: 20,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: Colors.grey.shade300),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: Colors.grey.shade300),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: AppTheme.primaryColor),
              ),
              contentPadding: const EdgeInsets.symmetric(vertical: 0),
              filled: true,
              fillColor: Colors.white,
            ),
          ),
        ),
        
        const SizedBox(width: 16),
        
        // Translate button
        _buildActionButton(
          onPressed: onTranslate,
          icon: Icons.translate,
          label: 'Translate',
        ),
        
        const SizedBox(width: 12),
        
        // Detect terms button (primary action)
        _buildActionButton(
          onPressed: onDetectTerms,
          icon: Icons.auto_awesome,
          label: 'Detect terms',
          isPrimary: true,
        ),
        
        const SizedBox(width: 12),
        
        // Add new term button
        _buildActionButton(
          onPressed: onAddNewTerm,
          icon: Icons.add,
          label: 'Add new term',
        ),
      ],
    );
  }
  
  Widget _buildActionButton({
    required VoidCallback onPressed,
    required IconData icon,
    required String label,
    bool isPrimary = false,
  }) {
    if (isPrimary) {
      return ElevatedButton.icon(
        onPressed: onPressed,
        icon: Icon(icon, size: 18),
        label: Text(
          label,
          style: const TextStyle(
            fontWeight: FontWeight.w500,
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: AppTheme.primaryColor,
          foregroundColor: Colors.white,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      );
    } else {
      return OutlinedButton.icon(
        onPressed: onPressed,
        icon: Icon(icon, size: 18),
        label: Text(
          label,
          style: TextStyle(
            fontWeight: FontWeight.w500,
            color: AppTheme.textPrimaryColor,
          ),
        ),
        style: OutlinedButton.styleFrom(
          foregroundColor: AppTheme.textPrimaryColor,
          side: BorderSide(color: Colors.grey.shade300),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      );
    }
  }
}