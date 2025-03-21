---
layout:	post
title:	"WIP: Converting Chess Games to Animated Gifs on Android"
date:	2025-03-21
---

## Introduction

When building the **PgnToGif** Android application, I wanted to create a seamless way to convert chess games stored in PGN (Portable Game Notation) format into animated GIFs. This would allow players and enthusiasts to share game replays in a lightweight, universally supported format.

In this post, I’ll walk through how I built the app, the key technical challenges, and how the different components work together. The code for this project is available on [GitHub](https://github.com/Oziomajnr/PgnToGif), and you can try out the app on [Google Play](https://play.google.com/store/apps/details?id=com.chunkymonkey.imagetogifconverter).

## Understanding PGN (Portable Game Notation)

PGN is a widely used format for recording chess games. A typical PGN file contains:

1. **Tag Pairs (Metadata about the game):**
```pgn
[Event "World Championship Match"]
[Site "London, England"]
[Date "2000.10.12"]
[White "Kasparov, Garry"]
[Black "Kramnik, Vladimir"]
[Result "1/2-1/2"]
```

2. **Movetext (The actual moves played):**
```pgn
1. e4 e5 2. Nf3 Nc6 3. Bb5 a6 4. Ba4 Nf6
```

### PGN Parsing in the Application

To process PGN files in the app, I used the `bhlangonijr` chess library, which allows efficient parsing and handling of chess moves. Here’s how a PGN file is loaded:

```kotlin
val pgn = PgnHolder(pgnFile.absolutePath)
pgn.loadPgn()
val game = pgn.games.firstOrNull()
```

The method `processPgnFile()` in [`HomePresenterImpl.kt`](https://github.com/Oziomajnr/PgnToGif/blob/main/app/src/main/java/com/chunkymonkey/pgntogifconverter/ui/home/HomePresenterImpl.kt) is responsible for handling PGN parsing. It follows these steps:

1. Reads the PGN file from storage.
2. Extracts metadata and moves.
3. Generates a sequence of board positions for each move.
4. Prepares data for image conversion.

## Converting Chess Positions to Images

### Board Representation

Each chess position needs to be converted into a visual board representation. The app follows a standard coordinate system:

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

### Converting Board to Bitmap

The class [`ChessBoardToBitmapConverter.kt`](https://github.com/Oziomajnr/PgnToGif/blob/main/app/src/main/java/com/chunkymonkey/pgntogifconverter/converter/ChessBoardToBitmapConverter.kt) is responsible for rendering the board as an image. It:

1. Creates a blank `Bitmap`.
2. Draws the board squares.
3. Places chess pieces in the correct positions.
4. Highlights moves and check positions.

Example code snippet:

```kotlin
val bitmap = Bitmap.createBitmap(boardSize, boardSize, Bitmap.Config.ARGB_8888)
val canvas = Canvas(bitmap)
```

### Rendering Pieces

Piece images are managed by [`ChessPieceResourceProvider.kt`](https://github.com/Oziomajnr/PgnToGif/blob/main/app/src/main/java/com/chunkymonkey/pgntogifconverter/resource/ChessPieceResourceProvider.kt), which:

- Maps piece types to drawable resources.
- Converts piece images to correctly scaled bitmaps.
- Supports multiple piece styles.

## Creating the Animated GIF

### GIF Format Overview

GIFs are well-suited for animating chess moves because they support:
- Multiple frames with different delays.
- Transparency.
- Lossless compression.

### Encoding the GIF

The [`AnimatedGifEncoder.java`](https://github.com/Oziomajnr/PgnToGif/blob/main/app/src/main/java/com/chunkymonkey/pgntogifconverter/util/AnimatedGifEncoder.java) class handles GIF creation by:

1. Initializing parameters:
```kotlin
encoder.setSize(bitmapWidth, bitmapHeight)
encoder.setDelay((settingsData.moveDelay * 1000).roundToInt())
encoder.setRepeat(1)
encoder.setQuality(7)
```

2. Iterating through moves:
 - Updating the board position.
 - Converting the board to a `Bitmap`.
 - Adding the frame to the GIF.

### The Complete Process

The following diagram illustrates the conversion workflow:

```mermaid
graph TD
    A[PGN File] --> B[Parse PGN]
    B --> C[Generate Board States]
    C --> D[For Each Move]
    D --> E[Render Board as Bitmap]
    E --> F[Add Frame to GIF]
    F --> G{Last Move?}
    G -->|No| D
    G -->|Yes| H[Save GIF File]
```

## Additional Features

### Player Name Overlays

The app allows adding player names on the final GIF by:
1. Generating text bitmaps.
2. Overlaying them onto the board image.

### Board Flipping

Users can choose to view the board from White's or Black's perspective, adjusting the piece positions accordingly.

## Lessons Learned & Performance Optimizations

### Handling Large PGN Files

Parsing large PGN files efficiently was crucial. To optimize:
- Only the selected game is loaded into memory.
- Lazy evaluation is used to generate bitmaps on demand.

### Bitmap Memory Optimization

Since each move generates a new bitmap, memory usage was a concern. Improvements included:
- Reusing `Canvas` objects where possible.
- Using lower resolution bitmaps when needed.
- Compressing the GIF with adjustable quality settings.

## Conclusion

The **PgnToGif** project was a great learning experience in:
- Parsing PGN files and handling chess game logic.
- Rendering chess positions dynamically.
- Encoding animated GIFs efficiently.
- Optimizing Android UI and memory usage.

The modular design allows easy customization and expansion. Future enhancements could include:
- More styling options for boards and pieces.
- Alternative animation formats (e.g., MP4).
- PGN editing within the app.

You can check out the full source code on [GitHub](https://github.com/Oziomajnr/PgnToGif) and download the app from [Google Play](https://play.google.com/store/apps/details?id=com.chunkymonkey.imagetogifconverter).