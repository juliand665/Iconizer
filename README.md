# Iconizer

A pure SwiftUI app for generating icon sets given a single artwork image, PNG or PDF (recommended).

Simply drag your image into the app, or select one using the file browser. Select the export options you want, check that everything's working as intended in the preview, and hit export.

All chosen export options (even combinations between iOS and macOS) are combined into a single .appiconset folder, which you place where you need it (e.g. replacing the one in your project's .xcassets folder).

## Export Options

### macOS

Either just downsamples your artwork to the correct sizes, or additionally applies the mask and shadow (on a per-size basis) from Apple's template.

### iOS/iPadOS

Exports all iPhone and iPad sizes, as well as the 512×512@2x App Store artwork.

