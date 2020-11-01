# Migration Guide

## Migrate to 5.0.0

### Summary

_If you only use the `AssetPicker.pickAssets` and `AssetEntityImageProvider`,
didn't use `AssetPickerViewer`, `AssetPickerProvider`, or other components separately,
you can stop reading._

`AssetPicker` and `AssetPickerViewer` are only a builder since 5.x, all widgets construct were moved
to `AssetPickerBuilderDelegate` and `AssetPickerViewerBuilderDelegate`, and these delegates are both
abstract.

By splitting delegates, now you can build your own picker with custom types, style, and widgets.

### Migration steps

For how to implement a custom picker, see the example's custom page for more implementation details.

* If you have ever use `AssetPickerViewer.pushToViewer`, the properties `assets` has changed to
  `previewAssets`.

* If you have extends an `AssetPickerProvider` or `AssetPickerViewerProvider`, it now requires you
  to pass generic type `A` and `P`, and handle the entities on your own.

### References

API documentation:
* `AssetPickerBuilderDelegate`: https://pub.dev/documentation/wechat_assets_picker/latest/wechat_assets_picker/AssetPickerBuilderDelegate-class.html
* `AssetPickerViewerBuilderDelegate`: https://pub.dev/documentation/wechat_assets_picker/latest/wechat_assets_picker/AssetPickerViewerBuilderDelegate-class.html
* `AssetPickerProvider`: https://pub.dev/documentation/wechat_assets_picker/latest/wechat_assets_picker/AssetPickerProvider-class.html
* `AssetPickerViewerProvider`: https://pub.dev/documentation/wechat_assets_picker/latest/wechat_assets_picker/AssetPickerViewerProvider-class.html