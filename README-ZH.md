# Flutter 仿微信资源选择器

[![pub package](https://img.shields.io/pub/v/wechat_assets_picker?color=42a012&label=%E7%A8%B3%E5%AE%9A%E7%89%88&logo=dart&style=flat-square)](https://pub.flutter-io.cn/packages/wechat_assets_picker)
[![pub package](https://img.shields.io/pub/v/wechat_assets_picker?color=42a012&include_prereleases&label=%E5%BC%80%E5%8F%91%E7%89%88&logo=dart&style=flat-square)](https://pub.flutter-io.cn/packages/wechat_assets_picker)
[![Build status](https://img.shields.io/github/workflow/status/fluttercandies/flutter_wechat_assets_picker/Build%20test?label=%E7%8A%B6%E6%80%81&logo=github&style=flat-square)](https://github.com/fluttercandies/flutter_wechat_assets_picker/actions?query=workflow%3A%22Build+test%22)
[![CodeFactor](https://img.shields.io/codefactor/grade/github/fluttercandies/flutter_wechat_assets_picker?label=%E4%BB%A3%E7%A0%81%E8%B4%A8%E9%87%8F&logo=codefactor&logoColor=%23ffffff&style=flat-square)](https://www.codefactor.io/repository/github/fluttercandies/flutter_wechat_assets_picker)
[![GitHub license](https://img.shields.io/github/license/fluttercandies/flutter_wechat_assets_picker?label=%E5%8D%8F%E8%AE%AE&style=flat-square)](https://github.com/fluttercandies/flutter_wechat_assets_picker/blob/master/LICENSE)

[![Awesome Flutter](https://img.shields.io/badge/Awesome-Flutter-blue.svg?longCache=true&style=flat-square)](https://github.com/Solido/awesome-flutter)
[![GitHub stars](https://img.shields.io/github/stars/fluttercandies/flutter_wechat_assets_picker?logo=github&style=flat-square)](https://github.com/fluttercandies/flutter_wechat_assets_picker/stargazers)
[![GitHub forks](https://img.shields.io/github/forks/fluttercandies/flutter_wechat_assets_picker?logo=github&style=flat-square)](https://github.com/fluttercandies/flutter_wechat_assets_picker/network)
<a target="_blank" href="https://jq.qq.com/?_wv=1027&k=5bcc0gy"><img border="0" src="https://pub.idqqimg.com/wpa/images/group.png" alt="FlutterCandies" title="FlutterCandies"></a>

Language: [English](README.md) | 中文简体

对标微信的**资源选择器**，基于`photo_manager`实现资源相关功能，`extended_image`用于查看图片，`provider`用于协助管理选择器的状态。

拍照及录制视频，请查看 example 详细用法，并前往 [wechat_camera_picker](https://fluttercandies.github.io/flutter_wechat_camera_picker/README-ZH.html) 。

所有的界面细节基于 微信 7.x 版本，将在微信版本更新后随时进行跟进。

**贴士：** 如果你觉得你的自定义实现会在某些程度上帮助其他人实现他们的需求，你可以通过 PR 提交你的实现。
更多信息请参考 [贡献自定义实现](example/lib/customs/CONTRIBUTING.md) 。

## 目录 🗂

* [迁移指南](#迁移指南-%EF%B8%8F)
* [特性](#特性-)
* [截图](#截图-)
* [准备工作](#准备工作-)
  * [版本限制](#版本限制)
  * [Flutter](#flutter)
  * [Android](#android)
  * [iOS](#ios)
  * [MacOS](#macos)
* [使用方法](#使用方法-)
  * [简单的使用方法](#简单的使用方法)
  * [完整参数的使用方法](#完整参数的使用方法)
  * [展示选中的资源](#展示选中的资源)
  * [注册资源变化回调](#注册资源变化回调)
  * [自定义类型或 UI](#自定义类型或-ui)
* [类介绍](#类介绍-)
  * [`AssetEntity`](#assetentity)
* [常见问题](#常见问题-)
  * [编译时报错 `Unresolved reference: R`](#编译时报错-unresolved-reference-r)
  * [如何获取资源的路径以进行上传或编辑等操作的整合？](#如何获取资源的路径以进行上传或编辑等操作的整合)
  * [如何更改 'Recent' 或其他路径的名称或属性？](#如何更改-recent-或其他路径的名称或属性)
  * [从 `File` 或 `Uint8List` 创建 `AssetEntity` 的方法](#从-file-或-uint8list-创建-assetentity-的方法)
  * [控制台提示 'Failed to find GeneratedAppGlideModule'](#控制台提示-failed-to-find-generatedappglidemodule)
  * [禁用媒体位置权限](#禁用媒体位置权限)

## 迁移指南 ♻️

查看 [迁移指南](guides/migration_guide.md).

## 特性 ✨

- ♻️ 支持基于代理重载的全量自定义
- 💚 99% 的微信风格
- ⚡️ 根据参数可调的性能优化
- 📷 图片资源支持
  - 🔬 HEIC/HEIF 格式图片支持
- 🎥 视频资源支持
- 🎶 音频资源支持
- 1️⃣ 单资源模式
- 💱 国际化支持
  - ⏪ RTL 语言支持
- ➕ 特殊 widget 构建支持（前置/后置）
- 🗂 自定义路径排序支持
- 📝 自定义文本构建支持
- ⏳ 自定义筛选规则支持（ `photo_manager` ）
- 🎏 完整的自定义主题
- 💻 支持 MacOS

## 截图 📸

| ![1](https://tva1.sinaimg.cn/large/007S8ZIlgy1ggo5plm5wlj30u01t0zp7.jpg) | ![2](https://tva1.sinaimg.cn/large/007S8ZIlgy1ggo5q69848j30u01t04o5.jpg) | ![3](https://tva1.sinaimg.cn/large/007S8ZIlgy1ggo5q60v9qj30u01t07vh.jpg) |
| ------------------------------------------------------------ | ------------------------------------------------------------ | ------------------------------------------------------------ |
| ![4](https://tva1.sinaimg.cn/large/007S8ZIlgy1ggo5q5qe7jj30u01t04qp.jpg) | ![5](https://tva1.sinaimg.cn/large/007S8ZIlgy1ggo5q5jobgj30u01t0ngi.jpg) | ![6](https://tva1.sinaimg.cn/large/007S8ZIlgy1ggo5q5cebej30u01t04a0.jpg) |
| ![7](https://tva1.sinaimg.cn/large/007S8ZIlgy1ggo5q56xuhj30u01t077a.jpg) | ![8](https://tva1.sinaimg.cn/large/007S8ZIlgy1ggo5q50otnj30u01t0kjf.jpg) | ![9](https://tva1.sinaimg.cn/large/007S8ZIlgy1ggo5q4o7x5j30u01t0e81.jpg) |

## 开始前的注意事项 ‼️

尽管该库提供了资源的选择，其仍然要求使用者构建自己的方法来处理显示、上传等操作。如果你在使用该库的过程对某些方法或API有疑问，请运行demo并查看[photo_manager](https://github.com/CaiJingLong/flutter_photo_manager)对相关方法的使用说明。

## 准备工作 🍭

### 版本限制

Flutter SDK：`>=2.0.0` 。

如果在 `flutter pub get` 时遇到了失败问题，请使用 `dependency_overrides` 解决。参考[这里](#xxx-版本获取冲突-例如-dartx)。

### Flutter

将 `wechat_assets_picker` 添加至 `pubspec.yaml` 引用。

```yaml
dependencies:
  wechat_assets_picker: ^latest_version
```

最新的**稳定**版本是: [![pub package](https://img.shields.io/pub/v/wechat_assets_picker?logo=dart&label=stable&style=flat-square)](https://pub.flutter-io.cn/packages/wechat_assets_picker)

最新的**开发**版本是: [![pub package](https://img.shields.io/pub/v/wechat_assets_picker?color=42a012&include_prereleases&label=dev&logo=dart&style=flat-square)](https://pub.flutter-io.cn/packages/wechat_assets_picker)

在你的代码中导入：

```dart
import 'package:wechat_assets_picker/wechat_assets_picker.dart';
```

### Android

依赖要求项目的安卓原生部分整合至 Android embedding v2，更多信息请至 [Upgrading pre 1.12 Android projects](https://github.com/flutter/flutter/wiki/Upgrading-pre-1.12-Android-projects) 查看。

需要声明的权限：`INTERNET`, `READ_EXTERNAL_STORAGE`, `WRITE_EXTERNAL_STORAGE`, `ACCESS_MEDIA_LOCATION`。

如果你发现有一些与`Glide`有关的警告日志输出，那么主项目就需要实现 `AppGlideModule`。请查看 [Generated API](https://muyangmin.github.io/glide-docs-cn/doc/generatedapi.html).

### iOS

在 `ios/Podfile` 中指定最低构建版本至 **9.0**。
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

### MacOS

目前 Flutter 桌面版仍然在开发阶段，所以请注意，任何与桌面版本有关的问题都不会受到技术支持。

1. 在 `macos/Podfile` 中指定最低构建版本至 **10.15**。

2. 使用 **Xcode** 打开 `macos/Runner.xcworkspace`。接着根据下面的截图将最低构建版本提升至 **10.15**。

3. ![step 1](https://tva1.sinaimg.cn/large/007S8ZIlgy1ghw67v4yk4j30qy0b50u0.jpg)

4. ![step 2](https://tva1.sinaimg.cn/large/007S8ZIlgy1ghw67vd3f2j30jv04zgm5.jpg)

5. 与 iOS 一样，添加相同的东西到  `info.plist` 里。

## 使用方法 📖

| 参数名                     | 类型                    | 描述                                      | 默认值             |
| ------------------------- | ---------------------- | ------------------------------------------------ | ------------------- |
| selectedAssets            | `List<AssetEntity>?`   | 已选的资源。确保不重复选择。如果你允许重复选择，请将其置空。 | `null`              |
| maxAssets                 | `int`                  | 最多选择的图片数量                      | 9                   |
| pageSize                  | `int`                  | 分页加载时每页加载的资源数量。**必须为网格数的倍数。** 设置为`null`可以取消分页。 | 320 (80 * 4) |
| gridThumbSize             | `int`                  | 预览网格的缩略图大小                     | 200                  |
| pathThumbSize             | `int`                  | 路径选择器的缩略图大小                    | 80                  |
| previewThumbSize          | `List<int>?`           | 预览时图片的缩略图大小                    | `null`                 |
| gridCount                 | `int`                  | 选择器网格数量                        | 4                   |
| requestType               | `RequestType`          | 选择器选择资源的类型                    | `RequestType.image` |
| specialPickerType         | `SpecialPickerType?`   | 提供一些特殊的选择器类型以整合非常规的选择行为 | `null` |
| themeColor                | `Color?`               | 选择器的主题色  | `Color(0xff00bc56)` |
| pickerTheme               | `ThemeData?`           | 选择器的主题提供，包括查看器 | `null` |
| sortPathDelegate          | `SortPathDeleage?`     | 资源路径的排序实现，可自定义路径排序方法 | `CommonSortPathDelegate` |
| textDelegate              | `DefaultAssetsPickerTextDelegate?` | 选择器的文本代理构建，用于自定义文本 | `DefaultAssetsPickerTextDelegate()` |
| filterOptions             | `FilterOptionGroup?`   | 允许用户自定义资源过滤条件 | `null` |
| specialItemBuilder        | `WidgetBuilder?`       | 自定义item的构造方法 | `null` |
| specialItemPosition       | `SpecialItemPosition`  | 允许用户在选择器中添加一个自定义item，并指定位置。 | `SpecialPosition.none` |
| allowSpecialItemWhenEmpty | `bool`                 | 在资源为空时是否允许显示自定义item  | `false` |
| routeCurve                | `Curve`                | 选择构造路由动画的曲线 | `Curves.easeIn` |
| routeDuration             | `Duration`             | 选择构造路由动画的时间 | `const Duration(milliseconds: 500)` |

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

### 展示选中的资源

`AssetEntityImageProvider` 可以为 **图片 & 视频** 展示缩略图，以及展示 **图片的原图**。它的使用方法与常见的 `ImageProvider` 一致。

```dart
Image(image: AssetEntityImageProvider(asset, isOriginal: false))
```

请查看示例以了解它如何进行展示。

### 注册资源变化回调

```dart
AssetPicker.registerObserve(); // 注册回调
```
```dart
AssetPicker.unregisterObserve(); // 取消注册回调
```

### 自定义类型或 UI

`AssetPickerBuilderDelegate`、`AssetPickerViewerBuilderDelegate`、`AssetPickerProvider` 及
`AssetPickerViewerProvider` 均已暴露且可重载。使用者可以使用自定义的泛型类型 `<A: 资源, P: 路径>`，
配合继承与重载，实现对应抽象类和类中的方法。更多用法请查看示例中的 `Custom` 页面，该页面包含一个以
`<File, Directory>` 为类型基础的选择器。

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

### 编译时报错 `Unresolved reference: R`

```groovy
e: <path>\photo_manager-x.y.z\android\src\main\kotlin\top\kikt\imagescanner\core\PhotoManagerDeleteManager.kt: (116, 36): Unresolved reference: R
e: <path>\photo_manager-x.y.z\android\src\main\kotlin\top\kikt\imagescanner\core\PhotoManagerDeleteManager.kt: (119, 36): Unresolved reference: createTrashRequest
e: <path>\photo_manager-x.y.z\android\src\main\kotlin\top\kikt\imagescanner\core\PhotoManagerPlugin.kt: (341, 84): Unresolved reference: R
e: <path>\photo_manager-x.y.z\android\src\main\kotlin\top\kikt\imagescanner\core\utils\Android30DbUtils.kt: (34, 34): Unresolved reference: R
e: <path>\photo_manager-x.y.z\android\src\main\kotlin\top\kikt\imagescanner\core\utils\IDBUtils.kt: (27, 67): Unresolved reference: R

FAILURE: Build failed with an exception.
```

请执行 `flutter clean`。

### 如何获取资源的路径以进行上传或编辑等操作的整合？

你不需要获得路径（也许）。

`File` 对象可以通过 `entity.originFile` 获得，如果需要 `Uint8List` 则使用 `entity.originBytes`。

如果再此之后你仍然需要路径，那么可以通过已获得的 `File` 对象获取： `file.absolutePath`。

### 如何更改 'Recent' 或其他路径的名称或属性？

由 `photo_manager` 传递的 “Recent” 路径，包含了您设备上的所有的 `AssetEntity`。大部分的平台都会将这个路径命名为 “Recent”。尽管我们提供了自定义文字构建的能力，但是 `AssetPathEntity` 的名字或属性只能通过 `SortPathDelegate` 进行更改。这是你能访问到所有 `AssetPathEntity` 的唯一方法，或者说，是现阶段我们暴露出来的唯一方法。

若需要更改某一个路径的名字，继承 `SortPathDelegate` 并实现你自己的构建，接着像如下代码一样进行编写：

```dart
/// 构建你自己的排序
class CustomSortPathDelegate extends SortPathDelegate {
  const CustomSortPathDelegate();

  @override
  void sort(List<AssetPathEntity> list) {
    ///...///

    // 在这里你可以对每个你认为需要的路径进行判断。
    // 我们唯一推荐更改的属性是 [name]，
    // 并且我们不对更改其他属性造成的问题负责。
    for (final AssetPathEntity entity in list) {
      // 如果这个路径的 `isAll` 为真，则该路径就是你需要的。
      if (entity.isAll) {
        entity.name = '最近';
      }
    }

    ///...///
  }
}
```

将你的构建传递至静态调用方法里，而后你就会看到你自定义了名称的路径。

### 从 `File` 或 `Uint8List` 创建 `AssetEntity` 的方法

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

### 禁用媒体位置权限

Android 将默认包含 `ACCESS_MEDIA_LOCATION` 权限。
这个权限是在 Android Q 中引入的。
如果你的应用不需要这个权限，
你需要在你的应用中的 `AndroidManifest.xml` 中添加以下节点内容：
```xml
<uses-permission
  android:name="android.permission.ACCESS_MEDIA_LOCATION"
  tools:node="remove"
  />
```

## 致谢

> IntelliJ IDEA 的每个方面都旨在最大化开发者生产力。结合智能编码辅助与符合人体工程学的设计，让开发不仅高效，更成为一种享受。

感谢 [JetBrains](https://www.jetbrains.com/?from=fluttercandies) 为开源项目提供免费的 [IntelliJ IDEA](https://www.jetbrains.com/idea/?from=fluttercandies) 等 IDE 的授权。

[<img src=".github/jetbrains-variant.png" width="200"/>](https://www.jetbrains.com/?from=fluttercandies)