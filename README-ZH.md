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

基于微信 UI 的 **资源选择器**，基于 `photo_manager` 实现资源相关功能，
`extended_image` 用于查看图片，`provider` 用于协助管理选择器的状态。

需要拍照及录制视频，请查看示例的详细用法，
并前往 [wechat_camera_picker](https://pub.flutter-io.cn/packages/wechat_camera_picker) 。

当前的界面设计基于的微信版本：**8.x**
界面更新将在微信版本更新后随时进行跟进。

**注意：** 如果你觉得你的自定义实现会在某些程度上帮助其他人实现他们的需求，你可以通过 PR 提交你的自定义实现。
更多信息请参考 [贡献自定义实现](example/lib/customs/CONTRIBUTING.md) 。

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

尽管该库提供了资源的选择，其仍然要求使用者构建自己的方法来处理显示、上传等操作。
如果你在使用该库的过程对某些方法或API有疑问，
请运行示例并查看 [photo_manager](https://github.com/CaiJingLong/flutter_photo_manager) 对相关方法的使用说明。

## 准备工作 🍭

### 版本兼容

|        | 2.0.0 | 2.2.0 | 2.5.0 |
|--------|:-----:|:-----:|:-----:|
| 6.2.1+ |   ❌   |   ❌   |   ✅   |
| 6.2.0  |   ✅   |   ✅   |   ✅   |
| 5.0.0+ |   ✅   |  N/A  |  N/A  |

如果在 `flutter pub get` 时遇到了 `resolve conflict` 失败问题，
请使用 `dependency_overrides` 解决。

### Flutter

将 `wechat_assets_picker` 添加至 `pubspec.yaml` 引用。

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

依赖要求项目的安卓原生部分整合至 Android embedding v2，
更多信息请至 [Upgrading pre 1.12 Android projects](https://github.com/flutter/flutter/wiki/Upgrading-pre-1.12-Android-projects)
查看。

需要声明的权限：`INTERNET`, `READ_EXTERNAL_STORAGE`, `WRITE_EXTERNAL_STORAGE`, `ACCESS_MEDIA_LOCATION`。
如果你不需要 `ACCESS_MEDIA_LOCATION` 权限，请参考 [禁用媒体位置权限](#禁用媒体位置权限) 要进行移除。

如果你发现有一些与 `Glide` 有关的警告日志输出，那么主项目就需要实现 `AppGlideModule`。
请查看 [Generated API](https://muyangmin.github.io/glide-docs-cn/doc/generatedapi.html).

### iOS

在 `ios/Podfile` 中指定最低构建版本至 **9.0**。
```ruby
platform :ios, '9.0'
```

将以下内容添加至 `info.plist`。
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

目前 Flutter 桌面版仍然在开发阶段，所以请注意，任何与桌面版本有关的问题都不会受到技术支持。

1. 在 `macos/Podfile` 中指定最低构建版本至 **10.15**。

2. 使用 **Xcode** 打开 `macos/Runner.xcworkspace`。接着根据下面的截图将最低构建版本提升至 **10.15**。

3. ![step 1](https://tva1.sinaimg.cn/large/007S8ZIlgy1ghw67v4yk4j30qy0b50u0.jpg)

4. ![step 2](https://tva1.sinaimg.cn/large/007S8ZIlgy1ghw67vd3f2j30jv04zgm5.jpg)

5. 与 iOS 一样，添加相同的东西到 `info.plist` 里。

## 使用方法 📖

| 参数名                       | 类型                                 | 描述                                             | 默认值                                 |
|---------------------------|------------------------------------|------------------------------------------------|-------------------------------------|
| selectedAssets            | `List<AssetEntity>?`               | 已选的资源。确保不重复选择。如果你允许重复选择，请将其置空。                 | `null`                              |
| maxAssets                 | `int`                              | 最多选择的图片数量                                      | 9                                   |
| pageSize                  | `int`                              | 分页加载时每页加载的资源数量。**必须为网格数的倍数。** 设置为`null`可以取消分页。 | 320 (80 * 4)                        |
| gridThumbSize             | `int`                              | 预览网格的缩略图大小                                     | 200                                 |
| pathThumbSize             | `int`                              | 路径选择器的缩略图大小                                    | 80                                  |
| previewThumbSize          | `List<int>?`                       | 预览时图片的缩略图大小                                    | `null`                              |
| gridCount                 | `int`                              | 选择器网格数量                                        | 4                                   |
| requestType               | `RequestType`                      | 选择器选择资源的类型                                     | `RequestType.image`                 |
| specialPickerType         | `SpecialPickerType?`               | 提供一些特殊的选择器类型以整合非常规的选择行为                        | `null`                              |
| themeColor                | `Color?`                           | 选择器的主题色                                        | `Color(0xff00bc56)`                 |
| pickerTheme               | `ThemeData?`                       | 选择器的主题提供，包括查看器                                 | `null`                              |
| sortPathDelegate          | `SortPathDeleage?`                 | 资源路径的排序实现，可自定义路径排序方法                           | `CommonSortPathDelegate`            |
| textDelegate              | `DefaultAssetsPickerTextDelegate?` | 选择器的文本代理构建，用于自定义文本                             | `DefaultAssetsPickerTextDelegate()` |
| filterOptions             | `FilterOptionGroup?`               | 允许用户自定义资源过滤条件                                  | `null`                              |
| specialItemBuilder        | `WidgetBuilder?`                   | 自定义item的构造方法                                   | `null`                              |
| specialItemPosition       | `SpecialItemPosition`              | 允许用户在选择器中添加一个自定义item，并指定位置。                    | `SpecialPosition.none`              |
| loadingIndicatorBuilder   | `IndicatorBuilder?`                | 加载器的实现                                         | `null`                              |
| allowSpecialItemWhenEmpty | `bool`                             | 在资源为空时是否允许显示自定义item                            | `false`                             |
| selectPredicate           | `AssetSelectPredicate`             | 判断资源可否被选择                                      | `null`                              |
| shouldRevertGrid          | `bool?`                            | 判断资源网格是否需要倒序排列                                 | `null`                              |
| routeCurve                | `Curve`                            | 选择构造路由动画的曲线                                    | `Curves.easeIn`                     |
| routeDuration             | `Duration`                         | 选择构造路由动画的时间                                    | `const Duration(milliseconds: 500)` |

### 简单的使用方法

```dart
final List<AssetEntity> assets = await AssetPicker.pickAssets(context);
```

### 使用自定义代理

你只能在使用 `pickAssetsWithDelegate` 方法时使用 `keepScrollOffset` 的功能。
更多细节请查看示例内的 `Keep scroll offset` 方法。

想要了解更多关于自定义代理实现的内容，
查阅 [`example/lib/customs`](example/lib/customs)。

### 更详细的使用方法

我们已将常用的调用方法封装在 [example](example) 中。

#### 一般的调用选择情况

你可以在 `example/lib/pages/multi_assets_page.dart` 和
`example/lib/pages/single_assets_page.dart` 找到 `List<PickMethod> pickMethods`，
它分别定义了多选和单选可用的选择模式。
在选择资源后，资源会暂存并展示在页面下方。

##### 多选资源

页面中的最大选择数是 `9`，你可以按需修改。

某些模式只能在多选下使用，例如「WeChat Moment」（朋友圈）模式。

##### 单选资源

一次只能且最多能选择一个资源。

#### 自定义选择器

你可以在「Custom」页面尝试自定义的选择器。
目前我们提供了一个基于 `Directory` 和 `File`
（与 `photo_manager` 完全无关）实现的选择器，
以及一个多 Tab 页切换的选择器。
如果你觉得你的实现有价值或能帮助到其他人，欢迎以 PR 的形式进行提交。
更多细节请阅读 [贡献自定义实现][example/lib/customs/CONTRIBUTING.md]

### 展示选中的资源

`AssetEntityImageProvider` 可以为 **图片 & 视频** 展示缩略图，以及展示 **图片的原图**。
它的使用方法与常见的 `ImageProvider` 一致。

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

## 常见问题 ❔

### Execution failed for task ':photo_manager:compileDebugKotlin'

查看 [photo_manager#561][] 了解详细的解决方法。

[photo_manager#561]: https://github.com/CaiJingLong/flutter_photo_manager/issues/561

### 如何获取资源的路径以进行上传或编辑等操作的整合？

你不需要获得路径（也许）。

`File` 对象可以通过 `entity.file` 或 `entity.originFile` 获得，
如果需要 `Uint8List` 则使用 `entity.originBytes`。

如果再此之后你仍然需要路径，那么可以通过已获得的 `File` 对象获取： `file.path`。

```dart
final File file = await entity.file; // 缩略图或编辑后的视频
final File originFile = await entity.originFile; // 原图或者原视频
final String path = file.path;
final String originPath = originFile.path;
```

### 如何更改 'Recent' 或其他路径的名称或属性？

由 `photo_manager` 传递的 “Recent” 路径，包含了你设备上的所有的 `AssetEntity`。
大部分的平台都会将这个路径命名为 “Recent”。尽管我们提供了自定义文字构建的能力，
但是 `AssetPathEntity` 的名字或属性只能通过 `SortPathDelegate` 进行更改。
这是你能访问到所有 `AssetPathEntity` 的唯一方法，或者说，是现阶段我们暴露出来的唯一方法。

若需要更改某一个路径的名字，继承 `CommonSortPathDelegate` 并实现你自己的构建，
接着像如下代码一样进行编写：

```dart
/// 构建你自己的排序
class CustomSortPathDelegate extends CommonSortPathDelegate {
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

如果需要使用此库结合一些拍照需求，可通过以下方法将 `File` 或 `Uint8List` 转为 `AssetEntity`。

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
final List<String> result = await PhotoManager.editor.deleteWithIds([entity.id]);
```

参考文档： [flutter_photo_manager#insert-new-item](https://github.com/CaiJingLong/flutter_photo_manager#insert-new-item)

### 控制台提示 'Failed to find GeneratedAppGlideModule'

```
W/Glide   (21133): Failed to find GeneratedAppGlideModule. You should include an annotationProcessor complie dependency on com.github.bumptech.glide:compiler in you application ana a @GlideModule annotated AppGlideModule implementation or LibraryGlideModules will be silently ignored.
```

`Glide` 通过注解来保证单例，防止单例或版本之间的冲突，
而因为 `photo_manager` 使用了 `Glide` 提供部分图片功能，所以使用它的项目必须实现自己的 `AppGlideModule`。
请移步 [Android](#android) 部分了解如何实现。

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

感谢 [JetBrains](https://www.jetbrains.com/?from=fluttercandies) 为开源项目提供免费的
[IntelliJ IDEA](https://www.jetbrains.com/idea/?from=fluttercandies) 等 IDE 的授权。

[<img src=".github/jetbrains-variant.png" width="200"/>](https://www.jetbrains.com/?from=fluttercandies)