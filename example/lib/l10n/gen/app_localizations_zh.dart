import 'app_localizations.dart';

/// The translations for Chinese (`zh`).
class AppLocalizationsZh extends AppLocalizations {
  AppLocalizationsZh([String locale = 'zh']) : super(locale);

  @override
  String get appTitle => 'WeChat Asset Picker 示例';

  @override
  String appVersion(Object version) {
    return '版本：$version';
  }

  @override
  String get appVersionUnknown => '未知';

  @override
  String get navMulti => '多选';

  @override
  String get navSingle => '单选';

  @override
  String get navCustom => '自定义';

  @override
  String get selectedAssetsText => '已选的资源';

  @override
  String pickMethodNotice(Object dist) {
    return '该页面的所有选择器的代码位于 $dist，由 `pickMethods` 定义。';
  }

  @override
  String get pickMethodImageName => '图片选择';

  @override
  String get pickMethodImageDescription => '仅选择图片。';

  @override
  String get pickMethodVideoName => '视频选择';

  @override
  String get pickMethodVideoDescription => '仅选择视频。';

  @override
  String get pickMethodAudioName => '音频选择';

  @override
  String get pickMethodAudioDescription => '仅选择音频。';

  @override
  String get pickMethodLivePhotoName => '实况图片选择';

  @override
  String get pickMethodLivePhotoDescription => '仅选择实况图片。';

  @override
  String get pickMethodCameraName => '从相机生成选择';

  @override
  String get pickMethodCameraDescription => '通过相机拍照生成并选择资源';

  @override
  String get pickMethodCameraAndStayName => '从相机生成选择并停留';

  @override
  String get pickMethodCameraAndStayDescription => '通过相机拍照生成选择资源，并停留在选择界面。';

  @override
  String get pickMethodCommonName => '常用选择';

  @override
  String get pickMethodCommonDescription => '选择图片和视频。';

  @override
  String get pickMethodThreeItemsGridName => '横向 3 格';

  @override
  String get pickMethodThreeItemsGridDescription =>
      '选择器每行为 3 格。（pageSize 必须为 gridCount 的倍数）';

  @override
  String get pickMethodCustomFilterOptionsName => '自定义过滤条件';

  @override
  String get pickMethodCustomFilterOptionsDescription => '为选择器添加自定义过滤条件。';

  @override
  String get pickMethodPrependItemName => '往网格前插入 widget';

  @override
  String get pickMethodPrependItemDescription => '网格的靠前位置会添加一个自定义的 widget。';

  @override
  String get pickMethodNoPreviewName => '禁止预览';

  @override
  String get pickMethodNoPreviewDescription =>
      '无法预览选择的资源，与 WhatsApp/MegaTok 的行为类似。';

  @override
  String get pickMethodKeepScrollOffsetName => '保持滚动位置';

  @override
  String get pickMethodKeepScrollOffsetDescription => '可以从上次滚动到的位置再次开始选择。';

  @override
  String get pickMethodChangeLanguagesName => '更改语言';

  @override
  String get pickMethodChangeLanguagesDescription =>
      '传入 AssetPickerTextDelegate 手动更改选择器的语言（例如 EnglishAssetPickerTextDelegate）。';

  @override
  String get pickMethodPreventGIFPickedName => '禁止选择 GIF 图片';

  @override
  String get pickMethodPreventGIFPickedDescription =>
      '通过 selectPredicate 来禁止 GIF 图片在点击时被选择。';

  @override
  String get pickMethodCustomizableThemeName => '自定义主题 (ThemeData)';

  @override
  String get pickMethodCustomizableThemeDescription => '可以用亮色或其他颜色及自定义的主题进行选择。';

  @override
  String get pickMethodPathNameBuilderName => '构建路径名称';

  @override
  String get pickMethodPathNameBuilderDescription => '在路径后添加 🍭 进行自定义。';

  @override
  String get pickMethodWeChatMomentName => '微信朋友圈模式';

  @override
  String get pickMethodWeChatMomentDescription => '允许选择图片或仅 1 个视频。';

  @override
  String get pickMethodCustomImagePreviewThumbSizeName => '自定义图片预览的缩略图大小';

  @override
  String get pickMethodCustomImagePreviewThumbSizeDescription =>
      '通过降低缩略图的质量来获得更快的加载速度。';

  @override
  String get customPickerNotice =>
      '本页面包含了多种方式、不同界面和特定应用的自定义选择器。欢迎贡献添加你自定义的选择器。\n该页面的所有选择器的代码位于 lib/customs/pickers 目录。';

  @override
  String get customPickerCallThePickerButton => '🎁 开始选择资源';

  @override
  String get customPickerDirectoryAndFileName => 'Directory+File 选择器';

  @override
  String get customPickerDirectoryAndFileDescription =>
      '为 `File` 构建的自定义选择器。\n通过阅读该选择器的源码，你可以学习如何完全以你自定义的资源类型来构建并选择器的界面。\n\n该选择器会从 `getApplicationDocumentsDirectory` 目录获取资源，然后检查它是否包含图片。你需要将图片放在该目录来查看选择器的效果。';

  @override
  String get customPickerMultiTabName => '多 Tab 选择器';

  @override
  String get customPickerMultiTabDescription =>
      '该选择器会以多 Tab 的形式同时展示多种资源类型的选择器。';

  @override
  String get customPickerMultiTabTab1 => '全部';

  @override
  String get customPickerMultiTabTab2 => '视频';

  @override
  String get customPickerMultiTabTab3 => '图片';

  @override
  String get customPickerInstagramLayoutName => 'Instagram 布局的选择器';

  @override
  String get customPickerInstagramLayoutDescription =>
      '该选择器以 Instagram 的布局模式构建，在选择时可以同时预览。其已发布为单独的 package：insta_assets_picker。';

  @override
  String get customPickerGalleryMode => '画廊模式';

  @override
  String get customPickerGalleryModeDescription =>
      '使用一个小部件来显示能够对其执行操作的资产，但不能选择它们并将其返回到调用小部件。';
}
