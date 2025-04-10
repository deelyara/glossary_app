// lib/widgets/common/sidebar.dart
import 'package:flutter/material.dart';
import '../../config/theme.dart';

class GlossarySidebar extends StatelessWidget {
  final bool isSmall;
  
  const GlossarySidebar({
    super.key,
    this.isSmall = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: isSmall ? 60 : 240,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          right: BorderSide(color: Colors.grey.shade300, width: 1),
        ),
      ),
      child: Column(
        children: [
          const SizedBox(height: 24),
          // Navigation items - would be more dynamic in a real app
          _buildNavItem(
            icon: Icons.dashboard_outlined,
            label: 'Dashboard',
            isActive: false,
            isSmall: isSmall,
          ),
          _buildNavItem(
            icon: Icons.translate_outlined,
            label: 'Translations',
            isActive: false,
            isSmall: isSmall,
          ),
          _buildNavItem(
            icon: Icons.edit_note_outlined,
            label: 'Glossary',
            isActive: true,
            isSmall: isSmall,
          ),
          _buildNavItem(
            icon: Icons.people_outline,
            label: 'Team',
            isActive: false,
            isSmall: isSmall,
          ),
          _buildNavItem(
            icon: Icons.settings_outlined,
            label: 'Settings',
            isActive: false,
            isSmall: isSmall,
          ),
          
          const Spacer(),
          
          // User section at bottom
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                const CircleAvatar(
                  radius: 16,
                  backgroundColor: AppTheme.primaryColor,
                  child: Text(
                    'JD',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 12,
                    ),
                  ),
                ),
                if (!isSmall) ...[
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'John Doe',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                          ),
                        ),
                        Text(
                          'john@example.com',
                          style: TextStyle(
                            fontSize: 12,
                            color: AppTheme.textSecondaryColor,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  Icon(
                    Icons.keyboard_arrow_down,
                    color: AppTheme.textSecondaryColor,
                    size: 20,
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildNavItem({
    required IconData icon,
    required String label,
    required bool isActive,
    required bool isSmall,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: isActive ? AppTheme.primaryColor.withOpacity(0.1) : Colors.transparent,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(8),
        child: InkWell(
          onTap: () {},
          borderRadius: BorderRadius.circular(8),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            child: Row(
              children: [
                Icon(
                  icon,
                  size: 20,
                  color: isActive ? AppTheme.primaryColor : AppTheme.textSecondaryColor,
                ),
                if (!isSmall) ...[
                  const SizedBox(width: 12),
                  Text(
                    label,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
                      color: isActive ? AppTheme.primaryColor : AppTheme.textPrimaryColor,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}