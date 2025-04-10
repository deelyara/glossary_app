# Project Description: Glossary App

## 1. Project Overview

**Purpose:** To build a glossary application as a new product for a translation service. The app will help users identify, manage, and eventually translate key terms from their digital content (starting with websites).

**Initial Core Flow:**
1. User starts mock AI scan of their website.
2. An AI service scans the website content.
3. The app detects and presents potential glossary terms found on the site.
4. User can accept and rejectt the suggested glossary terms.

## 2. Technical Stack & Architecture

*   **Framework:** Flutter (SDK version ^3.7.2)
*   **Language:** Dart
*   **State Management:** `provider`
*   **UI & Theming:**
    *   Material Design 3 (via `uses-material-design: true` and likely `flex_color_scheme`)
    *   Custom typography with `google_fonts`
    *   Animations via `flutter_animate`
    *   Responsiveness handled by `responsive_framework`
*   **Architecture:** Modular structure within the `lib/` directory:
    *   `main.dart`: App entry point.
    *   `app.dart`: Root application widget (likely setting up theme, routing).
    *   `config/`: Configuration files (themes, constants).
    *   `models/`: Data structures.
    *   `screens/` (or `pages`/`views`): UI screens for different parts of the app.
    *   `services/`: Business logic, API interactions (e.g., AI scanning).
    *   `widgets/`: Reusable UI components.
*   **Internationalization:** `intl` package included, suggesting future multi-language support within the app itself.

## 3. Design & UX Principles

**Guiding Philosophy:** Deliver a best-in-class user experience with a strong focus on clarity, ease of use, and aesthetic appeal.

**Key Pillars:**
*   **Visual Hierarchy:** Ensure clear structure and prioritization of elements on each screen. Important information and actions should be immediately apparent.
*   **Typography:** Utilize `google_fonts` effectively for readability and brand consistency. Maintain perfect typographic standards (scale, weight, line height).
*   **Consistency:** Maintain uniform design patterns, component behavior, and terminology throughout the app. Adhere strictly to Material Design 3 guidelines unless a deviation significantly improves UX.
*   **Interaction Design:** Focus on smooth, intuitive interactions. Use `flutter_animate` thoughtfully to provide meaningful feedback and enhance the user journey without being distracting.
*   **Responsiveness:** Ensure a seamless experience across different screen sizes and platforms using `responsive_framework`.

## 4. Development Guidelines (for LLM Agents)

*   **Prioritize UX:** When implementing features or making changes, always consider the impact on the user experience principles outlined above.
*   **Follow Structure:** Adhere to the existing project structure (`lib/` subdirectories). Place new components, services, models, etc., in their appropriate locations.
*   **Leverage Existing Packages:** Utilize the capabilities of installed packages (`provider`, `flex_color_scheme`, `flutter_animate`, etc.) before introducing new dependencies.
*   **Material 3:** Implement UI components following Material Design 3 guidelines and best practices.
*   **Code Clarity:** Write clean, readable, and well-commented Dart code.

## 5. Current Status

*   Initial Flutter project structure created.
*   Core dependencies added (`provider`, `flex_color_scheme`, `google_fonts`, etc.).
*   Basic app setup (`main.dart`, `app.dart`) likely exists.
*   No application-specific features (like website scanning or term display) have been implemented yet.

This document should be updated as the project evolves. 