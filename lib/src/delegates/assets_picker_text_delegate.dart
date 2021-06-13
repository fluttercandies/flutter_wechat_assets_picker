///
/// [Author] Alex (https://github.com/Alex525)
/// [Date] 2020/4/7 10:25
///

/// Text delegate that controls text in widgets.
/// 控制部件中的文字实现
abstract class AssetsPickerTextDelegate {
  /// Confirm string for the confirm button.
  /// 确认按钮的字段
  late final String confirm;

  /// Cancel string for back button.
  /// 返回按钮的字段
  late final String cancel;

  /// Edit string for edit button.
  /// 编辑按钮的字段
  late final String edit;

  /// GIF indicator string.
  /// GIF指示的字段
  late final String gifIndicator;

  /// HEIC failed string.
  /// HEIC 类型资源加载失败的字段
  late final String heicNotSupported;

  /// Load failed string for item.
  /// 资源加载失败时的字段
  late final String loadFailed;

  /// Original string for original selection.
  /// 选择是否原图的字段
  late final String original;

  /// Preview string for preview button.
  /// 预览按钮的字段
  late final String preview;

  /// Select string for select button.
  /// 选择按钮的字段
  late final String select;

  /// Un-supported asset type string for assets that belongs to [AssetType.other].
  /// 未支持的资源类型的字段
  late final String unSupportedAssetType;

  /// This is used in video asset item in the picker, in order
  /// to display the duration of the video or audio type of asset.
  /// 该字段用在选择器视频或音频部件上，用于显示视频或音频资源的时长。
  String durationIndicatorBuilder(Duration duration);

  static String defaultDurationIndicatorBuilder(Duration duration) {
    const String separator = ':';
    final String minute = duration.inMinutes.toString().padLeft(2, '0');
    final String second =
        ((duration - Duration(minutes: duration.inMinutes)).inSeconds)
            .toString()
            .padLeft(2, '0');
    return '$minute$separator$second';
  }
}

/// Default text delegate implements with Chinese.
/// 中文文字实现
class DefaultAssetsPickerTextDelegate implements AssetsPickerTextDelegate {
  factory DefaultAssetsPickerTextDelegate() => _instance;

  DefaultAssetsPickerTextDelegate._internal();

  static final DefaultAssetsPickerTextDelegate _instance =
      DefaultAssetsPickerTextDelegate._internal();

  @override
  String confirm = '确认';

  @override
  String cancel = '取消';

  @override
  String edit = '编辑';

  @override
  String gifIndicator = 'GIF';

  @override
  String heicNotSupported = '尚未支持HEIC类型资源';

  @override
  String loadFailed = '加载失败';

  @override
  String original = '原图';

  @override
  String preview = '预览';

  @override
  String select = '选择';

  @override
  String unSupportedAssetType = '尚未支持的资源类型';

  @override
  String durationIndicatorBuilder(Duration duration) =>
      AssetsPickerTextDelegate.defaultDurationIndicatorBuilder(duration);
}

/// [AssetsPickerTextDelegate] implements with English.
class EnglishTextDelegate implements AssetsPickerTextDelegate {
  factory EnglishTextDelegate() => _instance;

  EnglishTextDelegate._internal();

  static final EnglishTextDelegate _instance = EnglishTextDelegate._internal();

  @override
  String confirm = 'Confirm';

  @override
  String cancel = 'Cancel';

  @override
  String edit = 'Edit';

  @override
  String gifIndicator = 'GIF';

  @override
  String heicNotSupported = 'Unsupported HEIC asset type.';

  @override
  String loadFailed = 'Load failed';

  @override
  String original = 'Origin';

  @override
  String preview = 'Preview';

  @override
  String select = 'Select';

  @override
  String unSupportedAssetType = 'Unsupported HEIC asset type.';

  @override
  String durationIndicatorBuilder(Duration duration) =>
      AssetsPickerTextDelegate.defaultDurationIndicatorBuilder(duration);
}

/// [AssetsPickerTextDelegate] implements with Hebrew.
/// 希伯来文字实现
class HebrewTextDelegate implements AssetsPickerTextDelegate {
  factory HebrewTextDelegate() => _instance;

  HebrewTextDelegate._internal();

  static final HebrewTextDelegate _instance = HebrewTextDelegate._internal();

  @override
  String confirm = 'אישור';

  @override
  String cancel = 'ביטול';

  @override
  String edit = 'עריכה';

  @override
  String gifIndicator = 'GIF';

  @override
  String heicNotSupported = 'קובץ HEIC לא נתמך.';

  @override
  String loadFailed = 'הטעינה נכשלה';

  @override
  String original = 'מקור';

  @override
  String preview = 'תצוגה מקדימה';

  @override
  String select = 'בחר';

  @override
  String unSupportedAssetType = 'סוג קובץ HEIC אינו נתמך';

  @override
  String durationIndicatorBuilder(Duration duration) =>
      AssetsPickerTextDelegate.defaultDurationIndicatorBuilder(duration);
}

/// [AssetsPickerTextDelegate] implementiert mit der deutschen Übersetzung.
/// Deutsche Textimplementierung.
class GermanTextDelegate implements AssetsPickerTextDelegate {
  factory GermanTextDelegate() => _instance;

  GermanTextDelegate._internal();

  static final GermanTextDelegate _instance = GermanTextDelegate._internal();

  @override
  String confirm = 'Bestätigen';

  @override
  String cancel = 'Abbrechen';

  @override
  String edit = 'Bearbeiten';

  @override
  String gifIndicator = 'GIF';

  @override
  String heicNotSupported = 'HEIC Format ist nicht unterstützt.';

  @override
  String loadFailed = 'Ladevorgang ist fehlgeschlagen';

  @override
  String original = 'Ursprung';

  @override
  String preview = 'Vorschau';

  @override
  String select = 'Auswählen';

  @override
  String unSupportedAssetType = 'HEIC Format ist nicht unterstützt.';

  @override
  String durationIndicatorBuilder(Duration duration) =>
      AssetsPickerTextDelegate.defaultDurationIndicatorBuilder(duration);
}

/// [AssetsPickerTextDelegate] implements with Russian.
/// Локализация на русский язык.
class RussianTextDelegate implements AssetsPickerTextDelegate {
  factory RussianTextDelegate() => _instance;

  RussianTextDelegate._internal();

  static final RussianTextDelegate _instance = RussianTextDelegate._internal();

  @override
  String confirm = 'Готово';

  @override
  String cancel = 'Отмена';

  @override
  String edit = 'Изменить';

  @override
  String gifIndicator = 'GIF';

  @override
  String heicNotSupported = 'Формат HEIC не поддерживается.';

  @override
  String loadFailed = 'Ошибка при загрузке';

  @override
  String original = 'Исходное';

  @override
  String preview = 'Предпросмотр';

  @override
  String select = 'Выбрать';

  @override
  String unSupportedAssetType = 'Неподдерживаемый формат ресурса.';

  @override
  String durationIndicatorBuilder(Duration duration) =>
      AssetsPickerTextDelegate.defaultDurationIndicatorBuilder(duration);
}

/// [AssetsPickerTextDelegate] implements with Japanese.
/// 日本語の TextDelegate
class JapaneseTextDelegate implements AssetsPickerTextDelegate {
  factory JapaneseTextDelegate() => _instance;

  JapaneseTextDelegate._internal();

  static final JapaneseTextDelegate _instance =
      JapaneseTextDelegate._internal();

  @override
  String confirm = '決定';

  @override
  String cancel = 'キャンセル';

  @override
  String edit = '編集';

  @override
  String gifIndicator = 'GIF';

  @override
  String heicNotSupported = 'HEIC フォーマットはサポートしていません。';

  @override
  String loadFailed = '読み込みに失敗しました。';

  @override
  String original = '元の画像';

  @override
  String preview = 'プレビュー';

  @override
  String select = '選択';

  @override
  String unSupportedAssetType = 'HEIC フォーマットはサポートしていません。';

  @override
  String durationIndicatorBuilder(Duration duration) =>
      AssetsPickerTextDelegate.defaultDurationIndicatorBuilder(duration);
}
