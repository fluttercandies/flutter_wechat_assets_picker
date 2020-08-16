# [4.2.0] - [2020/08/16]

* Add `previewThumbSize` for the viewer.

# [4.1.0+4] - [2020/08/06]

* Upgrade `extended_image` .

# [4.1.0+3] - [2020/08/06]

* Make widgets constant.
* Remove system ui overlays update.
* Migrate files to compatible with Flutter `1.20.0` .
* Sync analysis options.

# [4.1.0+2] - [2020/07/28]

* Ignore size constraint for image assets.
* Format code using `dartfmt`.
* Upgrade `photo_manager`.

# [4.1.0+1] - [2020/07/23]

* Adjust AppleOS layout.

# [4.1.0] - [2020/07/22]

* Add backdrop widget in the picker, which makes the picker more like the one in WeChat.

# [4.0.0] - [2020/07/17]

* Drop `asset_audio_player` .
* Experimenting status bar hidden on iOS.
* Remove video player listener before pause.

## Breaking changes

* `TextDelegate` -> `AssetsPickerTextDelegate` .

# [3.0.0+1] - [2020/07/13]

* Constraint dependencies version.

# [3.0.0] - [2020/07/13]

* Add `FilterOptionGroup`. Fix #41 .
* Add `SpecialPickerType`. Fix #37 .
* Add custom item build mode. Fix #39 .

# [2.2.1] - [2020/06/23]

* Introduce `ColorScheme` for theme details. Fixed #32 .
* Enhance RTL compatibility.
* Enlarge select indicator's size. Related to #33 .

# [2.2.0+2] - [2020/06/08]

* Remove path entity properties refresh.

# [2.2.0+1] - [2020/06/01]

* Fix preview widget for audio assets in picker viewer.

# [2.2.0] - [2020/06/01]

* Brand new example.
* Add `SortPathDelegate`.
* Using zoom page transition for viewer.
* Slightly add padding to viewer's assets list view.
* Migrate elevation and color to material rendering.
* Request thumb only when request type is not audio.
* Force request title for audio type asset.
* Expose `AssetType` enum.
* Fix issue with request type.

# [2.1.0] - [2020/05/28]

* Add present english text delegate.
* Refactored theme constructor and getter with theme capability #22 .
* Update color scheme usage for assets grid #23 .
* Update picker viewer style for apple OS.
* Fix bottom bar disappearing on apple os when it's single asset mode.

# [2.0.2] - [2020/05/27]

* Fix audio paused accidentally when the app is launching on Android #18 .

# [2.0.1] - [2020/05/22]

* Expose observe register methods.

# [2.0.0] - [2020/05/21]

* Support audio assets.
* Support single asset mode.
* Enlarge preview button's detector area size.
* Fix wrong properties usage causing infinite build when the page reaches the end.

## Breaking changes

* `videoIndicatorBuilder` -> `durationIndicatorBuilder`.

# [1.7.0] - [2020/05/19]

* Hide detail display when video start to play.
* Switch to `ExtendedImageGesturePageView`. Fix #16 .
* Add fully theme support.
* Add MacOS support.
* Add delay for the first init method to prevent stuck in page routing. Fix #13 .
* Update widgets style on iOS. Fix #14 .
* Fix state of the example not updated after the result was returned without input method activated.

# [1.6.0] - [2020/05/10]

* Support HEIC/HEIF image type.

# [1.5.0+1] - [2020/05/09]

* Upgrade `photo_manager` to `0.5.1`.
* Replace deprecate `TextTheme.title` API usage.
* Document (dartdoc) update.

# [1.5.0] - [2020/05/09]

* Bumping flutter sdk minimum version to `1.17.0`.
* Declare API stability and compatibility with 1.0.0 ( more details at: https://github.com/flutter/flutter/wiki/Package-migration-to-1.0.0 ).

# [1.4.1] - [2020/04/20]

* Remove loading indicator for image widget.
* Refactor video page's initialization for ratio update.
* Using constants to store text delegate.
* Add error catching for main methods.
* Update text delegate management.

# [1.4.0+1] - [2020/04/19]

* Fix call on null with `currentlySelectedAssets`.

# [1.4.0] - [2020/04/17]

* Support paging assets load.
* Fix selected assets not synced with picker provider.
* Bump `photo_manager` to `0.5.1-dev.5`

# [1.3.2] - [2020/04/15]

* Expose page transition curve and duration to static method.
* Fix theme color not passed to static method.

# [1.3.1+1] - [2020/04/14]

* Fix `pageBuilder` null issue.

# [1.3.1] - [2020/04/13]

* Add upwards slide page transition.
* Add padding to bottom action bar in picker.

# [1.3.0] - [2020/04/09]

* Add iOS style.
* Add cancel field to text delegate.
* `Set` -> `List`.

# [1.2.1] - [2020/04/08]

* Fix missing aspect ratio for video player.
* Using common request type in example.

# [1.2.0] - [2020/04/07]

* Add text delegate support. (Also with i18n support using delegate).

# [1.1.0] - [2020/04/07]

* Support video assets. You can use `requestType` to select video or video+image.
* Hide system ui overlays according to flag and system.
* Update GIF indicator and add video indicator.

# [1.0.0] - [2020/03/31]

* Initial release.
