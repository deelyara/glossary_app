# Glossary App - Frontend Implementation Notes

## Overview
This is a prototype for a glossary management application. The current implementation focuses on demonstrating the UI/UX flow, with some features implemented as placeholders.

## Key UI Components

### 1. Glossary Management
- Dropdown for glossary selection
- "Manage glossaries" dropdown with options (non-functional placeholders):
  - Create new glossary
  - View all glossaries

### 2. Term Management
- Main terms table with:
  - Term, translation, and examples
  - No source location (only for AI suggestions)
  - No "Do not translate" or "Case sensitive" options
- AI suggestions table with:
  - Term, translation, examples, and source location
  - Accept/Reject actions

### 3. AI Detection Flow
- First run: Shows banner with results
- Subsequent runs: Directly shows suggestions in table
- Empty state shows "Detect terms" button

## UI Issues to Fix

1. **Empty State Container**
   - The "Detect terms" button container in empty state is too wide
   - Should match the width of empty glossary state container

2. **AI Detection Banner**
   - Banner positioning needs to be closer to the table
   - Current implementation has spacing limitations

3. **Known Issues**
   - RangeError when adding examples in regular terms table
   - Source location should only appear in AI suggestions table

## Implementation Notes
- Most buttons are non-functional placeholders
- Focus on UI layout and component structure
- Maintain consistent spacing and container widths
- Follow the provided design for empty states and banners

## Next Steps
1. Fix empty state container width
2. Adjust AI detection banner positioning
3. Implement proper example handling in terms table
4. Remove source location from regular terms table
