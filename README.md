# Flutter WeChat Assets Picker

[![pub package](https://img.shields.io/pub/v/wechat_assets_picker?logo=dart&label=stable&style=flat-square)](https://pub.dev/packages/wechat_assets_picker)
[![pub package](https://img.shields.io/pub/v/wechat_assets_picker?color=42a012&include_prereleases&label=rc%20version&logo=dart&style=flat-square)](https://pub.dev/packages/wechat_assets_picker)
[![GitHub stars](https://img.shields.io/github/stars/fluttercandies/flutter_wechat_assets_picker?logo=github&style=flat-square)](https://github.com/fluttercandies/flutter_wechat_assets_picker/stargazers)
[![GitHub forks](https://img.shields.io/github/forks/fluttercandies/flutter_wechat_assets_picker?logo=github&style=flat-square)](https://github.com/fluttercandies/flutter_wechat_assets_picker/network)
[![GitHub license](https://img.shields.io/github/license/fluttercandies/flutter_wechat_assets_picker?style=flat-square)](https://github.com/fluttercandies/flutter_wechat_assets_picker/blob/master/LICENSE)
<a target="_blank" href="https://jq.qq.com/?_wv=1027&k=5bcc0gy"><img border="0" src="https://pub.idqqimg.com/wpa/images/group.png" alt="FlutterCandies" title="FlutterCandies"></a>

Language: English | [中文简体](README-ZH.md)

An **assets picker** which looks like the one in WeChat, based on `photo_manager` for asset implementation, `extended_image` for image preview, `provider` to help controlling the state of the picker.

## Category 🗂

* [Features](#features-)
* [Screenshots](#screenshots-)
* [TODO](#todo-)
* [Preparing for use](#preparing-for-use-)
  * [Flutter](#flutter)
  * [Android](#android)
  * [iOS](#ios)
* [Usage](#usage-)
  * [Simple usage](#simple-usage)
  * [Complete param usage](#complete-param-usage)
  * [Register assets change observe callback](#register-assets-change-observe-callback)
* [Frequent asked questions](#frequent-asked-question)
  * [Create `AssetEntity` from `File` or `Uint8List` (rawData)](#create-assetentity-from-file-or-uint8list-rawdata)
  * [Console warning 'Failed to find GeneratedAppGlideModule'](#glide-warning-failed-to-find-generatedappglidemodule)

## Features ✨

- 💚 99% simillar to WeChat style.
- 🌠 Support multi assets pick.
- 🔍 Support asset preview. (Image / Video)

## TODO 📅

- [x] Image asset support
  - [x] HEIC/HEIF Image type support
- [x] Video asset support
- [x] Audio asset support
- [x] Single asset mode
- [x] i18n support
- [x] Custom text delegate support
- [x] Custom theme entirely
- [x] MacOS support

## Screenshots 📸

![1.png](screenshots/1.png)![2.png](screenshots/2.png)![3.png](screenshots/3.png)


## READ THIS FIRST

Althought the package provide selection for assets, it still require users build their own methods to handle display/upload, etc. If you have any question about how to build it, please run the example or refer to [photo_manager](https://github.com/CaiJingLong/flutter_photo_manager) for API usage.

## Preparing for use 🍭

### Flutter

Add `wechat_assets_picker` to `pubspec.yaml` dependencies.
```yaml
dependencies:
  wechat_assets_picker: $latest_version
```
Then import the package in your code:
```dart
import 'package:wechat_assets_picker/wechat_assets_picker.dart';
```

### Android

You need at lease three permissions: `INTERNET` `READ_EXTERNAL_STORAGE` `WRITE_EXTERNAL_STORAGE`.

Then the main project needs implementation of `AppGlideModule`. For example:
`example/android/app/build.gradle`:
```gradle
  apply plugin: 'com.android.application'
  apply plugin: 'kotlin-android'
+ apply plugin: 'kotlin-kapt'
  apply from: "$flutterRoot/packages/flutter_tools/gradle/flutter.gradle"
  
  dependencies {
    implementation "org.jetbrains.kotlin:kotlin-stdlib-jdk8:$kotlin_version"
+   implementation 'com.github.bumptech.glide:glide:4.11.0'
+   kapt 'com.github.bumptech.glide:compiler:4.11.0'
    testImplementation 'junit:junit:4.12'
}
```

`example/android/app/src/main/kotlin/com/example/exampleapp/ExampleAppGlideModule.java`:

```kotlin
package com.example.exampleapp;

import com.bumptech.glide.annotation.GlideModule;
import com.bumptech.glide.module.AppGlideModule;

@GlideModule
public class ExampleAppGlideModule extends AppGlideModule {
}
```
If you're using different versions of `Glide`, please add this to the `build.gradle`:
```gradle
rootProject.allprojects {
    subprojects {
        project.configurations.all {
            resolutionStrategy.eachDependency { details ->
                if (details.requested.group == 'com.github.bumptech.glide'
                        && details.requested.name.contains('glide')) {
                    details.useVersion "4.11.0"
                }
            }
        }
    }
}
```

### iOS

Add following content to `info.plist`.

```
<key>NSAppTransportSecurity</key>
<dict>
	<key>NSAllowsArbitraryLoads</key>
  <true/>
</dict>
<key>NSPhotoLibraryUsageDescription</key>
<string>Replace with your permission description.</string>
```



## Usage 📖

| Name           | Type                | Description                                                  | Default                             |
| -------------- | ------------------- | ------------------------------------------------------------ | ----------------------------------- |
| context        | `BuildContext`      | Context for navigator push.                                  | `null`                              |
| maxAssets      | `int`               | Maximum asset that the picker can pick.                      | 9                                   |
| pageSize       | `int`               | Assets amount when assets loaded with paging. **Must be a multiple of `gridCount`.** Nullable for non paging. | 320 (80 * 4)                        |
| pathThumbSize  | `int`               | The size of thumb data in picker.                            | 80                                  |
| gridCount      | `int`               | Grid count in picker.                                        | 4                                   |
| requestType    | `RequestType`       | Request type for picker.                                     | RequestType.image                   |
| selectedAssets | `List<AssetEntity>` | Selected assets. Prevent duplicate selection. If you don't need to prevent duplicate selection, just don't pass it. | `null`                              |
| themeColor     | `Color`             | Main theme color for the picker                              | `Color(0xff00bc56)`                 |
| pickerTheme    | `ThemeData`         | Theme data provider for the picker and the viewer.           | `null`                              |
| textDelegate   | `TextDelegate`      | Text delegate for the picker, for customize the texts.       | `DefaultTextDelegate()`             |
| routeCurve     | `Curve`             | The curve which the picker use to build page route transition. | `Curves.easeIn`                     |
| routeDuration  | `Duration`          | The duration which the picker use to build page route transition. | `const Duration(milliseconds: 500)` |

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

```dart
List<AssetEntity> assets = <AssetEntity>{};

final List<AssetEntity> result = await AssetPicker.pickAssets(
  context,
  maxAssets: 9,
  pageSize: 320,
  pathThumbSize: 80,
  gridCount: 4,
  requestType: RequestType.image,
  selectedAssets: assets,
  themeColor: Colors.cyan,
  pickerTheme: ThemeData.dark(), // This cannot be set when the `themeColor` was provided.
  textDelegate: DefaultTextDelegate(),
  routeCurve: Curves.easeIn,
  routeDuration: const Duration(milliseconds: 500),
);
```

or

```dart
List<AssetEntity> assets = <AssetEntity>{};

AssetPicker.pickAssets(
  context,
  maxAssets: 9,
  pageSize: 320,
  pathThumbSize: 80,
  gridCount: 4,
  requestType: RequestType.image,
  selectedAssets: assets,
  themeColor: Colors.cyan,
  pickerTheme: ThemeData.dark(), // This cannot be set when the `themeColor` was provided.
  textDelegate: DefaultTextDelegate(),
  routeCurve: Curves.easeIn,
  routeDuration: const Duration(milliseconds: 500),
).then((List<AssetEntity> assets) {
  /.../
});
```

### Register assets change observe callback
```dart
AssetPicker.registerObserve(); // Register callback.
```
```dart
AssetPicker.unregisterObserve(); // Unregister callback.
```

## Frequent asked question

### Create `AssetEntity` from `File` or `Uint8List` (rawData)

In order to combine this package with camera shooting or something related, there's a wordaround about how to create an `AssetEntity` with `File` or `Uint8List` object.

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