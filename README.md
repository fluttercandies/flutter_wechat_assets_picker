# Flutter WeChat Assets Picker

[![pub package](https://img.shields.io/pub/v/wechat_assets_picker.svg)](https://pub.dev/packages/wechat_assets_picker)
[![GitHub stars](https://img.shields.io/github/stars/fluttercandies/flutter_wechat_assets_picker)](https://github.com/fluttercandies/flutter_wechat_assets_picker/stargazers)
[![GitHub forks](https://img.shields.io/github/forks/fluttercandies/flutter_wechat_assets_picker)](https://github.com/fluttercandies/flutter_wechat_assets_picker/network)
[![GitHub license](https://img.shields.io/github/license/fluttercandies/flutter_wechat_assets_picker)](https://github.com/fluttercandies/flutter_wechat_assets_picker/blob/master/LICENSE)
<a target="_blank" href="https://jq.qq.com/?_wv=1027&k=5bcc0gy"><img border="0" src="https://pub.idqqimg.com/wpa/images/group.png" alt="FlutterCandies" title="FlutterCandies"></a>

Language: English | [中文简体](README-ZH.md)

An assets picker which looks like the one in WeChat, based on `photo_manager` for asset implementation, `extended_image` for image preview, `provider` to help controlling the state of the picker.

## Features ✨

- 💚 99% simillar to WeChat style.
- 🌠 Support multi assets pick.
- 🔍 Support asset preview.

## Screenshots 📸

![1.png](screenshots/1.png)![2.png](screenshots/2.png)![3.png](screenshots/3.png)

## TODO 📅

- [x] Image asset support
  - [ ] Image editing (Cut/Rotate/Draw)
- [x] Video asset support
  - [ ] Video editing support
- [ ] Single asset mode
- [ ] i18n support
- [ ] Custom text delegate support
- [ ] Flutter For the Web support

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

| Name           | Type               | Description                                                  | Default             |
| -------------- | ------------------ | ------------------------------------------------------------ | ------------------- |
| context        | `BuildContext`     | Context for navigator push.                                  | `null`              |
| maxAssets      | `int`              | Maximum asset that the picker can pick.                      | 9                   |
| pageThumbSize  | `int`              | The size of thumb data in picker.                            | 80                  |
| gridCount      | `int`              | Grid count in picker.                                        | 4                   |
| requestType    | `RequestType`      | Request type for picker.                                     | RequestType.image   |
| selectedAssets | `Set<AssetEntity>` | Selected assets. Using `Set` to prevent dulplicate selection. | `null`              |
| themeColor     | `Color`            | Main theme color for the picker                              | `Color(0xff00bc56)` |

### Simple usage
```dart
final Set<AssetEntity> assets = await AssetPicker.pickAssets(context);
```

or

```dart
AssetPicker.pickAsset(context).then((Set<AssetEntity> assets) {
  /.../
});
```

### Complete param usage

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
).then((Set<AssetEntity> assets) {
  /.../
});
```

