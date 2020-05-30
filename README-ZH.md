# Flutter仿微信资源选择器

[![pub package](https://img.shields.io/pub/v/wechat_assets_picker?logo=dart&label=stable&style=flat-square)](https://pub.dev/packages/wechat_assets_picker)
[![pub package](https://img.shields.io/pub/v/wechat_assets_picker?color=42a012&include_prereleases&label=rc%20version&logo=dart&style=flat-square)](https://pub.dev/packages/wechat_assets_picker)
[![GitHub stars](https://img.shields.io/github/stars/fluttercandies/flutter_wechat_assets_picker?logo=github&style=flat-square)](https://github.com/fluttercandies/flutter_wechat_assets_picker/stargazers)
[![GitHub forks](https://img.shields.io/github/forks/fluttercandies/flutter_wechat_assets_picker?logo=github&style=flat-square)](https://github.com/fluttercandies/flutter_wechat_assets_picker/network)
[![GitHub license](https://img.shields.io/github/license/fluttercandies/flutter_wechat_assets_picker?style=flat-square)](https://github.com/fluttercandies/flutter_wechat_assets_picker/blob/master/LICENSE)
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
* [常见问题](#常见问题)
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

![1.png](screenshots/1.png)![2.png](screenshots/2.png)![3.png](screenshots/3.png)

## 开始前的注意事项

尽管该库提供了资源的选择，其仍然要求使用者构建自己的方法来处理显示、上传等操作。如果你在使用该库的过程对某些方法或API有疑问，请运行demo并查看[photo_manager](https://github.com/CaiJingLong/flutter_photo_manager)对相关方法的使用说明。

## 准备工作 🍭

### Flutter

将`wechat_assets_picker`添加至`pubspec.yaml`引用。

```yaml
dependencies:
  wechat_assets_picker: ^2.2.0
```

在你的代码中导入：

```dart
import 'package:wechat_assets_picker/wechat_assets_picker.dart';
```

### Android

应用至少需要声明三个权限：`INTERNET` `READ_EXTERNAL_STORAGE WRITE_EXTERNAL_STORAGE`

如果你发现有一些警告日志输出，那么主项目组就需要要实现 `AppGlideModule`。比如：
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
| selectedAssets | `List<AssetEntity>` | 已选的资源。确保不重复选择。如果你允许重复选择，请将其置空。 | `null`              |
| themeColor     | `Color`            | 选择器的主题色  | `Color(0xff00bc56)` |
| pickerTheme | `ThemeData` | 选择器的主题提供，包括查看器 | `null` |
| sortPathDelegate | `SortPathDeleage` | 资源路径的排序实现，可自定义路径排序方法 | `CommonSortPathDelegate` |
| textDelegate | `TextDelegate` | 选择器的文本代理构建，用于自定义文本 | `DefaultTextDelegate()` |
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

```dart
List<AssetEntity> assets = <AssetEntity>[];

final List<AssetEntity> result = await AssetPicker.pickAssets(
  context,
  maxAssets: 9,
  pageSize: 320,
  pathThumbSize: 80,
  gridCount: 4,
  requestType: RequestType.image,
  selectedAssets: assets,
  themeColor: Colors.cyan,
  pickerTheme: ThemeData.dark(), // 不能跟`themeColor`同时设置
  textDelegate: DefaultTextDelegate(),
  sortPathDelegate: CommonSortPathDelegate(),
  routeCurve: Curves.easeIn,
  routeDuration: const Duration(milliseconds: 500),
);
```

或者

```dart
List<AssetEntity> assets = <AssetEntity>[];

AssetPicker.pickAssets(
  context,
  maxAssets: 9,
  pageSize: 320,
  pathThumbSize: 80,
  gridCount: 4,
  requestType: RequestType.image,
  selectedAssets: assets,
  themeColor: Colors.cyan,
  pickerTheme: ThemeData.dark(), // 不能跟`themeColor`同时设置
  textDelegate: DefaultTextDelegate(),
  sortPathDelegate: CommonSortPathDelegate(),
  routeCurve: Curves.easeIn,
  routeDuration: const Duration(milliseconds: 500),
).then((List<AssetEntity> assets) {
  /.../
});
```

### 注册资源变化回调
```dart
AssetPicker.registerObserve(); // 注册回调
```
```dart
AssetPicker.unregisterObserve(); // 取消注册回调
```

## 常见问题

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

