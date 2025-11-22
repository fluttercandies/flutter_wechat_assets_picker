<!-- Copyright 2019 The FlutterCandies author. All rights reserved.
Use of this source code is governed by an Apache license
that can be found in the LICENSE file. -->

# Flutter WeChat Assets Picker

[![pub package](https://img.shields.io/pub/v/wechat_assets_picker?logo=dart&label=stable&style=flat-square)](https://pub.dev/packages/wechat_assets_picker)
[![pub package](https://img.shields.io/pub/v/wechat_assets_picker?color=9d00ff&include_prereleases&label=dev&logo=dart&style=flat-square)](https://pub.dev/packages/wechat_assets_picker)
[![CodeFactor](https://img.shields.io/codefactor/grade/github/fluttercandies/flutter_wechat_assets_picker?logo=codefactor&logoColor=%23ffffff&style=flat-square)](https://www.codefactor.io/repository/github/fluttercandies/flutter_wechat_assets_picker)

[![Build status](https://img.shields.io/github/actions/workflow/status/fluttercandies/flutter_wechat_assets_picker/runnable.yml?branch=main&label=CI&logo=github&style=flat-square)](https://github.com/fluttercandies/flutter_wechat_assets_picker/actions/workflows/runnable.yml)
[![GitHub license](https://img.shields.io/github/license/fluttercandies/flutter_wechat_assets_picker?style=flat-square)](https://github.com/fluttercandies/flutter_wechat_assets_picker/blob/main/LICENSE)
[![GitHub stars](https://img.shields.io/github/stars/fluttercandies/flutter_wechat_assets_picker?logo=github&style=flat-square)](https://github.com/fluttercandies/flutter_wechat_assets_picker/stargazers)
[![GitHub forks](https://img.shields.io/github/forks/fluttercandies/flutter_wechat_assets_picker?logo=github&style=flat-square)](https://github.com/fluttercandies/flutter_wechat_assets_picker/network)

[![Awesome Flutter](https://cdn.rawgit.com/sindresorhus/awesome/d7305f38d29fed78fa85652e3a63e154dd8e8829/media/badge.svg)](https://github.com/Solido/awesome-flutter)
<a href="https://qm.qq.com/q/ZyJbSVjfSU"><img src="https://img.shields.io/badge/dynamic/yaml?url=https%3A%2F%2Fraw.githubusercontent.com%2Ffluttercandies%2F.github%2Frefs%2Fheads%2Fmain%2Fdata.yml&query=%24.qq_group_number&label=QQ%E7%BE%A4&logo=qq&style=flat&color=1DACE8" /></a>

Language: English | [中文](README-ZH.md)

An **image picker (also with videos and audios)**
for Flutter projects based on the WeChat's UI.

Current WeChat version that UI based on: **8.0.51**
UI designs will be updated following the WeChat update in anytime.

To take a photo or a video for assets,
please check the detailed usage in the example,
and head over to [wechat_camera_picker][wechat_camera_picker pub].
The package is a standalone extension that can to be used with combination.

See the [Migration Guide][] to learn how to migrate between breaking changes.

## Versions compatibility

The package only guarantees to be working on **the stable version of Flutter**.
We won't update it in real-time to align with other channels of Flutter.

|         | 3.10 | 3.13 | 3.16 | 3.22 | 3.27 |
|---------|:----:|:----:|:----:|:----:|:----:|
| 10.0.0+ |  ❌   |  ❌   |  ❌   |  ❌   |  ✅   |
| 9.5.0+  |  ❌   |  ❌   |  ❌   |  ✅   |  ✅   |
| 8.9.0+  |  ❌   |  ❌   |  ✅   |  ❌   |  ❌   |
| 8.7.0+  |  ❌   |  ✅   |  ❌   |  ❌   |  ❌   |
| 8.5.0+  |  ✅   |  ❌   |  ❌   |  ❌   |  ❌   |

If you got a `resolve conflict` error when running `flutter pub get`,
please use `dependency_overrides` to fix it.

## Package credits

The package is built from these wonderful packages.

| Name                                 | Features                                             |
|:-------------------------------------|:-----------------------------------------------------|
| [photo_manager][photo_manager pub]   | The basic abstractions and management for assets.    |
| [extended_image][extended_image pub] | Preview assets with expected behaviors.              |
| [provider][provider pub]             | Helps to manage the interaction state of the picker. |
| [video_player][video_player pub]     | Plays videos and audios correspondingly.             |
 
Their implementation should be relatively stable in the package.
If you've found any issues related to them when using the picker,
submit issues to our issue tracker first.

<details>
  <summary>Table of content</summary>

<!-- TOC -->
* [Flutter WeChat Assets Picker](#flutter-wechat-assets-picker)
  * [Versions compatibility](#versions-compatibility)
  * [Package credits](#package-credits)
  * [Features ✨](#features-)
    * [Notes 📝](#notes-)
  * [Projects using this plugin 🖼️](#projects-using-this-plugin-)
  * [Screenshots 📸](#screenshots-)
  * [READ THIS FIRST ‼️](#read-this-first-)
  * [Preparing for use 🍭](#preparing-for-use-)
    * [Flutter](#flutter)
    * [Android](#android)
      * [Permissions](#permissions)
    * [iOS](#ios)
    * [macOS](#macos)
  * [Usage 📖](#usage-)
    * [Localizations](#localizations)
    * [Simple usage](#simple-usage)
    * [Detailed usage](#detailed-usage)
      * [Display selected assets](#display-selected-assets)
      * [Register assets change observe callback](#register-assets-change-observe-callback)
      * [Upload an `AssetEntity` with a form data](#upload-an-assetentity-with-a-form-data)
        * [With `http`](#with-http)
        * [With `dio`](#with-dio)
    * [Custom pickers](#custom-pickers)
  * [Frequently asked question ❔](#frequently-asked-question-)
    * [Changing the default album name (`Recent` to others)](#changing-the-default-album-name-recent-to-others)
    * [Execution failed for task ':photo_manager:compileDebugKotlin'](#execution-failed-for-task-photo_managercompiledebugkotlin)
    * [Create `AssetEntity` from `File` or `Uint8List` (rawData)](#create-assetentity-from-file-or-uint8list-rawdata)
    * [Glide warning 'Failed to find GeneratedAppGlideModule'](#glide-warning-failed-to-find-generatedappglidemodule)
  * [Contributors ✨](#contributors-)
  * [Credits](#credits)
<!-- TOC -->
</details>

## Features ✨

- ♿ Complete a11y support with _TalkBack_ and _VoiceOver_
- ♻️ Fully customizable with delegates override
- 🎏 Fully customizable theme based on `ThemeData`
- 💚 Completely WeChat style (even more)
- ⚡️ Adjustable performance with different configurations
- 📷 Image support
  - 🔬 HEIF Image type support <a href="#notes-"><sup>(1)</sup></a>
- 🎥 Video support
- 🎶 Audio support <a href="#notes-"><sup>(2)</sup></a>
- 1️⃣ Single picking mode
- 💱 Internationalization (i18n) support
  - ⏪ RTL language support
- ➕ Special item builder support
- 🗂 Custom sort path delegate support
- 📝 Custom text delegate support
- ⏳ Custom filter options support
- 💻 macOS support

### Notes 📝

1. HEIF (HEIC) images are support to obtain and conversion,
   but the display with them are based on Flutter's image decoder.
   See [flutter/flutter#20522](https://github.com/flutter/flutter/issues/20522).
   Use `entity.file` or `AssetEntityImage` for them when displays.
2. Due to limitations on iOS and macOS, audio can only be fetched within the sandbox.

## Projects using this plugin 🖼️

| name                | pub                                                                                                              | github                                                                                                                                        |
|:--------------------|:-----------------------------------------------------------------------------------------------------------------|:----------------------------------------------------------------------------------------------------------------------------------------------|
| insta_assets_picker | [![pub package](https://img.shields.io/pub/v/insta_assets_picker)](https://pub.dev/packages/insta_assets_picker) | [![star](https://img.shields.io/github/stars/LeGoffMael/insta_assets_picker?style=social)](https://github.com/LeGoffMael/insta_assets_picker) |

## Screenshots 📸

| ![1](screenshots/README_1.webp)   | ![2](screenshots/README_2.webp)   | ![3](screenshots/README_3.webp)   |
|-----------------------------------|-----------------------------------|-----------------------------------|
| ![4](screenshots/README_4.webp)   | ![5](screenshots/README_5.webp)   | ![6](screenshots/README_6.webp)   |
| ![7](screenshots/README_7.webp)   | ![8](screenshots/README_8.webp)   | ![9](screenshots/README_9.webp)   |
| ![10](screenshots/README_10.webp) | ![11](screenshots/README_11.webp) | ![12](screenshots/README_12.webp) |

## READ THIS FIRST ‼️

Be aware of below notices before you started anything:
- Due to understanding differences and the limitation of a single document,
  documents will not cover all the contents.
  If you find nothing related to your expected features and cannot understand about concepts,
  run the example project and check every options first.
  It has covered 90% of regular requests with the package.
- The package deeply integrates with the [photo_manager][photo_manager pub] plugin,
  make sure you understand these two concepts as much as possible:
  - Asset (photos/videos/audio) - [`AssetEntity`](https://pub.dev/documentation/photo_manager/latest/photo_manager/AssetEntity-class.html)
  - Assets collection (albums/libraries) - [`AssetPathEntity`](https://pub.dev/documentation/photo_manager/latest/photo_manager/AssetPathEntity-class.html)

When you have questions about related APIs and behaviors,
check [photo_manager's API docs][] for more details.

Most usages are detailed covered by the [example](example).
Please walk through the [example](example) carefully
before you have any questions.

## Preparing for use 🍭

### Flutter

Run `flutter pub add wechat_assets_picker`,
or add `wechat_assets_picker` to `pubspec.yaml` dependencies manually.
```yaml
dependencies:
  wechat_assets_picker: ^latest_version
```

The latest **stable** version is:
[![pub package](https://img.shields.io/pub/v/wechat_assets_picker?logo=dart&label=stable&style=flat-square)](https://pub.dev/packages/wechat_assets_picker)

The latest **dev** version is:
[![pub package](https://img.shields.io/pub/v/wechat_assets_picker?color=9d00ff&include_prereleases&label=dev&logo=dart&style=flat-square)](https://pub.dev/packages/wechat_assets_picker)

Then import the package in your code:
```dart
import 'package:wechat_assets_picker/wechat_assets_picker.dart';
```

### Android

When using the package, please upgrade
`targetSdkVersion` and `compileSdkVersion` to `33`.
Otherwise, no assets can be fetched on Android 13.

#### Permissions

| Name                     | Required | Declared | Max API Level | Others                       |
|--------------------------|----------|----------|---------------|------------------------------|
| `READ_EXTERNAL_STORAGE`  | YES      | YES      | 32            |                              |
| `WRITE_EXTERNAL_STORAGE` | NO       | NO       | 29            |                              |
| `ACCESS_MEDIA_LOCATION`  | YES*     | NO       | N/A           | Required when reading EXIF   |
| `READ_MEDIA_IMAGES`      | YES*     | YES      | N/A           | Required when reading images | 
| `READ_MEDIA_VIDEO`       | YES*     | YES      | N/A           | Required when reading videos | 
| `READ_MEDIA_AUDIO`       | YES*     | YES      | N/A           | Required when reading audios | 

If you're targeting Android SDK 33+,
and you don't need to load photos, videos or audios,
consider declare only relevant permission in your apps, more specifically:

```xml
<manifest xmlns:android="http://schemas.android.com/apk/res/android"
    xmlns:tools="http://schemas.android.com/tools"
    package="com.your.app">
    <!--Requesting access to images and videos.-->
    <uses-permission android:name="android.permission.READ_MEDIA_IMAGES" />
    <uses-permission android:name="android.permission.READ_MEDIA_VIDEO" />
    <!--When your app has no need to access audio, remove it or comment it out.-->
    <!--<uses-permission android:name="android.permission.READ_MEDIA_AUDIO" />-->
</manifest>
```

### iOS

1. Platform version has to be at least *11.0*.
   Modify `ios/Podfile` and update accordingly.
   ```Podfile
   platform :ios, '11.0'
   ```
   Remove the `#` heading if the line starts with it.
2. Add the following content to `Info.plist`.
```
<key>NSPhotoLibraryUsageDescription</key>
<string>Replace with your permission description.</string>
```

### macOS

1. Platform version has to be at least *10.15*.
   Modify `macos/Podfile` and update accordingly.
   ```ruby
   platform :osx, '10.15'
   ```
   Remove the `#` heading if the line starts with it.
2. Set the minimum deployment target of the macOS to *10.15*.
   Use XCode to open `macos/Runner.xcworkspace` .
3. Follow the [iOS](#iOS) instructions and modify `Info.plist` accordingly.

## Usage 📖

### Localizations

When you're picking assets, the package will obtain the `Locale?`
from your `BuildContext`, and return the corresponding text delegate
of the current language.
Make sure you have a valid `Locale` in your widget tree that can be accessed
from the `BuildContext`. **Otherwise, the default Chinese delegate will be used.**

Embedded text delegates languages are:
* 简体中文 (default)
* English
* העברית
* Deutsche
* Локализация
* 日本語
* مة العربية
* Délégué
* Tiếng Việt
* Türkçe Yerelleştirme

If you want to use a custom/fixed text delegate, pass it through the
`AssetPickerConfig.textDelegate`.

### Simple usage

```dart
final List<AssetEntity>? result = await AssetPicker.pickAssets(context);
```

Use `AssetPickerConfig` for more picking behaviors.

```dart
final List<AssetEntity>? result = await AssetPicker.pickAssets(
  context,
  pickerConfig: const AssetPickerConfig(),
);
```

Fields in `AssetPickerConfig`:

| Name                              | Type                                             | Description                                                                                    | Default                     |
|-----------------------------------|--------------------------------------------------|------------------------------------------------------------------------------------------------|-----------------------------|
| selectedAssets                    | `List<AssetEntity>?`                             | Selected assets. Prevent duplicate selection.                                                  | `null`                      |
| maxAssets                         | `int`                                            | Maximum asset that the picker can pick.                                                        | 9                           |
| pageSize                          | `int?`                                           | Number of assets per page. **Must be a multiple of `gridCount`**.                              | 80                          |
| gridThumbnailSize                 | `ThumbnailSize`                                  | Thumbnail size for the grid's item.                                                            | `ThumbnailSize.square(200)` |
| pathThumbnailSize                 | `ThumbnailSize`                                  | Thumbnail size for the path selector.                                                          | `ThumbnailSize.square(80)`  |
| previewThumbnailSize              | `ThumbnailSize?`                                 | Preview thumbnail size in the viewer.                                                          | `null`                      |
| requestType                       | `RequestType`                                    | Request type for picker.                                                                       | `RequestType.common`        |
| specialPickerType                 | `SpecialPickerType?`                             | Provides the option to integrate a custom picker type.                                         | `null`                      |
| keepScrollOffset                  | `bool`                                           | Whether the picker should save the scroll offset between pushes and pops.                      | `null`                      |
| sortPathDelegate                  | `SortPathDelegate<AssetPathEntity>?`             | Path entities sort delegate for the picker, sort paths as you want.                            | `CommonSortPathDelegate`    |
| sortPathsByModifiedDate           | `bool`                                           | Whether to allow sort delegates to sort paths with `FilterOptionGroup.containsPathModified`.   | `false`                     |
| filterOptions                     | `PMFilter?`                                      | Allow users to customize assets filter options.                                                | `null`                      |
| gridCount                         | `int`                                            | Grid count in picker.                                                                          | 4                           |
| themeColor                        | `Color?`                                         | Main theme color for the picker.                                                               | `Color(0xff00bc56)`         |
| pickerTheme                       | `ThemeData?`                                     | Theme data provider for the picker and the viewer.                                             | `null`                      |
| textDelegate                      | `AssetPickerTextDelegate?`                       | Text delegate for the picker, for customize the texts.                                         | `AssetPickerTextDelegate()` |
| specialItems                      | `List<SpecialItem>`                              | List of special items.                                                                         | `const <SpecialItem>[]`     |
| loadingIndicatorBuilder           | `IndicatorBuilder?`                              | Indicates the loading status for the builder.                                                  | `null`                      |
| selectPredicate                   | `AssetSelectPredicate`                           | Predicate whether an asset can be selected or unselected.                                      | `null`                      |
| shouldRevertGrid                  | `bool?`                                          | Whether the assets grid should revert.                                                         | `null`                      |
| limitedPermissionOverlayPredicate | `LimitedPermissionOverlayPredicate?`             | Predicate whether the limited permission overlay should be displayed.                          | `null`                      |
| pathNameBuilder                   | `PathNameBuilder<AssetPathEntity>?`              | Build customized path (album) name with the given path entity.                                 | `null`                      |
| assetsChangeCallback              | `AssetsChangeCallback<AssetPathEntity>?`         | The callback that will be called when the system notifies assets changes.                      | `null`                      |
| assetsChangeRefreshPredicate      | `AssetsChangeRefreshPredicate<AssetPathEntity>?` | Whether assets changing should call refresh with the given call and the current selected path. | `null`                      |
| shouldAutoPlayPreview             | `bool`                                           | Whether the preview should auto play.                                                          | `false`                     |
| dragToSelect                      | `bool`                                           | Whether assets selection can be done with drag gestures.                                       | `true`                      |
| enableLivePhoto                   | `bool`                                           | Whether to enable Live-Photo functionality in the picker.                                      | `true`                      |

- When `maxAssets` equals to `1` (a.k.a. single picking mode),
  use `SpecialPickerType.noPreview` will immediately select asset
  clicked (pressed) by the user and popped.
- `limitedPermissionOverlayPredicate` lives without persistence,
  if you want to ignore the limited preview after restart,
  you'll need to integrate with your own saving methods.

### Detailed usage

We've put multiple common usage
with the packages in the [example](example).
You can both found `List<PickMethod> pickMethods` in
[here](example/lib/pages/multi_assets_page.dart)
and [here](example/lib/pages/single_assets_page.dart),
which provide methods in multiple picking and single picking mode.
Assets will be stored temporary and displayed at the below of the page.

#### Display selected assets

The `AssetEntityImage` and `AssetEntityImageProvider`
can display the thumb image of _images & videos_,
and the original data of _image_.
Use it like a common `Image` and `ImageProvider`.

```dart
AssetEntityImage(asset, isOriginal: false);
```

Or:

```dart
Image(image: AssetEntityImageProvider(asset, isOriginal: false));
```

#### Register assets change observe callback

```dart
// Register callback.
AssetPicker.registerObserve();

// Unregister callback.
AssetPicker.unregisterObserve();
```

#### Upload an `AssetEntity` with a form data

There are multiple ways to upload an `AssetEntity` with I/O related methods.
**Be aware, I/O related methods will consume performance
(typically time and memory), they should not be called frequently.**

##### With `http`

`http` package: https://pub.dev/packages/http

The `http` package uses
[`MultipartFile`](https://pub.dev/documentation/http/latest/http/MultipartFile-class.html)
to handle files in requests.

Pseudo code:
```dart
import 'package:http/http.dart' as http;

Future<void> upload() async {
  final entity = await obtainYourEntity();
  final uri = Uri.https('example.com', 'create');
  final request = http.MultipartRequest('POST', uri)
    ..fields['test_field'] = 'test_value'
    ..files.add(await multipartFileFromAssetEntity(entity));
  final response = await request.send();
  if (response.statusCode == 200) {
    print('Uploaded!');
  }
}

Future<http.MultipartFile> multipartFileFromAssetEntity(AssetEntity entity) async {
  http.MultipartFile mf;
  // Using the file path.
  final file = await entity.file;
  if (file == null) {
    throw StateError('Unable to obtain file of the entity ${entity.id}.');
  }
  mf = await http.MultipartFile.fromPath('test_file', file.path);
  // Using the bytes.
  final bytes = await entity.originBytes;
  if (bytes == null) {
    throw StateError('Unable to obtain bytes of the entity ${entity.id}.');
  }
  mf = http.MultipartFile.fromBytes('test_file', bytes);
  return mf;
}
```

##### With `dio`

`dio` package: https://pub.dev/packages/dio

The `dio` package also uses
[`MultipartFile`](https://pub.dev/documentation/dio/latest/dio/MultipartFile-class.html)
to handle files in requests.

Pseudo code:
```dart
import 'package:dio/dio.dart' as dio;

Future<void> upload() async {
  final entity = await obtainYourEntity();
  final uri = Uri.https('example.com', 'create');
  final response = dio.Dio().requestUri(
    uri,
    data: dio.FormData.fromMap({
      'test_field': 'test_value',
      'test_file': await multipartFileFromAssetEntity(entity),
    }),
  );
  print('Uploaded!');
}

Future<dio.MultipartFile> multipartFileFromAssetEntity(AssetEntity entity) async {
  dio.MultipartFile mf;
  // Using the file path.
  final file = await entity.file;
  if (file == null) {
    throw StateError('Unable to obtain file of the entity ${entity.id}.');
  }
  mf = await dio.MultipartFile.fromFile(file.path);
  // Using the bytes.
  final bytes = await entity.originBytes;
  if (bytes == null) {
    throw StateError('Unable to obtain bytes of the entity ${entity.id}.');
  }
  mf = dio.MultipartFile.fromBytes(bytes);
  return mf;
}
```

### Custom pickers

`AssetPickerBuilderDelegate`, `AssetPickerViewerBuilderDelegate`,
`AssetPickerProvider` and `AssetPickerViewerProvider`
are all exposed and overridable.
You can extend them and use your own
type with generic type `<A: Asset, P: Path>`,
then implement abstract methods.

To know about how to fully customize themes, widgets or layouts.
See how to customize delegates in the custom pickers page in the
[example](example/lib/customs/pickers).

You can submit PRs to create your own implementation
if you found your implementation might be useful for others.
See [Contribute custom implementations][] for more details.

## Frequently asked question ❔

### Changing the default album name (`Recent` to others)

`Recent` is the fix album name for the ALL assets on Android
since the all assets' album is not an actual album, it only represents all media data records.

To solve that on Android, use `pathNameBuilder`, for example:
```dart
AssetPickerConfig(
  pathNameBuilder: (AssetPathEntity path) => switch (path) {
    final p when p.isAll => '最近',
    // You can apply similar conditions to other common paths.
    _ => path.name,
  },
)
```

Other albums or albums on other platforms (iOS/macOS) will follow
the configured system localization and supported localizations.
`pathNameBuilder` is available for all albums.

### Execution failed for task ':photo_manager:compileDebugKotlin'

See [photo_manager#561][] for more details.

### Create `AssetEntity` from `File` or `Uint8List` (rawData)

In order to combine this package with camera shooting or something related,
there's a solution about how to create an `AssetEntity`
with `File` or `Uint8List` object.

```dart
final File file = your_file; // Your `File` object
final String path = file.path;
final AssetEntity fileEntity = await PhotoManager.editor.saveImageWithPath(
  path,
  title: basename(path),
); // Saved in the device then create an AssetEntity

final Uint8List data = your_data; // Your `Uint8List` object
final AssetEntity imageEntity = await PhotoManager.editor.saveImage(
  file.path,
  title: 'title_with_extension.jpg',
); // Saved in the device then create an AssetEntity
```

**Notice: If you don't want to keep the file in your device,
use `File` for operations as much as possible.**
Deleting an `AssetEntity` might cause system popups show:

```dart
final List<String> result = await PhotoManager.editor.deleteWithIds(
  <String>[entity.id],
);
```

See [photo_manager#from-raw-data][]
and [photo_manager#delete-entities][]
for more details.

### Glide warning 'Failed to find GeneratedAppGlideModule'

```
W/Glide   (21133): Failed to find GeneratedAppGlideModule. 
                   You should include an annotationProcessor compile dependency on com.github.bumptech.glide:compiler
                   in you application ana a @GlideModule annotated AppGlideModule implementation
                   or LibraryGlideModules will be silently ignored.
```

`Glide` needs annotation to keep singleton,
prevent conflict between instances and versions,
so while the photo manager uses `Glide` to implement image features,
the project which import this should define its own `AppGlideModule`.
See [Glide Generated API docs][] for implementation.

## Contributors ✨

Many thanks to these wonderful people ([emoji key](https://allcontributors.org/docs/en/emoji-key)):
<!-- ALL-CONTRIBUTORS-LIST:START - Do not remove or modify this section -->
<!-- prettier-ignore-start -->
<!-- markdownlint-disable -->
<table>
  <tbody>
    <tr>
      <td align="center" valign="top" width="14.28%"><a href="https://blog.alexv525.com"><img src="https://avatars1.githubusercontent.com/u/15884415?v=4?s=50" width="50px;" alt="Alex Li"/><br /><sub><b>Alex Li</b></sub></a><br /><a href="https://github.com/fluttercandies/flutter_wechat_assets_picker/commits?author=AlexV525" title="Code">💻</a> <a href="#design-AlexV525" title="Design">🎨</a> <a href="https://github.com/fluttercandies/flutter_wechat_assets_picker/commits?author=AlexV525" title="Documentation">📖</a> <a href="#example-AlexV525" title="Examples">💡</a> <a href="#ideas-AlexV525" title="Ideas, Planning, & Feedback">🤔</a> <a href="#maintenance-AlexV525" title="Maintenance">🚧</a> <a href="#question-AlexV525" title="Answering Questions">💬</a> <a href="https://github.com/fluttercandies/flutter_wechat_assets_picker/pulls?q=is%3Apr+reviewed-by%3AAlexV525" title="Reviewed Pull Requests">👀</a> <a href="#a11y-AlexV525" title="Accessibility">️️️️♿️</a> <a href="#translation-AlexV525" title="Translation">🌍</a></td>
      <td align="center" valign="top" width="14.28%"><a href="https://www.kikt.top"><img src="https://avatars0.githubusercontent.com/u/14145407?v=4?s=50" width="50px;" alt="Caijinglong"/><br /><sub><b>Caijinglong</b></sub></a><br /><a href="#example-CaiJingLong" title="Examples">💡</a> <a href="#ideas-CaiJingLong" title="Ideas, Planning, & Feedback">🤔</a></td>
      <td align="center" valign="top" width="14.28%"><a href="https://github.com/SchnMar"><img src="https://avatars3.githubusercontent.com/u/12902321?v=4?s=50" width="50px;" alt="Marcel Schneider"/><br /><sub><b>Marcel Schneider</b></sub></a><br /><a href="https://github.com/fluttercandies/flutter_wechat_assets_picker/issues?q=author%3ASchnMar" title="Bug reports">🐛</a> <a href="https://github.com/fluttercandies/flutter_wechat_assets_picker/commits?author=SchnMar" title="Code">💻</a> <a href="#ideas-SchnMar" title="Ideas, Planning, & Feedback">🤔</a></td>
      <td align="center" valign="top" width="14.28%"><a href="https://github.com/ganlanshu0211"><img src="https://avatars0.githubusercontent.com/u/9670379?v=4?s=50" width="50px;" alt="ganlanshu0211"/><br /><sub><b>ganlanshu0211</b></sub></a><br /><a href="https://github.com/fluttercandies/flutter_wechat_assets_picker/issues?q=author%3Aganlanshu0211" title="Bug reports">🐛</a> <a href="#ideas-ganlanshu0211" title="Ideas, Planning, & Feedback">🤔</a></td>
      <td align="center" valign="top" width="14.28%"><a href="https://github.com/JasonHezz"><img src="https://avatars3.githubusercontent.com/u/15358765?v=4?s=50" width="50px;" alt="JasonHezz"/><br /><sub><b>JasonHezz</b></sub></a><br /><a href="https://github.com/fluttercandies/flutter_wechat_assets_picker/issues?q=author%3AJasonHezz" title="Bug reports">🐛</a> <a href="https://github.com/fluttercandies/flutter_wechat_assets_picker/commits?author=JasonHezz" title="Code">💻</a></td>
      <td align="center" valign="top" width="14.28%"><a href="https://github.com/yanivshaked"><img src="https://avatars.githubusercontent.com/u/13107481?v=4?s=50" width="50px;" alt="Yaniv Shaked"/><br /><sub><b>Yaniv Shaked</b></sub></a><br /><a href="#translation-yanivshaked" title="Translation">🌍</a> <a href="https://github.com/fluttercandies/flutter_wechat_assets_picker/commits?author=yanivshaked" title="Code">💻</a> <a href="https://github.com/fluttercandies/flutter_wechat_assets_picker/issues?q=author%3Ayanivshaked" title="Bug reports">🐛</a> <a href="#maintenance-yanivshaked" title="Maintenance">🚧</a></td>
      <td align="center" valign="top" width="14.28%"><a href="https://github.com/avi-yadav"><img src="https://avatars.githubusercontent.com/u/7314430?v=4?s=50" width="50px;" alt="avi-yadav"/><br /><sub><b>avi-yadav</b></sub></a><br /><a href="https://github.com/fluttercandies/flutter_wechat_assets_picker/commits?author=avi-yadav" title="Code">💻</a></td>
    </tr>
    <tr>
      <td align="center" valign="top" width="14.28%"><a href="https://github.com/Letalus"><img src="https://avatars.githubusercontent.com/u/41230136?v=4?s=50" width="50px;" alt="Letalus"/><br /><sub><b>Letalus</b></sub></a><br /><a href="https://github.com/fluttercandies/flutter_wechat_assets_picker/issues?q=author%3ALetalus" title="Bug reports">🐛</a> <a href="#translation-Letalus" title="Translation">🌍</a></td>
      <td align="center" valign="top" width="14.28%"><a href="https://github.com/greymag"><img src="https://avatars.githubusercontent.com/u/1502131?v=4?s=50" width="50px;" alt="greymag"/><br /><sub><b>greymag</b></sub></a><br /><a href="#translation-greymag" title="Translation">🌍</a></td>
      <td align="center" valign="top" width="14.28%"><a href="https://github.com/NaikSoftware"><img src="https://avatars.githubusercontent.com/u/4218994?v=4?s=50" width="50px;" alt="Nickolay Savchenko"/><br /><sub><b>Nickolay Savchenko</b></sub></a><br /><a href="#design-NaikSoftware" title="Design">🎨</a></td>
      <td align="center" valign="top" width="14.28%"><a href="https://github.com/KosukeSaigusa"><img src="https://avatars.githubusercontent.com/u/13669049?v=4?s=50" width="50px;" alt="Kosuke Saigusa"/><br /><sub><b>Kosuke Saigusa</b></sub></a><br /><a href="#translation-KosukeSaigusa" title="Translation">🌍</a></td>
      <td align="center" valign="top" width="14.28%"><a href="https://github.com/Jon-Millent"><img src="https://avatars.githubusercontent.com/u/17584565?v=4?s=50" width="50px;" alt="三闻书店"/><br /><sub><b>三闻书店</b></sub></a><br /><a href="https://github.com/fluttercandies/flutter_wechat_assets_picker/commits?author=Jon-Millent" title="Documentation">📖</a></td>
      <td align="center" valign="top" width="14.28%"><a href="https://github.com/didiosn"><img src="https://avatars.githubusercontent.com/u/15895051?v=4?s=50" width="50px;" alt="DidiosFaust"/><br /><sub><b>DidiosFaust</b></sub></a><br /><a href="#translation-didiosn" title="Translation">🌍</a></td>
      <td align="center" valign="top" width="14.28%"><a href="https://github.com/ConanXie"><img src="https://avatars.githubusercontent.com/u/10040846?v=4?s=50" width="50px;" alt="xiejie"/><br /><sub><b>xiejie</b></sub></a><br /><a href="https://github.com/fluttercandies/flutter_wechat_assets_picker/issues?q=author%3AConanXie" title="Bug reports">🐛</a></td>
    </tr>
    <tr>
      <td align="center" valign="top" width="14.28%"><a href="https://github.com/maxzod"><img src="https://avatars.githubusercontent.com/u/47630729?v=4?s=50" width="50px;" alt="Ahmed Masoud "/><br /><sub><b>Ahmed Masoud </b></sub></a><br /><a href="#translation-maxzod" title="Translation">🌍</a></td>
      <td align="center" valign="top" width="14.28%"><a href="https://github.com/luomo-pro"><img src="https://avatars.githubusercontent.com/u/41097395?v=4?s=50" width="50px;" alt="luomo-pro"/><br /><sub><b>luomo-pro</b></sub></a><br /><a href="#a11y-luomo-pro" title="Accessibility">️️️️♿️</a> <a href="https://github.com/fluttercandies/flutter_wechat_assets_picker/issues?q=author%3Aluomo-pro" title="Bug reports">🐛</a></td>
      <td align="center" valign="top" width="14.28%"><a href="https://github.com/paigupai"><img src="https://avatars.githubusercontent.com/u/44311361?v=4?s=50" width="50px;" alt="paigupai"/><br /><sub><b>paigupai</b></sub></a><br /><a href="#translation-paigupai" title="Translation">🌍</a></td>
      <td align="center" valign="top" width="14.28%"><a href="https://github.com/taqiabdulaziz"><img src="https://avatars.githubusercontent.com/u/30410316?v=4?s=50" width="50px;" alt="Muhammad Taqi Abdul Aziz"/><br /><sub><b>Muhammad Taqi Abdul Aziz</b></sub></a><br /><a href="https://github.com/fluttercandies/flutter_wechat_assets_picker/commits?author=taqiabdulaziz" title="Documentation">📖</a></td>
      <td align="center" valign="top" width="14.28%"><a href="https://github.com/hellohejinyu"><img src="https://avatars.githubusercontent.com/u/8766034?v=4?s=50" width="50px;" alt="何锦余"/><br /><sub><b>何锦余</b></sub></a><br /><a href="https://github.com/fluttercandies/flutter_wechat_assets_picker/issues?q=author%3Ahellohejinyu" title="Bug reports">🐛</a></td>
      <td align="center" valign="top" width="14.28%"><a href="https://github.com/leonpesdk"><img src="https://avatars.githubusercontent.com/u/57394644?v=4?s=50" width="50px;" alt="Leon Dudlik"/><br /><sub><b>Leon Dudlik</b></sub></a><br /><a href="https://github.com/fluttercandies/flutter_wechat_assets_picker/issues?q=author%3Aleonpesdk" title="Bug reports">🐛</a></td>
      <td align="center" valign="top" width="14.28%"><a href="https://www.legoffmael.fr"><img src="https://avatars.githubusercontent.com/u/22376981?v=4?s=50" width="50px;" alt="Maël"/><br /><sub><b>Maël</b></sub></a><br /><a href="https://github.com/fluttercandies/flutter_wechat_assets_picker/commits?author=LeGoffMael" title="Code">💻</a> <a href="#maintenance-LeGoffMael" title="Maintenance">🚧</a></td>
    </tr>
    <tr>
      <td align="center" valign="top" width="14.28%"><a href="https://github.com/dddrop"><img src="https://avatars.githubusercontent.com/u/5361175?v=4?s=50" width="50px;" alt="dddrop"/><br /><sub><b>dddrop</b></sub></a><br /><a href="https://github.com/fluttercandies/flutter_wechat_assets_picker/commits?author=dddrop" title="Code">💻</a></td>
      <td align="center" valign="top" width="14.28%"><a href="https://www.linkedin.com/in/loinp"><img src="https://avatars.githubusercontent.com/u/34020090?v=4?s=50" width="50px;" alt="Nguyen Phuc Loi"/><br /><sub><b>Nguyen Phuc Loi</b></sub></a><br /><a href="#translation-nploi" title="Translation">🌍</a></td>
      <td align="center" valign="top" width="14.28%"><a href="https://sqlturk.wordpress.com/"><img src="https://avatars.githubusercontent.com/u/12383547?v=4?s=50" width="50px;" alt="Cevheri"/><br /><sub><b>Cevheri</b></sub></a><br /><a href="#translation-cevheri" title="Translation">🌍</a></td>
      <td align="center" valign="top" width="14.28%"><a href="https://velog.io/@hee_mm_"><img src="https://avatars.githubusercontent.com/u/48482259?v=4?s=50" width="50px;" alt="mirimhee"/><br /><sub><b>mirimhee</b></sub></a><br /><a href="#translation-LIMMIHEE" title="Translation">🌍</a></td>
      <td align="center" valign="top" width="14.28%"><a href="https://amoshk.top"><img src="https://avatars.githubusercontent.com/u/32262985?v=4?s=50" width="50px;" alt="Amos"/><br /><sub><b>Amos</b></sub></a><br /><a href="https://github.com/fluttercandies/flutter_wechat_assets_picker/issues?q=author%3AAmosHuKe" title="Bug reports">🐛</a></td>
      <td align="center" valign="top" width="14.28%"><a href="https://github.com/Dimilkalathiya"><img src="https://avatars.githubusercontent.com/u/102401667?v=4?s=50" width="50px;" alt="Dimil Kalathiya"/><br /><sub><b>Dimil Kalathiya</b></sub></a><br /><a href="https://github.com/fluttercandies/flutter_wechat_assets_picker/commits?author=Dimilkalathiya" title="Code">💻</a></td>
      <td align="center" valign="top" width="14.28%"><a href="http://about.me/gasol"><img src="https://avatars.githubusercontent.com/u/108053?v=4?s=50" width="50px;" alt="Gasol Wu"/><br /><sub><b>Gasol Wu</b></sub></a><br /><a href="#translation-Gasol" title="Translation">🌍</a></td>
    </tr>
    <tr>
      <td align="center" valign="top" width="14.28%"><a href="https://github.com/WeiJun0507"><img src="https://avatars.githubusercontent.com/u/66726409?v=4?s=50" width="50px;" alt="Wei Jun"/><br /><sub><b>Wei Jun</b></sub></a><br /><a href="#business-WeiJun0507" title="Business development">💼</a> <a href="https://github.com/fluttercandies/flutter_wechat_assets_picker/commits?author=WeiJun0507" title="Code">💻</a> <a href="#ideas-WeiJun0507" title="Ideas, Planning, & Feedback">🤔</a></td>
      <td align="center" valign="top" width="14.28%"><a href="https://github.com/yujune"><img src="https://avatars.githubusercontent.com/u/56582497?v=4?s=50" width="50px;" alt="JuNe"/><br /><sub><b>JuNe</b></sub></a><br /><a href="https://github.com/fluttercandies/flutter_wechat_assets_picker/commits?author=yujune" title="Code">💻</a></td>
    </tr>
  </tbody>
</table>

<!-- markdownlint-restore -->
<!-- prettier-ignore-end -->

<!-- ALL-CONTRIBUTORS-LIST:END -->
This project follows the
[all-contributors](https://github.com/all-contributors/all-contributors) specification.
Contributions of any kind welcomed!!

## Credits

> Every aspect of IntelliJ IDEA has been designed to maximize developer productivity.
Together, intelligent coding assistance and ergonomic design make development not only productive but also enjoyable.

Thanks to [JetBrains](https://www.jetbrains.com/?from=fluttercandies)
for allocating free open-source licenses for IDEs
such as [IntelliJ IDEA](https://www.jetbrains.com/idea/?from=fluttercandies).

[<img src="https://github.com/fluttercandies/flutter_wechat_assets_picker/raw/main/.github/jetbrains-variant.png" width="200"/>](https://www.jetbrains.com/?from=fluttercandies)


[photo_manager pub]: https://pub.dev/packages/photo_manager
[extended_image pub]: https://pub.dev/packages/extended_image
[provider pub]: https://pub.dev/packages/provider
[video_player pub]: https://pub.dev/packages/video_player
[wechat_camera_picker pub]: https://pub.dev/packages/wechat_camera_picker
[Migration Guide]: https://github.com/fluttercandies/flutter_wechat_assets_picker/blob/main/guides/migration_guide.md
[photo_manager's API docs]: https://pub.dev/documentation/photo_manager/latest/
[Glide Generated API docs]: https://sjudd.github.io/glide/doc/generatedapi.html
[Contribute custom implementations]: https://github.com/fluttercandies/flutter_wechat_assets_picker/blob/main/example/lib/customs/CONTRIBUTING.md
[photo_manager#561]: https://github.com/fluttercandies/flutter_photo_manager/issues/561
[photo_manager#from-raw-data]: https://github.com/fluttercandies/flutter_photo_manager#from-raw-data
[photo_manager#delete-entities]: https://github.com/fluttercandies/flutter_photo_manager#delete-entities
