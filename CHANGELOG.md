<!-- Copyright 2019 The FlutterCandies author. All rights reserved.
Use of this source code is governed by an Apache license
that can be found in the LICENSE file. -->

# Changelog

## 7.2.0

### New features

- Separate `AssetPickerDelegate` (#315),
  which provides the ability to override methods within the `AssetPicker`.

### Improvements

- Improve `specialItemBuilder`. (#314)

## 7.1.2

### Fixes

- Fix context usages for inherited theme data.
- Fix unlinked path name builder.

### Improvements

- Update how paths get update. (#312)
- Expose `DefaultAssetPickerProvider.forTest`.

## 7.1.1

### Fixes

- Fix `selectPredicate` with the viewer. (#307)

## 7.1.0

### New features

- Add `PathNameBuilder`. (#303)
- Add `LimitedPermissionOverlayPredicate`. (#287)

## 7.0.5

### Improvements

- Support compile on the Web. (#273)

## 7.0.4

### Improvements

- Make all text delegates const.

## 7.0.3

### Fixes

- Fix the broken semantics on iOS/macOS. (#272)

## 7.0.2

### Fixes

- Fix wrong conditions judging when obtaining path thumbnails.

## 7.0.1

### Improvements

- Support semantics with Japanese text delegates. (#266).

### Fixes

- Obtain the path thumbnail only when asset is image or video.

## 7.0.0

To know more about breaking changes, see [Migration Guide][].

### New features

- Support predictable special item display. (#264)
- Support live photos display. (#251)
- Expose `AssetPickerPageRoute` for customization. (#248)
- Add full semantics support. (#232, #235, #240, #242, #243, #245, #254)

### Improvements

- Improve scaling with select indicators and numbers.
- Implement the default light theme. (#234)

### Fixes

- Fix `LocallyAvailableBuilder` with more edge conditions. (#263)
- Fix potentially "No elements" error with thumbnails.

## 6.3.1

- Improve image type determine when resolving image data.This mostly resolved the occasionally HEIC loading issue when
  apps are running under the release mode.

## 6.3.0

- Support for Flutter 2.8.0, also drop supports for Flutter below 2.8.0.

## 6.2.4

- Improve audio item layout.
- Improve workflows.
- Indicate path getter more precisely.
- Improve Arabic text delegate.

## 6.2.3

- Pass through `selectPredicate` to `AssetPickerViewer`. (#211)
- Bump sdk constraints (since 6.2.1).

## 6.2.2

- Use `.contentUri` for video preview only on Android.

## 6.2.1

- Migrate to `extended_image` 5.x.
- Use `.contentUri` constructor for `VideoPlayerController`.

## 6.2.0

- Introduce `shouldRevertGrid` to determine whether the assets grid should be reverted.
- Upgrade `photo_manager` to resolve issues against `AssetEntity`s comparison.

## 6.1.2

- Fix limited resources refresh issue.
- Update callers to avoid deprecated usage.

## 6.1.1

- Handle iCloud video more gracefully.

## 6.1.0

- Introduce `selectPredicate` to predicate asset when picking.

## 6.0.6

- Use the correct index reference with `selectedBackdrop`. (#195)

## 6.0.5

- Upgrade dependencies.

## 6.0.4

- Add French language text delegate. (Thanks to @didiosn)
- Export "Nothing here." as a field to text delegate. (#190)
- Fix selected backdrop not synced all the time.
- Improve the instructions for the example.

## 6.0.3

- Fix path entity nullable issues with the asset grid.
- Fix assets displaying condition missing with the iOS layout.

## 6.0.2

- Expose `shouldReversePreview` for `AssetPickerViewerBuilderDelegate`.

## 6.0.1

- Improve total count calculation with `AssetPathEntity`. (#187)
- Obtain `AssetPathEntity.isAll` fix from `photo_manager`.
- Documents update.

## 6.0.0

### New features

- Sync all UI details from WeChat 8.x.
- Integrate iCloud progress overview in previews.
- Change the permission from the app settings when it's limited.
- Request more assets on iOS when the permission is limited.
- Fit the assets' grid's layout as the iOS `Photos` app (reverted and started from the bottom).
- Add Arabic language text delegate.
- Allow using `AssetPicker` and `AssetPickerViewer` directly with delegates.
- Add `keepScrollOffset` feature for the `AssetPickerBuilderDelegate`.

### Improvements

- Items that being banned from select (reached max assets or type conflict)
  will have a stronger color cover to indicate.
- Video preview in the [SpecialPickerType.wechatMoment] is completely different from other previews.
- Grid items has removed fade builder for more straight feedback after it gets loaded.
- Better interaction when jumping between previewing assets.
- Path entities list layout structure performance & structure improved.
- More precise thumbnail's option for iOS.
- Improve text scale handling. (#177)
- Reduce font size for couple texts.

To know more about breaking changes, see [Migration Guide][].

## 5.5.8

- Fix the viewer's select button issue with WeChat Moment on Android.

## 5.5.7

- Make `switchPath` method in `AssetPickerProvider` async.

## 5.5.6

- Add Japanese language text delegate. (Thanks to @KosukeSaigusa)
- Fix video judge condition with WeChat Moment mode.
- Fix wrong position for the confirm button on iOS with WeChat Moment mode.

## 5.5.5

- Migrate permissions check to the new API in `photo_manager`.

## 5.5.4

- Fix assets reduced under the WeChat Moment mode when previewing.

## 5.5.3+1

- Fix static analysis issue.

## 5.5.3

- Use `SystemUiOverlayStyle` from the provided theme first.

## 5.5.2

- Add German language text delegate. (Thanks to @Letalus)
- Add Russian language text delegate. (Thanks to @greymag)

## 5.5.1

- Implement `RenderToggleable` to support other channels of flutter (2.1.x - 2.3.x). (Thanks to @Letalus)

## 5.5.0

- Add `findChildIndexBuilder` to indicates grid find reusable `RenderObject`.
- Fix padding issue for the assets' grid.

## 5.4.3

- Fix missing `ScrollController` in the scroll view.

## 5.4.2

- Split `AssetGridItemBuidler` to solve the rebuild issue.
- Fix GIF indicator stretched issue.

## 5.4.1

- Export `AssetPickerPageRoute`.

## 5.4.0+1

- Fix format that pub.dev suggest.

## 5.4.0

- Fully support RTL languages.
- Add control for root navigator.
- Improve `AssetEntityImageProvider`'s constructor and decode.
- Grab iOS/macOS thumbnail's size fix from `photo_manager`.

## 5.3.0

- Add `gridThumbSize` to control thumbnails in the select grid.
- Applies a further fix to the WeChat Moment video preview.
- Fix unlimited assets choose in preview mode.

## 5.2.1

- Fix WeChat Moment preview issue.

## 5.2.0

- Add `SpecialPickerType.noPreview` to disable the preview when picking. (Thanks to @yanivshaked)

## 5.1.4

- Add Hebrew language text delegate. (Thanks to @yanivshaked)
- Fix slide page route issue when integrate with the `get` package.

## 5.1.3

- Fix not synced issue when the picker is under single pick mode.

## 5.1.2

- Fix selected assets not sync between thumbnail preview mode and grid view.
- Fix wrong index displays in thumbnail preview mode.
- Dependencies upgrade roll.

## 5.1.1

- Integrate `lastModified` to sort path entities by default.

## 5.1.0

- Reset to the top for the asset grid view after switching path.
- Add ability to select assets in any position of the picker.
- Implement mime type for image type judgement.
- Fix disappeared GIFs indicator.

## 5.0.5

- Fix force cast null type issue with WeChat moment special pick type.
- Improve app bar's type definition.

## 5.0.4

- Fix path thumb data's display issue.
- Fix default preview thumb size issue with image preview builder.

## 5.0.3

- Remove required annotation for selected assets.

## 5.0.2

- Fix wrong viewer provider state.
- Enhance page stream controller sink close.
- Fix `dartdoc` generate issue for pub.

## 5.0.1

- Fix video indicator layout issue.
- Prevent video select in WeChat moment mode for edge cases.
- Pickup fixes from `photo_manager`.

## 5.0.0

- Add ability to show the special item when the device has no assets.
- Allow users build their own picker with custom assets types. (See example for custom delegate.)
- Slightly reduce performance consume with layout.

### Breaking changes

- Migrate to non-nullable by default.
- `CustomItemBuilder` -> `SpecialItemBuilder`, `CustomItemPosition` -> `SpecialItemPosition` .
- Abstract `AssetPickerBuilderDelegate<A, P>`, `AssetPickerViewerBuilderDelegate<A, P>`,
  `AssetPickerProvider<A, P>`, and minify the `AssetPickerViewerProvider<A>`. Support custom types by generic type.
- The `assets` param in `AssetPickerViewer.pushToViewer` is now `previewAssets` .

## 4.2.2

- Suppress deprecated usage in example.
- Improve code format with dart format.
- Raise dependencies version.

## 4.2.1

- Fix arguments judging condition with preview thumb size.
- Remove common exports and split out constants.

## 4.2.0

- Add `previewThumbSize` for the viewer.

## 4.1.0+4

- Upgrade `extended_image` .

## 4.1.0+3

- Make widgets constant.
- Remove system ui overlays update.
- Migrate files to compatible with Flutter `1.20.0` .
- Sync analysis options.

## 4.1.0+2

- Ignore size constraint for image assets.
- Format code using `dartfmt`.
- Upgrade `photo_manager`.

## 4.1.0+1

- Adjust AppleOS layout.

## 4.1.0

- Add backdrop widget in the picker, which makes the picker more like the one in WeChat.

## 4.0.0

- Drop `asset_audio_player` .
- Experimenting status bar hidden on iOS.
- Remove video player listener before pause.

### Breaking changes

- `TextDelegate` -> `AssetsPickerTextDelegate` .

## 3.0.0+1

- Constraint dependencies version.

## 3.0.0

- Add `FilterOptionGroup`. Fix #41 .
- Add `SpecialPickerType`. Fix #37 .
- Add custom item build mode. Fix #39 .

## 2.2.1

- Introduce `ColorScheme` for theme details. Fixed #32 .
- Enhance RTL compatibility.
- Enlarge select indicator's size. Related to #33 .

## 2.2.0+2

- Remove path entity properties refresh.

## 2.2.0+1

- Fix preview widget for audio assets in picker viewer.

## 2.2.0

- A brand new example.
- Add `SortPathDelegate`.
- Using zoom page transition for viewer.
- Slightly add padding to viewer's assets list view.
- Migrate elevation and color to material rendering.
- Request thumb only when request type is not audio.
- Force request title for audio type asset.
- Expose `AssetType` enum.
- Fix issue with request type.

## 2.1.0

- Add present english text delegate.
- Refactored theme constructor and getter with theme capability #22 .
- Update color scheme usage for assets grid #23 .
- Update picker viewer style for apple OS.
- Fix bottom bar disappearing on apple os when it's single asset mode.

## 2.0.2

- Fix audio paused accidentally when the app is launching on Android #18 .

## 2.0.1

- Expose observe register methods.

## 2.0.0

- Support audio assets.
- Support single asset mode.
- Enlarge preview button's detector area size.
- Fix wrong properties' usage causing infinite build when the page reaches the end.

### Breaking changes

- `videoIndicatorBuilder` -> `durationIndicatorBuilder`.

## 1.7.0

- Hide detail display when video start to play.
- Switch to `ExtendedImageGesturePageView`. Fix #16 .
- Add fully theme support.
- Add MacOS support.
- Add delay for the first init method to prevent stuck in page routing. Fix #13 .
- Update widgets style on iOS. Fix #14 .
- Fix state of the example not updated after the result was returned without input method activated.

## 1.6.0

- Support HEIC/HEIF image type.

## 1.5.0+1

- Upgrade `photo_manager` to `0.5.1`.
- Replace deprecate `TextTheme.title` API usage.
- Document (dartdoc) update.

## 1.5.0

- Bumping flutter sdk minimum version to `1.17.0`.
- Declare API stability and compatibility with 1.0.0
  ( more details at: https://github.com/flutter/flutter/wiki/Package-migration-to-1.0.0 ).

## 1.4.1

- Remove loading indicator for image widget.
- Refactor video page's initialization for ratio update.
- Using constants to store text delegate.
- Add error catching for main methods.
- Update text delegate management.

## 1.4.0+1

- Fix call on null with `currentlySelectedAssets`.

## 1.4.0

- Support paging assets load.
- Fix selected assets not synced with picker provider.
- Bump `photo_manager` to `0.5.1-dev.5`

## 1.3.2

- Expose page transition curve and duration to static method.
- Fix theme color not passed to static method.

## 1.3.1+1

- Fix `pageBuilder` null issue.

## 1.3.1

- Add upwards slide page transition.
- Add padding to bottom action bar in picker.

## 1.3.0

- Add iOS style.
- Add cancel field to text delegate.
- `Set` -> `List`.

## 1.2.1

- Fix missing aspect ratio for video player.
- Using common request type in example.

## 1.2.0

- Add text delegate support. (Also with i18n support using delegate).

## 1.1.0

- Support video assets. You can use `requestType` to select video or video+image.
- Hide system ui overlays according to flag and system.
- Update GIF indicator and add video indicator.

## 1.0.0

- Initial release.

[Migration Guide]: guides/migration_guide.md
