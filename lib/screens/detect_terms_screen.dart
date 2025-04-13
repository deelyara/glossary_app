import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../config/theme.dart';
import '../models/term.dart';
import '../services/glossary_service.dart';
import '../services/detection_service.dart';
import '../main_glossary_page.dart';

class DetectTermsScreen extends StatefulWidget {
  const DetectTermsScreen({super.key});

  @override
  State<DetectTermsScreen> createState() => _DetectTermsScreenState();
}

class _DetectTermsScreenState extends State<DetectTermsScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }
  
  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final glossaryService = Provider.of<GlossaryService>(context);
    final textTheme = Theme.of(context).textTheme;
    
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            const LogoPlaceholder(height: 36),
            const SizedBox(width: 16),
            const Text('Glossary'),
            const SizedBox(width: 8),
            Text(
              'TEST',
              style: TextStyle(
                color: Colors.red,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.help_outline),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        children: [
          // Publish banner
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            color: const Color(0xFFE1EFFF),
            child: Row(
              children: [
                const Text(
                  'For changes to the glossary to take effect, you need to publish them.',
                  style: TextStyle(color: Color(0xFF2D4665)),
                ),
                const Spacer(),
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2D4665),
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  child: const Text('Publish'),
                ),
              ],
            ),
          ),
          
          // Main content area
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Top row with dropdowns and actions
                  Row(
                    children: [
                      // First glossary update dropdown
                      Container(
                        height: 36,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey.shade300),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12.0),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<String>(
                              value: 'First glossary update',
                              icon: const Icon(Icons.arrow_drop_down),
                              style: textTheme.bodyMedium,
                              items: const [
                                DropdownMenuItem(
                                  value: 'First glossary update',
                                  child: Text('First glossary update'),
                                ),
                              ],
                              onChanged: (value) {},
                            ),
                          ),
                        ),
                      ),
                      
                      const SizedBox(width: 16),
                      
                      // Ukrainian dropdown
                      Container(
                        height: 36,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey.shade300),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12.0),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<String>(
                              value: 'Ukrainian (UA)',
                              icon: const Icon(Icons.arrow_drop_down),
                              style: textTheme.bodyMedium,
                              items: const [
                                DropdownMenuItem(
                                  value: 'Ukrainian (UA)',
                                  child: Row(
                                    children: [
                                      Text('🇺🇦'),
                                      SizedBox(width: 8),
                                      Text('Ukrainian (UA)'),
                                    ],
                                  ),
                                ),
                              ],
                              onChanged: (value) {},
                            ),
                          ),
                        ),
                      ),
                      
                      const Spacer(),
                      
                      // Export button
                      Container(
                        height: 36,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey.shade300),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: TextButton.icon(
                          onPressed: () {},
                          icon: const Icon(Icons.download, size: 18),
                          label: const Text('Export'),
                          style: TextButton.styleFrom(
                            minimumSize: Size.zero,
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                          ),
                        ),
                      ),
                      
                      const SizedBox(width: 16),
                      
                      // Import button
                      Container(
                        height: 36,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey.shade300),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: TextButton.icon(
                          onPressed: () {},
                          icon: const Icon(Icons.upload, size: 18),
                          label: const Text('Import'),
                          style: TextButton.styleFrom(
                            minimumSize: Size.zero,
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                          ),
                        ),
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 16),
                  
                  // Search row with buttons
                  Row(
                    children: [
                      // Search field
                      Expanded(
                        child: Container(
                          height: 36,
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey.shade300),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: const TextField(
                            decoration: InputDecoration(
                              hintText: 'Search',
                              prefixIcon: Icon(Icons.search, size: 20),
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.symmetric(vertical: 8),
                            ),
                          ),
                        ),
                      ),
                      
                      const SizedBox(width: 16),
                      
                      // Back to glossary button
                      ElevatedButton.icon(
          onPressed: () {
                  Navigator.pop(context);
                        },
                        icon: const Icon(Icons.arrow_back, size: 18),
                        label: const Text('Back to glossary'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: Colors.black87,
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          minimumSize: const Size(0, 36),
                          side: BorderSide(color: Colors.grey.shade300),
                        ),
                      ),
                      
                      const SizedBox(width: 16),
                      
                      // Translate button
                      ElevatedButton.icon(
                        onPressed: () {},
                        icon: const Icon(Icons.translate, size: 18),
                        label: const Text('Translate'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: Colors.black87,
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          minimumSize: const Size(0, 36),
                          side: BorderSide(color: Colors.grey.shade300),
                        ),
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 16),
                  
                  // Tab bar
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.grey.shade50,
                      border: Border(
                        bottom: BorderSide(color: Colors.grey.shade300),
                      ),
                    ),
                    child: TabBar(
                      controller: _tabController,
                      tabs: const [
                        Tab(text: 'Terms'),
                        Tab(text: 'AI suggestions'),
                      ],
                      indicatorColor: Colors.blue,
                      labelColor: Colors.blue,
                      unselectedLabelColor: Colors.grey.shade700,
                      labelStyle: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                  ),
                  
                  // Tab content
                  Expanded(
                    child: TabBarView(
                      controller: _tabController,
                      children: [
                        // Terms tab - now showing all terms (glossary + accepted AI terms)
                        buildTermsTable(glossaryService.allTerms),
                        
                        // AI suggestions tab
                        buildAISuggestionsTable(glossaryService.aiSuggestedTerms),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
  
  // Regular terms table for the Terms tab (shows both glossary terms and accepted AI terms)
  Widget buildTermsTable(List<Term> terms) {
    return Container(
      margin: const EdgeInsets.only(top: 8),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          // Table header
          Container(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(8),
                topRight: Radius.circular(8),
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
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Text(
                    'Term',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: Colors.grey.shade700,
                      fontSize: 14,
                    ),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Text(
                    'Translation',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: Colors.grey.shade700,
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
                        color: Colors.grey.shade700,
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
                      color: Colors.grey.shade700,
                      fontSize: 14,
                    ),
                  ),
                ),
                SizedBox(
                  width: 80,
                  child: Text(
                    'Actions',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: Colors.grey.shade700,
                      fontSize: 14,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ),
          
          // Table rows
          Expanded(
            child: terms.isEmpty
                ? Center(
                    child: Text(
                      'No terms to display',
                      style: TextStyle(
                        color: Colors.grey.shade600,
                        fontSize: 16,
                      ),
                    ),
                  )
                : ListView.builder(
                    itemCount: terms.length,
                    itemBuilder: (context, index) {
                      final term = terms[index];
                      final isEven = index % 2 == 0;
                      
                      return Container(
                        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                        decoration: BoxDecoration(
                          color: isEven ? Colors.white : Colors.grey.shade50,
                          border: Border(
                            bottom: BorderSide(color: Colors.grey.shade200),
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
                                  color: term.translation == null ? Colors.grey.shade600 : Colors.black87,
                                ),
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
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 2,
                              child: Text(
                                term.examples.isNotEmpty ? term.examples[0] : '',
                                style: const TextStyle(
                                  fontSize: 14,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            SizedBox(
                              width: 80,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  IconButton(
                                    icon: const Icon(Icons.more_vert),
                                    onPressed: () {},
                                    iconSize: 20,
                                    splashRadius: 20,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
  
  // AI suggestions table matching the provided image
  Widget buildAISuggestionsTable(List<Term> terms) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Container(
            padding: const EdgeInsets.all(16),
            margin: const EdgeInsets.only(top: 8),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade300),
              borderRadius: BorderRadius.circular(8),
              color: Colors.red,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Table header row
                Row(
                  children: [
                    // Checkbox for Term
                    Container(
                      width: 40,
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: Checkbox(
                        value: false,
                        onChanged: (value) {},
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ),
                    
                    // Term
                    Container(
                      width: 120,
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: Text(
                        'Term',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: Colors.grey.shade700,
                          fontSize: 14,
                        ),
                      ),
                    ),
                    
                    // Usage score (moved closer to Term)
                    Container(
                      width: 100,
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: Row(
                        children: [
                          Text(
                            'Usage score',
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              color: Colors.grey.shade700,
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(width: 4),
                          Icon(
                            Icons.sort,
                            size: 16,
                            color: Colors.grey.shade700,
                          ),
                        ],
                      ),
                    ),
                    
                    // Examples
                    Container(
                      width: 400,
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: Text(
                        'Examples',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: Colors.grey.shade700,
                          fontSize: 14,
                        ),
                      ),
                    ),
                    
                    // Do not translate
                    Container(
                      width: 150,
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: Center(
                        child: Text(
                          'Do not translate',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: Colors.blue.shade800,
                            fontSize: 14,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                    
                    // Case sensitive
                    Container(
                      width: 150,
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: Center(
                        child: Text(
                          'Case sensitive',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: Colors.blue.shade800,
                            fontSize: 14,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                    
                    // Actions
                    Container(
                      width: 200,
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: Center(
                        child: Text(
                          'Actions',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: Colors.grey.shade700,
                            fontSize: 14,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ],
                ),
                
                // Divider between header and content
                Divider(color: Colors.grey.shade300, height: 1),
                
                // Table content
                Container(
                  height: constraints.maxHeight - 70, // Account for header and margins
                  child: terms.isEmpty
                      ? Center(
                          child: Text(
                            'No AI suggestions to display',
                            style: TextStyle(
                              color: Colors.grey.shade600,
                              fontSize: 16,
                            ),
                          ),
                        )
                      : ListView.separated(
                          itemCount: terms.length,
                          separatorBuilder: (context, index) => Divider(
                            color: Colors.grey.shade200,
                            height: 1,
                          ),
                          itemBuilder: (context, index) {
                            final term = terms[index];
                            
                            return Padding(
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Checkbox for term selection
                                  Container(
                                    width: 40,
                                    child: Checkbox(
                                      value: false,
                                      onChanged: (value) {},
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                    ),
                                  ),
                                
                                  // Term
                                  Container(
                                    width: 120,
                                    child: Text(
                                      term.text,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ),
                                  
                                  // Usage score
                                  Container(
                                    width: 100,
                                    child: Text(
                                      '${term.usageScore.toInt()}',
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ),
                                  
                                  // Examples
                                  Container(
                                    width: 400,
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        const Text(
                                          'Select examples to include:',
                                          style: TextStyle(
                                            fontWeight: FontWeight.w500,
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
                                                          color: Colors.grey.shade600,
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
                                  
                                  // Do not translate
                                  Container(
                                    width: 150,
                                    child: Center(
                                      child: Switch(
                                        value: term.doNotTranslate,
                                        onChanged: (value) {
                                          final glossaryService = Provider.of<GlossaryService>(context, listen: false);
                                          final updatedTerm = term.copyWith(doNotTranslate: value);
                                          glossaryService.updateAISuggestion(updatedTerm);
                                          setState(() {});
                                        },
                                        activeColor: Colors.blue,
                                      ),
                                    ),
                                  ),
                                  
                                  // Case sensitive
                                  Container(
                                    width: 150,
                                    child: Center(
                                      child: Switch(
                                        value: term.caseSensitive,
                                        onChanged: (value) {
                                          final glossaryService = Provider.of<GlossaryService>(context, listen: false);
                                          final updatedTerm = term.copyWith(caseSensitive: value);
                                          glossaryService.updateAISuggestion(updatedTerm);
                                          setState(() {});
                                        },
                                        activeColor: Colors.blue,
                                      ),
                                    ),
                                  ),
                                  
                                  // Actions
                                  Container(
                                    width: 200,
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        // Reject button
                                        ElevatedButton(
                                          onPressed: () {
                                            // Handle reject action
                                            final glossaryService = Provider.of<GlossaryService>(context, listen: false);
                                            glossaryService.rejectAISuggestion(term);
                                          },
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: const Color(0xFFFFE8E8),
                                            foregroundColor: const Color(0xFFD32F2F),
                                            padding: const EdgeInsets.symmetric(horizontal: 12),
                                            minimumSize: const Size(80, 32),
                                            elevation: 0,
                                            textStyle: const TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                          child: const Text('Reject'),
                                        ),
                                        const SizedBox(width: 8),
                                        // Add button
                                        ElevatedButton(
                                          onPressed: () {
                                            // Handle add action
                                            final glossaryService = Provider.of<GlossaryService>(context, listen: false);
                                            glossaryService.acceptAISuggestion(term);
                                          },
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: const Color(0xFFE8F5E9),
                                            foregroundColor: const Color(0xFF388E3C),
                                            padding: const EdgeInsets.symmetric(horizontal: 12),
                                            minimumSize: const Size(80, 32),
                                            elevation: 0,
                                            textStyle: const TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                          child: const Text('Add'),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                ),
              ],
            ),
          ),
        );
      }
    );
  }
}