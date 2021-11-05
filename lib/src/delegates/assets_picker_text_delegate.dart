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

  /// Empty list string for empty asset list.
  /// 资源列表为空时的占位字段
  String get emptyList => '列表为空';

  /// Un-supported asset type string for assets that
  /// belongs to [AssetType.other].
  /// 未支持的资源类型的字段
  String get unSupportedAssetType => '尚未支持的资源类型';

  /// "Unable to access all assets in album".
  String get unableToAccessAll => '无法访问所有资源';

  String get viewingLimitedAssetsTip => '应用只能访问部分资源和相册';

  String get changeAccessibleLimitedAssets => '设置可访问的资源';

  String get accessAllTip => '你已设置应用只能访问设备部分资源，'
      '建议允许访问「所有资源」';

  String get goToSystemSettings => '前往系统设置';

  /// "Continue accessing some assets".
  String get accessLimitedAssets => '继续访问部分资源';

  String get accessiblePathName => '可访问的资源';

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
/// English Localization
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
  String get emptyList => 'Empty list';

  @override
  String get unSupportedAssetType => 'Unsupported HEIC asset type.';

  @override
  String get unableToAccessAll => 'Unable to access all assets on the device';

  @override
  String get viewingLimitedAssetsTip =>
      'Only view assets and albums accessible to app.';

  @override
  String get changeAccessibleLimitedAssets =>
      'Update limited access assets list';

  @override
  String get accessAllTip => 'App can only access some assets on the device. '
      'Go to system settings and allow app to access all assets on the device.';

  @override
  String get goToSystemSettings => 'Go to system settings';

  @override
  String get accessLimitedAssets => 'Continue with limited access';

  @override
  String get accessiblePathName => 'Accessible assets';
}

/// [AssetsPickerTextDelegate] implements with Hebrew.
/// תרגום בשפה העברית
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
  String get emptyList => 'הרשימה ריקה';

  @override
  String get unSupportedAssetType => 'סוג קובץ HEIC אינו נתמך';

  @override
  String get unableToAccessAll => 'לא ניתן לגשת לכל הקבצים במכשיר';

  @override
  String get viewingLimitedAssetsTip =>
      'הצג רק קבצים ואלבומים נגישים לאפליקציה.';

  @override
  String get changeAccessibleLimitedAssets => 'אפשר גישה לקבצים נוספים';

  @override
  String get accessAllTip => 'האפליקציה יכולה לגשת רק לחלק מהקבצים במכשיר. '
      'פתח הגדרות מערכת ואפשר לאפליקציה גישה לכל הקבצים במכשיר.';

  @override
  String get goToSystemSettings => 'פתח הגדרות מערכת';

  @override
  String get accessLimitedAssets => 'המשך גישה מוגבלת';

  @override
  String get accessiblePathName => 'קבצים נגישים';
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
  String get emptyList => 'Leere Liste';

  @override
  String get unSupportedAssetType => 'HEIC Format ist nicht unterstützt.';

  @override
  String get unableToAccessAll => 'Zugriff nicht möglich';

  @override
  String get viewingLimitedAssetsTip =>
      'Zeigen Sie nur Dateien und Alben an, auf die die App zugreifen kann';

  @override
  String get accessAllTip =>
      'Die App kann nur auf einige der Dateien auf dem Gerät zugreifen. '
      'Öffnen Sie die Systemeinstellungen und erlauben Sie der App, '
      'auf alle Dateien auf dem Gerät zuzugreifen';

  @override
  String get goToSystemSettings => 'Gehe zu den Systemeinstellungen';

  @override
  String get accessLimitedAssets => 'Fahre fort mit limitierten Zugriff';

  @override
  String get accessiblePathName => 'Verfügbare Assets';
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
  String get original => 'Оригинал';

  @override
  String get preview => 'Предпросмотр';

  @override
  String get select => 'Выбрать';

  @override
  String get emptyList => 'Пустой список';

  @override
  String get unSupportedAssetType => 'Неподдерживаемый формат ресурса.';

  @override
  String get unableToAccessAll => 'Не все файлы доступны на устройстве';

  @override
  String get viewingLimitedAssetsTip =>
      'Показать только файлы, которые доступны приложению.';

  @override
  String get changeAccessibleLimitedAssets =>
      'Разрешить доступ к дополнительным файлам';

  @override
  String get accessAllTip =>
      'У приложения доступ только к некоторым файлам на устройстве. '
      'Откройте настройки системы и разрешите приложению доступ ко всем файлам на устройстве.';

  @override
  String get goToSystemSettings => 'Открыть настройки системы';

  @override
  String get accessLimitedAssets => 'Продолжить с ограниченным доступом';

  @override
  String get accessiblePathName => 'Доступные файлы';
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
  String get emptyList => '空リスト';

  @override
  String get unSupportedAssetType => 'HEIC フォーマットはサポートしていません。';

  @override
  String get unableToAccessAll => 'すべてのリソースにアクセスできない';

  @override
  String get viewingLimitedAssetsTip => 'このアプリは一部のリソース及'
      'びアルバムのみにアクセスできる';

  @override
  String get changeAccessibleLimitedAssets => 'アクセスできるリソースを設置';

  @override
  String get accessAllTip => 'アプリがデバイスの一部のリソースの'
      'みにアクセスするように設定され、'
      '「すべてのリソースへ」にアクセスする権限を許可してください';

  @override
  String get goToSystemSettings => '「システム設定」に移動';

  @override
  String get accessLimitedAssets => 'リソースの一部へのアクセスを続行';

  @override
  String get accessiblePathName => 'アクセスできるリソース';
}

/// [AssetsPickerTextDelegate] implements with Arabic.
/// الترجمة العربية
class ArabicTextDelegate extends AssetsPickerTextDelegate {
  @override
  String get confirm => 'تاكيد';

  @override
  String get cancel => 'إلغاء';

  @override
  String get edit => 'تعديل';

  @override
  String get gifIndicator => 'GIF';

  @override
  String get heicNotSupported => 'نوع HEIC غير مدعوم.';

  @override
  String get loadFailed => 'فشل التحميل';

  @override
  String get original => 'أصلي';

  @override
  String get preview => 'معاينة';

  @override
  String get select => 'تحديد';

  @override
  String get emptyList => 'القائمة فارغة';

  @override
  String get unSupportedAssetType => 'نوع HEIC غير مدعوم';

  @override
  String get unableToAccessAll =>
      'لا يمكن الوصول إلى جميع الملفات الموجودة على الجهاز';

  @override
  String get viewingLimitedAssetsTip =>
      'إظهار الملفات والألبومات التي يمكن للتطبيق الوصول إليها فقط.';

  @override
  String get changeAccessibleLimitedAssets => 'السماح بالوصول إلى ملفات إضافية';

  @override
  String get accessAllTip =>
      'يمكن للتطبيق الوصول فقط إلى بعض الملفات الموجودة على الجهاز. '
      'افتح إعدادات النظام واسمح للتطبيق بالوصول إلى جميع الملفات الموجودة على الجهاز.';

  @override
  String get goToSystemSettings => 'فتح إعدادات النظام';

  @override
  String get accessLimitedAssets => 'الاستمرار مع صلاحيات محدوده';

  @override
  String get accessiblePathName => 'ملفات يمكن الوصول إليها';
}

/// [AssetsPickerTextDelegate] implements with French.
/// Délégué texte français
class FrenchTextDelegate extends AssetsPickerTextDelegate {
  @override
  String get confirm => 'OK';

  @override
  String get cancel => 'Annuler';

  @override
  String get edit => 'Modifier';

  @override
  String get gifIndicator => 'GIF';

  @override
  String get heicNotSupported => 'Type de fichier non supporté';

  @override
  String get loadFailed => 'Echec du chargement';

  @override
  String get original => 'Original';

  @override
  String get preview => 'Aperçu';

  @override
  String get select => 'Choisir';

  @override
  String get unSupportedAssetType => 'Type de fichier non supporté';

  @override
  String get unableToAccessAll =>
      'Impossible d\'accéder aux médias de votre appareil';

  @override
  String get viewingLimitedAssetsTip =>
      'Affichage des médias et albums limité ';

  @override
  String get changeAccessibleLimitedAssets =>
      "Modifier l'accès limité aux médias";

  @override
  String get accessAllTip =>
      "L'application ne peut accéder qu'à certains medias. "
      "Allez dans les paramètres système et autoriser l'application "
      "à accéder à tous les medias sur l'appareil";

  @override
  String get goToSystemSettings => 'Allez dans les paramètres système';

  @override
  String get accessLimitedAssets => 'Continuer avec un accès limité';

  @override
  String get accessiblePathName => 'Medias accessible';

  @override
  String get emptyList => 'Liste vide';
}
