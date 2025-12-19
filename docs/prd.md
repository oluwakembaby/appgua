#Product Requirement Document (PRD)**Project Name:** Aqua Harmony: Zen Puzzle
**Platform:** Android (Google Play)
**Tech Stack:** Flutter (UI) + Flame Engine (Game Loop)
**Target Audience:** Casual gamers, Puzzle enthusiasts, All ages (Family Friendly)

---

##1. Executive Summary**Aqua Harmony** is a 2D spatial puzzle game where players arrange fish and decorations in an aquarium. Unlike a simulation, this is a logic game: players must place items to satisfy specific "social rules" (e.g., a shy fish must be near a plant; a predator must be far from small fish).

**Value Proposition:** A relaxing, non-violent puzzle experience that combines the aesthetic appeal of aquariums with satisfying logic problems.

---

##2. Core Gameplay Mechanics###2.1 The Game Loop1. **Setup:** Player enters a level with an empty tank and a "Inventory Bar" containing unplaced assets (fish/decor).
2. **Action:** Player drags assets from the Inventory Bar into the Tank (Flame Game Area).
3. **Validation:**
* As an item is held/placed, visual indicators show if its rules are met.
* **Green Heart:** Rule satisfied.
* **Red Storm Cloud:** Rule violated.


4. **Win Condition:** All items from the inventory are placed in the tank, and *all* items display the "Green Heart" status simultaneously.
5. **Transition:** A "Level Complete" overlay appears -> Next Level.

###2.2 Rules System (The Puzzle Logic)The core logic relies on **Proximity Checks** (Radius detection).

* **Attraction Rule:** Item A must be within X pixels of Item B. (e.g., *Clownfish needs Anemone*)
* **Repulsion Rule:** Item A must be at least Y pixels away from Item C. (e.g., *Goldfish dislikes Dirty Rock*)
* **Grouping Rule:** Item A must be within X pixels of another Item A. (e.g., *Schooling Neons*)

###2.3 Controls* **Input:** Single-finger touch.
* **Drag & Drop:** Touch to grab, drag to move, release to place.
* **Physics:** Zero gravity/top-down logic. Items stay exactly where placed (no falling).

---

##3. Technical Specifications###3.1 Architecture* **Framework:** Flutter 3.x
* **Game Engine:** Flame ^1.20.0
* **Dependencies:**
    * `flutter_animate` (UI Effects)
    * `google_fonts` (Typography)
    * `audioplayers` (Sound)
    * `shared_preferences` (Persistence)
* **Architecture Pattern:** Game Widget composition with Hybrid Input.
* `main.dart`: Standard Flutter entry point.
* `GameOverlay`: Flutter widget for HUD (Pause, Restart).
* `InventoryWidget`: Flutter widget overlaid at the bottom of the screen.
* `AquariumGame`: The `FlameGame` class extending `HasCollisionDetection`.
* **Input Strategy:** "Ghost Widget" Drag & Drop.
    * *Description:* User drags a Flutter Widget from the Inventory. A "ghost" follows the finger. On release, the Flutter coordinates are converted to Game World coordinates, and a Flame Component is spawned.

###3.2 Data Structure (Level Config)Levels should be defined in a JSON or constant Map structure to allow rapid creation without code changes.

```json
{
  "level_id": 1,
  "background": "bg_sandy.png",
  "inventory": [
    {"type": "neon_tetra", "count": 2},
    {"type": "plant_fern", "count": 1}
  ],
  "rules": {
    "neon_tetra": {"needs_nearby": "neon_tetra", "radius": 100}
  }
}

```

###3.3 State Management* Use a singleton or simple Provider for:
* `currentLevel`
* `isAudioMuted`
* `highestLevelUnlocked` (Persisted via `shared_preferences`)



---

##4. Visual & Audio Requirements###4.1 Asset List (Minimal Viable Product)**Sprites (2D Assets):**

* **Fish:**
1. *The Social Fish* (e.g., Neon Tetra - Needs friends).
2. *The Loner* (e.g., Betta - Needs space).
3. *The Hider* (e.g., Clownfish - Needs cover).


* **Decor:**
1. *Plant* (Safety object).
2. *Rock* (Neutral/Obstacle).


* **Backgrounds:** 2 static gradients or water textures (Blue, Teal).
* **UI Icons:** Green Heart (Happy), Red Cloud (Sad), Hand/Arrow (Tutorial).

###4.2 AnimationsTo ensure "Quality" perception by Google Play:

* **Idle Animation:** All fish sprites must use a simple `MoveEffect.by` (Sine wave) to bob up and down slightly, simulating floating.
* **Feedback Animation:** When a rule is met, the Green Heart should "pop" (scale up and down once).

###4.3 Audio* **BGM:** One looping "Underwater Zen" track.
* **SFX:**
* *Plop:* Item placed.
* *Success:* Chime when level is cleared.
* *Error:* Soft buzzer if player tries to place item outside bounds.



---

##5. User Interface (UI) Flow1. **Splash Screen:** Game Logo -> Loads Assets.
2. **Main Menu:**
* Title: "Aqua Harmony"
* Big "Play" Button.
* Small "Settings" Icon (Toggle Sound/Music).


3. **Level Select:** A simple grid of numbers (1-20). Locked levels are grayed out.
4. **Game Screen:**
* **Top Right:** Pause Button.
* **Center:** The Tank (Flame View).
* **Bottom:** Inventory Dock (Flutter Row).


5. **Win Screen:** 3-Star graphic (based on speed or just completion) -> "Next Level" button.

---

##6. Scope & Timeline StrategyTo ensure delivery in **1 Week**:

* **Day 1: Project Setup.** Flutter/Flame init. Drag and Drop physics implementation.
* **Day 2: The Logic Engine.** Implement the `checkProximity()` function in the game loop.
* **Day 3: Assets & Feedback.** Import sprites. Add the Heart/Cloud visual feedback system.
* **Day 4: Level Design.** Define JSON for 15 levels. (Levels 1-3 are tutorials).
* **Day 5: UI Wrapper.** Build Main Menu, Inventory bar, and Win screens in Flutter.
* **Day 6: Polish.** Add sound, particle effects (bubbles), and app icon.
* **Day 7: Build & Submit.** Release APK, take screenshots, write store description.

---

##7. Safety & Compliance (Google Play)* **Content Rating:** PEGI 3 / "E for Everyone".
* *Note:* Ensure no "dead fish" sprites. Failure state is "unhappy," not death.


* **Data Safety:** The app will not collect user data (No login required).
* **Ad Policy:** If Ads are used (optional), mark the app as "Contains Ads" in the manifest.

##8. Definition of Done (DoD)1. App runs on Android Emulator and Physical Device without crashing.
2. Drag and Drop works smoothly near screen edges.
3. 15 Playable Levels with increasing difficulty.
4. Win state triggers reliably only when rules are met.
5. App Icon and Loading Screen are implemented.