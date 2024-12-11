import 'app_localizations.dart';

// ignore_for_file: type=lint

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
}

/// The translations for Chinese, using the Han script (`zh_Hant`).
class AppLocalizationsZhHant extends AppLocalizationsZh {
  AppLocalizationsZhHant() : super('zh_Hant');

  @override
  String get appTitle => 'WeChat Asset Picker 範例';

  @override
  String appVersion(Object version) {
    return '版本：$version';
  }

  @override
  String get appVersionUnknown => '未知';

  @override
  String get navMulti => '多選';

  @override
  String get navSingle => '單選';

  @override
  String get navCustom => '自訂';

  @override
  String get selectedAssetsText => '已選的資源';

  @override
  String pickMethodNotice(Object dist) {
    return '此頁面的所有選擇器的程式碼位於 $dist，由 `pickMethods` 定義。';
  }

  @override
  String get pickMethodImageName => '圖片選擇';

  @override
  String get pickMethodImageDescription => '僅選擇圖片。';

  @override
  String get pickMethodVideoName => '影片選擇';

  @override
  String get pickMethodVideoDescription => '僅選擇影片。';

  @override
  String get pickMethodAudioName => '音訊選擇';

  @override
  String get pickMethodAudioDescription => '僅選擇音訊。';

  @override
  String get pickMethodLivePhotoName => '實況圖片選擇';

  @override
  String get pickMethodLivePhotoDescription => '僅選擇實況圖片。';

  @override
  String get pickMethodCameraName => '從相機生成選擇';

  @override
  String get pickMethodCameraDescription => '透過相機拍照生成並選擇資源';

  @override
  String get pickMethodCameraAndStayName => '從相機生成選擇並停留';

  @override
  String get pickMethodCameraAndStayDescription => '透過相機拍照生成選擇資源，並停留在選擇介面。';

  @override
  String get pickMethodCommonName => '常用選擇';

  @override
  String get pickMethodCommonDescription => '選擇圖片和影片。';

  @override
  String get pickMethodThreeItemsGridName => '橫向 3 格';

  @override
  String get pickMethodThreeItemsGridDescription =>
      '選擇器每行為 3 格。（pageSize 必須為 gridCount 的倍數）';

  @override
  String get pickMethodCustomFilterOptionsName => '自訂過濾條件';

  @override
  String get pickMethodCustomFilterOptionsDescription => '為選擇器添加自訂過濾條件。';

  @override
  String get pickMethodPrependItemName => '往網格前插入 widget';

  @override
  String get pickMethodPrependItemDescription => '網格的前面位置會添加一個自訂的 widget。';

  @override
  String get pickMethodNoPreviewName => '禁止預覽';

  @override
  String get pickMethodNoPreviewDescription =>
      '無法預覽選擇的資源，與 WhatsApp/MegaTok 的行為類似。';

  @override
  String get pickMethodKeepScrollOffsetName => '保持捲動位置';

  @override
  String get pickMethodKeepScrollOffsetDescription => '可以從上次捲動到的位置再次開始選擇。';

  @override
  String get pickMethodChangeLanguagesName => '更改語言';

  @override
  String get pickMethodChangeLanguagesDescription =>
      '傳入 AssetPickerTextDelegate 手動更改選擇器的語言（例如 EnglishAssetPickerTextDelegate）。';

  @override
  String get pickMethodPreventGIFPickedName => '禁止選擇 GIF 圖片';

  @override
  String get pickMethodPreventGIFPickedDescription =>
      '透過 selectPredicate 來禁止 GIF 圖片在點擊時被選擇。';

  @override
  String get pickMethodCustomizableThemeName => '自訂主題 (ThemeData)';

  @override
  String get pickMethodCustomizableThemeDescription => '可以用亮色或其他顏色及自訂的主題進行選擇。';

  @override
  String get pickMethodPathNameBuilderName => '構建路徑名稱';

  @override
  String get pickMethodPathNameBuilderDescription => '在路徑後添加 🍭 進行自訂。';

  @override
  String get pickMethodWeChatMomentName => '微信朋友圈模式';

  @override
  String get pickMethodWeChatMomentDescription => '允許選擇圖片或僅 1 個影片。';

  @override
  String get pickMethodCustomImagePreviewThumbSizeName => '自訂圖片預覽的縮圖大小';

  @override
  String get pickMethodCustomImagePreviewThumbSizeDescription =>
      '透過降低縮圖的品質來獲得更快的載入速度。';

  @override
  String get customPickerNotice =>
      '本頁面包含了多種方式、不同介面和特定應用的自訂選擇器。歡迎貢獻添加你自訂的選擇器。\n此頁面的所有選擇器的程式碼位於 lib/customs/pickers 目錄。';

  @override
  String get customPickerCallThePickerButton => '🎁 開始選擇資源';

  @override
  String get customPickerDirectoryAndFileName => '目錄+檔案 選擇器';

  @override
  String get customPickerDirectoryAndFileDescription =>
      '為 `File` 構建的自訂選擇器。\n透過閱讀此選擇器的原始碼，你可以學習如何完全以你自訂的資源類型來構建並選擇器的介面。\n\n此選擇器會從 `getApplicationDocumentsDirectory` 目錄獲取資源，然後檢查它是否包含圖片。你需要將圖片放在此目錄來查看選擇器的效果。';

  @override
  String get customPickerMultiTabName => '多 Tab 選擇器';

  @override
  String get customPickerMultiTabDescription =>
      '此選擇器會以多 Tab 的形式同時展示多種資源類型的選擇器。';

  @override
  String get customPickerMultiTabTab1 => '全部';

  @override
  String get customPickerMultiTabTab2 => '影片';

  @override
  String get customPickerMultiTabTab3 => '圖片';

  @override
  String get customPickerInstagramLayoutName => 'Instagram 佈局的選擇器';

  @override
  String get customPickerInstagramLayoutDescription =>
      '此選擇器以 Instagram 的佈局模式構建，在選擇時可以同時預覽。其已發布為單獨的 package：insta_assets_picker。';
}
