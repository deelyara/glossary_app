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
import '../widgets/detection/detection_second_run_banner.dart';
import '../config/colors.dart';
import 'main_glossary_screen_fix.dart';

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
  bool _detectionFinished = false; // State for finished detection
  bool _showSecondRunBanner = false; // State for showing second run banner
  bool _isSearchActive = false; // Add state to track if search is active
  bool _showAIReviewTabs = false; // Add state to track if AI review tabs should be shown
  int _selectedTabIndex = 0; // Track selected tab index
  final TextEditingController _searchController = TextEditingController(); // Controller for search text
  String _searchQuery = ''; // Store the current search query
  
  // State for sorting
  bool _usageScoreSortAscending = true; // Default to ascending
  bool _isUsageScoreSorted = false; // Track if table is sorted by usage score

  // Map to track selected examples for each term
  final Map<String, Set<int>> _selectedExamples = {};
  
  // Set to track selected term IDs in the main Terms table
  final Set<String> _selectedTermIds = {};

  // Helper getter to check if any term is selected
  bool get _isAnyTermSelected => _selectedTermIds.isNotEmpty;

  // Helper to get currently filtered terms (needed for select all)
  List<Term> _getFilteredTerms(GlossaryService service) {
    if (_selectedTabIndex == 0 || !_showAIReviewTabs) {
      // For Terms tab
      return _searchQuery.isEmpty
          ? service.allTerms
          : service.allTerms.where(
              (term) => term.text.toLowerCase().contains(_searchQuery.toLowerCase())
            ).toList();
    } else {
      // For AI suggestions tab
      return _searchQuery.isEmpty
          ? service.aiSuggestedTerms
          : service.aiSuggestedTerms.where(
              (term) => term.text.toLowerCase().contains(_searchQuery.toLowerCase())
            ).toList();
    }
  }

  // Toggle selection for all visible terms
  void _toggleSelectAll(bool? newValue, List<Term> filteredTerms) {
    setState(() {
      if (newValue == true) {
        // Select all
        _selectedTermIds.addAll(filteredTerms.map((term) => term.id));
      } else {
        // Deselect all
        _selectedTermIds.clear();
      }
    });
  }

  void _showDetectionDialog() {
    final detectionService = Provider.of<DetectionService>(context, listen: false);
    
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

  @override
  void initState() {
    super.initState();
    
    // Connect the detection service to the glossary service
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final glossaryService = Provider.of<GlossaryService>(context, listen: false);
      final detectionService = Provider.of<DetectionService>(context, listen: false);
      
      glossaryService.setDetectionService(detectionService);
    });
  }

  void _startDetection() {
    final detectionService = Provider.of<DetectionService>(context, listen: false);
    
    // Show a snack bar for detection progress instead of banner
    final snackBar = SnackBar(
      content: Text(
        'AI detection in progress. You will be notified when it finishes.',
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w500,
        ),
      ),
      duration: const Duration(seconds: 4),
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      margin: const EdgeInsets.all(16),
    );
    
    ScaffoldMessenger.of(context).showSnackBar(snackBar);

    // Check if this is first detection run
    if (detectionService.detectionRunCount == 0) {
      // For the first run
      detectionService.detectTerms().then((_) {
        if (mounted) {
          setState(() {
            _detectionFinished = true;
            _showSecondRunBanner = false;
          });
        }
      });
    } else {
      // For second and later runs
      detectionService.detectMoreTerms().then((_) {
        if (mounted) {
          // Update the AI suggestions immediately for second+ runs
          _updateAISuggestionsWithDetectedTerms();
          setState(() {
            _detectionFinished = true;
            _showSecondRunBanner = true;
          });
        }
      });
    }
  }

  // Method to update AI suggestions with the latest detected terms
  void _updateAISuggestionsWithDetectedTerms() {
    final glossaryService = Provider.of<GlossaryService>(context, listen: false);
    final detectionService = Provider.of<DetectionService>(context, listen: false);
    
    // Add the detected terms to the AI suggestions
    glossaryService.addAISuggestedTerms(detectionService.detectedTerms);
    
    // Show the AI suggestions tab
    setState(() {
      _showAIReviewTabs = true;
      _selectedTabIndex = 1;
      _detectionFinished = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final glossaryService = Provider.of<GlossaryService>(context);
    final detectionService = Provider.of<DetectionService>(context);
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.background,
      body: Row(
        children: [
          const LeftSidebar(),
          Expanded(
            // Make entire column scrollable
            child: SingleChildScrollView(
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
                                borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'For changes to the glossary to take effect, you need to publish them.',
                                    style: textTheme.bodyMedium?.copyWith(color: colorScheme.onPrimaryContainer),
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
                if (_detectionFinished && !_showSecondRunBanner && detectionService.detectionRunCount == 1) // Only show first run banner on first detection
                  DetectionFinishedBanner(
                    onReviewCandidates: _updateAISuggestionsWithDetectedTerms,
                  ),
                  
                if (_showSecondRunBanner) // Show second run banner (dismissable)
                  DetectionSecondRunBanner(
                    onDismiss: () {
                      setState(() {
                        _showSecondRunBanner = false; // Hide the banner when dismissed
                        _detectionFinished = false; // Also reset detection finished flag
                      });
                    },
                  ),

                // Divider between top section/banners and toolbars
                Divider(height: 1, thickness: 1, color: colorScheme.outline.withOpacity(0.2)),

                // Toolbar with dropdowns
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      // First glossary dropdown
                      Container(
                        height: 36,
                        decoration: BoxDecoration(
                          border: Border.all(color: colorScheme.outline.withOpacity(0.5)),
                          borderRadius: BorderRadius.circular(12),
                          color: colorScheme.surface,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12.0),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<String>(
                              value: 'First glossary update',
                              icon: const Icon(Icons.arrow_drop_down, size: 20, color: Colors.black),
                              style: textTheme.bodyMedium?.copyWith(color: Colors.black),
                              items: const [
                                DropdownMenuItem(
                                  value: 'First glossary update',
                                  child: Text('First glossary update', style: TextStyle(color: Colors.black)),
                                ),
                              ],
                              onChanged: (value) {},
                              focusColor: Colors.transparent,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      // Second glossary management dropdown
                      Container(
                        height: 36,
                        decoration: BoxDecoration(
                          border: Border.all(color: colorScheme.outline.withOpacity(0.5)),
                          borderRadius: BorderRadius.circular(12),
                          color: colorScheme.surface,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12.0),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<String>(
                              value: null,
                              hint: Text('Manage glossaries', style: textTheme.bodyMedium?.copyWith(color: Colors.black)),
                              icon: const Icon(Icons.arrow_drop_down, size: 20, color: Colors.black),
                              style: textTheme.bodyMedium?.copyWith(color: Colors.black),
                              items: [
                                DropdownMenuItem(
                                  enabled: false,
                                  value: 'header',
                                  child: Text('Manage glossaries', 
                                    style: textTheme.bodyMedium?.copyWith(
                                      color: Colors.black,
                                      fontWeight: FontWeight.w500
                                    )
                                  ),
                                ),
                                const DropdownMenuItem(
                                  value: 'create',
                                  child: Text('Create new glossary', style: TextStyle(color: Colors.black)),
                                ),
                                const DropdownMenuItem(
                                  value: 'view',
                                  child: Text('View all glossaries', style: TextStyle(color: Colors.black)),
                                ),
                              ],
                              onChanged: (String? value) {
                                if (value == 'create') {
                                  // TODO: Show create glossary dialog
                                } else if (value == 'view') {
                                  // TODO: Navigate to glossaries list page
                                }
                              },
                              focusColor: Colors.transparent,
                            ),
                          ),
                        ),
                      ),
                      const Spacer(),
                      Row(
                        children: [
                          IconButton(icon: const Icon(Icons.download_outlined), onPressed: () {}, tooltip: 'Export glossary', iconSize: 20),
                          IconButton(icon: const Icon(Icons.upload_outlined), onPressed: () {}, tooltip: 'Import glossary', iconSize: 20),
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
                                        borderRadius: BorderRadius.circular(12),
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
                                                  setState(() {
                                                    _searchQuery = value.trim();
                                                  });
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
                                                _searchQuery = ''; // Clear the search query
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
                            // Add vertical divider here
                            Container(
                              height: 24,
                              width: 1,
                              color: colorScheme.outline.withOpacity(0.3),
                              margin: const EdgeInsets.symmetric(horizontal: 8),
                            ),
                          MenuAnchor(
                            controller: _languageMenuController,
                            style: MenuStyle(
                              maximumSize: MaterialStateProperty.all(const Size(300, 400)),
                              padding: MaterialStateProperty.all(EdgeInsets.zero),
                                shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
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
                                          '${details['name']} (${details['country']})',
                                        style: textTheme.bodyMedium,
                                      ),
                                    ],
                                  ),
                                );
                              }).toList(),
                            ],
                              child: Tooltip(
                                message: 'Switch target language',
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
                          ),
                        ],
                      )
                    ],
                  ),
                ),
                Divider(height: 1, thickness: 1, color: colorScheme.outline.withOpacity(0.2)),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    child: Container(), // Adding an empty container as placeholder
                  ),

                  // Table section with fixed height
                  Padding(
                    padding: const EdgeInsets.only(left: 24.0, right: 24.0, bottom: 16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                        // Add some space above the table
                        const SizedBox(height: 8),
                        
                        // Row with tabs on left and action buttons on right
                       Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                         children: [
                            // Tabs on the left side (if AI review is active)
                            if (_showAIReviewTabs)
                              Row(
                                children: [
                                  _buildTab(0, 'Terms', colorScheme),
                                  _buildTab(1, 'AI suggestions', colorScheme),
                                ],
                              )
                            else
                              const SizedBox(), // Empty placeholder when tabs are not shown
                            
                            // Action buttons 
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end, // Align to the end
                              children: [
                                // Show Reject All button when AI suggestions are selected
                                if (_selectedTabIndex == 1 && _showAIReviewTabs && _selectedTermIds.isNotEmpty)
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: colorScheme.errorContainer.withOpacity(0.2),
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: TextButton.icon(
                                      onPressed: _rejectSelectedAISuggestions,
                                      icon: const Icon(Icons.delete_outline, size: 18),
                                      label: const Text('Reject all'),
                                      style: TextButton.styleFrom(
                                        foregroundColor: colorScheme.error,
                                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 0),
                                      ),
                                    ),
                                  ),
                                
                                // Show the custom buttons only when Terms tab is active
                                if (_selectedTabIndex == 0 || !_showAIReviewTabs)
                                  Row(
                                    mainAxisSize: MainAxisSize.min, // Prevent row from taking extra space
                                    children: [
                                       // Delete button
                                       if (_isAnyTermSelected)
                                         TextButton.icon(
                                           onPressed: _deleteSelectedTerms,
                                           icon: const Icon(Icons.delete_outline, size: 18),
                                           label: const Text('Delete'),
                                           style: TextButton.styleFrom(
                                             foregroundColor: colorScheme.error,
                                           ),
                                         ),
                                       
                                       // Detect terms button - moved to before Add new term
                                       Tooltip(
                                         message: 'Detect terms with AI',
                                         child: OutlinedButton.icon(
                                           onPressed: _showDetectionDialog,
                                           icon: const Icon(Icons.auto_awesome_outlined, size: 18),
                                           label: const Text('Detect terms'),
                                           style: OutlinedButton.styleFrom(
                                             foregroundColor: colorScheme.primary,
                                             side: BorderSide(color: colorScheme.primary),
                                             padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                                             shape: RoundedRectangleBorder(
                                               borderRadius: BorderRadius.circular(20),
                                             ),
                                             textStyle: textTheme.labelLarge?.copyWith(fontWeight: FontWeight.w500),
                                           ),
                                         ),
                                       ),
                                       
                                       const SizedBox(width: 8), // Add space between buttons
                                        
                                        // Add term button - now without icon
                                        Tooltip(
                                          message: 'Add new term',
                                          child: FilledButton(
                                            onPressed: () {},
                                            child: const Text('Add new term'),
                                            style: FilledButton.styleFrom(
                                              foregroundColor: colorScheme.onPrimary,
                                              backgroundColor: colorScheme.primary,
                                              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                                              shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(20),
                                              ),
                                              textStyle: textTheme.labelLarge?.copyWith(fontWeight: FontWeight.w500),
                                              elevation: 0,
                                            ),
                                          ),
                                        ),
                                        
                                        const SizedBox(width: 8), // Add space between Add and Translate
                                        
                                        // Translate terms button with tooltip
                                        Tooltip(
                                          message: _isAnyTermSelected ? 'Translate terms with AI' : 'Select term to translate with AI',
                                          child: FilledButton.icon(
                                            // Disable if no terms are selected
                                            onPressed: _isAnyTermSelected ? () { 
                                              // TODO: Implement translation logic for selected terms
                                              print('Translating: ${_selectedTermIds.join(', ')}');
                                            } : null,
                                            icon: const Icon(Icons.auto_awesome_outlined, size: 18),
                                            label: const Text('Translate'),
                                            style: FilledButton.styleFrom(
                                              foregroundColor: colorScheme.onPrimary,
                                              backgroundColor: colorScheme.primary,
                                              // Let the theme handle disabled state colors
                                              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                                              shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(20),
                                              ),
                                              textStyle: textTheme.labelLarge?.copyWith(fontWeight: FontWeight.w500),
                                            ),
                                          ),
                                        ),
                                    ], // End of "Terms" specific buttons row
                                  ),
                            ],
                            ),
                          ],
                        ),
                        
                        // Tab content bar (only shown when tabs are active)
                        if (_showAIReviewTabs)
                          Container(
                            decoration: BoxDecoration(
                              border: Border(
                                bottom: BorderSide(color: colorScheme.outline.withOpacity(0.2)),
                              ),
                            ),
                          ),
                        
                        const SizedBox(height: 16),
                        
                        // Fixed height container for table
                        Container(
                          height: 600, // Fixed height for the table section
                            decoration: BoxDecoration(
                              border: Border.all(color: colorScheme.outline.withOpacity(0.5)),
                            borderRadius: BorderRadius.circular(12),
                            ),
                            child: Column(
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                                  decoration: BoxDecoration(
                                    color: colorScheme.surfaceVariant,
                                    borderRadius: const BorderRadius.only(
                                    topLeft: Radius.circular(12),
                                    topRight: Radius.circular(12),
                                    ),
                                    border: Border(
                                      bottom: BorderSide(color: colorScheme.outline.withOpacity(0.3)),
                                    )
                                  ),
                                  child: Row(
                                    children: [
                                    // Select all checkbox header (fixed width)
                                      SizedBox(
                                        width: 40,
                                        child: Checkbox(
                                        // Determine state based on selection
                                        value: _selectedTermIds.isNotEmpty &&
                                               _selectedTermIds.length == _getFilteredTerms(glossaryService).length,
                                        tristate: true, // Allows intermediate state
                                        onChanged: (value) {
                                          // Only toggle if there are terms to select/deselect
                                          final filtered = _getFilteredTerms(glossaryService);
                                          if (filtered.isNotEmpty) {
                                             _toggleSelectAll(value, filtered);
                                          }
                                        },
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(4),
                                          ),
                                          visualDensity: VisualDensity.compact,
                                          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                        ),
                                      ),
                                    
                                    // Term column
                                      Expanded(
                                        flex: 1,
                                        child: Center(
                                          child: Text(
                                            'Term',
                                            style: TextStyle(
                                              fontWeight: FontWeight.w600,
                                              color: colorScheme.onSurfaceVariant,
                                              fontSize: 12,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                            textAlign: TextAlign.center,
                                          ),
                                        ),
                                      ),
                                    
                                    // Conditional columns based on the selected tab
                                    if (_selectedTabIndex == 1 && _showAIReviewTabs) ...[
                                      // Usage score column
                                          Expanded(
                                            flex: 1,
                                        child: Center(
                                          child: InkWell(
                                            onTap: () {
                                              setState(() {
                                                _usageScoreSortAscending = !_usageScoreSortAscending;
                                                _isUsageScoreSorted = true;
                                                // Here we would also call a sorting function
                                                // in the GlossaryService
                                                final glossaryService = Provider.of<GlossaryService>(context, listen: false);
                                                glossaryService.sortAISuggestionsByUsageScore(_usageScoreSortAscending);
                                              });
                                            },
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                Text(
                                                  'Usage score',
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.w600,
                                                    color: colorScheme.onSurfaceVariant,
                                                    fontSize: 12,
                                                    overflow: TextOverflow.ellipsis,
                                                  ),
                                                ),
                                                const SizedBox(width: 4),
                                                Icon(
                                                  _isUsageScoreSorted
                                                      ? (_usageScoreSortAscending ? Icons.arrow_upward : Icons.arrow_downward)
                                                      : Icons.sort,
                                                  size: 16,
                                                  color: colorScheme.onSurfaceVariant,
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                      
                                      // Do Not Translate column
                                      Expanded(
                                        flex: 1,
                                        child: Center(
                                          child: Text(
                                            'Do not translate',
                                            style: TextStyle(
                                              fontWeight: FontWeight.w600,
                                              color: colorScheme.onSurfaceVariant,
                                              fontSize: 12,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                            textAlign: TextAlign.center,
                                          ),
                                        ),
                                      ),
                                      
                                      // Case Sensitive column
                                      Expanded(
                                        flex: 1,
                                        child: Center(
                                          child: Text(
                                            'Case sensitive',
                                            style: TextStyle(
                                              fontWeight: FontWeight.w600,
                                              color: colorScheme.onSurfaceVariant,
                                              fontSize: 12,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                            textAlign: TextAlign.center,
                                          ),
                                        ),
                                      ),
                                      
                                      const SizedBox(width: 16),
                                      
                                      // Examples column
                                          Expanded(
                                            flex: 4,
                                            child: Center(
                                              child: Text(
                                                'Example',
                                                style: TextStyle(
                                                  fontWeight: FontWeight.w600,
                                                  color: colorScheme.onSurfaceVariant,
                                                  fontSize: 12,
                                                  overflow: TextOverflow.ellipsis,
                                                ),
                                                textAlign: TextAlign.center,
                                              ),
                                            ),
                                          ),
                                      
                                      // Actions column
                                          Expanded(
                                            flex: 1,
                                            child: Center(
                                              child: Text(
                                                'Actions',
                                                style: TextStyle(
                                                  fontWeight: FontWeight.w600,
                                                  color: colorScheme.onSurfaceVariant,
                                                  fontSize: 12,
                                                  overflow: TextOverflow.ellipsis,
                                                ),
                                                textAlign: TextAlign.center,
                                              ),
                                            ),
                                          ),
                                    ] else ...[
                                      // Translation column
                                          Expanded(
                                            flex: 2,
                                            child: Center(
                                              child: Text(
                                                'Translation',
                                                style: TextStyle(
                                                  fontWeight: FontWeight.w600,
                                                  color: colorScheme.onSurfaceVariant,
                                                  fontSize: 12,
                                                  overflow: TextOverflow.ellipsis,
                                                ),
                                                textAlign: TextAlign.center,
                                              ),
                                            ),
                                          ),
                                      
                                      // Confirmed column
                                          Expanded(
                                            flex: 1,
                                            child: Center(
                                              child: Text(
                                                'Confirmed',
                                                style: TextStyle(
                                                  fontWeight: FontWeight.w600,
                                                  color: colorScheme.onSurfaceVariant,
                                                  fontSize: 12,
                                                  overflow: TextOverflow.ellipsis,
                                                ),
                                                textAlign: TextAlign.center,
                                              ),
                                            ),
                                          ),
                                      
                                      // Example column
                                          Expanded(
                                            flex: 2,
                                            child: Center(
                                              child: Text(
                                                'Example',
                                                style: TextStyle(
                                                  fontWeight: FontWeight.w600,
                                                  color: colorScheme.onSurfaceVariant,
                                                  fontSize: 12,
                                                  overflow: TextOverflow.ellipsis,
                                                ),
                                                textAlign: TextAlign.center,
                                              ),
                                            ),
                                          ),
                                      
                                      // Actions column
                                      Expanded(
                                        flex: 1,
                                        child: Center(
                                            child: Text(
                                              'Actions',
                                              style: TextStyle(
                                                fontWeight: FontWeight.w600,
                                                color: colorScheme.onSurfaceVariant,
                                                fontSize: 12,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                              textAlign: TextAlign.center,
                                          ),
                                            ),
                                          ),
                                        ],
                                    ],
                                  ),
                                ),
                                
                                Expanded(
                                  child: _selectedTabIndex == 0 || !_showAIReviewTabs
                                  ? buildTermsTable(
                                      context, 
                                      glossaryService, 
                                      colorScheme, 
                                      textTheme, 
                                      _searchQuery, 
                                      _selectedTermIds, // Pass the set
                                      (termId, isSelected) { // Define the toggle logic
                                        setState(() {
                                          if (isSelected == true) {
                                            _selectedTermIds.add(termId);
                                          } else {
                                            _selectedTermIds.remove(termId);
                                          }
                                        });
                                      },
                                    )
                                  : buildAISuggestionsTable(
                                      context, 
                                      glossaryService, 
                                      colorScheme, 
                                      textTheme, 
                                      _searchQuery,
                                      _selectedExamples,
                                      _selectedTermIds, // Pass the same set used for terms
                                      (String termId, int exampleIndex, bool? value) {
                                        setState(() {
                                          // Initialize set if it doesn't exist
                                          if (!_selectedExamples.containsKey(termId)) {
                                            _selectedExamples[termId] = {};
                                          }
                                          
                                          // Toggle example selection (only index 0 is used now)
                                          if (value == true) {
                                            _selectedExamples[termId]!.add(exampleIndex); // Will always be 0
                                          } else {
                                            _selectedExamples[termId]!.remove(exampleIndex);
                                          }
                                        });
                                      },
                                      (String termId, bool? isSelected) { // Add handler for term selection
                                        setState(() {
                                          if (isSelected == true) {
                                            _selectedTermIds.add(termId);
                                          } else {
                                            _selectedTermIds.remove(termId);
                                          }
                                        });
                                      },
                                      () {
                                        // Don't switch back to the Terms tab when a term is accepted
                                        // The user should be able to stay on the AI suggestions tab
                                      },
                                      _showDetectionDialog,
                                    ),
                                ),
                              ],
                          ),
                        ),
                      ],
                  ),
                ),
              ],
              ),
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

  // Method to delete selected terms
  void _deleteSelectedTerms() {
    // Show confirmation dialog
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete term'),
        content: const Text('Are you sure you want to delete the selected term?'),
                    shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
                  child: Text(
              'Cancel',
              style: TextStyle(color: Theme.of(context).colorScheme.primary),
            ),
          ),
          TextButton(
                        onPressed: () {
              // Delete the selected terms
              Navigator.of(context).pop();

              // Get access to the glossary service
              final glossaryService = Provider.of<GlossaryService>(context, listen: false);

              // Process all selected terms
              for (final termId in _selectedTermIds.toList()) {
                // Find the term with this ID
                final term = glossaryService.allTerms.firstWhere(
                  (t) => t.id == termId,
                  orElse: () => null as Term, // This is typecasting, not actual null
                );

                if (term != null) {
                  // Check if it's a glossary term or an accepted AI term
                  final isGlossaryTerm = glossaryService.glossaryTerms.contains(term);
                  
                  if (isGlossaryTerm) {
                    // Remove from glossary
                    glossaryService.removeTerm(term);
                  } else {
                    // Remove from accepted AI terms
                    glossaryService.removeAcceptedAITerm(term);
                  }
                }
              }

              // Clear selection
              setState(() {
                _selectedTermIds.clear();
              });
            },
            style: TextButton.styleFrom(
              foregroundColor: Theme.of(context).colorScheme.onError,
              backgroundColor: Theme.of(context).colorScheme.error,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(28),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
            ),
            child: const Text('Delete'),
                  ),
                ],
              ),
        );
  }

  void _rejectSelectedAISuggestions() {
    // Show confirmation dialog
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Reject terms'),
        content: Text('Are you sure you want to reject ${_selectedTermIds.length} selected ${_selectedTermIds.length == 1 ? 'term' : 'terms'}?'),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(
              'Cancel',
              style: TextStyle(color: Theme.of(context).colorScheme.primary),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();

              // Get access to the glossary service
              final glossaryService = Provider.of<GlossaryService>(context, listen: false);

              // Process all selected terms
              for (final termId in _selectedTermIds.toList()) {
                // Find the term in AI suggestions
                final termIndex = glossaryService.aiSuggestedTerms.indexWhere((t) => t.id == termId);
                if (termIndex >= 0) {
                  // Get the term and reject it
                  final term = glossaryService.aiSuggestedTerms[termIndex];
                  glossaryService.rejectAISuggestion(term);
                }
              }

              // Clear selection
              setState(() {
                _selectedTermIds.clear();
              });
            },
            style: TextButton.styleFrom(
              foregroundColor: Theme.of(context).colorScheme.onError,
              backgroundColor: Theme.of(context).colorScheme.error,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(28),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
            ),
            child: const Text('Reject'),
          ),
        ],
      ),
    );
  }
} 