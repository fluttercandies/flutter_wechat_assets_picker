<!-- Copyright 2019 The FlutterCandies author. All rights reserved.
Use of this source code is governed by an Apache license
that can be found in the LICENSE file. -->

# Changelog

> [!IMPORTANT]  
> See the [Migration Guide](guides/migration_guide.md) for the details of breaking changes between versions.

## Unreleased

*None.*

## 9.8.0

> [!NOTE]
> Be aware of potential minor theme changes since the base theme has taken place in the picker's theme.

**Improvements**

- Improve themes by inheriting the base theme rather than standalone constructors.

**Fixes**

- Enabling using the package on Flutter 3.35.

## 9.7.0

**Improvements**

- Allows specifying the fallback text delegate through `assetPickerTextDelegateFromLocale`.

## 9.6.0

**New features**

- Expose more route settings.
  Users will now be able to control the route settings for the picker and viewer.
- Add Persian (Farsi) language support. (Thanks to @Ho3einTahan)

**Improvements**

- Improve how `MediaQuery` is being listened.
- Stop enabling drag to select when `maxAssets == 1`.
- Extract `DefaultAssetPickerProvider.init`.

**Fixes**

- Fix semantics with the close button.
- Fix `selectPredicate` not being called when selecting the video asset under the WeChat Moment mode.
- Manually dispose memory leak objects.

## 9.5.1

**Improvements**

- Allow `extended_image` v10.

## 9.5.0

**New features**

- Support drag to select.

**Fixes**

- Fixes semantics issues.

## 9.4.2

**Improvements**

- Add Traditional Chinese language text delegate. (Thanks to @Gasol)
- Improves the default sort conditions on Android.

## 9.4.1

**Improvements**

- Improves the default sort conditions.

**Fixes**

- Fixes selecting when reached the max asset limit in the preview.

## 9.4.0

**Improvements**

- Allows `extended_image: ^9.0.0`.

**Fixes**

- Allows assets changing when no path previously.

## 9.3.3

**Fixes**

- Recovers the compatibility with Flutter 3.16.

## 9.3.2

**Improvements**

- Adapt the file type getter from the image provider to get a precise file type in grid.
- Adds the identifier for grid item's semantics.
- Improves preview page back button.

## 9.3.1

**Improvements**

- Do not mute the Live Photo during the preview.

**Fixes**

- Fix the GIF indicator's layout.
- Fix the directionality with the reverted grid item.

## 9.3.0

**New features**

- Add explicit Live Photos indicator for assets.

**Improvements**

- Make Live Photos gesture consistent when scaling and panning.
- Integrate `LocallyAvailableBuilder` with thumbnail options to improve the thumbnail loading speed.
- Use `visibility_detector` and scroll observer to improve media playing experiences.

**Fixes**

- Fix the bottom actions bar display conditions.

## 9.2.2

- Uses correct `isOriginal` for the `LocallyAvailableBuilder`.

## 9.2.1

- Improve changes when limited on iOS.
- Use `LocallyAvailableBuilder` in the grid to provide better user awareness.

## 9.2.0

**New features**

- Introduce `AssetsChangeCallback` and `AssetsChangeRefreshPredicate`
  to help users act according to asset changes.
- Add `shouldAutoplayPreview` to the picker config.

**Fixes**

- Raise detailed negative range error.
- Fix viewer confirm button predication.
- Enlarge GIF gradients.
- Fix potential paths assets count unexpected merging behaviors.

## 9.1.0

**Improvements**

- Support limited permission displays on Android.
- Improves the limited overlay padding on Android.
- Adds permission request lock for the picker state.
- Speeding up by splitting asset loading into separate steps.
- Speeding up using `AdvancedCustomFilter` rather than `FilterOptionGroup` by default.

**Fixes**

- Fix reverted index when previewing assets on Android.
- Requests with the correct options with the picker.

## 9.0.4

**Fixes**

- Fix the app bar of the viewer that is not animating.
- Fix loading when no assets are in the path.
- Reset the has more to load flag between path switching.

## 9.0.3

**Fixes**

- Fix index reverting in `viewAsset`.

## 9.0.2

**Fixes**

- Fix the index with bottom items in the preview.

## 9.0.1

**Fixes**

- Fix the current asset in the picker viewer.

**Improvements**

- Improve code formatting.

## 9.0.0

**Breaking changes**

- Migrate to Flutter 3.16, and drop supports for previous Flutter versions.
- Bump `photo_manager` to v3.x.
- Export `photo_manager_image_provider`.
- Integrate `PermissionRequestOption` for callers.

**Improvements**

- Adapt `ThemeData` usages.
- Use `wechat_picker_library`.
- Make the first asset count not blocking loads.

**Fixes**

- Fix unhandled child semantics with the app bar title.
- Fix styles around the app bar and other widgets.
- Fix previewing selected assets' behavior.
- Use `PermissionRequestOption` as much as possible.
- Raise more errors for non-synced paths.
- Fix the experience with `shouldRevertGrid`.

## 8.8.0

**New features**

- Add Korean language support. (Thanks to @LIMMIHEE)

**Improvements**

- Use `viewAsset` in the preview button.

**Fixes**

- Fix disposed provider throwing error when fetching assets. (#493)

## 8.7.1

**Improvements**

- Improve README docs and add topics for pub.

## 8.7.0

**Breaking changes**

- Migrate to Flutter 3.13, and drop supports for previous Flutter versions.

## 8.6.3

**Improvements**

- Improve `AssetPickerProvider.paths`.

## 8.6.2

**Improvements**

- Add `appBarPreferredSize` in the picker delegate to help with padding calculations.
- Improve the performance with `MediaQuery` callers.

## 8.6.1

**Improvements**

- Remove `needTitle` for image filter options.

**Fixes**

- Fix hit test when previewing videos.

## 8.6.0

**Breaking changes**

- Use `TargetPlatform` for the `isAppleOS` method in delegates, which relies on a `BuildContext`.

**New features**

- Sync all UI details from WeChat 8.3.x. (#458)
- Add Turkish language text delegate. (Thanks to @cevheri).
- Allow to confirm 0 assets if there are selected assets previously. (#461)

**Improvements**

- Silent part of thumbnail request exceptions.

**Fixes**

- Fix semantics interactions for video preview. (#458)
- Be able to update the items builder page. (#417)

## 8.5.0

**Breaking changes**

- Migrate to Flutter 3.10, and drop supports for previous Flutter versions.

## 8.4.3

**New features**

- Add Vietnamese language text delegate. (Thanks to @nploi).

**Improvements**

- Expand `FilterOptionGroup` to `PMFilter`. (#436)

## 8.4.2

**Fixes**

- Avoid clearing selected assets when disposing the provider. (#428)

## 8.4.1

**Fixes**

- Call `AssetPickerProvider.dispose` when disposing the builder delegate. (#421)

## 8.4.0

**Breaking changes**

- Migrate to Flutter 3.7, and drop supports for previous Flutter versions.

## 8.3.2+1

**Improvements**

- Add more assertions. (#411)

## 8.3.2

**Fixes**

- Use `Completer` and more accurate conditions to avoid duplicate load assets
  when `AssetPickerConfig.pageSize` is smaller than a complete page. (#407)

## 8.3.1+1

**Improvements**

- Fix images and descriptions in `README`s.

## 8.3.1

**New features**

- Add `didUpdateViewer` and `initAnimations` in the `AssetPickerViewerBuilderDelegate`. (#403)
- Add insta_assets_picker as a custom delegate example. (#403)

## 8.3.0

**New features**

- Add `index` argument to `selectAsset` in the `AssetPickerBuilderDelegate`. (#399)

**Improvements**

- Improve UI details in the `AssetPickerAppBar`. (#400)

## 8.2.0

**New features**

- Allow overrides `viewAsset` in the `AssetPickerBuilderDelegate`. (#391)

**Fixes**

- Correct behaviors when the access is limited on iOS. (#392)

## 8.1.4

**Fixes**

- Fix conditions with the confirm button on iOS. (#376)

## 8.1.3

**Improvements**

- Bump `photo_manager` to explicitly remove the requirements of `requiredLegacyExternalStorage`.

## 8.1.2

**Fixes**

- Fix conditions with the confirm button. (#371)

## 8.1.1

**Fixes**

- Fix conditions with the confirm button. (#367)

## 8.1.0

**New features**

- Upgrade `photo_manager` for Android 13. (#365)

**Improvements**

- Improve `BuildContext` usages to obtain the correct directionality for the assets grid. (#359)
- Provide a better condition to the confirm button
  to make sure it displays correctly in all cases on iOS/macOS. (#359)
- Improve `bottomActionBar` in `DefaultAssetPickerBuilderDelegate`. (#359)

**Fixes**

- Fix invalid path sort. (#364)

## 8.0.2

**Improvements**

- Adapt Flutter 3.3. (#354)

## 8.0.1

**Fixes**

- Fix not updated empty flag in `DefaultAssetPickerProvider`. (#353)

## 8.0.0

To know more about breaking changes, see [Migration Guide][].

**New features**

- Introduce `PathWrapper` in delegates to improve the overall loading speed. (#338)
- Allow using `Key` during picking. (#339)
- Add `initializeDelayDuration` for `DefaultAssetPickerProvider`. (#341)
- Prevent race conditions with paths. (#342)
- Expose `sortPathsByModifiedDate`. (#343)

**Fixes**

- Unify indicator usage to avoid accidental indicator switching. (#344)

## 7.3.2

**Improvements**

- Improve `onChangingSelected` in `AssetPickerViewerBuilderDelegate`. (#332)
- Fix typo in `README.md`. (#333)

**Fixes**

- Fix behaviors when unselecting all assets in the viewer. (#335)

## 7.3.1

**Improvements**

- Improve selection callers between picker and viewer. (#327)

## 7.3.0

**Breaking changes**

- Migrate to Flutter 3, and drop supports for previous Flutter versions.

## 7.2.0

**New features**

- Separate `AssetPickerDelegate` (#315),
  which provides the ability to override methods within the `AssetPicker`.

**Improvements**

- Improve `specialItemBuilder`. (#314)

## 7.1.2

**Fixes**

- Fix context usages for inherited theme data.
- Fix unlinked path name builder.

**Improvements**

- Update how paths get updated. (#312)
- Expose `DefaultAssetPickerProvider.forTest`.

## 7.1.1

**Fixes**

- Fix `selectPredicate` with the viewer. (#307)

## 7.1.0

**New features**

- Add `PathNameBuilder`. (#303)
- Add `LimitedPermissionOverlayPredicate`. (#287)

## 7.0.5

**Improvements**

- Support compile on the Web. (#273)

## 7.0.4

**Improvements**

- Make all text delegates const.

## 7.0.3

**Fixes**

- Fix the broken semantics on iOS/macOS. (#272)

## 7.0.2

**Fixes**

- Fix wrong conditions judging when obtaining path thumbnails.

## 7.0.1

**Improvements**

- Support semantics with Japanese text delegates. (#266).

**Fixes**

- Obtain the path thumbnail only when the asset is an image or video.

## 7.0.0

To know more about breaking changes, see [Migration Guide][].

**New features**

- Support predictable special item display. (#264)
- Support Live-Photos display. (#251)
- Expose `AssetPickerPageRoute` for customization. (#248)
- Add full semantics support. (#232, #235, #240, #242, #243, #245, #254)

**Improvements**

- Improve scaling with select indicators and numbers.
- Implement the default light theme. (#234)

**Fixes**

- Fix `LocallyAvailableBuilder` with more edge conditions. (#263)
- Fix potential "No elements" error with thumbnails.

## 6.3.1

- Improve image type determined when resolving image data.
  This mostly resolved the occasional HEIC loading issue when
  apps are running under the release mode.

## 6.3.0

- Support for Flutter 2.8.0, also drop supports for Flutter below 2.8.0.

## 6.2.4

- Improve audio item layout.
- Improve workflows.
- Indicate the path getter more precisely.
- Improve Arabic text delegate.

## 6.2.3

- Pass through `selectPredicate` to `AssetPickerViewer`. (#211)
- Bump the `sdk` constraints (since 6.2.1).

## 6.2.2

- Use `.contentUri` for video preview only on Android.

## 6.2.1

- Migrate to `extended_image` 5.x.
- Use `.contentUri` constructor for `VideoPlayerController`.

## 6.2.0

- Introduce `shouldRevertGrid` to determine whether the assets grid should be reverted.
- Upgrade `photo_manager` to resolve issues against `AssetEntity`s comparison.

## 6.1.2

- Fix the limited resources refresh issue.
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
- Fix assets displaying conditions missing with the iOS layout.

## 6.0.2

- Expose `shouldReversePreview` for `AssetPickerViewerBuilderDelegate`.

## 6.0.1

- Improve total count calculation with `AssetPathEntity`. (#187)
- Obtain `AssetPathEntity.isAll` fix from `photo_manager`.
- Documents update.

## 6.0.0

**New features**

- Sync all UI details from WeChat 8.0.x.
- Integrate iCloud progress overview in previews.
- Change the permission from the app settings when it's limited.
- Request more assets on iOS when the permission is limited.
- Fit the assets' grid's layout as the iOS `Photos` app (reverted and started from the bottom).
- Add Arabic language text delegate.
- Allow using `AssetPicker` and `AssetPickerViewer` directly with delegates.
- Add `keepScrollOffset` feature for the `AssetPickerBuilderDelegate`.

**Improvements**

- Items that are being banned from select (reached max assets or type conflict)
  will have a stronger color cover to indicate.
- The video preview in the [SpecialPickerType.wechatMoment] is completely different from other previews.
- Grid items have removed the fade builder for more straight feedback after it gets loaded.
- Better interaction when jumping between previewing assets.
- Path entities list layout structure performance & structure improved.
- More precise thumbnail option for iOS.
- Improve text scale handling. (#177)
- Reduce font size for a couple of texts.

To know more about breaking changes, see [Migration Guide][].

## 5.5.8

- Fix the viewer's select button issue with WeChat Moment on Android.

## 5.5.7

- Make `switchPath` method in `AssetPickerProvider` async.

## 5.5.6

- Add Japanese language text delegate. (Thanks to @KosukeSaigusa)
- Fix video judge condition with WeChat Moment mode.
- Fix the wrong position for the confirm button on iOS with WeChat Moment mode.

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

- Add `findChildIndexBuilder` to indicate grid find reusable `RenderObject`.
- Fix the padding issue for the assets' grid.

## 5.4.3

- Fix the missing `ScrollController` in the scroll view.

## 5.4.2

- Split `AssetGridItemBuidler` to solve the rebuild issue.
- Fix the GIF indicator stretched issue.

## 5.4.1

- Export `AssetPickerPageRoute`.

## 5.4.0+1

- Fix the format that pub.dev suggests.

## 5.4.0

- Fully support RTL languages.
- Add control for root navigator.
- Improve `AssetEntityImageProvider`'s constructor and decode.
- Grab the iOS/macOS thumbnail's size fix from `photo_manager`.

## 5.3.0

- Add `gridThumbSize` to control thumbnails in the select grid.
- Applies a further fix to the WeChat Moment video preview.
- Fix unlimited assets choose in preview mode.

## 5.2.1

- Fix the WeChat Moment preview issue.

## 5.2.0

- Add `SpecialPickerType.noPreview` to disable the preview when picking. (Thanks to @yanivshaked)

## 5.1.4

- Add Hebrew language text delegate. (Thanks to @yanivshaked)
- Fix the slide page route issue when integrated with the `get` package.

## 5.1.3

- Fix not synced issue when the picker is under single pick mode.

## 5.1.2

- Fix selected assets not syncing between thumbnail preview mode and grid view.
- Fix the wrong index displays in thumbnail preview mode.
- Dependencies upgrade roll.

## 5.1.1

- Integrate `lastModified` to sort path entities by default.

## 5.1.0

- Reset to the top for the asset grid view after switching paths.
- Add the ability to select assets in any position of the picker.
- Implement mime type for image type judgment.
- Fix the disappeared GIFs indicator.

## 5.0.5

- Fix force cast null type issue with WeChat moment special pick type.
- Improve the app bar's type definition.

## 5.0.4

- Fix path thumb data's display issue.
- Fix the default preview thumb size issue with the image preview builder.

## 5.0.3

- Remove required annotation for selected assets.

## 5.0.2

- Fix the wrong viewer provider state.
- Enhance page stream controller sink close.
- Fix `dartdoc` generate issue for pub.

## 5.0.1

- Fix the video indicator layout issue.
- Prevent video selection in WeChat moment mode for edge cases.
- Pickup fixes from `photo_manager`.

## 5.0.0

- Add the ability to show the special item when the device has no assets.
- Allow users to build their own picker with custom asset types. (See example for custom delegate.)
- Slightly reduce performance consumption with layout.

**Breaking changes**

- Migrate to non-nullable by default.
- `CustomItemBuilder` -> `SpecialItemBuilder`, `CustomItemPosition` -> `SpecialItemPosition`.
- Abstract `AssetPickerBuilderDelegate<A, P>`, `AssetPickerViewerBuilderDelegate<A, P>`,
  `AssetPickerProvider<A, P>`, and minify the `AssetPickerViewerProvider<A>`. Support custom types by generic type.
- The `assets` param in `AssetPickerViewer.pushToViewer` is now `previewAssets`.

## 4.2.2

- Suppress deprecated usage for example.
- Improve code format with dart format.
- Raise the dependencies version.

## 4.2.1

- Fix arguments judging condition with preview thumb size.
- Remove common exports and split out constants.

## 4.2.0

- Add `previewThumbSize` for the viewer.

## 4.1.0+4

- Upgrade `extended_image`.

## 4.1.0+3

- Make widgets constant.
- Remove system UI overlays update.
- Migrate files to compatible with Flutter `1.20.0`.
- Sync analysis options.

## 4.1.0+2

- Ignore size constraints for image assets.
- Format code using `dartfmt`.
- Upgrade `photo_manager`.

## 4.1.0+1

- Adjust AppleOS layout.

## 4.1.0

- Add a backdrop widget in the picker, which makes the picker more like the one in WeChat.

## 4.0.0

- Drop `asset_audio_player`.
- Experimenting status bar hidden on iOS.
- Remove the video player listener before pausing.

**Breaking changes**

- `TextDelegate` -> `AssetsPickerTextDelegate`.

## 3.0.0+1

- Constraint dependencies version.

## 3.0.0

- Add `FilterOptionGroup`. (#41)
- Add `SpecialPickerType`. (#37)
- Add custom item build mode. (#39)

## 2.2.1

- Introduce `ColorScheme` for theme details. (#32)
- Enhance RTL compatibility.
- Enlarge select indicator's size. (#33)

## 2.2.0+2

- Remove path entity properties refresh.

## 2.2.0+1

- Fix the preview widget for audio assets in the picker viewer.

## 2.2.0

- A brand-new example.
- Add `SortPathDelegate`.
- Using `ZoomPageTransition` for viewers.
- Slightly add padding to the viewer's assets list view.
- Migrate elevation and color to material rendering.
- Request thumb only when the request type is not audio.
- Force request title for audio type asset.
- Expose `AssetType` enum.
- Fix the issue with the request type.

## 2.1.0

- Add present English text delegate.
- Refactored theme constructor and getter with theme capability. (#22)
- Update color scheme usage for the assets grid. (#23)
- Update picker viewer style for Apple OS.
- Fix the bottom bar disappearing on Apple OS when it's single asset mode.

## 2.0.2

- Fix audio paused accidentally when the app is launching on Android. (#18)

## 2.0.1

- Expose observe register methods.

## 2.0.0

- Support audio assets.
- Support single asset mode.
- Enlarge the preview button's detector area size.
- Fix wrong properties' usage causing infinite build when the page reaches the end.

**Breaking changes**

- `videoIndicatorBuilder` -> `durationIndicatorBuilder`.

## 1.7.0

- Hide detail display when the video starts to play.
- Switch to `ExtendedImageGesturePageView`. (#16)
- Add full theme support.
- Add macOS support.
- Add delay for the first init method to prevent stuck in page routing. (#13)
- Update widgets style on iOS. (#14)
- Fix the state of the example not updated after the result was returned without the input method activated.

## 1.6.0

- Support HEIC/HEIF image type.

## 1.5.0+1

- Upgrade `photo_manager` to `0.5.1`.
- Replace deprecate `TextTheme.title` API usage.
- Document (`dartdoc`) update.

## 1.5.0

- Bumping flutter SDK minimum version to `1.17.0`.
- Declare API stability and compatibility with 1.0.0
  ( more details at: https://github.com/flutter/flutter/wiki/Package-migration-to-1.0.0 ).

## 1.4.1

- Remove the loading indicator for the image widget.
- Refactor the video page's initialization for ratio update.
- Using constants to store text delegate.
- Add error catching for main methods.
- Update text delegate management.

## 1.4.0+1

- Fix call on null with `currentlySelectedAssets`.

## 1.4.0

- Support paging assets load.
- Fix selected assets not synced with the picker provider.
- Bump `photo_manager` to `0.5.1-dev.5`

## 1.3.2

- Expose page transition curve and duration to a static method.
- Fix theme color not passed to a static method.

## 1.3.1+1

- Fix the `pageBuilder` null issue.

## 1.3.1

- Add upwards slide page transition.
- Add padding to the bottom action bar in the picker.

## 1.3.0

- Add iOS style.
- Add cancel field to text delegate.
- `Set` -> `List`.

## 1.2.1

- Fix the missing aspect ratio for the video player.
- Using common request type in example.

## 1.2.0

- Add text delegate support. (Also with i18n support using delegate).

## 1.1.0

- Support video assets. You can use `requestType` to select video or video+image.
- Hide system ui overlays according to flag and system.
- Update the GIF indicator and add a video indicator.

## 1.0.0

- Initial release.

[Migration Guide]: guides/migration_guide.md
