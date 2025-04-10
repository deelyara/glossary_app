// lib/screens/dashboard_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/common/app_bar.dart';
import '../widgets/common/sidebar.dart';
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
  bool _showDetectionModal = false;

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
    setState(() {});
    
    // Auto-switch to AI suggestions tab when detection completes
    final detectionService = Provider.of<DetectionService>(context, listen: false);
    if (detectionService.status == DetectionStatus.completed) {
      _tabController.animateTo(1); // Switch to AI suggestions tab
    }
  }

  @override
  void dispose() {
    final detectionService = Provider.of<DetectionService>(context, listen: false);
    detectionService.removeListener(_onDetectionStatusChanged);
    _tabController.dispose();
    super.dispose();
  }

  void _showDetectionModalDialog() {
    setState(() {
      _showDetectionModal = true;
    });
  }

  void _hideDetectionModal() {
    setState(() {
      _showDetectionModal = false;
    });
  }

  void _startDetection() {
    _hideDetectionModal();
    final detectionService = Provider.of<DetectionService>(context, listen: false);
    detectionService.detectTerms();
  }

  void _reviewCandidates() {
    _tabController.animateTo(1); // Switch to AI suggestions tab
  }
  
  void _addTerm(term) {
    final glossaryService = Provider.of<GlossaryService>(context, listen: false);
    glossaryService.addTerm(term);
    
    // Show snackbar feedback
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Added "${term.text}" to glossary'),
        backgroundColor: AppTheme.successColor,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
      ),
    );
  }
  
  void _rejectTerm(term) {
    // Show snackbar feedback
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Rejected "${term.text}"'),
        backgroundColor: AppTheme.errorColor,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final detectionService = Provider.of<DetectionService>(context);
    final glossaryService = Provider.of<GlossaryService>(context);
    
    return Scaffold(
      appBar: const GlossaryAppBar(title: 'Detect terms with AI'),
      body: Row(
        children: [
          // Left sidebar
          const GlossarySidebar(),
          
          // Main content
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Top toolbar with glossary selector and import/export
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey.shade300),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: DropdownButton<String>(
                          value: glossaryService.currentGlossary.name,
                          items: [
                            DropdownMenuItem(
                              value: glossaryService.currentGlossary.name,
                              child: Text(
                                glossaryService.currentGlossary.name,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          ],
                          onChanged: (value) {},
                          underline: const SizedBox(),
                          icon: const Icon(Icons.arrow_drop_down),
                        ),
                      ),
                      const Spacer(),
                      Text(
                        'Target language:',
                        style: TextStyle(
                          fontSize: 16,
                          color: AppTheme.textSecondaryColor,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey.shade300),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: DropdownButton<String>(
                          value: glossaryService.currentGlossary.targetLanguage,
                          items: [
                            DropdownMenuItem(
                              value: glossaryService.currentGlossary.targetLanguage,
                              child: Row(
                                children: [
                                  const Text('🇭🇺'),
                                  const SizedBox(width: 8),
                                  Text(
                                    glossaryService.currentGlossary.targetLanguage,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 16,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                          onChanged: (value) {},
                          underline: const SizedBox(),
                          icon: const Icon(Icons.arrow_drop_down),
                        ),
                      ),
                      const Spacer(),
                      ElevatedButton.icon(
                        onPressed: () {},
                        icon: const Icon(Icons.file_upload_outlined),
                        label: const Text('Export'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: AppTheme.textPrimaryColor,
                          side: BorderSide(color: Colors.grey.shade300),
                          elevation: 0,
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        ),
                      ),
                      const SizedBox(width: 12),
                      ElevatedButton.icon(
                        onPressed: () {},
                        icon: const Icon(Icons.file_download_outlined),
                        label: const Text('Import'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: AppTheme.textPrimaryColor,
                          side: BorderSide(color: Colors.grey.shade300),
                          elevation: 0,
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        ),
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 24),
                  
                  // Detection Status Banners
                  if (detectionService.status == DetectionStatus.inProgress)
                    const ProgressBanner(),
                  
                  if (detectionService.status == DetectionStatus.completed)
                    SuccessBanner(
                      termCount: detectionService.termCount,
                      onReviewCandidates: _reviewCandidates,
                    ),
                  
                  const SizedBox(height: 24),
                  
                  // Term actions (search, translate, add)
                  TermActions(
                    onDetectTerms: _showDetectionModalDialog,
                    onTranslate: () {},
                    onAddNewTerm: () {},
                  ),
                  
                  const SizedBox(height: 24),
                  
                  // Tabs for Terms and AI suggestions
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
                      labelStyle: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                      unselectedLabelStyle: const TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: 16,
                      ),
                      labelColor: AppTheme.primaryColor,
                      unselectedLabelColor: AppTheme.textSecondaryColor,
                      indicatorColor: AppTheme.primaryColor,
                      indicatorWeight: 3,
                    ),
                  ),
                  
                  const SizedBox(height: 16),
                  
                  // Tab content
                  Expanded(
                    child: TabBarView(
                      controller: _tabController,
                      children: [
                        // Terms tab
                        glossaryService.currentGlossary.terms.isEmpty
                            ? _buildEmptyGlossaryState()
                            : TermTable(
                                terms: glossaryService.currentGlossary.terms,
                                onDoNotTranslateToggle: (term, value) {
                                  // Update term property
                                  setState(() {});
                                },
                                onCaseSensitiveToggle: (term, value) {
                                  // Update term property
                                  setState(() {});
                                },
                                onAddTerm: _addTerm,
                                onRejectTerm: _rejectTerm,
                              ),
                        
                        // AI suggestions tab
                        detectionService.detectedTerms.isEmpty && detectionService.status != DetectionStatus.inProgress
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
                              ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          
          // Right sidebar for icons
          Container(
            width: 60,
            color: Colors.white,
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
      
      // Detection Modal
      bottomSheet: _showDetectionModal
          ? DetectionModal(
              onCancel: _hideDetectionModal,
              onStartDetection: _startDetection,
            )
          : null,
    );
  }
  
  Widget _buildEmptyGlossaryState() {
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
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: AppTheme.textPrimaryColor,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Add terms manually or use AI detection to find potential terms',
            style: TextStyle(
              fontSize: 16,
              color: AppTheme.textSecondaryColor,
            ),
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton.icon(
                onPressed: _showDetectionModalDialog,
                icon: const Icon(Icons.auto_awesome),
                label: const Text('Detect terms with AI'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primaryColor,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                ),
              ),
              const SizedBox(width: 16),
              OutlinedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.add),
                label: const Text('Add term manually'),
              ),
            ],
          ),
        ],
      ),
    );
  }
  
  Widget _buildEmptySuggestionsState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.search_outlined,
            size: 64,
            color: Colors.grey.shade400,
          ),
          const SizedBox(height: 16),
          Text(
            'No term suggestions yet',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: AppTheme.textPrimaryColor,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Run AI detection to find potential terms in your content',
            style: TextStyle(
              fontSize: 16,
              color: AppTheme.textSecondaryColor,
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: _showDetectionModalDialog,
            icon: const Icon(Icons.auto_awesome),
            label: const Text('Start AI detection'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primaryColor,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            ),
          ),
        ],
      ),
    );
  }
}