// lib/screens/dashboard_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/common/app_bar.dart';
import '../widgets/common/sidebar.dart';
import '../widgets/common/secondary_toolbar.dart';
import '../widgets/detection/detection_modal.dart';
import '../widgets/detection/progress_banner.dart';
import '../widgets/detection/success_banner.dart';
import '../widgets/terms/term_actions.dart';
import '../widgets/terms/term_table.dart';
import '../services/detection_service.dart';
import '../services/glossary_service.dart';
import '../config/theme.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    
    // Listen to detection service status changes to update UI
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final detectionService = Provider.of<DetectionService>(context, listen: false);
      detectionService.addListener(_onDetectionStatusChanged);
    });
  }
  
  void _onDetectionStatusChanged() {
    // Force rebuild when detection status changes
    if (mounted) { // Check if the widget is still in the tree
      setState(() {});
    }
    
    // Auto-switch to AI suggestions tab when detection completes
    final detectionService = Provider.of<DetectionService>(context, listen: false);
    if (detectionService.status == DetectionStatus.completed) {
      _tabController.animateTo(1); // Switch to AI suggestions tab
    }
  }

  @override
  void dispose() {
    // Make sure to check for provider existence before accessing it in dispose
    if (mounted) {
       final detectionService = Provider.of<DetectionService>(context, listen: false);
       detectionService.removeListener(_onDetectionStatusChanged);
    }
    _tabController.dispose();
    super.dispose();
  }

  void _showDetectionModalDialog() {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return DetectionModal(
          onCancel: () => Navigator.of(dialogContext).pop(),
          onStartDetection: () {
             Navigator.of(dialogContext).pop();
            _startDetection();
          },
        );
      },
    );
  }

  void _startDetection() {
    final detectionService = Provider.of<DetectionService>(context, listen: false);
    detectionService.detectTerms();
  }

  void _reviewCandidates() {
    _tabController.animateTo(1); // Switch to AI suggestions tab
  }
  
  void _addTerm(term) {
    final glossaryService = Provider.of<GlossaryService>(context, listen: false);
    glossaryService.addTerm(term);
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Added "${term.text}" to glossary'),
        backgroundColor: AppTheme.successColor,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        margin: const EdgeInsets.all(16),
      ),
    );
  }
  
  void _rejectTerm(term) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Rejected "${term.text}"'),
        backgroundColor: AppTheme.errorColor,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        margin: const EdgeInsets.all(16),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final detectionService = Provider.of<DetectionService>(context);
    final glossaryService = Provider.of<GlossaryService>(context);
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    final size = MediaQuery.of(context).size;

    const double toolbarWidgetHeight = 40.0;
    const double horizontalPadding = 16.0;
    
    final ButtonStyle toolbarButtonStyle = ElevatedButton.styleFrom(
      minimumSize: const Size(0, toolbarWidgetHeight),
      backgroundColor: colorScheme.surface, 
      foregroundColor: AppTheme.textPrimaryColor, 
      side: BorderSide(color: Colors.grey.shade300),
      elevation: 0,
      padding: const EdgeInsets.symmetric(horizontal: horizontalPadding, vertical: 0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      textStyle: textTheme.labelLarge?.copyWith(fontWeight: FontWeight.w500), 
    );

    return Scaffold(
      appBar: const GlossaryAppBar(title: 'Detect terms with AI'),
      // Use SafeArea to respect system UI elements
      body: SafeArea(
        child: Column(
          children: [
            // Add the secondary toolbar below the app bar
            SecondaryToolbar(
              actions: [
                ElevatedButton.icon(
                  onPressed: _showDetectionModalDialog,
                  icon: const Icon(Icons.auto_awesome, size: 18),
                  label: const Text('Detect terms'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primaryColor,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    minimumSize: const Size(0, 36),
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4),
                    ),
                    textStyle: textTheme.labelMedium?.copyWith(fontWeight: FontWeight.w500),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.filter_list, size: 18),
                  label: const Text('Filter'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: colorScheme.surface,
                    foregroundColor: AppTheme.textPrimaryColor,
                    elevation: 0,
                    side: BorderSide(color: Colors.grey.shade300),
                    minimumSize: const Size(0, 36),
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4),
                    ),
                    textStyle: textTheme.labelMedium?.copyWith(fontWeight: FontWeight.w500),
                  ),
                ),
                const Spacer(),
                Text(
                  'Glossary Terms',
                  style: textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: AppTheme.textPrimaryColor,
                  ),
                ),
              ],
            ),
            
            // Main content in an Expanded widget to fill remaining space
            Expanded(
              child: Row(
                children: [
                  const GlossarySidebar(),
                  
                  // Use Expanded with SingleChildScrollView for the main content
                  Expanded(
                    child: LayoutBuilder(
                      builder: (context, constraints) {
                        // Get available height minus the necessary padding
                        final availableHeight = constraints.maxHeight - 48.0; // 24.0 padding top/bottom
                        
                        return SingleChildScrollView(
                          child: ConstrainedBox(
                            constraints: BoxConstraints(
                              minHeight: availableHeight,
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(24.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Top toolbar with fixed height and spacing
                                  SizedBox(
                                    height: toolbarWidgetHeight,
                                    child: Row(
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        // Glossary dropdown - increased width to fit text
                                        SizedBox(
                                          width: 220, // Increased from 180 to fit "Project's glossary" text
                                          child: DecoratedBox(
                                            decoration: BoxDecoration(
                                              border: Border.all(color: Colors.grey.shade300),
                                              borderRadius: BorderRadius.circular(8),
                                              color: colorScheme.surface,
                                            ),
                                            child: Padding(
                                              padding: const EdgeInsets.symmetric(horizontal: 12.0),
                                              child: DropdownButtonHideUnderline(
                                                child: DropdownButton<String>(
                                                  value: glossaryService.currentGlossary.name,
                                                  isExpanded: true,
                                                  icon: const Icon(Icons.arrow_drop_down),
                                                  // Ensure text is properly sized
                                                  style: textTheme.bodyMedium?.copyWith(
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                  items: [
                                                    DropdownMenuItem(
                                                      value: glossaryService.currentGlossary.name,
                                                      child: Text(
                                                        glossaryService.currentGlossary.name,
                                                        overflow: TextOverflow.ellipsis,
                                                      ),
                                                    ),
                                                    const DropdownMenuItem(
                                                      value: 'Another Glossary',
                                                      child: Text('Another Glossary'),
                                                    ),
                                                  ],
                                                  onChanged: (value) {
                                                    setState(() {});
                                                  },
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 16),
                                        
                                        Text(
                                          'Target language:',
                                          style: textTheme.labelLarge?.copyWith(
                                            color: AppTheme.textSecondaryColor,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        
                                        SizedBox(
                                          width: 160,
                                          child: DecoratedBox(
                                            decoration: BoxDecoration(
                                              border: Border.all(color: Colors.grey.shade300),
                                              borderRadius: BorderRadius.circular(8),
                                              color: colorScheme.surface,
                                            ),
                                            child: Padding(
                                              padding: const EdgeInsets.symmetric(horizontal: 12.0),
                                              child: DropdownButtonHideUnderline(
                                                child: DropdownButton<String>(
                                                  value: glossaryService.currentGlossary.targetLanguage,
                                                  isExpanded: true,
                                                  icon: const Icon(Icons.arrow_drop_down),
                                                  style: textTheme.bodyMedium?.copyWith(
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                  items: [
                                                    DropdownMenuItem(
                                                      value: glossaryService.currentGlossary.targetLanguage,
                                                      child: Row(
                                                        mainAxisSize: MainAxisSize.min,
                                                        children: [
                                                          const Text('🇭🇺', style: TextStyle(fontSize: 16)),
                                                          const SizedBox(width: 8),
                                                          Flexible(
                                                            child: Text(
                                                              glossaryService.currentGlossary.targetLanguage,
                                                              overflow: TextOverflow.ellipsis,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    const DropdownMenuItem(
                                                      value: 'German',
                                                      child: Row(
                                                        mainAxisSize: MainAxisSize.min,
                                                        children: [
                                                          Text('🇩🇪', style: TextStyle(fontSize: 16)),
                                                          SizedBox(width: 8),
                                                          Text('German'),
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                  onChanged: (value) {
                                                    setState(() {});
                                                  },
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        
                                        const Spacer(),
                                        
                                        ElevatedButton.icon(
                                          onPressed: () {},
                                          icon: const Icon(Icons.file_upload_outlined, size: 20),
                                          label: const Text('Export'),
                                          style: toolbarButtonStyle,
                                        ),
                                        const SizedBox(width: 12),
                                        
                                        ElevatedButton.icon(
                                          onPressed: () {},
                                          icon: const Icon(Icons.file_download_outlined, size: 20),
                                          label: const Text('Import'),
                                          style: toolbarButtonStyle,
                                        ),
                                      ],
                                    ),
                                  ),
                                  
                                  const SizedBox(height: 24),
                                  
                                  if (detectionService.status == DetectionStatus.inProgress)
                                    const ProgressBanner(),
                                  
                                  if (detectionService.status == DetectionStatus.completed)
                                    SuccessBanner(
                                      termCount: detectionService.termCount,
                                      onReviewCandidates: _reviewCandidates,
                                    ),
                                  
                                  const SizedBox(height: 24),
                                  
                                  TermActions(
                                    onDetectTerms: _showDetectionModalDialog,
                                    onTranslate: () {},
                                    onAddNewTerm: () {},
                                  ),
                                  
                                  const SizedBox(height: 24),
                                  
                                  Container(
                                    decoration: BoxDecoration(
                                      border: Border(
                                        bottom: BorderSide(
                                          color: Colors.grey.shade300,
                                          width: 1.0,
                                        ),
                                      ),
                                    ),
                                    child: TabBar(
                                      controller: _tabController,
                                      tabs: const [
                                        Tab(text: 'Terms'),
                                        Tab(text: 'AI suggestions'),
                                      ],
                                      labelStyle: textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600),
                                      unselectedLabelStyle: textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w400),
                                      labelColor: AppTheme.primaryColor,
                                      unselectedLabelColor: AppTheme.textSecondaryColor,
                                      indicatorColor: AppTheme.primaryColor,
                                      indicatorWeight: 3,
                                    ),
                                  ),
                                  
                                  const SizedBox(height: 16),
                                  
                                  // Explicitly constrain the TabBarView's height to prevent overflow
                                  LimitedBox(
                                    maxHeight: availableHeight - 300, // Subtract space for all other UI elements
                                    child: TabBarView(
                                      controller: _tabController,
                                      children: [
                                        // Wrap each tab content in SingleChildScrollView to handle overflow
                                        SingleChildScrollView(
                                          child: glossaryService.currentGlossary.terms.isEmpty
                                              ? _buildEmptyGlossaryState()
                                              : TermTable(
                                                  terms: glossaryService.currentGlossary.terms,
                                                  onDoNotTranslateToggle: (term, value) {
                                                    setState(() {});
                                                  },
                                                  onCaseSensitiveToggle: (term, value) {
                                                    setState(() {});
                                                  },
                                                  onAddTerm: _addTerm,
                                                  onRejectTerm: _rejectTerm,
                                                ),
                                        ),
                                        
                                        // AI suggestions tab with proper scrolling
                                        SingleChildScrollView(
                                          child: detectionService.detectedTerms.isEmpty && detectionService.status != DetectionStatus.inProgress
                                              ? _buildEmptySuggestionsState()
                                              : TermTable(
                                                  terms: detectionService.detectedTerms,
                                                  onDoNotTranslateToggle: (term, value) {
                                                    term.doNotTranslate = value;
                                                    setState(() {});
                                                  },
                                                  onCaseSensitiveToggle: (term, value) {
                                                    term.caseSensitive = value;
                                                    setState(() {});
                                                  },
                                                  onAddTerm: _addTerm,
                                                  onRejectTerm: _rejectTerm,
                                                  onDetectTerms: _showDetectionModalDialog,
                                                  onTranslate: () {
                                                    // Translate functionality
                                                    ScaffoldMessenger.of(context).showSnackBar(
                                                      SnackBar(
                                                        content: const Text('Translating terms...'),
                                                        behavior: SnackBarBehavior.floating,
                                                        duration: const Duration(seconds: 2),
                                                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                                        margin: const EdgeInsets.all(16),
                                                      ),
                                                    );
                                                  },
                                                ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  
                  Container(
                    width: 60,
                    color: colorScheme.surface,
                    child: Column(
                       children: [
                        const SizedBox(height: 24),
                        IconButton(
                          onPressed: () {},
                          icon: Icon(
                            Icons.edit_outlined,
                            color: AppTheme.textSecondaryColor,
                          ),
                          tooltip: 'Edit',
                        ),
                        const SizedBox(height: 12),
                        IconButton(
                          onPressed: () {},
                          icon: Icon(
                            Icons.info_outline,
                            color: AppTheme.textSecondaryColor,
                          ),
                          tooltip: 'Info',
                        ),
                        const SizedBox(height: 12),
                        IconButton(
                          onPressed: () {},
                          icon: Icon(
                            Icons.settings_outlined,
                            color: AppTheme.textSecondaryColor,
                          ),
                          tooltip: 'Settings',
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
    );
  }
  
  Widget _buildEmptyGlossaryState() {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    final ButtonStyle primaryButtonStyle = ElevatedButton.styleFrom(
      backgroundColor: AppTheme.primaryColor,
      foregroundColor: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      textStyle: textTheme.labelLarge?.copyWith(fontWeight: FontWeight.w500),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
    );
     final ButtonStyle secondaryButtonStyle = OutlinedButton.styleFrom(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      side: BorderSide(color: Colors.grey.shade300),
      foregroundColor: AppTheme.textPrimaryColor,
      textStyle: textTheme.labelLarge?.copyWith(fontWeight: FontWeight.w500),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
    );

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.list_alt_outlined,
            size: 64,
            color: Colors.grey.shade400,
          ),
          const SizedBox(height: 16),
          Text(
            'Your glossary is empty',
            style: textTheme.headlineSmall,
          ),
          const SizedBox(height: 8),
          Text(
            'Add terms manually or use AI detection to find potential terms',
            style: textTheme.bodyLarge?.copyWith(color: AppTheme.textSecondaryColor),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton.icon(
                onPressed: _showDetectionModalDialog,
                icon: const Icon(Icons.auto_awesome, size: 18),
                label: const Text('Detect terms with AI'),
                style: primaryButtonStyle,
              ),
              const SizedBox(width: 16),
              OutlinedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.add, size: 18),
                label: const Text('Add term manually'),
                style: secondaryButtonStyle,
              ),
            ],
          ),
        ],
      ),
    );
  }
  
  Widget _buildEmptySuggestionsState() {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    final ButtonStyle primaryButtonStyle = ElevatedButton.styleFrom(
       backgroundColor: AppTheme.primaryColor,
      foregroundColor: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      textStyle: textTheme.labelLarge?.copyWith(fontWeight: FontWeight.w500),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
    );

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.search_off_outlined,
            size: 64,
            color: Colors.grey.shade400,
          ),
          const SizedBox(height: 16),
          Text(
            'No term suggestions yet',
            style: textTheme.headlineSmall,
          ),
          const SizedBox(height: 8),
          Text(
            'Run AI detection to find potential terms in your content',
            style: textTheme.bodyLarge?.copyWith(color: AppTheme.textSecondaryColor),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: _showDetectionModalDialog,
            icon: const Icon(Icons.auto_awesome, size: 18),
            label: const Text('Start AI detection'),
            style: primaryButtonStyle,
          ),
        ],
      ),
    );
  }
}