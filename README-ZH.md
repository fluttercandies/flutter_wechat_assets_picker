# Flutter仿微信资源选择器

[![pub package](https://img.shields.io/pub/v/wechat_assets_picker?color=42a012&label=%E7%A8%B3%E5%AE%9A%E7%89%88&logo=dart&style=flat-square)](https://pub.dev/packages/wechat_assets_picker)
[![pub package](https://img.shields.io/pub/v/wechat_assets_picker?color=42a012&include_prereleases&label=%E5%BC%80%E5%8F%91%E7%89%88&logo=dart&style=flat-square)](https://pub.dev/packages/wechat_assets_picker)
[![GitHub stars](https://img.shields.io/github/stars/fluttercandies/flutter_wechat_assets_picker?logo=github&style=flat-square)](https://github.com/fluttercandies/flutter_wechat_assets_picker/stargazers)
[![Build status](https://img.shields.io/github/workflow/status/fluttercandies/flutter_wechat_assets_picker/Build%20test?label=%E7%8A%B6%E6%80%81&logo=github&style=flat-square)](https://github.com/fluttercandies/flutter_wechat_assets_picker/actions?query=workflow%3A%22Build+test%22)
[![GitHub forks](https://img.shields.io/github/forks/fluttercandies/flutter_wechat_assets_picker?logo=github&style=flat-square)](https://github.com/fluttercandies/flutter_wechat_assets_picker/network)
[![GitHub license](https://img.shields.io/github/license/fluttercandies/flutter_wechat_assets_picker?label=%E5%8D%8F%E8%AE%AE&style=flat-square)](https://github.com/fluttercandies/flutter_wechat_assets_picker/blob/master/LICENSE)
<a target="_blank" href="https://jq.qq.com/?_wv=1027&k=5bcc0gy"><img border="0" src="https://pub.idqqimg.com/wpa/images/group.png" alt="FlutterCandies" title="FlutterCandies"></a>

Language: [English](README.md) | 中文简体

对标微信的**资源选择器**，基于`photo_manager`实现资源相关功能，`extended_image`用于查看图片，`provider`用于协助管理选择器的状态。

## 目录 🗂

* [特性](#特性-)
* [截图](#截图-)
* [准备工作](#准备工作-)
  * [Flutter](#flutter)
  * [Android](#android)
  * [iOS](#ios)
* [使用方法](#使用方法-)
  * [简单的使用方法](#简单的使用方法)
  * [完整参数的使用方法](#完整参数的使用方法)
  * [注册资源变化回调](#注册资源变化回调)
* [类介绍](#类介绍-)
  * [`AssetEntity`](#assetentity)
* [常见问题](#常见问题-)
  * [如何获取资源的路径以进行上传或编辑等操作的整合？](#如何获取资源的路径以进行上传或编辑等操作的整合)
  * [从`File`或`Uint8List`创建`AssetEntity`的方法](#从file或uint8list创建assetentity的方法)
  * [控制台提示 'Failed to find GeneratedAppGlideModule'](#控制台提示-failed-to-find-generatedappglidemodule)

## 特性 ✨

- [x] 💚 99%的微信风格
- [x] 📷 图片资源支持
  - [x] 🔬HEIC格式图片支持
- [x] 🎥 视频资源支持
- [x] 🎶 音频资源支持
- [x] 1️⃣ 单资源模式
- [x] 💱 国际化支持
- [x] 🗂 自定义路径排序支持
- [x] 📝 自定义文本支持
- [x] 🎏 完整的自定义主题
- [x] 💻 支持 MacOS

## 截图 📸

| ![1](screenshots/1.jpg) | ![2](screenshots/2.jpg) | ![3](screenshots/3.jpg) |
| ----------------------- | ----------------------- | ----------------------- |
| ![4](screenshots/4.jpg) | ![5](screenshots/5.jpg) | ![6](screenshots/6.jpg) |
| ![7](screenshots/7.jpg) | ![8](screenshots/8.jpg) | ![9](screenshots/9.jpg) |

## 开始前的注意事项 ‼️

尽管该库提供了资源的选择，其仍然要求使用者构建自己的方法来处理显示、上传等操作。如果你在使用该库的过程对某些方法或API有疑问，请运行demo并查看[photo_manager](https://github.com/CaiJingLong/flutter_photo_manager)对相关方法的使用说明。

## 准备工作 🍭

### Flutter

将`wechat_assets_picker`添加至`pubspec.yaml`引用。

```yaml
dependencies:
  wechat_assets_picker: ^latest_version
```

最新的**稳定**版本是: [![pub package](https://img.shields.io/pub/v/wechat_assets_picker?logo=dart&label=stable&style=flat-square)](https://pub.dev/packages/wechat_assets_picker)

最新的**开发**版本是: [![pub package](https://img.shields.io/pub/v/wechat_assets_picker?color=42a012&include_prereleases&label=dev&logo=dart&style=flat-square)](https://pub.dev/packages/wechat_assets_picker)

在你的代码中导入：

```dart
import 'package:wechat_assets_picker/wechat_assets_picker.dart';
```

### Android

需要声明的权限：`INTERNET`, `READ_EXTERNAL_STORAGE`, `WRITE_EXTERNAL_STORAGE`, `ACCESS_MEDIA_LOCATION`。

如果你发现有一些与`Glide`有关的警告日志输出，那么主项目就需要要实现 `AppGlideModule`。比如：
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
如果你使用了与该库不一样的`Glide`版本，请将以下内容添加到`build.gradle`：
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

在 `ios/Podfile` 中指定最低构建版本至 *9.0*。
```
platform :ios, '9.0'
```

将以下内容添加至`info.plist`。

```
<key>NSAppTransportSecurity</key>
<dict>
	<key>NSAllowsArbitraryLoads</key>
  <true/>
</dict>
<key>NSPhotoLibraryUsageDescription</key>
<string>你的相册权限描述</string>
```



## 使用方法 📖

| 参数名           | 类型               | 描述                                      | 默认值             |
| -------------- | ------------------ | ------------------------------------------------ | ------------------- |
| context        | `BuildContext`     | 用于路由的上下文                      | `null`              |
| maxAssets      | `int`              | 最多选择的图片数量                      | 9                   |
| pageSize | `int` | 分页加载时每页加载的资源数量。**必须为网格数的倍数。** 设置为`null`可以取消分页。 | 320 (80 * 4) |
| pathThumbSize | `int`              | 选择器的缩略图大小                      | 80                  |
| gridCount      | `int`              | 选择器网格数量                        | 4                   |
| requestType    | `RequestType`      | 选择器选择资源的类型                    | `RequestType.image` |
| specialPickerType | `SpecialPickerType` | 提供一些特殊的选择器类型以整合非常规的选择行为 | `null` |
| selectedAssets | `List<AssetEntity>` | 已选的资源。确保不重复选择。如果你允许重复选择，请将其置空。 | `null`              |
| themeColor     | `Color`            | 选择器的主题色  | `Color(0xff00bc56)` |
| pickerTheme | `ThemeData` | 选择器的主题提供，包括查看器 | `null` |
| sortPathDelegate | `SortPathDeleage` | 资源路径的排序实现，可自定义路径排序方法 | `CommonSortPathDelegate` |
| textDelegate | `TextDelegate` | 选择器的文本代理构建，用于自定义文本 | `DefaultTextDelegate()` |
| filterOptions | `FilterOptionGroup` | Allow users to customize assets filter options. | `null` |
| customItemBuilder | `WidgetBuilder` | 自定义item的构造方法 | `null` |
| customItemPosition | `CustomItemPosition` | 允许用户在选择器中添加一个自定义item，并指定位置。 | `CustomItemPosition.none` |
| routeCurve | `Curve` | 选择构造路由动画的曲线 | `Curves.easeIn` |
| routeDuration | `Duration` | 选择构造路由动画的时间 | `const Duration(milliseconds: 500)` |

### 简单的使用方法

```dart
final List<AssetEntity> assets = await AssetPicker.pickAssets(context);
```

或者

```dart
AssetPicker.pickAsset(context).then((List<AssetEntity> assets) {
  /.../
});
```

### 完整参数的使用方法

欲了解各种选择器模式，请直接运行 example 查看。

### 注册资源变化回调
```dart
AssetPicker.registerObserve(); // 注册回调
```
```dart
AssetPicker.unregisterObserve(); // 取消注册回调
```

## 类介绍 💭

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

## 常见问题 ❔

### 如何获取资源的路径以进行上传或编辑等操作的整合？

你不需要获得路径（也许）。

`File` 对象可以通过 `entity.originFile` 获得，如果需要 `Uint8List` 则使用 `entity.originBytes`。

如果再此之后你仍然需要路径，那么可以通过已获得的 `File` 对象获取： `file.absolutePath`。

### 从`File`或`Uint8List`创建`AssetEntity`的方法

如果需要使用此库结合一些拍照需求，可通过以下方法将`File`或`Uint8List`转为`AssetEntity`。

```dart
final File file = your_file; // 你的File对象
final Uint8List byteData = await file.readAsBytes(); // 转为Uint8List
final AssetEntity imageEntity = await PhotoManager.editor.saveImage(byteData); // 存入手机并生成AssetEntity
```

如果不想保留文件，可以在操作完成（上传完或业务处理完）后进行删除：

```dart
final List<String> result = await PhotoManager.editor.deleteWithIds([entity.id]);
```

参考文档： [flutter_photo_manager#insert-new-item](https://github.com/CaiJingLong/flutter_photo_manager#insert-new-item)


### 控制台提示 'Failed to find GeneratedAppGlideModule'

```
W/Glide   (21133): Failed to find GeneratedAppGlideModule. You should include an annotationProcessor complie dependency on com.github.bumptech.glide:compiler in you application ana a @GlideModule annotated AppGlideModule implementation or LibraryGlideModules will be silently ignored.
```

`Glide` 通过注解来保证单例，防止单例或版本之间的冲突，而因为`photo_manager`使用了`Glide`提供部分图片功能，所以使用它的项目必须实现自己的`AppGlideModule`。 请移步[Android](#android)部分了解如何实现。

