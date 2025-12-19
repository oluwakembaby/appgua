# Aqua Harmony: Design Language System (DLS)

## 1. Core Philosophy
**"Zen & Flow"**
The visual identity should feel immersive, calming, and aquatic. Interfaces should be clean, rounded, and unobtrusive, mimicking the softness of water.

---

## 2. Color Palette

### Primary Colors (The Ocean)
*   **Deep Blue (Background):** `#001F3F` (For main menus, outer edges)
*   **Teal (Accent/Water):** `#39CCCC` (For buttons, highlights)
*   **Aqua (Light):** `#7FDBFF` (For text, selection borders)

### Functional Colors (Feedback)
*   **Success (Harmony):** `#2ECC40` (Emerald Green - Used for the "Heart" icon and success states)
*   **Error (Dissonance):** `#FF4136` (Soft Red - Used for the "Storm Cloud" icon and invalid placement)
*   **Neutral (UI Elements):** `#DDDDDD` (Off-white for text on dark backgrounds)

### Gradients
*   **Water Gradient:** Linear Gradient from Top (`#001F3F`) to Bottom (`#0074D9`).

---

## 3. Typography

### Primary Font: **Fredoka** (Google Fonts)
*   **Why:** Rounded, bubbly, and friendly. Fits the casual puzzle genre perfectly.
*   **Usage:**
    *   **Titles:** Weight 600, Size 32sp (White/Aqua)
    *   **Buttons:** Weight 500, Size 20sp (White)
    *   **Body:** Weight 400, Size 16sp (Light Grey)

---

## 4. Iconography & Assets

### Indicators
*   **Green Heart:** A soft, bouncing heart icon. Appears when a rule is satisfied.
*   **Red Storm Cloud:** A small, jagged grey/red cloud. Appears when a rule is violated.

### UI Icons
*   **Settings:** Gear icon (rounded).
*   **Inventory:** Simple outlined box or bag.
*   **Navigation:** Rounded arrows.

---

## 5. UI Components

### Buttons
*   **Shape:** Pill-shaped (Rounded Stadium borders).
*   **Style:** Flat with a subtle shadow (Elevation 2).
*   **Interaction:** "Squish" effect on tap (Scale down to 0.95).

### Panels & Overlays
*   **Style:** "Glassmorphism" (Frosted Glass).
*   **Color:** White with 10-20% opacity.
*   **Blur:** `BackdropFilter` with blur sigma 5.0.
*   **Borders:** Thin white border (opacity 0.3).

### The Inventory Dock
*   **Location:** Bottom of screen.
*   **Appearance:** Semi-transparent dark bar.
*   **Items:** Displayed in circular slots.

---

## 6. Animations
*   **Transitions:** Fade through colors (300ms).
*   **Feedback:** Elastic "Pop" (Spring simulation) for hearts and placement.
*   **Idle:** Slow Sine Wave (breathing effect) for all UI elements.

