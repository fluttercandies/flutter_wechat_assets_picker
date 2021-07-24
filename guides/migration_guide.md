# Migration Guide

This document gathered all breaking changes and migrations requirement between major versions.

## References

API documentation:
- `AssetPickerBuilderDelegate`:
  - https://pub.dev/documentation/wechat_assets_picker/latest/wechat_assets_picker/AssetPickerBuilderDelegate-class.html
  - https://pub.flutter-io.cn/documentation/wechat_assets_picker/latest/wechat_assets_picker/AssetPickerBuilderDelegate-class.html
- `AssetPickerViewerBuilderDelegate`:
  - https://pub.dev/documentation/wechat_assets_picker/latest/wechat_assets_picker/AssetPickerViewerBuilderDelegate-class.html
  - https://pub.flutter-io.cn/documentation/wechat_assets_picker/latest/wechat_assets_picker/AssetPickerViewerBuilderDelegate-class.html
- `AssetPickerProvider`:
  - https://pub.dev/documentation/wechat_assets_picker/latest/wechat_assets_picker/AssetPickerProvider-class.html
  - https://pub.flutter-io.cn/documentation/wechat_assets_picker/latest/wechat_assets_picker/AssetPickerProvider-class.html
- `AssetPickerViewerProvider`:
  - https://pub.dev/documentation/wechat_assets_picker/latest/wechat_assets_picker/AssetPickerViewerProvider-class.html
  - https://pub.flutter-io.cn/documentation/wechat_assets_picker/latest/wechat_assets_picker/AssetPickerViewerProvider-class.html
- `AssetsPickerTextDelegate`:
  - https://pub.dev/documentation/wechat_assets_picker/latest/wechat_assets_picker/AssetsPickerTextDelegate-class.html
  - https://pub.flutter-io.cn/documentation/wechat_assets_picker/latest/wechat_assets_picker/AssetsPickerTextDelegate-class.html

## Major versions

- [6.0.0](#6.0.0)
- [5.0.0](#5.0.0)

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
  which makes `DefaultAssetsPickerTextDelegate` removed. So if you used to use `DefaultAssetsPickerTextDelegate()`,
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

_If you only use the `AssetPicker.pickAssets` and `AssetEntityImageProvider`,
didn't use `AssetPickerViewer`, `AssetPickerProvider`, or other components separately,
you can stop reading._

The `AssetPicker` and the `AssetPickerViewer` are only a builder since 5.x,
all widgets construct were moved to `AssetPickerBuilderDelegate` and `AssetPickerViewerBuilderDelegate`,
and these delegates are both abstract.

By splitting delegates, now you can build your own picker with custom types, style, and widgets.

#### Details

For how to implement a custom picker, see the example's custom page for more implementation details.

- If you have ever use `AssetPickerViewer.pushToViewer`, the properties `assets` has changed to
  `previewAssets`.

- If you have extended an `AssetPickerProvider` or `AssetPickerViewerProvider`, it now requires you
  to pass generic type `Asset` and `Path`, and handle the entities on your own.
