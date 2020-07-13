///
/// [Author] Alex (https://github.com/AlexV525)
/// [Date] 2020/7/13 11:08
///
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:camera/camera.dart';
import 'package:path_provider/path_provider.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';

import '../constants/constants.dart';

/// Create a camera picker integrate with [CameraDescription].
/// 通过 [CameraDescription] 整合的拍照选择
///
/// The picker provides create an [AssetEntity] through the camera.
/// However, this might failed (high probability) if there're any steps
/// went wrong during the process.
/// 该选择器可以通过拍照创建 [AssetEntity] ，但由于过程中有的步骤随时会出现问题，
/// 使用时有较高的概率会遇到失败。
class CameraPicker extends StatefulWidget {
  const CameraPicker({
    Key key,
    this.shouldKeptInLocal = false,
  }) : super(key: key);

  /// Whether the taken file should be kept in local.
  /// 拍照的文件是否应该保存在本地
  final bool shouldKeptInLocal;

  @override
  _CameraPickerState createState() => _CameraPickerState();
}

class _CameraPickerState extends State<CameraPicker> {
  /// The path which the temporary file will be stored.
  /// 临时文件会存放的目录
  String cacheFilePath;

  /// Available cameras.
  /// 可用的相机实例
  List<CameraDescription> cameras;

  /// The controller for the current camera.
  /// 当前相机实例的控制器
  CameraController controller;

  /// The index of the current cameras. Defaults to `0`.
  /// 当前相机的索引。默认为0
  int currentCameraIndex = 0;

  /// The path of the taken file.
  /// 拍照文件的路径。
  String takenFilePath;

  /// Whether the current [CameraDescription] initialized.
  /// 当前的相机实例是否已完成初始化
  bool get isInitialized => controller?.value?.isInitialized ?? false;

  /// Whether the taken file should be kept in local. (A non-null wrapper)
  /// 拍照的文件是否应该保存在本地（非空包装）
  bool get shouldKeptInLocal => widget.shouldKeptInLocal ?? false;

  /// A getter to the current [CameraDescription].
  /// 获取当前相机实例
  CameraDescription get currentCamera => cameras?.elementAt(currentCameraIndex);

  /// Get [ThemeData] of the [AssetPicker] through [Constants.pickerKey].
  /// 通过常量全局 Key 获取当前选择器的主题
  ThemeData get theme =>
      (Constants.pickerKey.currentWidget as AssetPicker).theme;

  @override
  void initState() {
    super.initState();
    // TODO(Alex): Currently hide status bar will cause the viewport shaking on Android.
    /// Hide system status bar automatically on iOS.
    /// 在iOS设备上自动隐藏状态栏
    if (Platform.isIOS) {
      SystemChrome.setEnabledSystemUIOverlays(<SystemUiOverlay>[]);
    }
    initStorePath();
    initCameras();
  }

  @override
  void dispose() {
    SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values);
    controller?.dispose();
    super.dispose();
  }

  /// Defined the path according to [shouldKeptInLocal], with platforms specification.
  /// 根据 [shouldKeptInLocal] 及平台规定确定存储路径。
  ///
  /// * When [Platform.isIOS], use [getApplicationDocumentsDirectory].
  /// * When platform is others: [shouldKeptInLocal] ?
  ///   * [true] : [getExternalStorageDirectory]'s path
  ///   * [false]: [getExternalCacheDirectories]'s last path
  Future<void> initStorePath() async {
    if (Platform.isIOS) {
      cacheFilePath = (await getApplicationDocumentsDirectory()).path;
    } else {
      if (shouldKeptInLocal) {
        cacheFilePath = (await getExternalStorageDirectory()).path;
      } else {
        cacheFilePath = (await getExternalCacheDirectories()).last.path;
      }
    }
    if (cacheFilePath != null) {
      cacheFilePath += '/picker';
    }
  }

  /// Initialize cameras instances.
  /// 初始化相机实例
  Future<void> initCameras({CameraDescription cameraDescription}) async {
    controller?.dispose();

    /// When it's null, which means this is the first time initializing the cameras.
    /// So cameras should fetch.
    if (cameraDescription == null) {
      cameras = await availableCameras();
    }

    /// After cameras fetched, judge again with the list is empty or not to ensure
    /// there is at least an available camera for use.
    if (cameraDescription == null && (cameras?.isEmpty ?? true)) {
      realDebugPrint('No cameras found.');
      return;
    }

    /// Initialize the controller with the max resolution preset.
    /// - No one want the lower resolutions. :)
    controller = CameraController(
      cameraDescription ?? cameras[0],
      ResolutionPreset.max,
    );
    controller.initialize().then((dynamic _) {
      if (mounted) {
        setState(() {});
      }
    });
  }

  /// The method to switch cameras.
  /// 切换相机的方法
  ///
  /// Switch cameras in order. When the [currentCameraIndex] reached the length
  /// of cameras, start from the beginning.
  /// 按顺序切换相机。当达到相机数量时从头开始。
  void switchCameras() {
    ++currentCameraIndex;
    if (currentCameraIndex == cameras.length) {
      currentCameraIndex = 0;
    }
    initCameras(cameraDescription: currentCamera);
  }

  /// The method to take a picture.
  /// 拍照方法
  ///
  /// The picture will only taken when [isInitialized], and the camera is not
  /// taking pictures.
  /// 仅当初始化成功且相机未在拍照时拍照。
  Future<void> takePicture() async {
    if (isInitialized && !controller.value.isTakingPicture) {
      try {
        final String path = '${cacheFilePath}_$currentTimeStamp.jpg';
        await controller.takePicture(path);
        takenFilePath = path;
        if (mounted) {
          setState(() {});
        }
      } catch (e) {
        realDebugPrint('Error when taking pictures: $e');
      }
    }
  }

  /// Make sure the [takenFilePath] is `null` before pop.
  /// Otherwise, make it `null` .
  Future<bool> clearTakenFileBeforePop() async {
    if (takenFilePath != null) {
      setState(() {
        takenFilePath = null;
      });
      return false;
    }
    return true;
  }

  /// When users confirm to use the taken file, create the [AssetEntity] using
  /// [Editor.saveImage] (PhotoManager.editor.saveImage), then delete the file
  /// if not [shouldKeptInLocal]. While the entity might returned null, there's
  /// no side effects if popping `null` because the parent picker will ignore it.
  Future<void> createAssetEntityAndPop() async {
    try {
      final File file = File(takenFilePath);
      final Uint8List data = await file.readAsBytes();
      final AssetEntity entity = await PhotoManager.editor.saveImage(
        data,
        title: takenFilePath,
      );
      if (!shouldKeptInLocal) {
        file.delete();
      }
      Navigator.of(context).pop(entity);
    } catch (e) {
      realDebugPrint('Error when creating entity: $e');
    }
  }

  /// Settings action section widget.
  /// 设置操作区
  ///
  /// This displayed at the top of the screen.
  /// 该区域显示在屏幕上方。
  Widget get settingsAction {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0),
      child: Row(
        children: const <Widget>[
          Spacer(),
          // TODO(Alex): There's an issue tracking NPE of the camera plugin, so switching is temporary disabled .
//          if ((cameras?.length ?? 0) > 1) switchCamerasButton,
        ],
      ),
    );
  }

  /// The button to switch between cameras.
  /// 切换相机的按钮
  Widget get switchCamerasButton {
    return InkWell(
      onTap: switchCameras,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Icon(
          Icons.switch_camera,
          color: Colors.white,
          size: 30.0,
        ),
      ),
    );
  }

  /// Shooting action section widget.
  /// 拍照操作区
  ///
  /// This displayed at the top of the screen.
  /// 该区域显示在屏幕下方。
  Widget get shootingActions {
    return SizedBox(
      height: Screens.width / 5,
      child: Row(
        children: <Widget>[
          Expanded(child: Center(child: backButton)),
          Expanded(child: Center(child: shootingButton)),
          const Spacer(),
        ],
      ),
    );
  }

  /// The back button near to the [shootingButton].
  /// 靠近拍照键的返回键
  Widget get backButton {
    return InkWell(
      borderRadius: maxBorderRadius,
      onTap: Navigator.of(context).pop,
      child: Container(
        margin: const EdgeInsets.all(10.0),
        width: Screens.width / 15,
        height: Screens.width / 15,
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
        ),
        child: Center(
          child: Icon(
            Icons.keyboard_arrow_down,
            color: Colors.black,
          ),
        ),
      ),
    );
  }

  /// The shooting button.
  /// 拍照按钮
  // TODO(Alex): Need further integration with video recording.
  Widget get shootingButton {
    return InkWell(
      borderRadius: maxBorderRadius,
      onTap: takePicture,
      child: Container(
        width: Screens.width / 5,
        height: Screens.width / 5,
        padding: const EdgeInsets.all(12.0),
        decoration: BoxDecoration(
          color: Colors.white30,
          shape: BoxShape.circle,
        ),
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
          ),
        ),
      ),
    );
  }

  /// The preview section for the taken file.
  /// 拍摄文件的预览区
  Widget get takenFilePreviewWidget {
    return ColoredBox(
      color: Colors.black,
      child: Stack(
        children: <Widget>[
          Positioned.fill(child: Image.file(File(takenFilePath))),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 8.0,
                vertical: 20.0,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      previewBackButton,
                      const Spacer(),
                    ],
                  ),
                  Row(
                    children: <Widget>[
                      const Spacer(),
                      previewConfirmButton,
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// The back button for the preview section.
  /// 预览区的返回按钮
  Widget get previewBackButton {
    return InkWell(
      borderRadius: maxBorderRadius,
      onTap: () {
        File(takenFilePath).delete();
        setState(() {
          takenFilePath = null;
        });
      },
      child: Container(
        margin: const EdgeInsets.all(10.0),
        width: Screens.width / 15,
        height: Screens.width / 15,
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
        ),
        child: Center(
          child: Icon(
            Icons.close,
            color: Colors.black,
            size: 18.0,
          ),
        ),
      ),
    );
  }

  /// The confirm button for the preview section.
  /// 预览区的确认按钮
  Widget get previewConfirmButton {
    return MaterialButton(
      minWidth: 20.0,
      height: 32.0,
      padding: const EdgeInsets.symmetric(horizontal: 12.0),
      color: theme.colorScheme.secondary,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(3.0),
      ),
      child: Text(
        Constants.textDelegate.confirm,
        style: TextStyle(
          color: theme.textTheme.bodyText1.color,
          fontSize: 17.0,
          fontWeight: FontWeight.normal,
        ),
      ),
      onPressed: createAssetEntityAndPop,
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: clearTakenFileBeforePop,
      child: Theme(
        data: theme,
        child: Material(
          color: Colors.black,
          child: Stack(
            children: <Widget>[
              if (isInitialized)
                Center(
                  child: AspectRatio(
                    aspectRatio: controller.value.aspectRatio,
                    child: CameraPreview(controller),
                  ),
                )
              else
                const SizedBox.shrink(),
              SafeArea(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      settingsAction,
                      shootingActions,
                    ],
                  ),
                ),
              ),
              if (takenFilePath != null) takenFilePreviewWidget,
            ],
          ),
        ),
      ),
    );
  }
}
