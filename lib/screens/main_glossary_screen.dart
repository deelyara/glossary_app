import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:country_flags/country_flags.dart';
import '../config/theme.dart';
import '../config/routes.dart';
import '../models/term.dart';
import '../services/glossary_service.dart';
import '../services/detection_service.dart';
import '../widgets/common/left_sidebar.dart';
import '../widgets/common/right_sidebar.dart';
import '../widgets/detection/detection_dialog.dart';
import '../widgets/detection/detection_progress_banner.dart';
import '../widgets/detection/detection_finished_banner.dart';
import '../config/colors.dart';

class MainGlossaryScreen extends StatefulWidget {
  const MainGlossaryScreen({super.key});

  @override
  State<MainGlossaryScreen> createState() => _MainGlossaryScreenState();
}

class _MainGlossaryScreenState extends State<MainGlossaryScreen> {
  // Controller for the language menu
  final MenuController _languageMenuController = MenuController();
  String _selectedLanguageCode = 'uk-UA'; // Example initial value

  // Example language data
  final Map<String, Map<String, String>> _languages = {
    'sq-AL': {'name': 'Albanian', 'country': 'Albania', 'langCodeForFlag': 'sq'},
    'uk-UA': {'name': 'Ukrainian', 'country': 'Ukraine', 'langCodeForFlag': 'uk'},
    'zh-CN': {'name': 'Chinese', 'country': 'China', 'langCodeForFlag': 'zh'},
    // Add more languages here
  };

  // State variables to track detection progress
  bool _isDetectionInProgress = false;
  bool _detectionFinished = false; // Add state for finished detection
  bool _isSearchActive = false; // Add state to track if search is active
  bool _showAIReviewTabs = false; // Add state to track if AI review tabs should be shown
  int _selectedTabIndex = 0; // Track selected tab index
  final TextEditingController _searchController = TextEditingController(); // Controller for search text

  void _showDetectionDialog() {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return DetectionDialog(
          onCancel: () => Navigator.of(dialogContext).pop(),
          onStartDetection: () {
            Navigator.of(dialogContext).pop(); // Close dialog
            _startDetection(); // Start the detection process
          },
        );
      },
    );
  }

  void _startDetection() {
    // Reset finished state and start progress
    setState(() {
      _isDetectionInProgress = true;
      _detectionFinished = false; // Reset finished state when starting
    });

    // Example: Simulate detection finishing after 5 seconds
    Future.delayed(const Duration(seconds: 5), () {
       if (mounted) { // Check if widget is still in the tree
          setState(() {
            _isDetectionInProgress = false; // Stop progress
            _detectionFinished = true; // Set finished state to true
          });
       }
    });
  }

  @override
  Widget build(BuildContext context) {
    final glossaryService = Provider.of<GlossaryService>(context);
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.background,
      body: Row(
        children: [
          const LeftSidebar(),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Top Section: Title and Publish Banner (Aligned)
                Padding(
                  padding: const EdgeInsets.only(top: 16.0, bottom: 8.0), // Removed horizontal padding here
                  child: Row(
                    // Removed mainAxisAlignment: MainAxisAlignment.spaceBetween
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Glossary Title (with padding)
                      Padding(
                        padding: const EdgeInsets.only(left: 24.0, right: 24.0), // Added padding here
                        child: Text(
                          'Glossary',
                          style: textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w600),
                        ),
                      ),
                      // Publish Banner Row (Expanded to take space)
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(right: 24.0),
                          child: Container(
                            // Increased vertical padding for taller banner
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                            decoration: BoxDecoration(
                              color: colorScheme.primaryContainer,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'For changes to the glossary to take effect, you need to publish them.',
                                  style: TextStyle(color: colorScheme.onPrimaryContainer),
                                ),
                                FilledButton(
                                  onPressed: () {},
                                  style: FilledButton.styleFrom(
                                    backgroundColor: colorScheme.primary,
                                    foregroundColor: colorScheme.onPrimary,
                                    elevation: 0,
                                    // Increased padding for larger button
                                    padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    // Use labelLarge for bigger text
                                    textStyle: textTheme.labelLarge?.copyWith(fontWeight: FontWeight.w500),
                                  ),
                                  child: const Text('Publish'),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // Conditionally display detection banners here
                if (_isDetectionInProgress)
                  const DetectionProgressBanner(),
                if (_detectionFinished) // Show finished banner when done
                  DetectionFinishedBanner(
                    onReviewCandidates: () {
                      setState(() {
                        _showAIReviewTabs = true; // Show the AI review tabs
                        _selectedTabIndex = 1; // Select the AI suggestions tab
                      });
                    },
                  ),

                // Divider between top section/banners and toolbars
                Divider(height: 1, thickness: 1, color: colorScheme.outline.withOpacity(0.2)),

                // Toolbar 1: Glossary Dropdown & Icons
                Padding(
                  padding: const EdgeInsets.only(left: 24.0, right: 24.0, top: 12.0, bottom: 8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        height: 36,
                        decoration: BoxDecoration(
                          border: Border.all(color: colorScheme.outline.withOpacity(0.5)),
                          borderRadius: BorderRadius.circular(8),
                          color: colorScheme.surface,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12.0),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<String>(
                              value: 'First glossary update',
                              icon: const Icon(Icons.arrow_drop_down, size: 20),
                              style: textTheme.bodyMedium,
                              items: const [
                                DropdownMenuItem(
                                  value: 'First glossary update',
                                  child: Text('First glossary update'),
                                ),
                              ],
                              onChanged: (value) {},
                              focusColor: Colors.transparent,
                            ),
                          ),
                        ),
                      ),
                      Row(
                        children: [
                          IconButton(icon: const Icon(Icons.download_outlined), onPressed: () {}, tooltip: 'Export glossary', iconSize: 20),
                          IconButton(icon: const Icon(Icons.upload_outlined), onPressed: () {}, tooltip: 'Import glossary', iconSize: 20),
                          IconButton(icon: const Icon(Icons.add), onPressed: () {}, tooltip: 'Add new term', iconSize: 20),
                          // Replace the search icon button with an AnimatedSwitcher
                          AnimatedSwitcher(
                            duration: const Duration(milliseconds: 200),
                            transitionBuilder: (Widget child, Animation<double> animation) {
                              return FadeTransition(opacity: animation, child: child);
                            },
                            child: _isSearchActive
                                ? Container(
                                    key: const ValueKey('searchField'),
                                    width: 200, // Reasonable search field width
                                    height: 36,
                                    decoration: BoxDecoration(
                                      color: colorScheme.surface,
                                      borderRadius: BorderRadius.circular(8),
                                      border: Border.all(color: colorScheme.outline.withOpacity(0.5)),
                                    ),
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: Padding(
                                            padding: const EdgeInsets.only(left: 12.0),
                                            child: TextField(
                                              controller: _searchController,
                                              decoration: InputDecoration(
                                                hintText: 'Search terms...',
                                                border: InputBorder.none,
                                                contentPadding: EdgeInsets.zero,
                                                isDense: true,
                                                hintStyle: TextStyle(
                                                  color: colorScheme.onSurfaceVariant.withOpacity(0.6),
                                                  fontSize: 14,
                                                ),
                                              ),
                                              style: const TextStyle(fontSize: 14),
                                              onSubmitted: (value) {
                                                // Handle search submission
                                                // TODO: Implement search functionality
                                              },
                                              autofocus: true, // Focus the field when it appears
                                            ),
                                          ),
                                        ),
                                        IconButton(
                                          icon: const Icon(Icons.close, size: 16),
                                          onPressed: () {
                                            setState(() {
                                              _isSearchActive = false;
                                              _searchController.clear();
                                            });
                                          },
                                          splashRadius: 16,
                                          visualDensity: VisualDensity.compact,
                                          padding: EdgeInsets.zero,
                                          constraints: const BoxConstraints(
                                            minWidth: 36,
                                            minHeight: 36,
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                : IconButton(
                                    key: const ValueKey('searchIcon'),
                                    icon: const Icon(Icons.search),
                                    onPressed: () {
                                      setState(() {
                                        _isSearchActive = true;
                                      });
                                    },
                                    tooltip: 'Search',
                                    iconSize: 20,
                                  ),
                          ),
                          const SizedBox(width: 8),
                          MenuAnchor(
                            controller: _languageMenuController,
                            style: MenuStyle(
                              maximumSize: MaterialStateProperty.all(const Size(300, 400)),
                              padding: MaterialStateProperty.all(EdgeInsets.zero),
                              shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
                              elevation: MaterialStateProperty.all(3.0),
                            ),
                            menuChildren: [
                              Padding(
                                padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
                                child: Text('Target language', style: textTheme.titleSmall?.copyWith(color: colorScheme.onSurfaceVariant)),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 4.0),
                                child: TextField(
                                  style: textTheme.bodyMedium,
                                  decoration: InputDecoration(
                                    hintText: 'Search...',
                                    prefixIcon: Icon(Icons.search, size: 20, color: Colors.grey.shade500),
                                    isDense: true,
                                    contentPadding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(4),
                                      borderSide: BorderSide(color: colorScheme.outline.withOpacity(0.5)),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(4),
                                      borderSide: BorderSide(color: colorScheme.outline.withOpacity(0.5)),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(4),
                                      borderSide: BorderSide(color: colorScheme.primary, width: 1.5),
                                    ),
                                    filled: true,
                                    fillColor: colorScheme.surface,
                                  ),
                                ),
                              ),
                              const Divider(height: 1),
                              ..._languages.entries.map((entry) {
                                final code = entry.key;
                                final details = entry.value;
                                final bool isSelected = code == _selectedLanguageCode;
                                final String langCode = details['langCodeForFlag'] ?? 'un';

                                return MenuItemButton(
                                  onPressed: () {
                                    setState(() {
                                      _selectedLanguageCode = code;
                                    });
                                  },
                                  leadingIcon: isSelected ? const Icon(Icons.check, size: 18) : Container(width: 18),
                                  child: Row(
                                    children: [
                                      CountryFlag.fromLanguageCode(
                                        langCode,
                                        width: 20,
                                        height: 15,
                                      ),
                                      const SizedBox(width: 8),
                                      Text(
                                        '${details['name']} (${details['country']}) | $code',
                                        style: textTheme.bodyMedium,
                                      ),
                                    ],
                                  ),
                                );
                              }).toList(),
                            ],
                            child: TextButton(
                              onPressed: () {
                                if (_languageMenuController.isOpen) {
                                  _languageMenuController.close();
                                } else {
                                  _languageMenuController.open();
                                }
                              },
                              style: TextButton.styleFrom(
                                foregroundColor: colorScheme.onSurface,
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                                minimumSize: Size.zero,
                                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                                splashFactory: NoSplash.splashFactory,
                              ),
                              child: Row(
                                children: [
                                  CountryFlag.fromLanguageCode(
                                    _languages[_selectedLanguageCode]?['langCodeForFlag'] ?? 'un',
                                    width: 20,
                                    height: 15,
                                  ),
                                  const SizedBox(width: 4),
                                  Icon(Icons.arrow_drop_down, size: 20, color: Colors.grey.shade600),
                                ],
                              ),
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
                Divider(height: 1, thickness: 1, color: colorScheme.outline.withOpacity(0.2)),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                       Row(
                         children: [
                           // Detect terms button (Styled like Publish, Larger)
                           FilledButton.icon(
                              onPressed: _showDetectionDialog,
                              icon: const Icon(Icons.auto_awesome_outlined, size: 18),
                              label: const Text('Detect terms'),
                              style: FilledButton.styleFrom(
                                foregroundColor: colorScheme.onPrimary,
                                backgroundColor: colorScheme.primary,
                                // Increased padding for wider/taller button
                                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                                shape: RoundedRectangleBorder(
                                   borderRadius: BorderRadius.circular(20),
                                ),
                                // Increased font size
                                textStyle: textTheme.labelLarge?.copyWith(fontWeight: FontWeight.w500),
                                elevation: 0,
                              ),
                            ),
                            const SizedBox(width: 8),
                            // Translate button (Styled like Publish, Larger)
                            FilledButton.icon(
                              onPressed: () {},
                              icon: const Icon(Icons.auto_awesome_outlined, size: 18),
                              label: const Text('Translate'),
                              style: FilledButton.styleFrom(
                                foregroundColor: colorScheme.onPrimary,
                                backgroundColor: colorScheme.primary,
                                // Increased padding for wider/taller button
                                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                                shape: RoundedRectangleBorder(
                                   borderRadius: BorderRadius.circular(20),
                                ),
                                // Increased font size
                                textStyle: textTheme.labelLarge?.copyWith(fontWeight: FontWeight.w500),
                                elevation: 0,
                              ),
                            ),
                         ],
                       )
                    ],
                  ),
                ),

                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 24.0, right: 24.0, bottom: 16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Add some space above the table if the banner is not showing
                        if (!_isDetectionInProgress) const SizedBox(height: 16),
                        
                        // Show tabs if AI review is active
                        if (_showAIReviewTabs)
                          Container(
                            margin: const EdgeInsets.only(bottom: 16),
                            decoration: BoxDecoration(
                              border: Border(
                                bottom: BorderSide(color: colorScheme.outline.withOpacity(0.2)),
                              ),
                            ),
                            child: Row(
                              children: [
                                _buildTab(0, 'Terms', colorScheme),
                                _buildTab(1, 'AI suggestions', colorScheme),
                              ],
                            ),
                          ),
                        
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                              border: Border.all(color: colorScheme.outline.withOpacity(0.5)),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Column(
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                                  decoration: BoxDecoration(
                                    color: colorScheme.surfaceVariant,
                                    borderRadius: const BorderRadius.only(
                                      topLeft: Radius.circular(8),
                                      topRight: Radius.circular(8),
                                    ),
                                    border: Border(
                                      bottom: BorderSide(color: colorScheme.outline.withOpacity(0.3)),
                                    )
                                  ),
                                  child: Row(
                                    children: [
                                      SizedBox(
                                        width: 40,
                                        child: Checkbox(
                                          value: false,
                                          onChanged: (value) {},
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(4),
                                          ),
                                          visualDensity: VisualDensity.compact,
                                          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                        ),
                                      ),
                                      Expanded(
                                        flex: 2,
                                        child: Text(
                                          'Term',
                                          style: TextStyle(
                                            fontWeight: FontWeight.w600,
                                            color: colorScheme.onSurfaceVariant,
                                            fontSize: 14,
                                          ),
                                        ),
                                      ),
                                      // Show different columns based on selected tab
                                      if (_showAIReviewTabs && _selectedTabIndex == 1) 
                                        // AI suggestions tab columns
                                        ...[
                                          // Usage score
                                          Expanded(
                                            flex: 1,
                                            child: Row(
                                              children: [
                                                Text(
                                                  'Usage score',
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.w600,
                                                    color: colorScheme.onSurfaceVariant,
                                                    fontSize: 14,
                                                  ),
                                                ),
                                                Icon(
                                                  Icons.unfold_more,
                                                  size: 16,
                                                  color: colorScheme.onSurfaceVariant,
                                                ),
                                              ],
                                            ),
                                          ),
                                          // Examples
                                          Expanded(
                                            flex: 3,
                                            child: Text(
                                              'Examples',
                                              style: TextStyle(
                                                fontWeight: FontWeight.w600,
                                                color: colorScheme.onSurfaceVariant,
                                                fontSize: 14,
                                              ),
                                            ),
                                          ),
                                          // Do not translate
                                          Expanded(
                                            flex: 1,
                                            child: Center(
                                              child: Text(
                                                'Do not translate',
                                                style: TextStyle(
                                                  fontWeight: FontWeight.w600,
                                                  color: colorScheme.onSurfaceVariant,
                                                  fontSize: 14,
                                                ),
                                                textAlign: TextAlign.center,
                                              ),
                                            ),
                                          ),
                                          // Case sensitive
                                          Expanded(
                                            flex: 1,
                                            child: Center(
                                              child: Text(
                                                'Case sensitive',
                                                style: TextStyle(
                                                  fontWeight: FontWeight.w600,
                                                  color: colorScheme.onSurfaceVariant,
                                                  fontSize: 14,
                                                ),
                                                textAlign: TextAlign.center,
                                              ),
                                            ),
                                          ),
                                          // Actions
                                          Expanded(
                                            flex: 1,
                                            child: Center(
                                              child: Text(
                                                'Actions',
                                                style: TextStyle(
                                                  fontWeight: FontWeight.w600,
                                                  color: colorScheme.onSurfaceVariant,
                                                  fontSize: 14,
                                                ),
                                                textAlign: TextAlign.center,
                                              ),
                                            ),
                                          ),
                                        ]
                                      else
                                        // Regular terms tab columns
                                        ...[
                                          Expanded(
                                            flex: 2,
                                            child: Text(
                                              'Translation',
                                              style: TextStyle(
                                                fontWeight: FontWeight.w600,
                                                color: colorScheme.onSurfaceVariant,
                                                fontSize: 14,
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                            flex: 1,
                                            child: Center(
                                              child: Text(
                                                'Confirmed',
                                                style: TextStyle(
                                                  fontWeight: FontWeight.w600,
                                                  color: colorScheme.onSurfaceVariant,
                                                  fontSize: 14,
                                                ),
                                                textAlign: TextAlign.center,
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                            flex: 2,
                                            child: Text(
                                              'Example',
                                              style: TextStyle(
                                                fontWeight: FontWeight.w600,
                                                color: colorScheme.onSurfaceVariant,
                                                fontSize: 14,
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            width: 60,
                                            child: Text(
                                              'Actions',
                                              style: TextStyle(
                                                fontWeight: FontWeight.w600,
                                                color: colorScheme.onSurfaceVariant,
                                                fontSize: 14,
                                              ),
                                              textAlign: TextAlign.center,
                                            ),
                                          ),
                                        ],
                                    ],
                                  ),
                                ),
                                
                                Expanded(
                                  child: _selectedTabIndex == 0 || !_showAIReviewTabs
                                    ? _buildTermsTable(glossaryService, colorScheme, textTheme)
                                    : _buildAISuggestionsTable(glossaryService, colorScheme, textTheme),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          VerticalDivider(thickness: 1, width: 1, color: colorScheme.outline.withOpacity(0.2)),
          const RightSidebar(),
        ],
      ),
    );
  }

  // Helper method to build tab
  Widget _buildTab(int index, String label, ColorScheme colorScheme) {
    final isSelected = _selectedTabIndex == index;
    
    return InkWell(
      onTap: () {
        setState(() {
          _selectedTabIndex = index;
        });
      },
      splashFactory: NoSplash.splashFactory,
      highlightColor: Colors.transparent,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: isSelected ? colorScheme.primary : Colors.transparent,
              width: 2,
            ),
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? colorScheme.primary : colorScheme.onSurfaceVariant,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
            fontSize: 14,
          ),
        ),
      ),
    );
  }

  // Helper method to build the terms table
  Widget _buildTermsTable(GlossaryService glossaryService, ColorScheme colorScheme, TextTheme textTheme) {
    return glossaryService.allTerms.isEmpty 
      ? Center(child: Text("No terms in glossary.", style: textTheme.bodyMedium)) 
      : ListView.builder(
        itemCount: glossaryService.allTerms.length,
        itemBuilder: (context, index) {
          final term = glossaryService.allTerms[index];
          final isEven = index % 2 == 0;
          
          return Container(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            decoration: BoxDecoration(
              color: isEven ? colorScheme.surface : colorScheme.surfaceVariant.withOpacity(0.3),
              border: Border(
                bottom: BorderSide(color: colorScheme.outline.withOpacity(0.1)),
              ),
            ),
            child: Row(
              children: [
                SizedBox(
                  width: 40,
                  child: Checkbox(
                    value: false,
                    onChanged: (value) {},
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4),
                    ),
                    visualDensity: VisualDensity.compact,
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Text(
                    term.text,
                    style: const TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 14,
                    ),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Text(
                    term.translation ?? 'This term is not translatable',
                    style: TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: 14,
                      fontStyle: term.translation == null ? FontStyle.italic : FontStyle.normal,
                      color: term.translation == null ? Colors.grey.shade600 : ColorUtils.textPrimaryColor(context),
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Center(
                    child: Checkbox(
                      value: index == 5,
                      onChanged: (value) {},
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4),
                      ),
                      visualDensity: VisualDensity.compact,
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Text(
                    term.examples.isNotEmpty ? term.examples[0] : '-',
                    style: const TextStyle(
                      fontSize: 14,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                SizedBox(
                  width: 60,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.more_vert),
                        onPressed: () {
                          // TODO: Implement action menu (edit, delete, etc.)
                        },
                        iconSize: 20,
                        splashRadius: 20,
                        visualDensity: VisualDensity.compact,
                        tooltip: 'Actions',
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      );
  }

  // Helper method to build the AI suggestions table
  Widget _buildAISuggestionsTable(GlossaryService glossaryService, ColorScheme colorScheme, TextTheme textTheme) {
    return glossaryService.aiSuggestedTerms.isEmpty 
      ? Center(child: Text("No AI term suggestions.", style: textTheme.bodyMedium)) 
      : ListView.builder(
          itemCount: glossaryService.aiSuggestedTerms.length,
          itemBuilder: (context, index) {
            final term = glossaryService.aiSuggestedTerms[index];
            final isEven = index % 2 == 0;
            
            return Container(
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
              decoration: BoxDecoration(
                color: isEven ? colorScheme.surface : colorScheme.surfaceVariant.withOpacity(0.3),
                border: Border(
                  bottom: BorderSide(color: colorScheme.outline.withOpacity(0.1)),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Term
                      Expanded(
                        flex: 2,
                        child: Text(
                          term.text,
                          style: const TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 14,
                          ),
                        ),
                      ),
                      
                      // Usage score
                      Expanded(
                        flex: 1,
                        child: Text(
                          '${term.usageScore.toInt()}',
                          style: const TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 14,
                          ),
                        ),
                      ),
                      
                      // Examples section
                      Expanded(
                        flex: 3,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Select examples to include:',
                              style: TextStyle(
                                fontWeight: FontWeight.w400,
                                fontSize: 14,
                              ),
                            ),
                            const SizedBox(height: 8),
                            ...term.examples.take(2).map((example) {
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 4.0),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(
                                      width: 24,
                                      height: 24,
                                      child: Checkbox(
                                        value: false,
                                        onChanged: (value) {},
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(4),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            example,
                                            style: const TextStyle(
                                              fontSize: 14,
                                            ),
                                          ),
                                          Text(
                                            'Found on: dogs/boci/',
                                            style: TextStyle(
                                              fontSize: 12,
                                              color: colorScheme.onSurfaceVariant.withOpacity(0.7),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }).toList(),
                          ],
                        ),
                      ),
                      
                      // Do not translate switch
                      Expanded(
                        flex: 1,
                        child: Center(
                          child: Transform.scale(
                            scale: 0.7,
                            child: Switch.adaptive(
                              value: term.doNotTranslate,
                              onChanged: (value) {},
                              activeColor: colorScheme.primary,
                              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                              trackOutlineColor: MaterialStateProperty.all(Colors.transparent),
                              thumbColor: MaterialStatePropertyAll(term.doNotTranslate 
                                ? colorScheme.onPrimary 
                                : Colors.grey.shade400),
                            ),
                          ),
                        ),
                      ),
                      
                      // Case sensitive switch
                      Expanded(
                        flex: 1,
                        child: Center(
                          child: Transform.scale(
                            scale: 0.7,
                            child: Switch.adaptive(
                              value: term.caseSensitive,
                              onChanged: (value) {},
                              activeColor: colorScheme.primary,
                              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                              trackOutlineColor: MaterialStateProperty.all(Colors.transparent),
                              thumbColor: MaterialStatePropertyAll(term.caseSensitive 
                                ? colorScheme.onPrimary 
                                : Colors.grey.shade400),
                            ),
                          ),
                        ),
                      ),
                      
                      // Action buttons - Swap order: Add first, then Reject
                      Expanded(
                        flex: 1,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            // Add button - Now first
                            ElevatedButton.icon(
                              onPressed: () {
                                // Accept the AI suggestion
                                glossaryService.acceptAISuggestion(term);
                                setState(() {}); // Refresh UI
                              },
                              icon: const Icon(Icons.add, size: 14),
                              label: const Padding(
                                padding: EdgeInsets.only(right: 2),
                                child: Text('Add'),
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFFE8F5E9),
                                foregroundColor: const Color(0xFF388E3C),
                                padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 0),
                                minimumSize: const Size(0, 30),
                                maximumSize: const Size(85, 30),
                                elevation: 0,
                                textStyle: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                            const SizedBox(width: 4),
                            // Reject button - Now second
                            ElevatedButton.icon(
                              onPressed: () {
                                // Reject the AI suggestion
                                glossaryService.rejectAISuggestion(term);
                                setState(() {}); // Refresh UI
                              },
                              icon: const Icon(Icons.close, size: 14),
                              label: const Padding(
                                padding: EdgeInsets.only(right: 2),
                                child: Text('Reject'),
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFFFFE8E8),
                                foregroundColor: const Color(0xFFD32F2F),
                                padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 0),
                                minimumSize: const Size(0, 30),
                                maximumSize: const Size(85, 30),
                                elevation: 0,
                                textStyle: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        );
  }
} 