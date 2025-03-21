---
layout:	post
title:	"WIP: Converting Chess Games to Animated Gifs on Android"
date:	2025-03-21
---

## Introduction

The **PgnToGif** Android app was created to help chess players and fans convert PGN (Portable Game Notation) files into animated GIFs. This allows users to share their games as short animations without needing special chess software. The project involved solving several technical challenges, such as reading PGN files, drawing chess boards, creating images, and making smooth GIF animations.

This article explains the development process, key challenges, and how they were overcome. It also covers performance improvements and design choices that made the app run efficiently. You can find the full source code on [GitHub](https://github.com/Oziomajnr/PgnToGif) and download the app from [Google Play](https://play.google.com/store/apps/details?id=com.chunkymonkey.imagetogifconverter).

## What is PGN (Portable Game Notation)?

PGN is a standard format for recording chess games. A PGN file consists of:

1. **Game Information (Metadata):**

```pgn
[Event "World Championship Match"]
[Site "London, England"]
[Date "2000.10.12"]
[White "Kasparov, Garry"]
[Black "Kramnik, Vladimir"]
[Result "1/2-1/2"]
```

2. **Move List:**

```pgn
1. e4 e5 2. Nf3 Nc6 3. Bb5 a6 4. Ba4 Nf6
```

### How the App Reads PGN Files

To handle PGN files, the app uses the `bhlangonijr` chess library. Here’s how it loads a PGN file:

```kotlin
val pgn = PgnHolder(pgnFile.absolutePath)
pgn.loadPgn()
val game = pgn.games.firstOrNull()
```

The function `processPgnFile()` in [`HomePresenterImpl.kt`](https://github.com/Oziomajnr/PgnToGif/blob/main/app/src/main/java/com/chunkymonkey/pgntogifconverter/ui/home/HomePresenterImpl.kt) follows these steps:

1. Reads the PGN file.
2. Extracts game details and moves.
3. Creates a list of board positions for each move.
4. Prepares the data for display.
5. Handles errors for incorrect PGN files.
6. Improves efficiency by processing moves quickly.
7. Supports different PGN formats.
8. Uses memory-saving techniques for large PGN files.
9. Provides user feedback when errors occur.

## Drawing the Chess Board

### Board Setup

Each chess position is displayed as a board with coordinates:

```
   A  B  C  D  E  F  G  H
8  r  n  b  q  k  b  n  r
7  p  p  p  p  p  p  p  p
6  .  .  .  .  .  .  .  .
5  .  .  .  .  .  .  .  .
4  .  .  .  .  .  .  .  .
3  .  .  .  .  .  .  .  .
2  P  P  P  P  P  P  P  P
1  R  N  B  Q  K  B  N  R
```

### Converting a Board Position to an Image

The class [`ChessBoardToBitmapConverter.kt`](https://github.com/Oziomajnr/PgnToGif/blob/main/app/src/main/java/com/chunkymonkey/pgntogifconverter/converter/ChessBoardToBitmapConverter.kt) handles turning board positions into images. It does the following:

1. Creates a blank image (`Bitmap`).
2. Draws the chessboard and pieces.
3. Highlights moves and check positions.
4. Allows users to change themes and colors.
5. Adds shading for better visibility.
6. Optimizes rendering for smooth animations.
7. Saves images in memory to avoid repeated calculations.

Example:

```kotlin
val bitmap = Bitmap.createBitmap(boardSize, boardSize, Bitmap.Config.ARGB_8888)
val canvas = Canvas(bitmap)
```

## Making an Animated GIF

### Why Use GIFs?

GIFs are a great format for chess animations because they:

- Support multiple frames with time delays.
- Allow transparency.
- Have small file sizes for easy sharing.
- Work on almost all platforms.

### Encoding the GIF

The class [`AnimatedGifEncoder.java`](https://github.com/Oziomajnr/PgnToGif/blob/main/app/src/main/java/com/chunkymonkey/pgntogifconverter/util/AnimatedGifEncoder.java) is responsible for creating GIFs. Here’s how it works:

1. Sets up the GIF settings:

```kotlin
encoder.setSize(bitmapWidth, bitmapHeight)
encoder.setDelay((settingsData.moveDelay * 1000).roundToInt())
encoder.setRepeat(1)
encoder.setQuality(7)
```

2. Processes each move:
    - Updates the board for the next move.
    - Turns the board into an image.
    - Adds the image to the GIF.
    - Adjusts the speed of the animation.
    - Compresses the GIF to reduce file size.

## Improving Performance

### Handling Large PGN Files

For big PGN files, these techniques improve speed and efficiency:

- Loads only the active game into memory.
- Uses lazy loading for image generation.
- Runs processes on multiple threads.
- Caches previously rendered positions.
- Reduces unnecessary calculations.
- Detects errors in PGN files early.

### Optimizing Memory Usage

Since every move generates a new frame, memory management is important. These optimizations were applied:

- Reuses `Canvas` objects to prevent extra memory use.
- Uses lower-quality images when possible.
- Compresses GIFs based on user settings.
- Runs heavy processing tasks in the background.
- Monitors memory usage to find and fix slowdowns.

## Conclusion

Developing **PgnToGif** involved:

- Efficiently reading and processing PGN files.
- Creating dynamic chessboard images.
- Making smooth and optimized GIFs.
- Improving memory and performance on Android devices.
- Allowing users to customize their animations.

Future updates could include:

- More board and piece styles.
- Support for MP4 video output.
- An in-app PGN editor.
- Cloud storage for GIFs.
- AI-based move analysis.

Check out the full source code on [GitHub](https://github.com/Oziomajnr/PgnToGif) and download the app on [Google Play](https://play.google.com/store/apps/details?id=com.chunkymonkey.imagetogifconverter).

