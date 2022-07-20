<!-- Copyright 2019 The FlutterCandies author. All rights reserved.
Use of this source code is governed by an Apache license
that can be found in the LICENSE file. -->

# Migration Guide

This document gathered all breaking changes and migrations requirement between major versions.

## Major versions

- [8.0.0](#8.0.0)
- [7.0.0](#7.0.0)
- [6.0.0](#6.0.0)
- [5.0.0](#5.0.0)

## 8.0.0

### Summary

- `AssetPathEntity.assetCountAsync` was introduced in
  [fluttercandies/flutter_photo_manager#784](https://github.com/fluttercandies/flutter_photo_manager/pull/784)
  to improve the loading performance during paths obtain.
  By migrating the asynchronous getter, we need to introduce a new concept `PathWrapper` to hold metadata together,
  but initialize fields separately.
- `containsPathModified` is now `false` by default (previously `true`), and can be changed accordingly.

### Details

#### `AssetPickerProvider`

- `currentPath` has been changed from `Path?` to `PathWrapper<Path>?`.
- `pathsList` has been removed, and added `AssetPickerProvider.paths`.
- `totalAssetsCount` is now nullable to indicates initialization.
- `getThumbnailFromPath` and `switchPath` have different signature from `Path` to `PathWrapper<Path>`.

#### `AssetPickerBuilderDelegate`

- `pathEntityWidget` has different signature from `Path` to `PathWrapper<Path>`,
  and the `isAudio` argument has been removed.

#### `SortPathDelegate`

`sort` has a different signature, which needs `PathWrapper`s to sort. More specifically:

Before:

```dart
void sort(List<Path> list) {}
```

After:

```dart
void soft(List<PathWrapper<Path>> list) {}
```

## 7.0.0

### Summary

- Nearly all delegates are updated due to semantic support and de-nested improvements.
- Most arguments in `pickAssets` have been gathered as the `AssetPickerConfig`.
- Most text delegates has been renamed with `*AssetPickerTextDelegate`.
- `AssetsPickerTextDelegate` has been renamed to `AssetPickerTextDelegate` (**Asset** without **s**).

### Details

#### `AssetPicker`

- `gridThumbSize` has been renamed to `gridThumbnailSize` and has different type.
- `pathThumbSize` has been renamed to `pathThumbnailSize` and has different type.
- `previewThumbSize` has been renamed to `previewThumbnailSize` and has different type.

##### `pickAssets`

Before:

```dart
AssetPicker.pickAssets(
  context,
  maxAssets: maxAssetsCount,
  selectedAssets: assets,
  requestType: RequestType.image,
)
```

After:

```dart
AssetPicker.pickAssets(
  context,
  pickerConfig: AssetPickerConfig(
    maxAssets: maxAssetsCount,
    selectedAssets: assets,
    requestType: RequestType.image,
  ),
)
```

##### `pickAssetsWithDelegate`

This method no longer requires the `provider` argument, delegate should hold provider itself if necessary.

#### `AssetPickerBuilderDelegate`

- **The abstract delegate doesn't require a `provider` anymore, custom delegates should maintain their own providers.**
- **The `ChangeNotifierProvider` is no longer held inside the `pickAssets` method,
  custom delegates should provide the notifier on their own.**
- `keepScrollOffset` has been moved to the default delegate instead of the abstract one.
- Custom delegates must implement `isSingleAssetMode`, `selectAsset`, `assetGridItemSemanticsBuilder` and `build`.
- `selectIndicator` method now has a different signature.
- `dispose` must call super when extending.

#### `AssetPickerProvider`

- **`isSwitchingPath` now holds by the default delegate.**
- `currentPathEntity` has been renamed to `currentPath`.
- `getAssetsFromEntity` has been renamed to `getAssetsFromPath`.
- `getFirstThumbFromPathEntity` has been renamed to `getThumbnailFromPath`.
- `getAssetPathList` has been renamed to `getPaths`.
- `pathEntityList` has been renamed to `pathsList`.
- `validPathThumbCount` has been renamed to `validPathThumbnailsCount`.

#### `AssetPickerViewer`

##### `pushToViewer`

- `previewThumbSize` has been renamed to `previewThumbnailSize` and has different type.

## 6.0.0

### Summary

_If you didn't extend `AssetPickerBuilderDelegate` or `AssetTextDelegate` to build delegates on your own,
you can stop reading._

- User who extended `AssetPickerBuilderDelegate` needs to update the subclass with the latest changes.
- `AssetsPickerTextDelegate` is not abstract anymore.

### Details

#### `AssetPickerBuilderDelegate`

New arguments:

- `PermissionState initialPermission`: The intention of this change is to be capable with various of `PermissionState`.
  If your delegate didn't require a permission check, you can pass `PermissionState.authorized` directly.
- `keepScrollOffset`: To hold the provider and delegate without disposing,
  and keep the scroll offset with the last picking.

Other changes:

- `assetsGridBuilder` is not implemented by default.
- The `findChildIndexBuilder` and `assetsGridItemCount` methods have new signature.
  They require calculating placeholders count on iOS/macOS by default.

#### `AssetPickerViewerBuilderDelegate`

- Added the `isDisplayingDetail` notifier.
- Added double tap animation series of fields.

#### `AssetsPickerTextDelegate`

- This delegate is now a normal class with Chinese language implemented by default,
  which makes `DefaultAssetsPickerTextDelegate` removed. If you used to use `DefaultAssetsPickerTextDelegate()`,
  use `AssetsPickerTextDelegate()` instead.

#### `AssetPickerProvider`

- The `switchPath` method has a different signature:

Before:

```dart
void switchPath(Path pathEntity);
```

After:

```dart
Future<void> switchPath([P? pathEntity]);
```

### `SortPathDelegate`

`SortPathDelegate` accepts a generic type `Path` now, and the type will be delivered to the `sort` method.

## 5.0.0

### Summary

_If you only use the `AssetPicker.pickAssets` and `AssetEntityImageProvider`, didn't use `AssetPickerViewer`,
`AssetPickerProvider`, or other components separately, you can stop reading._

The `AssetPicker` and the `AssetPickerViewer` are only a builder since 5.x, all widgets construct were moved
to `AssetPickerBuilderDelegate` and `AssetPickerViewerBuilderDelegate`, and these delegates are both abstract.

By splitting delegates, now you can build your own picker with custom types, style, and widgets.

#### Details

For how to implement a custom picker, see the example's custom page for more implementation details.

- If you have ever use `AssetPickerViewer.pushToViewer`, the properties `assets` has changed to
  `previewAssets`.

- If you have extended an `AssetPickerProvider` or `AssetPickerViewerProvider`, it now requires you to pass generic
  type `Asset` and `Path`, and handle the entities on your own.
