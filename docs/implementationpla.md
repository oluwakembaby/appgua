We will split the work into **Track A (The Engine/Flame)** and **Track B (The App/Flutter)**.

---

###**Phase 0: Foundation & Setup (Day 1 - Morning)****Goal:** A running "Hello World" project on both developers' machines with the folder structure and assets ready.

* **Joint Tasks:**
1. **Initialize Project:** `flutter create aqua_harmony`.
2. **Add Dependencies (`pubspec.yaml`):**
* `flame: ^1.20.0` (Game Engine)
* `google_fonts: ^6.1.0` (Typography)
* `audioplayers: ^5.1.0` (Sound)
* `flutter_animate: ^4.2.0` (UI animations)
* `shared_preferences` (Save progress)


3. **Folder Structure:**
```text
lib/
├── game/           # All Flame logic
│   ├── components/ # Fish, Decor, Background
│   ├── logic/      # Rules engine
│   └── aqua_game.dart
├── ui/             # All Flutter Widgets
│   ├── overlays/   # Inventory, HUD, Pause Menu
│   ├── screens/    # Main Menu, Level Select
│   └── theme/      # app_theme.dart (The Design Language)
├── data/           # Level JSON files
└── main.dart

```


4. **Asset Import:** Create `assets/images/` and `assets/audio/`. Add placeholder squares if real art isn't ready.



---

###**Phase 1: The Core Loop (Day 1 Afternoon - Day 2)****Goal:** A playable "Toy." You can drag an item from a UI overlay into the game world, and it stays there.

| **Track A: Flame Developer (Game)** | **Track B: Flutter Developer (UI)** |
| --- | --- |
| **1. Game Class:** Set up `AquaGame` extending `FlameGame` with `HasCollisionDetection` and `HasDraggables`. | **1. Theme Setup:** Implement `app_theme.dart` using the **Deep Ocean Blue** and **Teal** palette from the DLS. |
| **2. Background:** Render the static background sprite. | **2. Main Wrapper:** Build the `GameScreen` scaffold. Place the `GameWidget` in the center and a **transparent Flutter Overlay** on top for the UI. |
| **3. Draggable Component:** Create a `DraggableSpriteComponent`. Logic: When touched, it scales up slightly. When released, it stays at the new `position`. | **3. Inventory UI:** Build a horizontal `ListView` at the bottom of the screen. This is the "Dock." |
| **4. Coordinate System:** **CRITICAL TASK.** Ensure that when Dev B drags an item from the Flutter UI and drops it, it instantiates a Flame Component at the correct Vector2 coordinate in the game world. | **4. Main Menu:** Build the Start Screen using the "Deep Ocean" colors and "Fredoka" font. |

---

###**Phase 2: The Puzzle Logic (Day 3)****Goal:** The game knows "Rules." It can tell if a fish is happy or sad based on what is near it.

| **Track A: Flame Developer (Logic)** | **Track B: Flutter Developer (Data)** |
| --- | --- |
| **1. The Rule Engine:** Create a function `checkHarmony()`. Loop through all placed components. Check `distanceTo` between them. | **1. Level Data Structure:** Define the JSON format. Create `level_1.json` through `level_5.json`. |
| **2. State Management:** Add a `MoodState` to the Fish component (Happy/Sad). Change the sprite tint or overlay an icon based on the state. | **2. Asset Sourcing:** Finalize the 5 fish types and 3 decor types. Ensure they are transparent PNGs. |
| **3. Proximity Logic:** <br><br>`if (fish.position.distanceTo(plant.position) < 100) { fish.isHappy = true; }` | **3. Level Select Screen:** Build the GridView. Handle logic: "If Level 1 is won, unlock Level 2." |
| **4. Visual Feedback:** Add the Green Heart / Red Cloud icons that appear above the fish. | **4. Save System:** Implement `Provider` for state and `SharedPreferences` to store `highestLevelUnlocked`. |

---

###**Phase 3: Game Flow & Content (Day 4)****Goal:** A full game loop. Start Level -> Play -> Win -> Next Level.

| **Track A: Flame Developer (Flow)** | **Track B: Flutter Developer (Design)** |
| --- | --- |
| **1. Level Loading:** Write a parser that reads Dev B's JSON and instantiates the correct sprites at the start of the game. | **1. Level Design:** **Paper Prototyping.** Draw out 15 puzzles. Ensure they get progressively harder. |
| **2. Win Condition:** In the `update()` loop: `if (inventory.isEmpty && allFish.areHappy) { triggerWin(); }` | **2. Win Overlay:** Create a beautiful "Level Complete" modal with a "Next Level" button and 3 stars. |
| **3. Clean Up:** Ensure `game.remove(component)` works correctly so the game doesn't crash when restarting a level. | **3. Tutorial:** For Level 1, add a simple "Hand Animation" overlay in Flutter showing the user how to drag. |

---

###**Phase 4: Juice & Polish (Day 5 - Day 6)****Goal:** Make it feel expensive. This is what gets you Google Play approval.

* **Joint Tasks:**
1. **Fish Animation:** (Dev A) Add a `MoveEffect.by` on a loop (Sine wave) so fish gently bob up and down. They shouldn't look like stickers.
2. **Particles:** (Dev A) When the level is won, spawn `BubbleParticles` that float up from the bottom.
3. **Audio:** (Dev B) Integrate `audioplayers`.
    * Ambient Water loop (Volume: 0.3).
    * "Pop" sound on drop.
    * "Chime" sound on Win.

4. **Haptics:** (Dev B) Add `HapticFeedback.lightImpact()` when an item is placed.

---

###**Critical Path / Risks**1. **The Drag & Drop Handoff (Flutter to Flame):**
* *Risk:* Dragging an item from a Flutter ListView (UI) into a Flame Game (Canvas) is tricky.
* *Solution:* Do not actually "drag" the Flutter widget into the Flame game.
* *Logic:* When the user *starts* dragging a Flutter list item, show a "Ghost" widget following their finger. When they *drop* it (onRelease), calculate the screen coordinates, convert them to Game World coordinates, and **spawn** a Flame Component at that spot.


2. **Screen Sizes:**
* *Risk:* The tank looks different on a tablet vs a phone.
* *Solution:* Use `CameraComponent.withFixedResolution(width: 360, height: 640)` in Flame to ensure the logic works the same on all devices.