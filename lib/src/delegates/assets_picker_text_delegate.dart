///
/// [Author] Alex (https://github.com/Alex525)
/// [Date] 2020/4/7 10:25
///

/// Text delegate that controls text in widgets.
/// 控制部件中的文字实现
class AssetsPickerTextDelegate {
  /// Confirm string for the confirm button.
  /// 确认按钮的字段
  String get confirm => '确认';

  /// Cancel string for back button.
  /// 返回按钮的字段
  String get cancel => '取消';

  /// Edit string for edit button.
  /// 编辑按钮的字段
  String get edit => '编辑';

  /// GIF indicator string.
  /// GIF指示的字段
  String get gifIndicator => 'GIF';

  /// HEIC failed string.
  /// HEIC 类型资源加载失败的字段
  String get heicNotSupported => '尚未支持HEIC类型资源';

  /// Load failed string for item.
  /// 资源加载失败时的字段
  String get loadFailed => '加载失败';

  /// Original string for original selection.
  /// 选择是否原图的字段
  String get original => '原图';

  /// Preview string for preview button.
  /// 预览按钮的字段
  String get preview => '预览';

  /// Select string for select button.
  /// 选择按钮的字段
  String get select => '选择';

  /// Un-supported asset type string for assets that belongs to [AssetType.other].
  /// 未支持的资源类型的字段
  String get unSupportedAssetType => '尚未支持的资源类型';

  /// "Unable to access all assets in album".
  String get unableToAccessAll => '无法访问所有资源';

  String get accessAllTip => '目前应用只能访问部分资源。'
      '请前往系统设置允许应用访问所有资源';

  String get goToSystemSettings => '前往系统设置';

  /// "Continue accessing some assets".
  String get accessLimitedAssets => '继续访问部分资源';

  /// This is used in video asset item in the picker, in order
  /// to display the duration of the video or audio type of asset.
  /// 该字段用在选择器视频或音频部件上，用于显示视频或音频资源的时长。
  String durationIndicatorBuilder(Duration duration) {
    const String separator = ':';
    final String minute = duration.inMinutes.toString().padLeft(2, '0');
    final String second =
        ((duration - Duration(minutes: duration.inMinutes)).inSeconds)
            .toString()
            .padLeft(2, '0');
    return '$minute$separator$second';
  }
}

/// [AssetsPickerTextDelegate] implements with English.
class EnglishTextDelegate extends AssetsPickerTextDelegate {
  @override
  String get confirm => 'Confirm';

  @override
  String get cancel => 'Cancel';

  @override
  String get edit => 'Edit';

  @override
  String get gifIndicator => 'GIF';

  @override
  String get heicNotSupported => 'Unsupported HEIC asset type.';

  @override
  String get loadFailed => 'Load failed';

  @override
  String get original => 'Origin';

  @override
  String get preview => 'Preview';

  @override
  String get select => 'Select';

  @override
  String get unSupportedAssetType => 'Unsupported HEIC asset type.';

  @override
  String get unableToAccessAll => 'Unable to access all assets on the device';

  @override
  String get accessAllTip => 'App can only access some assets on the device.'
      'Go to system settings and allow app to access all assets on the device.';

  @override
  String get goToSystemSettings => 'Go to system settings';

  @override
  String get accessLimitedAssets => 'Continue accessing some assets';
}

/// [AssetsPickerTextDelegate] implements with Hebrew.
/// 希伯来文字实现
class HebrewTextDelegate extends AssetsPickerTextDelegate {
  @override
  String get confirm => 'אישור';

  @override
  String get cancel => 'ביטול';

  @override
  String get edit => 'עריכה';

  @override
  String get gifIndicator => 'GIF';

  @override
  String get heicNotSupported => 'קובץ HEIC לא נתמך.';

  @override
  String get loadFailed => 'הטעינה נכשלה';

  @override
  String get original => 'מקור';

  @override
  String get preview => 'תצוגה מקדימה';

  @override
  String get select => 'בחר';

  @override
  String get unSupportedAssetType => 'סוג קובץ HEIC אינו נתמך';
}

/// [AssetsPickerTextDelegate] implementiert mit der deutschen Übersetzung.
/// Deutsche Textimplementierung.
class GermanTextDelegate extends AssetsPickerTextDelegate {
  @override
  String get confirm => 'Bestätigen';

  @override
  String get cancel => 'Abbrechen';

  @override
  String get edit => 'Bearbeiten';

  @override
  String get gifIndicator => 'GIF';

  @override
  String get heicNotSupported => 'HEIC Format ist nicht unterstützt.';

  @override
  String get loadFailed => 'Ladevorgang ist fehlgeschlagen';

  @override
  String get original => 'Ursprung';

  @override
  String get preview => 'Vorschau';

  @override
  String get select => 'Auswählen';

  @override
  String get unSupportedAssetType => 'HEIC Format ist nicht unterstützt.';
}

/// [AssetsPickerTextDelegate] implements with Russian.
/// Локализация на русский язык.
class RussianTextDelegate extends AssetsPickerTextDelegate {
  @override
  String get confirm => 'Готово';

  @override
  String get cancel => 'Отмена';

  @override
  String get edit => 'Изменить';

  @override
  String get gifIndicator => 'GIF';

  @override
  String get heicNotSupported => 'Формат HEIC не поддерживается.';

  @override
  String get loadFailed => 'Ошибка при загрузке';

  @override
  String get original => 'Исходное';

  @override
  String get preview => 'Предпросмотр';

  @override
  String get select => 'Выбрать';

  @override
  String get unSupportedAssetType => 'Неподдерживаемый формат ресурса.';
}

/// [AssetsPickerTextDelegate] implements with Japanese.
/// 日本語の TextDelegate
class JapaneseTextDelegate extends AssetsPickerTextDelegate {
  @override
  String get confirm => '決定';

  @override
  String get cancel => 'キャンセル';

  @override
  String get edit => '編集';

  @override
  String get gifIndicator => 'GIF';

  @override
  String get heicNotSupported => 'HEIC フォーマットはサポートしていません。';

  @override
  String get loadFailed => '読み込みに失敗しました。';

  @override
  String get original => '元の画像';

  @override
  String get preview => 'プレビュー';

  @override
  String get select => '選択';

  @override
  String get unSupportedAssetType => 'HEIC フォーマットはサポートしていません。';
}
