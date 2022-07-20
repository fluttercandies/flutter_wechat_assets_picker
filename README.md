<!-- Copyright 2019 The FlutterCandies author. All rights reserved.
Use of this source code is governed by an Apache license
that can be found in the LICENSE file. -->

# Flutter WeChat Assets Picker

[![pub package](https://img.shields.io/pub/v/wechat_assets_picker?logo=dart&label=stable&style=flat-square)](https://pub.dev/packages/wechat_assets_picker)
[![pub package](https://img.shields.io/pub/v/wechat_assets_picker?color=42a012&include_prereleases&label=dev&logo=dart&style=flat-square)](https://pub.dev/packages/wechat_assets_picker)
[![Build status](https://img.shields.io/github/workflow/status/fluttercandies/flutter_wechat_assets_picker/Build%20test?label=CI&logo=github&style=flat-square)](https://github.com/fluttercandies/flutter_wechat_assets_picker/actions?query=workflow%3A%22Build+test%22)
[![CodeFactor](https://img.shields.io/codefactor/grade/github/fluttercandies/flutter_wechat_assets_picker?logo=codefactor&logoColor=%23ffffff&style=flat-square)](https://www.codefactor.io/repository/github/fluttercandies/flutter_wechat_assets_picker)
[![GitHub license](https://img.shields.io/github/license/fluttercandies/flutter_wechat_assets_picker?style=flat-square)](https://github.com/fluttercandies/flutter_wechat_assets_picker/blob/master/LICENSE)

[![Awesome Flutter](https://img.shields.io/badge/Awesome-Flutter-blue.svg?longCache=true&style=flat-square)](https://github.com/Solido/awesome-flutter)
[![GitHub stars](https://img.shields.io/github/stars/fluttercandies/flutter_wechat_assets_picker?logo=github&style=flat-square)](https://github.com/fluttercandies/flutter_wechat_assets_picker/stargazers)
[![GitHub forks](https://img.shields.io/github/forks/fluttercandies/flutter_wechat_assets_picker?logo=github&style=flat-square)](https://github.com/fluttercandies/flutter_wechat_assets_picker/network)
<a target="_blank" href="https://jq.qq.com/?_wv=1027&k=5bcc0gy"><img border="0" src="https://pub.idqqimg.com/wpa/images/group.png" alt="FlutterCandies" title="FlutterCandies"></a>

Language: English | [中文](README-ZH.md)

An **assets' picker** based on the WeChat's UI,
using [photo_manager][photo_manager pub] for asset implementation,
[extended_image][extended_image pub]
for image preview,
and [provider][provider pub]
to help control the state of the picker.

To take a photo or a video for assets,
please check the detailed usage in the example,
and head over to
[wechat_camera_picker][wechat_camera_picker pub].

Current WeChat version that UI based on: **8.x**
UI designs will be updated following the WeChat update in anytime.

## Category 🗂

* [Migration Guide](#migration-guide-)
* [Features](#features-)
* [Screenshots](#screenshots-)
* [Preparing for use](#preparing-for-use-)
  * [Versions compatibility](#versions-compatibility)
  * [Flutter](#flutter)
  * [Android](#android)
  * [iOS](#ios)
  * [macOS](#macos)
* [Usage](#usage-)
  * [Simple usage](#simple-usage)
  * [Detailed usage](#detailed-usage)
  * [Using custom delegate](#using-custom-delegate)
  * [Display selected assets](#display-selected-assets)
  * [Register assets change observe callback](#register-assets-change-observe-callback)
  * [Customize with your own type or UI](#customize-with-your-own-type-or-ui)
* [Frequently asked question](#frequently-asked-question-)
  * [Execution failed for task ':photo_manager:compileDebugKotlin'](#execution-failed-for-task-photo_managercompiledebugkotlin)
  * [How can I get path from the `AssetEntity` to integrate with `File` object, upload or edit?](#how-can-i-get-path-from-the-assetentity-to-integrate-with-file-object-upload-or-edit)
  * [Create `AssetEntity` from `File` or `Uint8List` (rawData)](#create-assetentity-from-file-or-uint8list-rawdata)
  * [Console warning 'Failed to find GeneratedAppGlideModule'](#glide-warning-failed-to-find-generatedappglidemodule)

## Migration Guide ♻️

See [Migration Guide][].

## Features ✨

- ♻️ Fully implementable with delegates override
- 💚 99% similar to WeChat style
- ⚡️ Adjustable performance according to parameters
- 📷 Image asset support
  - 🔬 HEIF Image type support
- 🎥 Video asset support
- 🎶 Audio asset support
- 1️⃣ Single asset mode
- 💱 i18n support
  - ⏪ RTL language support
- ➕ Special item builder (prepend/append) support
- 🗂 Custom sort path delegate support
- 📝 Custom text delegate support
- ⏳ Custom filter options support ( `photo_manager` )
- 🎏 Fully customizable theme
- 💻 macOS support

## Screenshots 📸

| ![1](https://pic.alexv525.com/2021-07-05-picker_1.jpg)   | ![2](https://pic.alexv525.com/2021-07-05-picker_2.jpg)   | ![3](https://pic.alexv525.com/2021-07-05-picker_3.jpg)   |
|----------------------------------------------------------|----------------------------------------------------------|----------------------------------------------------------|
| ![4](https://pic.alexv525.com/2021-07-05-picker_4.jpg)   | ![5](https://pic.alexv525.com/2021-07-05-picker_5.jpg)   | ![6](https://pic.alexv525.com/2021-07-05-picker_6.jpg)   |
| ![7](https://pic.alexv525.com/2021-07-06-picker_7.jpg)   | ![8](https://pic.alexv525.com/2021-07-05-picker_8.jpg)   | ![9](https://pic.alexv525.com/2021-07-05-picker_9-1.jpg) |
| ![10](https://pic.alexv525.com/2021-07-05-picker_10.png) | ![10](https://pic.alexv525.com/2021-07-05-picker_11.png) | ![12](https://pic.alexv525.com/2021-07-05-picker_12.png) |

## READ THIS FIRST ‼️

The package works closely with the [photo_manager][photo_manager pub] plugin,
and most behaviors are controlled by the plugin.
When you have questions about related APIs and behaviors,
check [photo_manager's API docs][] for more details.

Most usages are detailed covered by the example.
Please walk through the example carefully
before you have any questions.

## Preparing for use 🍭

### Versions compatibility

|        | 2.8.0 | 2.10.0 | 3.0.0 |
|--------|:-----:|:------:|:-----:|
| 7.3.0+ |  N/A  |  N/A   |   ✅   |
| 7.0.0+ |   ✅   |   ✅    |   ❌   |
| 6.3.0+ |   ✅   |   ✅    |   ❌   |

If you got a `resolve conflict` error when running `flutter pub get`,
please use `dependency_overrides` to fix it.

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
[![pub package](https://img.shields.io/pub/v/wechat_assets_picker?color=42a012&include_prereleases&label=dev&logo=dart&style=flat-square)](https://pub.dev/packages/wechat_assets_picker)

Then import the package in your code:
```dart
import 'package:wechat_assets_picker/wechat_assets_picker.dart';
```

### Android

Required permissions: `READ_EXTERNAL_STORAGE` (declared already).
Optional permissions: `WRITE_EXTERNAL_STORAGE`, `ACCESS_MEDIA_LOCATION`.

If you're targeting Android SDK 29+,
you must declare `requestLegacyExternalStorage`
at the `<application>` node of `AndroidManifest.xml`.
See the example for the detailed usage.

If you found some warning logs with `Glide` appearing,
then the main project needs an implementation of `AppGlideModule`.
See [Generated API docs][].

### iOS

1. Platform version has to be at least *9.0*.
   Modify `ios/Podfile` and update accordingly.
```ruby
platform :ios, '9.0'
```

2. Add the following content to `info.plist`.
```plist
<key>NSAppTransportSecurity</key>
<dict>
	<key>NSAllowsArbitraryLoads</key>
	<true/>
</dict>
<key>NSPhotoLibraryUsageDescription</key>
<string>Replace with your permission description.</string>
```

### macOS

1. Platform version has to be at least *10.15*.
   Modify `macos/Podfile` and update accordingly.
```ruby
platform :osx, '10.15'
```
2. Set the minimum deployment target to *10.15*.
   Use XCode to open `macos/Runner.xcworkspace` .
3. ![step 1](https://tva1.sinaimg.cn/large/007S8ZIlgy1ghw67v4yk4j30qy0b50u0.jpg)
4. ![step 2](https://tva1.sinaimg.cn/large/007S8ZIlgy1ghw67vd3f2j30jv04zgm5.jpg)
5. Follow the iOS instructions and modify `info.plist` accordingly.

## Usage 📖

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

| Name                              | Type                                 | Description                                                                                  | Default                     |
|-----------------------------------|--------------------------------------|----------------------------------------------------------------------------------------------|-----------------------------|
| selectedAssets                    | `List<AssetEntity>?`                 | Selected assets. Prevent duplicate selection.                                                | `null`                      |
| maxAssets                         | `int`                                | Maximum asset that the picker can pick.                                                      | 9                           |
| pageSize                          | `int?`                               | Number of assets per page. **Must be a multiple of `gridCount`**.                            | 80                          |
| gridThumbnailSize                 | `ThumbnailSize`                      | Thumbnail size for the grid's item.                                                          | `ThumbnailSize.square(200)` |
| pathThumbnailSize                 | `ThumbnailSize`                      | Thumbnail size for the path selector.                                                        | `ThumbnailSize.square(80)`  |
| previewThumbnailSize              | `ThumbnailSize?`                     | Preview thumbnail size in the viewer.                                                        | `null`                      |
| requestType                       | `RequestType`                        | Request type for picker.                                                                     | `RequestType.common`        |
| specialPickerType                 | `SpecialPickerType?`                 | Provides the option to integrate a custom picker type.                                       | `null`                      |
| keepScrollOffset                  | `bool`                               | Whether the picker should save the scroll offset between pushes and pops.                    | `null`                      |
| sortPathDelegate                  | `SortPathDelegate<AssetPathEntity>?` | Path entities sort delegate for the picker, sort paths as you want.                          | `CommonSortPathDelegate`    |
| sortPathsByModifiedDate           | `bool`                               | Whether to allow sort delegates to sort paths with `FilterOptionGroup.containsPathModified`. | `false`                     |
| filterOptions                     | `FilterOptionGroup?`                 | Allow users to customize assets filter options.                                              | `null`                      |
| gridCount                         | `int`                                | Grid count in picker.                                                                        | 4                           |
| themeColor                        | `Color?`                             | Main theme color for the picker.                                                             | `Color(0xff00bc56)`         |
| pickerTheme                       | `ThemeData?`                         | Theme data provider for the picker and the viewer.                                           | `null`                      |
| textDelegate                      | `AssetPickerTextDelegate?`           | Text delegate for the picker, for customize the texts.                                       | `AssetPickerTextDelegate()` |
| specialItemPosition               | `SpecialItemPosition`                | Allow users set a special item in the picker with several positions.                         | `SpecialItemPosition.none`  |
| specialItemBuilder                | `SpecialItemBuilder?`                | The widget builder for the special item.                                                     | `null`                      |
| loadingIndicatorBuilder           | `IndicatorBuilder?`                  | Indicates the loading status for the builder.                                                | `null`                      |
| selectPredicate                   | `AssetSelectPredicate`               | Predicate whether an asset can be selected or unselected.                                    | `null`                      |
| shouldRevertGrid                  | `bool?`                              | Whether the assets grid should revert.                                                       | `null`                      |
| limitedPermissionOverlayPredicate | `LimitedPermissionOverlayPredicate?` | Predicate whether the limited permission overlay should be displayed.                        | `null`                      |
| pathNameBuilder                   | `PathNameBuilder<AssetPathEntity>?`  | Build customized path name.                                                                  | `null`                      |

### Detailed usage

TL;DR, we've put multiple common usage
with the packages in the [example](example).

### Using custom delegate

You can use the `keepScrollOffset` feature
only with the `pickAssetsWithDelegate` method.
See the `Keep scroll offset` pick method
in the example for how to implement it.

For more details about custom delegates,
head over to [`example/lib/customs`](example/lib/customs).

#### Regular picking

You can both found `List<PickMethod> pickMethods` in
`example/lib/pages/multi_assets_page.dart`
and `example/lib/pages/single_assets_page.dart`,
which provide methods in multiple picking and single picking mode.
Assets will be stored temporary and displayed at the below of the page.

##### Multiple assets picking

The maximum assets limit is `9` in the multiple picking page,
and you can modify it as you wish.

Some methods can only work with multiple mode, such as "WeChat Moment".

##### Single asset picking

Only one and maximum to one asset can be picked at once.

#### Custom pickers

You can try custom pickers with the "Custom" page.
We've defined a picker that integrates with `Directory` and `File`
(completely out of the `photo_manager` scope),
and a picker with multiple tabs switching.
You can submit PRs to create your own implementation
if you found your implementation might be useful for others.
See [Contribute custom implementations][] for more details.

### Display selected assets

The `AssetImage` and `AssetEntityImageProvider` can display the thumb image
of _images & videos_, and the original data of _image_.
Use it like a common `Image` and `ImageProvider`.

```dart
/// AssetEntityImage
AssetEntityImage(asset, isOriginal: false);

/// AssetEntityImageProvider
Image(image: AssetEntityImageProvider(asset, isOriginal: false));
```

### Register assets change observe callback

```dart
/// Register callback.
AssetPicker.registerObserve();

/// Unregister callback.
AssetPicker.unregisterObserve();
```

### Customize with your own type or UI

`AssetPickerBuilderDelegate`, `AssetPickerViewerBuilderDelegate`,
`AssetPickerProvider` and `AssetPickerViewerProvider`
are all exposed and overridable.
You can extend them and use your own
type with generic type `<A: Asset, P: Path>`,
then implement abstract methods. See the `Custom` page
in the example which has an implementation
based on `<File, Directory>` types.

## Frequently asked question ❔

### Execution failed for task ':photo_manager:compileDebugKotlin'

See [photo_manager#561][] for more details.

### How can I get path from the `AssetEntity` to integrate with `File` object, upload or edit?

You don't need it (might be).

You can always request the `File` object with
`entity.file` or `entity.originFile`,
and `entity.originBytes` for `Uint8List`.

If you still need path after requested the `File`, get it through `file.path`.

```dart
final File file = await entity.file; // Thumbnails or edited files.
final File originFile = await entity.originFile; // Original files.
final String path = file.path;
final String originPath = originFile.path;
```

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
A deletion operation might call system popups with some OS:

```dart
final List<String> result = await PhotoManager.editor.deleteWithIds(
  <String>[entity.id],
);
```

ref: [photo_manager#insert-new-item][]

### Glide warning 'Failed to find GeneratedAppGlideModule'

```
W/Glide   (21133): Failed to find GeneratedAppGlideModule. You should include an annotationProcessor compile dependency on com.github.bumptech.glide:compiler in you application ana a @GlideModule annotated AppGlideModule implementation or LibraryGlideModules will be silently ignored.
```

`Glide` needs annotation to keep singleton,
prevent conflict between instances and versions,
so while the photo manager uses `Glide` to implement image features,
the project which import this should define its own `AppGlideModule`.
See [Android](#android) section for implementation.

## Contributors ✨

Many thanks to these wonderful people ([emoji key](https://allcontributors.org/docs/en/emoji-key)):
<!-- ALL-CONTRIBUTORS-LIST:START - Do not remove or modify this section -->
<!-- prettier-ignore-start -->
<!-- markdownlint-disable -->
<table>
  <tr>
    <td align="center"><a href="https://blog.alexv525.com"><img src="https://avatars1.githubusercontent.com/u/15884415?v=4?s=50" width="50px;" alt=""/><br /><sub><b>Alex Li</b></sub></a><br /><a href="https://github.com/fluttercandies/flutter_wechat_assets_picker/commits?author=AlexV525" title="Code">💻</a> <a href="#design-AlexV525" title="Design">🎨</a> <a href="https://github.com/fluttercandies/flutter_wechat_assets_picker/commits?author=AlexV525" title="Documentation">📖</a> <a href="#example-AlexV525" title="Examples">💡</a> <a href="#ideas-AlexV525" title="Ideas, Planning, & Feedback">🤔</a> <a href="#maintenance-AlexV525" title="Maintenance">🚧</a> <a href="#question-AlexV525" title="Answering Questions">💬</a> <a href="https://github.com/fluttercandies/flutter_wechat_assets_picker/pulls?q=is%3Apr+reviewed-by%3AAlexV525" title="Reviewed Pull Requests">👀</a></td>
    <td align="center"><a href="https://www.kikt.top"><img src="https://avatars0.githubusercontent.com/u/14145407?v=4?s=50" width="50px;" alt=""/><br /><sub><b>Caijinglong</b></sub></a><br /><a href="#example-CaiJingLong" title="Examples">💡</a> <a href="#ideas-CaiJingLong" title="Ideas, Planning, & Feedback">🤔</a></td>
    <td align="center"><a href="https://github.com/SchnMar"><img src="https://avatars3.githubusercontent.com/u/12902321?v=4?s=50" width="50px;" alt=""/><br /><sub><b>Marcel Schneider</b></sub></a><br /><a href="https://github.com/fluttercandies/flutter_wechat_assets_picker/issues?q=author%3ASchnMar" title="Bug reports">🐛</a> <a href="https://github.com/fluttercandies/flutter_wechat_assets_picker/commits?author=SchnMar" title="Code">💻</a> <a href="#ideas-SchnMar" title="Ideas, Planning, & Feedback">🤔</a></td>
    <td align="center"><a href="https://github.com/ganlanshu0211"><img src="https://avatars0.githubusercontent.com/u/9670379?v=4?s=50" width="50px;" alt=""/><br /><sub><b>ganlanshu0211</b></sub></a><br /><a href="https://github.com/fluttercandies/flutter_wechat_assets_picker/issues?q=author%3Aganlanshu0211" title="Bug reports">🐛</a> <a href="#ideas-ganlanshu0211" title="Ideas, Planning, & Feedback">🤔</a></td>
    <td align="center"><a href="https://github.com/JasonHezz"><img src="https://avatars3.githubusercontent.com/u/15358765?v=4?s=50" width="50px;" alt=""/><br /><sub><b>JasonHezz</b></sub></a><br /><a href="https://github.com/fluttercandies/flutter_wechat_assets_picker/issues?q=author%3AJasonHezz" title="Bug reports">🐛</a> <a href="https://github.com/fluttercandies/flutter_wechat_assets_picker/commits?author=JasonHezz" title="Code">💻</a></td>
    <td align="center"><a href="https://github.com/yanivshaked"><img src="https://avatars.githubusercontent.com/u/13107481?v=4?s=50" width="50px;" alt=""/><br /><sub><b>Yaniv Shaked</b></sub></a><br /><a href="#translation-yanivshaked" title="Translation">🌍</a> <a href="https://github.com/fluttercandies/flutter_wechat_assets_picker/commits?author=yanivshaked" title="Code">💻</a> <a href="https://github.com/fluttercandies/flutter_wechat_assets_picker/issues?q=author%3Ayanivshaked" title="Bug reports">🐛</a> <a href="#maintenance-yanivshaked" title="Maintenance">🚧</a></td>
    <td align="center"><a href="https://github.com/avi-yadav"><img src="https://avatars.githubusercontent.com/u/7314430?v=4?s=50" width="50px;" alt=""/><br /><sub><b>avi-yadav</b></sub></a><br /><a href="https://github.com/fluttercandies/flutter_wechat_assets_picker/commits?author=avi-yadav" title="Code">💻</a></td>
  </tr>
  <tr>
    <td align="center"><a href="https://github.com/Letalus"><img src="https://avatars.githubusercontent.com/u/41230136?v=4?s=50" width="50px;" alt=""/><br /><sub><b>Letalus</b></sub></a><br /><a href="https://github.com/fluttercandies/flutter_wechat_assets_picker/issues?q=author%3ALetalus" title="Bug reports">🐛</a> <a href="#translation-Letalus" title="Translation">🌍</a></td>
    <td align="center"><a href="https://github.com/greymag"><img src="https://avatars.githubusercontent.com/u/1502131?v=4?s=50" width="50px;" alt=""/><br /><sub><b>greymag</b></sub></a><br /><a href="#translation-greymag" title="Translation">🌍</a></td>
    <td align="center"><a href="https://github.com/NaikSoftware"><img src="https://avatars.githubusercontent.com/u/4218994?v=4?s=50" width="50px;" alt=""/><br /><sub><b>Nickolay Savchenko</b></sub></a><br /><a href="#design-NaikSoftware" title="Design">🎨</a></td>
    <td align="center"><a href="https://github.com/KosukeSaigusa"><img src="https://avatars.githubusercontent.com/u/13669049?v=4?s=50" width="50px;" alt=""/><br /><sub><b>Kosuke Saigusa</b></sub></a><br /><a href="#translation-KosukeSaigusa" title="Translation">🌍</a></td>
    <td align="center"><a href="https://github.com/Jon-Millent"><img src="https://avatars.githubusercontent.com/u/17584565?v=4?s=50" width="50px;" alt=""/><br /><sub><b>三闻书店</b></sub></a><br /><a href="https://github.com/fluttercandies/flutter_wechat_assets_picker/commits?author=Jon-Millent" title="Documentation">📖</a></td>
    <td align="center"><a href="https://github.com/didiosn"><img src="https://avatars.githubusercontent.com/u/15895051?v=4?s=50" width="50px;" alt=""/><br /><sub><b>DidiosFaust</b></sub></a><br /><a href="#translation-didiosn" title="Translation">🌍</a></td>
    <td align="center"><a href="https://github.com/ConanXie"><img src="https://avatars.githubusercontent.com/u/10040846?v=4?s=50" width="50px;" alt=""/><br /><sub><b>xiejie</b></sub></a><br /><a href="https://github.com/fluttercandies/flutter_wechat_assets_picker/issues?q=author%3AConanXie" title="Bug reports">🐛</a></td>
  </tr>
  <tr>
    <td align="center"><a href="https://github.com/maxzod"><img src="https://avatars.githubusercontent.com/u/47630729?v=4?s=50" width="50px;" alt=""/><br /><sub><b>Ahmed Masoud </b></sub></a><br /><a href="#translation-maxzod" title="Translation">🌍</a></td>
    <td align="center"><a href="https://github.com/luomo-pro"><img src="https://avatars.githubusercontent.com/u/41097395?v=4?s=50" width="50px;" alt=""/><br /><sub><b>luomo-pro</b></sub></a><br /><a href="#a11y-luomo-pro" title="Accessibility">️️️️♿️</a> <a href="https://github.com/fluttercandies/flutter_wechat_assets_picker/issues?q=author%3Aluomo-pro" title="Bug reports">🐛</a></td>
    <td align="center"><a href="https://github.com/paigupai"><img src="https://avatars.githubusercontent.com/u/44311361?v=4?s=50" width="50px;" alt=""/><br /><sub><b>paigupai</b></sub></a><br /><a href="#translation-paigupai" title="Translation">🌍</a></td>
    <td align="center"><a href="http://taqi.me"><img src="https://avatars.githubusercontent.com/u/30410316?v=4?s=50" width="50px;" alt=""/><br /><sub><b>Muhammad Taqi Abdul Aziz</b></sub></a><br /><a href="https://github.com/fluttercandies/flutter_wechat_assets_picker/commits?author=taqiabdulaziz" title="Documentation">📖</a></td>
  </tr>
</table>

<!-- markdownlint-restore -->
<!-- prettier-ignore-end -->

<!-- ALL-CONTRIBUTORS-LIST:END -->
This project follows the
[all-contributors](https://github.com/all-contributors/all-contributors) specification.
Contributions of any kind welcomed!!

## Acknowledgement

> Every aspect of IntelliJ IDEA has been designed to maximize developer productivity.
Together, intelligent coding assistance and ergonomic design make development not only productive but also enjoyable.

Thanks to [JetBrains](https://www.jetbrains.com/?from=fluttercandies)
for allocating free open-source licenses for IDEs
such as [IntelliJ IDEA](https://www.jetbrains.com/idea/?from=fluttercandies).

[<img src="https://github.com/fluttercandies/flutter_wechat_assets_picker/raw/main/.github/jetbrains-variant.png" width="200"/>](https://www.jetbrains.com/?from=fluttercandies)


[photo_manager pub]: https://pub.dev/packages/photo_manager
[extended_image pub]: https://pub.dev/packages/extended_image
[provider pub]: https://pub.dev/packages/provider
[wechat_camera_picker pub]: https://pub.dev/packages/wechat_camera_picker
[Migration Guide]: https://github.com/fluttercandies/flutter_wechat_assets_picker/blob/main/guides/migration_guide.md
[photo_manager's API docs]: https://pub.dev/documentation/photo_manager/latest/
[Generated API docs]: https://sjudd.github.io/glide/doc/generatedapi.html
[Contribute custom implementations]: https://github.com/fluttercandies/flutter_wechat_assets_picker/blob/main/example/lib/customs/CONTRIBUTING.md
[photo_manager#561]: https://github.com/CaiJingLong/flutter_photo_manager/issues/561
[photo_manager#insert-new-item]: https://github.com/CaiJingLong/flutter_photo_manager#insert-new-item
