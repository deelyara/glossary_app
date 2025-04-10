// lib/widgets/common/app_bar.dart
import 'package:flutter/material.dart';
import '../../config/theme.dart';

class GlossaryAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final List<Widget>? actions;

  const GlossaryAppBar({
    super.key,
    this.title = 'Glossary App',
    this.actions,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(
        title,
        style: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: AppTheme.textPrimaryColor,
        ),
      ),
      actions: actions,
      backgroundColor: Colors.white,
      elevation: 0,
      shadowColor: Colors.transparent,
      toolbarHeight: 64,
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(1.0),
        child: Container(
          height: 1.0,
          color: Colors.grey.shade300,
        ),
      ),
      leadingWidth: 240,
      leading: Padding(
        padding: const EdgeInsets.only(left: 16.0),
        child: Row(
          children: [
            Icon(
              Icons.translate,
              color: AppTheme.primaryColor,
              size: 24,
            ),
            const SizedBox(width: 12),
            const Text(
              'Translation Studio',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: AppTheme.textPrimaryColor,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(64);
}