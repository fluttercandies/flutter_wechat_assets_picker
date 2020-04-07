# Flutter仿微信资源选择器


[![pub package](https://img.shields.io/pub/v/wechat_assets_picker.svg)](https://pub.dev/packages/wechat_assets_picker)
[![GitHub stars](https://img.shields.io/github/stars/fluttercandies/flutter_wechat_assets_picker)](https://github.com/fluttercandies/flutter_wechat_assets_picker/stargazers)
[![GitHub forks](https://img.shields.io/github/forks/fluttercandies/flutter_wechat_assets_picker)](https://github.com/fluttercandies/flutter_wechat_assets_picker/network)
[![GitHub license](https://img.shields.io/github/license/fluttercandies/flutter_wechat_assets_picker)](https://github.com/fluttercandies/flutter_wechat_assets_picker/blob/master/LICENSE)
<a target="_blank" href="https://jq.qq.com/?_wv=1027&k=5bcc0gy"><img border="0" src="https://pub.idqqimg.com/wpa/images/group.png" alt="FlutterCandies" title="FlutterCandies"></a>

Language: [English](README.md) | 中文简体

对标微信的资源选择器，基于`photo_manager`实现资源相关功能，`extended_image`用于查看图片，`provider`用于协助管理选择器的状态。

## 目录 🗂

* [特性](#特性-)
* [截图](#截图-)
* [目标TODO](#目标todo-)
* [准备工作](#准备工作-)
  * [Flutter](#flutter)
  * [Android](#android)
  * [iOS](#ios)
* [使用方法](#使用方法-)
  * [简单的使用方法](#简单的使用方法)
  * [完整参数的使用方法](#完整参数的使用方法)

## 特性 ✨

- 💚 99%的微信风格
- 🌠 支持同时选择多个资源
- 🔍 支持资源预览（图片、视频）

## 目标TODO 📅

- [x] 图片资源支持
  - [ ] 图片编辑（裁剪/旋转/涂鸦）
- [x] 视频资源支持
  - [ ] 视频编辑
- [ ] 音频资源支持
- [ ] 单资源模式
- [x] 国际化支持
- [x] 自定义文本支持
- [ ] FFW支持

## 截图 📸

![1.png](screenshots/1.png)![2.png](screenshots/2.png)![3.png](screenshots/3.png)


## 准备工作 🍭

### Flutter

将`wechat_assets_picker`添加至`pubspec.yaml`引用。

```yaml
dependencies:
  wechat_assets_picker: $latest_version
```

在你的代码中导入：

```dart
import 'package:wechat_assets_picker/wechat_assets_picker.dart';
```

### Android

应用至少需要声明三个权限：`INTERNET` `READ_EXTERNAL_STORAGE WRITE_EXTERNAL_STORAGE`

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
| pageThumbSize  | `int`              | 选择器的缩略图大小                      | 80                  |
| gridCount      | `int`              | 选择器网格数量                        | 4                   |
| requestType    | `RequestType`      | 选择器选择资源的类型                    | `RequestType.image` |
| selectedAssets | `Set<AssetEntity>` | 已选的资源。使用 `Set` 以确保不重复选择 | `null`              |
| themeColor     | `Color`            | 选择器的主题色  | `Color(0xff00bc56)` |
| textDelegate | `TextDelegate` | 选择器的文本代理构建，用于自定义文本 | `DefaultTextDelegate()` |

### 简单的使用方法

```dart
final Set<AssetEntity> assets = await AssetPicker.pickAssets(context);
```

或者

```dart
AssetPicker.pickAsset(context).then((Set<AssetEntity> assets) {
  /.../
});
```

### 完整参数的使用方法

```dart
Set<AssetEntity> assets = <AssetEntity>{};

final Set<AssetEntity> result = await AssetPicker.pickAssets(
  context,
  maxAssets: 9,
  pageThumbSize: 80,
  gridCount: 4,
  requestType: RequestType.image,
  selectedAssets: assets,
  themeColor: Colors.cyan,
  textDelegate: DefaultTextDelegate(),
);
```

or

```dart
Set<AssetEntity> assets = <AssetEntity>{};

AssetPicker.pickAssets(
  context,
  maxAssets: 9,
  pageThumbSize: 80,
  gridCount: 4,
  requestType: RequestType.image,
  selectedAssets: assets,
  themeColor: Colors.cyan,
  textDelegate: DefaultTextDelegate(),
).then((Set<AssetEntity> assets) {
  /.../
});
```

