# Flutter WeChat Assets Picker

[![pub package](https://img.shields.io/pub/v/wechat_assets_picker?logo=dart&label=stable&style=flat-square)](https://pub.dev/packages/wechat_assets_picker)
[![pub package](https://img.shields.io/pub/v/wechat_assets_picker?color=42a012&include_prereleases&label=dev&logo=dart&style=flat-square)](https://pub.dev/packages/wechat_assets_picker)
[![GitHub stars](https://img.shields.io/github/stars/fluttercandies/flutter_wechat_assets_picker?logo=github&style=flat-square)](https://github.com/fluttercandies/flutter_wechat_assets_picker/stargazers)
[![GitHub forks](https://img.shields.io/github/forks/fluttercandies/flutter_wechat_assets_picker?logo=github&style=flat-square)](https://github.com/fluttercandies/flutter_wechat_assets_picker/network)
[![Build status](https://img.shields.io/github/workflow/status/fluttercandies/flutter_wechat_assets_picker/Build%20test?label=CI&logo=github&style=flat-square)](https://github.com/fluttercandies/flutter_wechat_assets_picker/actions?query=workflow%3A%22Build+test%22)
[![CodeFactor](https://img.shields.io/codefactor/grade/github/fluttercandies/flutter_wechat_assets_picker?logo=codefactor&logoColor=%23ffffff&style=flat-square)](https://www.codefactor.io/repository/github/fluttercandies/flutter_wechat_assets_picker)
[![GitHub license](https://img.shields.io/github/license/fluttercandies/flutter_wechat_assets_picker?style=flat-square)](https://github.com/fluttercandies/flutter_wechat_assets_picker/blob/master/LICENSE)
<a target="_blank" href="https://jq.qq.com/?_wv=1027&k=5bcc0gy"><img border="0" src="https://pub.idqqimg.com/wpa/images/group.png" alt="FlutterCandies" title="FlutterCandies"></a>

Language: English | [中文简体](README-ZH.md)

An **assets picker** which looks like the one in WeChat, based on `photo_manager` for asset implementation, `extended_image` for image preview, `provider` to help controlling the state of the picker.

To take a photo or a video for assets, please check the detailed usage in the example, and head over to [wechat_camera_picker](https://fluttercandies.github.io/flutter_wechat_camera_picker/) .

## Contributors ✨

Thanks goes to these wonderful people ([emoji key](https://allcontributors.org/docs/en/emoji-key)):
<!-- ALL-CONTRIBUTORS-LIST:START - Do not remove or modify this section -->
<!-- prettier-ignore-start -->
<!-- markdownlint-disable -->
<table>
  <tr>
    <td align="center"><a href="https://blog.alexv525.com"><img src="https://avatars1.githubusercontent.com/u/15884415?v=4" width="50px;" alt=""/><br /><sub><b>Alex Li</b></sub></a><br /><a href="https://github.com/fluttercandies/flutter_wechat_assets_picker/commits?author=AlexV525" title="Code">💻</a> <a href="#design-AlexV525" title="Design">🎨</a> <a href="https://github.com/fluttercandies/flutter_wechat_assets_picker/commits?author=AlexV525" title="Documentation">📖</a> <a href="#example-AlexV525" title="Examples">💡</a> <a href="#ideas-AlexV525" title="Ideas, Planning, & Feedback">🤔</a> <a href="#maintenance-AlexV525" title="Maintenance">🚧</a> <a href="#question-AlexV525" title="Answering Questions">💬</a> <a href="https://github.com/fluttercandies/flutter_wechat_assets_picker/pulls?q=is%3Apr+reviewed-by%3AAlexV525" title="Reviewed Pull Requests">👀</a></td>
    <td align="center"><a href="https://www.kikt.top"><img src="https://avatars0.githubusercontent.com/u/14145407?v=4" width="50px;" alt=""/><br /><sub><b>Caijinglong</b></sub></a><br /><a href="#example-CaiJingLong" title="Examples">💡</a> <a href="#ideas-CaiJingLong" title="Ideas, Planning, & Feedback">🤔</a></td>
    <td align="center"><a href="https://github.com/SchnMar"><img src="https://avatars3.githubusercontent.com/u/12902321?v=4" width="50px;" alt=""/><br /><sub><b>Marcel Schneider</b></sub></a><br /><a href="https://github.com/fluttercandies/flutter_wechat_assets_picker/issues?q=author%3ASchnMar" title="Bug reports">🐛</a> <a href="https://github.com/fluttercandies/flutter_wechat_assets_picker/commits?author=SchnMar" title="Code">💻</a> <a href="#ideas-SchnMar" title="Ideas, Planning, & Feedback">🤔</a></td>
    <td align="center"><a href="https://github.com/ganlanshu0211"><img src="https://avatars0.githubusercontent.com/u/9670379?v=4" width="50px;" alt=""/><br /><sub><b>ganlanshu0211</b></sub></a><br /><a href="https://github.com/fluttercandies/flutter_wechat_assets_picker/issues?q=author%3Aganlanshu0211" title="Bug reports">🐛</a> <a href="#ideas-ganlanshu0211" title="Ideas, Planning, & Feedback">🤔</a></td>
    <td align="center"><a href="https://github.com/JasonHezz"><img src="https://avatars3.githubusercontent.com/u/15358765?v=4" width="50px;" alt=""/><br /><sub><b>JasonHezz</b></sub></a><br /><a href="https://github.com/fluttercandies/flutter_wechat_assets_picker/issues?q=author%3AJasonHezz" title="Bug reports">🐛</a> <a href="https://github.com/fluttercandies/flutter_wechat_assets_picker/commits?author=JasonHezz" title="Code">💻</a></td>
  </tr>
</table>

<!-- markdownlint-enable -->
<!-- prettier-ignore-end -->
<!-- ALL-CONTRIBUTORS-LIST:END -->
This project follows the [all-contributors](https://github.com/all-contributors/all-contributors) specification. Contributions of any kind welcome!

## Category 🗂

* [Features](#features-)
* [Screenshots](#screenshots-)
* [Preparing for use](#preparing-for-use-)
  * [Version constraints](#version-constraints)
  * [Flutter](#flutter)
  * [Android](#android)
  * [iOS](#ios)
  * [MacOS](#macos)
* [Usage](#usage-)
  * [Simple usage](#simple-usage)
  * [Complete param usage](#complete-param-usage)
  * [Register assets change observe callback](#register-assets-change-observe-callback)
* [Classes Introduction](#classes-introduction-)
  * [`AssetEntity`](#assetentity)
* [Frequent asked question](#frequent-asked-question-)
  * [Version resolve conflict with `xxx` (e.g. `dartx`)](#version-resolve-conflict-with-xxx-eg-dartx)
  * [How can I get path from the `AssetEntity` to integrate with `File` object, upload or edit?](#how-can-i-get-path-from-the-assetentity-to-integrate-with-file-object-upload-or-edit)
  * [How can I change the name of "Recent" or other entities name/properties?](#how-can-i-change-the-name-of-recent-or-other-entities-nameproperties)
  * [Create `AssetEntity` from `File` or `Uint8List` (rawData)](#create-assetentity-from-file-or-uint8list-rawdata)
  * [Console warning 'Failed to find GeneratedAppGlideModule'](#glide-warning-failed-to-find-generatedappglidemodule)

## Features ✨

- [x] 💚 99% simillar to WeChat style.
- [x] 📷 Image asset support
  - [x] 🔬HEIC/HEIF Image type support
- [x] 🎥 Video asset support
- [x] 🎶 Audio asset support
- [x] 1️⃣ Single asset mode
- [x] 💱 i18n support
- [x] ➕ Custom item builder (prepend/append) support
- [x] 🗂 Custom sort path delegate support
- [x] 📝 Custom text delegate support
- [x] ⏳ Custom filter options support ( `photo_manager` )
- [x] 🎏 Custom theme entirely
- [x] 💻 MacOS support

## Screenshots 📸

| ![1](https://tva1.sinaimg.cn/large/007S8ZIlgy1ggo5plm5wlj30u01t0zp7.jpg) | ![2](https://tva1.sinaimg.cn/large/007S8ZIlgy1ggo5q69848j30u01t04o5.jpg) | ![3](https://tva1.sinaimg.cn/large/007S8ZIlgy1ggo5q60v9qj30u01t07vh.jpg) |
| ------------------------------------------------------------ | ------------------------------------------------------------ | ------------------------------------------------------------ |
| ![4](https://tva1.sinaimg.cn/large/007S8ZIlgy1ggo5q5qe7jj30u01t04qp.jpg) | ![5](https://tva1.sinaimg.cn/large/007S8ZIlgy1ggo5q5jobgj30u01t0ngi.jpg) | ![6](https://tva1.sinaimg.cn/large/007S8ZIlgy1ggo5q5cebej30u01t04a0.jpg) |
| ![7](https://tva1.sinaimg.cn/large/007S8ZIlgy1ggo5q56xuhj30u01t077a.jpg) | ![8](https://tva1.sinaimg.cn/large/007S8ZIlgy1ggo5q50otnj30u01t0kjf.jpg) | ![9](https://tva1.sinaimg.cn/large/007S8ZIlgy1ggo5q4o7x5j30u01t0e81.jpg) |

## READ THIS FIRST ‼️

Althought the package provide selection for assets, it still require users build their own methods to handle display/upload, etc. If you have any question about how to build it, please run the example or refer to [photo_manager](https://github.com/CaiJingLong/flutter_photo_manager) for API usage.

## Preparing for use 🍭

### Version constraints

Flutter SDK: `>=1.17.0` .

If you got an error about `resolve conflict` when running `flutter pub get` , please use `dependency_overrides` to solve it. See [here](#version-resolve-conflict-with-xxx-eg-dartx) .

### Flutter

Add `wechat_assets_picker` to `pubspec.yaml` dependencies.
```yaml
dependencies:
  wechat_assets_picker: ^latest_version
```

The latest **stable** version is: [![pub package](https://img.shields.io/pub/v/wechat_assets_picker?logo=dart&label=stable&style=flat-square)](https://pub.dev/packages/wechat_assets_picker)

The latest **dev** version is: [![pub package](https://img.shields.io/pub/v/wechat_assets_picker?color=42a012&include_prereleases&label=dev&logo=dart&style=flat-square)](https://pub.dev/packages/wechat_assets_picker)

Then import the package in your code:
```dart
import 'package:wechat_assets_picker/wechat_assets_picker.dart';
```

### Android

Required permissions: `INTERNET`, `READ_EXTERNAL_STORAGE`, `WRITE_EXTERNAL_STORAGE`, `ACCESS_MEDIA_LOCATION`.

If you found some warning logs with `Glide` appearing, then the main project needs an implementation of `AppGlideModule`. 
See [Generated API](https://sjudd.github.io/glide/doc/generatedapi.html).

### iOS

1. Define the minimum platform in `ios/Podfile` upper to *9.0*.
```
platform :ios, '9.0'
```

2. Add following content to `info.plist`.

```
<key>NSAppTransportSecurity</key>
<dict>
	<key>NSAllowsArbitraryLoads</key>
	<true/>
</dict>
<key>NSPhotoLibraryUsageDescription</key>
<string>Replace with your permission description.</string>
```

### MacOS

Currently flutter desktop is still under development, so please be aware that any issues releated to the desktop version is not yet supported.

1. Define the minimum platform in `macos/Podfile` upper to *10.15*.
```
platform :osx, '10.15'
```

2. Use *Xcode* to open the `macos/Runner.xcworkspace`. Then follow screenshots to setup the minumum target version upper to *10.15*.

3. ![step 1](https://tva1.sinaimg.cn/large/007S8ZIlgy1ghw67v4yk4j30qy0b50u0.jpg)

4. ![step 2](https://tva1.sinaimg.cn/large/007S8ZIlgy1ghw67vd3f2j30jv04zgm5.jpg)

5. Add the same thing as iOS does into `info.plist`.

## Usage 📖

| Name               | Type                       | Description                                                  | Default                             |
| ------------------ | -------------------------- | ------------------------------------------------------------ | ----------------------------------- |
| maxAssets          | `int`                      | Maximum asset that the picker can pick.                      | 9                                   |
| pageSize           | `int`                      | Assets amount when assets loaded with paging. **Must be a multiple of `gridCount`.** Nullable for non paging. | 320 (80 * 4)                        |
| pathThumbSize      | `int`                      | The size of thumb data in picker.                            | 80                                  |
| gridCount          | `int`                      | Grid count in picker.                                        | 4                                   |
| previewThumbSize   | `List<int>`                | Thumb size for the preview of images in the viewer.          | `null`                              |
| requestType        | `RequestType`              | Request type for picker.                                     | `RequestType.image`                 |
| specialPickerType  | `SpacialPickerType`        | Provide some special picker types to integrate un-common pick pattern. | `null`                              |
| selectedAssets     | `List<AssetEntity>`        | Selected assets. Prevent duplicate selection. If you don't need to prevent duplicate selection, just don't pass it. | `null`                              |
| themeColor         | `Color`                    | Main theme color for the picker                              | `Color(0xff00bc56)`                 |
| pickerTheme        | `ThemeData`                | Theme data provider for the picker and the viewer.           | `null`                              |
| sortPathDelegate   | `SortPathDeleage`          | Path entities sort delegate for the picker, sort paths as you want. | `CommonSortPathDelegate`            |
| textDelegate       | `AssetsPickerTextDelegate` | Text delegate for the picker, for customize the texts.       | `DefaultAssetsPickerTextDelegate()` |
| filterOptions      | `FilterOptionGroup`        | Allow users to customize assets filter options.              | `null`                              |
| customItemBuilder  | `WidgetBuilder`            | The widget builder for the custom item.                      | `null`                              |
| customItemPosition | `CustomItemPosition`       | Allow users set custom item in the picker with several positions. | `CustomItemPosition.none`           |
| routeCurve         | `Curve`                    | The curve which the picker use to build page route transition. | `Curves.easeIn`                     |
| routeDuration      | `Duration`                 | The duration which the picker use to build page route transition. | `const Duration(milliseconds: 500)` |

### Simple usage

```dart
final List<AssetEntity> assets = await AssetPicker.pickAssets(context);
```

or

```dart
AssetPicker.pickAsset(context).then((List<AssetEntity> assets) {
  /.../
});
```

### Complete param usage

For various type of the picker, head over to the example and run it with no doubt.

### Register assets change observe callback
```dart
AssetPicker.registerObserve(); // Register callback.
```
```dart
AssetPicker.unregisterObserve(); // Unregister callback.
```

## Classes Introduction 💭

### `AssetEntity`

```dart
/// Android: Database _id column
/// iOS    : `PhotoKit > PHObject > localIdentifier`
String id;

/// Android: `MediaStore.MediaColumns.DISPLAY_NAME`
/// iOS    : `PHAssetResource.filename`. Nullable
/// If you must need it, See [FilterOption.needTitle] or use [titleAsync].
String title;

/// Android: title
/// iOS    : [PHAsset valueForKey:@"filename"]
Future<String> get titleAsync;

/// * 1: [AssetType.image]
/// * 2: [AssetType.video]
/// * 3: [AssetType.audio]
/// * default: [AssetType.other]
AssetType get type;

/// Asset type int value.
int typeInt;

/// Duration of video, the unit is second.
/// If [type] is [AssetType.image], then it's value is 0.
/// See also: [videoDuration].
int duration;

/// Width of the asset.
int width;

/// Height of the asset.
int height;

/// Location information when shooting. Nullable.
/// When the device is Android 10 or above, it's ALWAYS null.
/// See also: [longitude].
double get latitude => _latitude ?? 0;
/// Also with a setter.

/// Get lat/lng from `MediaStore`(Android) / `Photos`(iOS).
/// In Android Q, this comes from EXIF.
Future<LatLng> latlngAsync();

/// Get [File] object.
/// Notice that this is not the origin file, so when it comes to some
/// scene like reading a GIF's file, please use `originFile`, or you'll
/// get a JPG.
Future<File> get file async;

/// Get the original [File] object.
Future<File> get originFile async;

/// The raw data for the entity, it may be large.
/// This property is NOT RECOMMENDED for video assets.
Future<Uint8List> get originBytes;

/// The thumbnail data for the entity. Usually use for displaying a thumbnail image widget.
Future<Uint8List> get thumbData;

/// Get thumbnail data with specific size.
Future<Uint8List> thumbDataWithSize(
  int width,
  int height, {
  ThumbFormat format = ThumbFormat.jpeg,
  int quality = 100,
});

/// Get the asset's size. Nullable if the manager is null,
Size get size;

/// If the asset is deleted, return false.
Future<bool> get exists => PhotoManager._assetExistsWithId(id);

/// The url is provided to some video player. Such as [flutter_ijkplayer](https://pub.dev/packages/flutter_ijkplayer)
///
/// Android: `content://media/external/video/media/894857`
/// iOS    : `file:///var/mobile/Media/DCIM/118APPLE/IMG_8371.MOV` in iOS.
Future<String> getMediaUrl();

/// Refresh the properties for the entity.
Future<AssetEntity> refreshProperties() async;
```

## Frequent asked question ❔

### Version resolve conflict with `xxx` (e.g. `dartx`)

For some reasons `dartx` or other packages may require a different version than yours. If you're facing this issue, and the error looks like:

```
Because dartx >=0.2.0 <0.5.0 depends on collection >=1.14.11 <1.15.0 and every version of flutter from sdk depends on collection 1.15.0-nullsafety, dartx >=0.2.0 <0.5.0 is incompatible with flutter from sdk.
So, because wechat_assets_picker_demo depends on both flutter any from sdk and dartx ^0.4.2, version solving failed.
```

Please add the code below to make it work.

```yaml
dependency_overrides:
  dartx: ^0.4.2
```

### How can I get path from the `AssetEntity` to integrate with `File` object, upload or edit?

You don't need it (might be).

You can always request the `File` object with `entity.originFile`, if `Uint8List` then `entity.originBytes`.

If you still needs path after requested the `File`, get it through `file.absolutePath`.

### How can I change the name of "Recent" or other entities name/properties?

The path entity called "Recent", brought by `photo_manager` in the path entities list, includes all `AssetEntity` on your device. "Recent" is a system named entity in most of platforms. While we provided ability to customize the text delegate, the name/properties can only be updated with `SortPathDelegate` . This is the only way that you have access to all path entities, or the only way that we exposed currently.

To change the name of the path entity, extend the `SortPathDelegate` with your own delegate, then write something like the code below:

```dart
/// Create your own sort path delegate.
class CustomSortPathDelegate extends SortPathDelegate {
  const CustomSortPathDelegate();

  @override
  void sort(List<AssetPathEntity> list) {
    ///...///

    // In here you can check every path entities if you want.
    // The only property we recommend to change is [name],
    // And we have no responsibility for issues caused by
    // other properties update.
    for (final AssetPathEntity entity in list) {
      // If the entity `isAll`, that's the "Recent" entity you want.
      if (entity.isAll) {
        entity.name = 'Whatever you want';
      }
    }

    ///...///
  }
}
```

Pass the delegate through the static call method, then you will get a self-named path entity.

### Create `AssetEntity` from `File` or `Uint8List` (rawData)

In order to combine this package with camera shooting or something related, there's a solution about how to create an `AssetEntity` with `File` or `Uint8List` object.

```dart
final File file = your_file; // Your file object
final Uint8List byteData = await file.readAsBytes(); // Convert to Uint8List
final AssetEntity imageEntity = await PhotoManager.editor.saveImage(byteData); // Saved in the device then create an AssetEntity
```

If you don't want to keep the asset in your device, just delete it after you complete with your process (upload, editing, etc).

```dart
final List<String> result = await PhotoManager.editor.deleteWithIds([entity.id]);
```

ref: [flutter_photo_manager#insert-new-item](https://github.com/CaiJingLong/flutter_photo_manager#insert-new-item)

### Glide warning 'Failed to find GeneratedAppGlideModule'

```
W/Glide   (21133): Failed to find GeneratedAppGlideModule. You should include an annotationProcessor complie dependency on com.github.bumptech.glide:compiler in you application ana a @GlideModule annotated AppGlideModule implementation or LibraryGlideModules will be silently ignored.
```

`Glide` needs annotation to keep singleton, prevent conflict between instances and versions, so while the photo manager uses `Glide` to implement image features, the project which import this should define its own `AppGlideModule`. See [Android](#android) section for implementation.
