<!-- Copyright 2019 The FlutterCandies author. All rights reserved.
Use of this source code is governed by an Apache license
that can be found in the LICENSE file. -->

# Flutter WeChat Assets Picker

[![pub package](https://img.shields.io/pub/v/wechat_assets_picker?color=42a012&label=%E7%A8%B3%E5%AE%9A%E7%89%88&logo=dart&style=flat-square)](https://pub.flutter-io.cn/packages/wechat_assets_picker)
[![pub package](https://img.shields.io/pub/v/wechat_assets_picker?color=42a012&include_prereleases&label=%E5%BC%80%E5%8F%91%E7%89%88&logo=dart&style=flat-square)](https://pub.flutter-io.cn/packages/wechat_assets_picker)
[![Build status](https://img.shields.io/github/workflow/status/fluttercandies/flutter_wechat_assets_picker/Build%20test?label=%E7%8A%B6%E6%80%81&logo=github&style=flat-square)](https://github.com/fluttercandies/flutter_wechat_assets_picker/actions?query=workflow%3A%22Build+test%22)
[![CodeFactor](https://img.shields.io/codefactor/grade/github/fluttercandies/flutter_wechat_assets_picker?label=%E4%BB%A3%E7%A0%81%E8%B4%A8%E9%87%8F&logo=codefactor&logoColor=%23ffffff&style=flat-square)](https://www.codefactor.io/repository/github/fluttercandies/flutter_wechat_assets_picker)
[![GitHub license](https://img.shields.io/github/license/fluttercandies/flutter_wechat_assets_picker?label=%E5%8D%8F%E8%AE%AE&style=flat-square)](https://github.com/fluttercandies/flutter_wechat_assets_picker/blob/master/LICENSE)

[![Awesome Flutter](https://img.shields.io/badge/Awesome-Flutter-blue.svg?longCache=true&style=flat-square)](https://github.com/Solido/awesome-flutter)
[![GitHub stars](https://img.shields.io/github/stars/fluttercandies/flutter_wechat_assets_picker?logo=github&style=flat-square)](https://github.com/fluttercandies/flutter_wechat_assets_picker/stargazers)
[![GitHub forks](https://img.shields.io/github/forks/fluttercandies/flutter_wechat_assets_picker?logo=github&style=flat-square)](https://github.com/fluttercandies/flutter_wechat_assets_picker/network)
<a target="_blank" href="https://jq.qq.com/?_wv=1027&k=5bcc0gy"><img border="0" src="https://pub.idqqimg.com/wpa/images/group.png" alt="FlutterCandies" title="FlutterCandies"></a>

Language: [English](README.md) | 中文

基于微信 UI 的 **资源选择器**，
基于 [photo_manager][photo_manager pub] 实现资源相关功能，
[extended_image][extended_image pub] 用于查看图片，
[provider][provider pub] 用于协助管理选择器的状态。

需要拍照及录制视频，请查看示例的详细用法，
并前往 [wechat_camera_picker][wechat_camera_picker pub]。

当前的界面设计基于的微信版本：**8.x**
界面更新将在微信版本更新后随时进行跟进。

**注意：** 如果你觉得你的自定义实现会在某些程度上帮助其他人实现他们的需求，
你可以通过 PR 提交你的自定义实现。更多信息请参考
[贡献自定义实现](example/lib/customs/CONTRIBUTING.md) 。

## 目录 🗂

* [迁移指南](#迁移指南-%EF%B8%8F)
* [特性](#特性-)
* [截图](#截图-)
* [准备工作](#准备工作-)
  * [版本兼容](#版本兼容)
  * [Flutter](#flutter)
  * [Android](#android)
  * [iOS](#ios)
  * [macOS](#macos)
* [使用方法](#使用方法-)
  * [简单的使用方法](#简单的使用方法)
  * [使用自定义代理](#使用自定义代理)
  * [更详细的使用方法](#更详细的使用方法)
  * [展示选中的资源](#展示选中的资源)
  * [注册资源变化回调](#注册资源变化回调)
  * [自定义类型或 UI](#自定义类型或-ui)
* [常见问题](#常见问题-)
  * [Execution failed for task ':photo_manager:compileDebugKotlin'](#execution-failed-for-task-photo_managercompiledebugkotlin)
  * [如何获取资源的路径以进行上传或编辑等操作的整合？](#如何获取资源的路径以进行上传或编辑等操作的整合)
  * [从 `File` 或 `Uint8List` 创建 `AssetEntity` 的方法](#从-file-或-uint8list-创建-assetentity-的方法)
  * [控制台提示 'Failed to find GeneratedAppGlideModule'](#控制台提示-failed-to-find-generatedappglidemodule)

## 迁移指南 ♻️

查看 [迁移指南][]。

## 特性 ✨

- ♻️ 支持基于代理重载的全量自定义
- 💚 99% 的微信风格
- ⚡️ 根据参数可调的性能优化
- 📷 图片资源支持
  - 🔬 HEIF 格式图片支持
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

| ![1](https://pic.alexv525.com/2021-07-05-picker_1.jpg)   | ![2](https://pic.alexv525.com/2021-07-05-picker_2.jpg)   | ![3](https://pic.alexv525.com/2021-07-05-picker_3.jpg)   |
|----------------------------------------------------------|----------------------------------------------------------|----------------------------------------------------------|
| ![4](https://pic.alexv525.com/2021-07-05-picker_4.jpg)   | ![5](https://pic.alexv525.com/2021-07-05-picker_5.jpg)   | ![6](https://pic.alexv525.com/2021-07-05-picker_6.jpg)   |
| ![7](https://pic.alexv525.com/2021-07-06-picker_7.jpg)   | ![8](https://pic.alexv525.com/2021-07-05-picker_8.jpg)   | ![9](https://pic.alexv525.com/2021-07-05-picker_9-1.jpg) |
| ![10](https://pic.alexv525.com/2021-07-05-picker_10.png) | ![10](https://pic.alexv525.com/2021-07-05-picker_11.png) | ![12](https://pic.alexv525.com/2021-07-05-picker_12.png) |

## 开始前的注意事项 ‼️

该库与 [photo_manager][photo_manager pub] 有强关联性，
大部分方法的行为是由 photo_manager 进行控制的。
当你有与相关的 API 和行为的疑问时，你可以查看
[photo_manager API 文档][] 了解更多细节。

众多使用场景都已包含在示例中。
在你提出任何问题之前，请仔细并完整地查看和使用示例。

## 准备工作 🍭

### 版本兼容

|        | 2.8.0 | 2.10.0 | 3.0.0 |
|--------|:-----:|:------:|:-----:|
| 7.3.0+ |  不适用  |  不适用   |   ✅   |
| 7.0.0+ |   ✅   |   ✅    |   ❌   |
| 6.3.0+ |   ✅   |   ✅    |   ❌   |

如果在 `flutter pub get` 时遇到了 `resolve conflict` 失败问题，
请使用 `dependency_overrides` 解决。

### Flutter

执行 `flutter pub add wechat_assets_picker`，
或者将 `wechat_assets_picker` 手动添加至 `pubspec.yaml` 引用。

```yaml
dependencies:
  wechat_assets_picker: ^latest_version
```

最新的 **稳定** 版本是: 
[![pub package](https://img.shields.io/pub/v/wechat_assets_picker?logo=dart&label=stable&style=flat-square)](https://pub.flutter-io.cn/packages/wechat_assets_picker)

最新的 **开发** 版本是: 
[![pub package](https://img.shields.io/pub/v/wechat_assets_picker?color=42a012&include_prereleases&label=dev&logo=dart&style=flat-square)](https://pub.flutter-io.cn/packages/wechat_assets_picker)

在你的代码中导入：

```dart
import 'package:wechat_assets_picker/wechat_assets_picker.dart';
```

### Android

需要声明的权限：`READ_EXTERNAL_STORAGE`（已声明）.
可选声明的权限：`WRITE_EXTERNAL_STORAGE`、`ACCESS_MEDIA_LOCATION`.

如果你的目标 SDK 版本大于 29，
你必须声明在 `AndroidManifest.xml` 的 `<application>` 节点中
声明 `requestLegacyExternalStorage`。
详情请参考示例。

如果你发现有一些与 `Glide` 有关的警告日志输出，
那么主项目就需要实现 `AppGlideModule`。
详细信息请查看 [Generated API 文档][]。

### iOS

1. 在 `ios/Podfile` 中指定最低构建版本至 **9.0**。
```ruby
platform :ios, '9.0'
```

2. 将以下内容添加至 `info.plist`。
```plist
<key>NSAppTransportSecurity</key>
<dict>
	<key>NSAllowsArbitraryLoads</key>
  <true/>
</dict>
<key>NSPhotoLibraryUsageDescription</key>
<string>你的相册权限描述</string>
```

### macOS

1. 在 `macos/Podfile` 中指定最低构建版本至 **10.15**。
```ruby
platform :osx, '10.15'
```
2. 使用 **Xcode** 打开 `macos/Runner.xcworkspace`。
   接着根据下面的截图将最低构建版本提升至 **10.15**。
3. ![step 1](https://tva1.sinaimg.cn/large/007S8ZIlgy1ghw67v4yk4j30qy0b50u0.jpg)
4. ![step 2](https://tva1.sinaimg.cn/large/007S8ZIlgy1ghw67vd3f2j30jv04zgm5.jpg)
5. 与 iOS 一样，添加相同的内容到 `info.plist` 里。

## 使用方法 📖

### 简单的使用方法

```dart
final List<AssetEntity>? result = await AssetPicker.pickAssets(context);
```

你可以使用 `AssetPickerConfig` 来调整选择时的行为。

```dart
final List<AssetEntity>? result = await AssetPicker.pickAssets(
  context,
  pickerConfig: const AssetPickerConfig(),
);
```

`AssetPickerConfig` 的成员说明：

| 参数名                               | 类型                                   | 描述                                                   | 默认值                         |
|-----------------------------------|--------------------------------------|------------------------------------------------------|-----------------------------|
| selectedAssets                    | `List<AssetEntity>?`                 | 已选的资源。确保不重复选择。                                       | `null`                      |
| maxAssets                         | `int`                                | 最多选择的图片数量                                            | 9                           |
| pageSize                          | `int`                                | 分页加载时每页加载的资源数量。**必须为网格数的倍数。                          | 80                          |
| gridThumbnailSize                 | `ThumbnailSize`                      | 预览网格的缩略图大小                                           | `ThumbnailSize.square(200)` |
| pathThumbnailSize                 | `ThumbnailSize`                      | 路径选择器的缩略图大小                                          | `ThumbnailSize.square(80)`  |
| previewThumbnailSize              | `ThumbnailSize?`                     | 预览时图片的缩略图大小                                          | `null`                      |
| requestType                       | `RequestType`                        | 选择器选择资源的类型                                           | `RequestType.common`        |
| specialPickerType                 | `SpecialPickerType?`                 | 提供一些特殊的选择器类型以整合非常规的选择行为                              | `null`                      |
| keepScrollOffset                  | `bool`                               | 选择器是否可以从同样的位置开始选择                                    | `null`                      |
| sortPathDelegate                  | `SortPathDelegate<AssetPathEntity>?` | 资源路径的排序实现，可自定义路径排序方法                                 | `CommonSortPathDelegate`    |
| sortPathsByModifiedDate           | `bool`                               | 是否结合 `FilterOptionGroup.containsPathModified` 进行路径排序 | `false`                     |
| filterOptions                     | `FilterOptionGroup?`                 | 允许用户自定义资源过滤条件                                        | `null`                      |
| gridCount                         | `int`                                | 选择器网格数量                                              | 4                           |
| themeColor                        | `Color?`                             | 选择器的主题色                                              | `Color(0xff00bc56)`         |
| pickerTheme                       | `ThemeData?`                         | 选择器的主题提供，包括查看器                                       | `null`                      |
| textDelegate                      | `AssetPickerTextDelegate?`           | 选择器的文本代理构建，用于自定义文本                                   | `AssetPickerTextDelegate()` |
| specialItemPosition               | `SpecialItemPosition`                | 允许用户在选择器中添加一个自定义item，并指定位置。                          | `SpecialPosition.none`      |
| specialItemBuilder                | `SpecialItemBuilder?`                | 自定义item的构造方法                                         | `null`                      |
| loadingIndicatorBuilder           | `IndicatorBuilder?`                  | 加载器的实现                                               | `null`                      |
| selectPredicate                   | `AssetSelectPredicate`               | 判断资源可否被选择                                            | `null`                      |
| shouldRevertGrid                  | `bool?`                              | 判断资源网格是否需要倒序排列                                       | `null`                      |
| limitedPermissionOverlayPredicate | `LimitedPermissionOverlayPredicate?` | 判断有限的权限情况下是否展示提示页面                                   | `null`                      |
| pathNameBuilder                   | `PathNameBuilder<AssetPathEntity>?`  | 构建自定义路径名称                                            | `null`                      |

### 更详细的使用方法

我们已将常用的调用方法封装在 [example](example) 中。

### 使用自定义代理

你只能在使用 `pickAssetsWithDelegate` 方法时
使用 `keepScrollOffset` 的功能。
更多细节请查看示例内的 `Keep scroll offset` 方法。

想要了解更多关于自定义代理实现的内容，
查阅 [`example/lib/customs`](example/lib/customs)。

#### 一般的调用选择情况

你可以在 `example/lib/pages/multi_assets_page.dart` 和
`example/lib/pages/single_assets_page.dart`
找到 `List<PickMethod> pickMethods`，
它分别定义了多选和单选可用的选择模式。
在选择资源后，资源会暂存并展示在页面下方。

##### 多选资源

页面中的最大选择数是 `9`，你可以按需修改。

某些模式只能在多选下使用，例如「朋友圈」(WeChat Moment) 模式。

##### 单选资源

一次只能且最多能选择一个资源。

#### 自定义选择器

你可以在「Custom」页面尝试自定义的选择器。
目前我们提供了一个基于 `Directory` 和 `File`
（与 `photo_manager` 完全无关）实现的选择器，
以及一个多 Tab 页切换的选择器。
如果你觉得你的实现有价值或能帮助到其他人，欢迎以 PR 的形式进行提交。
更多细节请阅读 [贡献自定义实现][]。

### 展示选中的资源

`AssetEntityImage` 和 `AssetEntityImageProvider`
可以为 **图片 & 视频** 展示缩略图，以及展示 **图片的原图**。
它的使用方法与常见的 `Image` 和 `ImageProvider` 一致。

```dart
/// AssetEntityImage
AssetEntityImage(asset, isOriginal: false);

/// AssetEntityImageProvider
Image(image: AssetEntityImageProvider(asset, isOriginal: false));
```

### 注册资源变化回调

```dart
/// 注册回调
AssetPicker.registerObserve();

/// 取消注册回调
AssetPicker.unregisterObserve();
```

### 自定义类型或 UI

`AssetPickerBuilderDelegate`、`AssetPickerViewerBuilderDelegate`、
`AssetPickerProvider` 及 `AssetPickerViewerProvider` 均已暴露且可重载。
使用者可以使用自定义的泛型类型 `<A: 资源, P: 路径>`，
配合继承与重载，实现对应抽象类和类中的方法。
更多用法请查看示例中的 `Custom` 页面，
该页面包含一个以 `<File, Directory>` 为类型基础的选择器。

## 常见问题 ❔

### Execution failed for task ':photo_manager:compileDebugKotlin'

查看 [photo_manager#561][] 了解详细的解决方法。

### 如何获取资源的路径以进行上传或编辑等操作的整合？

你不需要获得路径（也许）。

`File` 对象可以通过 `entity.file` 或 `entity.originFile` 获得，
如果需要 `Uint8List` 则使用 `entity.originBytes`。

如果再此之后你仍然需要路径，
那么可以通过已获得的 `File` 对象获取：

```dart
final File file = await entity.file; // 缩略图或编辑后的视频
final File originFile = await entity.originFile; // 原图或者原视频
final String path = file.path;
final String originPath = originFile.path;
```

### 从 `File` 或 `Uint8List` 创建 `AssetEntity` 的方法

如果需要使用此库结合一些拍照需求，
可通过以下方法将 `File` 或 `Uint8List` 转为 `AssetEntity`。

```dart
final File file = your_file; // 你的 File 对象
final String path = file.path;
final AssetEntity fileEntity = await PhotoManager.editor.saveImageWithPath(
  path,
  title: basename(path),
); // 存入手机并生成 AssetEntity

final Uint8List data = your_data; // 你的 Uint8List 对象
final AssetEntity imageEntity = await PhotoManager.editor.saveImage(
  file.path,
  title: '带有后缀的名称.jpg',
); // 存入手机并生成 AssetEntity
```

**注意：如果不想保留文件，请尽量用 `File` 承载中间操作，**
否则在调用 `AssetEntity` 的删除时，某些系统下会触发系统弹窗事件：

```dart
final List<String> result = await PhotoManager.editor.deleteWithIds(
    <String>[entity.id],
);
```

参考文档：[photo_manager#insert-new-item][]

### 控制台提示 'Failed to find GeneratedAppGlideModule'

```
W/Glide   (21133): Failed to find GeneratedAppGlideModule. You should include an annotationProcessor complie dependency on com.github.bumptech.glide:compiler in you application ana a @GlideModule annotated AppGlideModule implementation or LibraryGlideModules will be silently ignored.
```

`Glide` 通过注解来保证单例，防止单例或版本之间的冲突，
而因为 `photo_manager` 使用了 `Glide` 提供部分图片功能，
所以使用它的项目必须实现自己的 `AppGlideModule`。
请移步 [Android](#android) 部分了解如何实现。

## 致谢

> IntelliJ IDEA 的每个方面都旨在最大化开发者生产力。结合智能编码辅助与符合人体工程学的设计，让开发不仅高效，更成为一种享受。

感谢 [JetBrains](https://www.jetbrains.com/?from=fluttercandies)
为开源项目提供免费的
[IntelliJ IDEA](https://www.jetbrains.com/idea/?from=fluttercandies)
等 IDE 的授权。

[<img src="https://github.com/fluttercandies/flutter_wechat_assets_picker/raw/master/.github/jetbrains-variant.png" width="200"/>](https://www.jetbrains.com/?from=fluttercandies)


[photo_manager pub]: https://pub.flutter-io.cn/packages/photo_manager
[extended_image pub]: https://pub.flutter-io.cn/packages/extended_image
[provider pub]: https://pub.flutter-io.cn/packages/provider
[wechat_camera_picker pub]: https://pub.flutter-io.cn/packages/wechat_camera_picker
[迁移指南]: https://github.com/fluttercandies/flutter_wechat_assets_picker/blob/main/guides/migration_guide.md
[photo_manager API 文档]: https://pub.flutter-io.cn/documentation/photo_manager/latest/
[Generated API 文档]: https://muyangmin.github.io/glide-docs-cn/doc/generatedapi.html
[贡献自定义实现]: https://github.com/fluttercandies/flutter_wechat_assets_picker/blob/main/example/lib/customs/CONTRIBUTING.md
[photo_manager#561]: https://github.com/CaiJingLong/flutter_photo_manager/issues/561
[photo_manager#insert-new-item]: https://github.com/CaiJingLong/flutter_photo_manager#insert-new-item
