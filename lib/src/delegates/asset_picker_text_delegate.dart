// Copyright 2019 The FlutterCandies author. All rights reserved.
// Use of this source code is governed by an Apache license that can be found
// in the LICENSE file.

import 'dart:io' show Platform;

import 'package:flutter/rendering.dart';
import 'package:photo_manager/photo_manager.dart' show AssetType;

/// All text delegates.
const List<AssetPickerTextDelegate> assetPickerTextDelegates =
    <AssetPickerTextDelegate>[
  AssetPickerTextDelegate(),
  EnglishAssetPickerTextDelegate(),
  HebrewAssetPickerTextDelegate(),
  GermanAssetPickerTextDelegate(),
  RussianAssetPickerTextDelegate(),
  JapaneseAssetPickerTextDelegate(),
  ArabicAssetPickerTextDelegate(),
  FrenchAssetPickerTextDelegate(),
];

/// Obtain the text delegate from the given locale.
AssetPickerTextDelegate assetPickerTextDelegateFromLocale(Locale? locale) {
  if (locale == null) {
    return const AssetPickerTextDelegate();
  }
  final String languageCode = locale.languageCode.toLowerCase();
  for (final AssetPickerTextDelegate delegate in assetPickerTextDelegates) {
    if (delegate.languageCode == languageCode) {
      return delegate;
    }
  }
  return const AssetPickerTextDelegate();
}

/// Text delegate that controls text in widgets.
/// 控制部件中的文字实现
class AssetPickerTextDelegate {
  const AssetPickerTextDelegate();

  String get languageCode => 'zh';

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

  String get changeAccessibleLimitedAssets => '点击设置可访问的资源';

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

  /// Semantics fields.
  ///
  /// Fields below are only for semantics usage. For customizable these fields,
  /// head over to [EnglishAssetPickerTextDelegate] for fields understanding.
  String get sTypeAudioLabel => '音频';

  String get sTypeImageLabel => '图片';

  String get sTypeVideoLabel => '视频';

  String get sTypeOtherLabel => '其他资源';

  String semanticTypeLabel(AssetType type) {
    switch (type) {
      case AssetType.audio:
        return sTypeAudioLabel;
      case AssetType.image:
        return sTypeImageLabel;
      case AssetType.video:
        return sTypeVideoLabel;
      case AssetType.other:
        return sTypeOtherLabel;
    }
  }

  String get sActionPlayHint => '播放';

  String get sActionPreviewHint => '预览';

  String get sActionSelectHint => '选中';

  String get sActionSwitchPathLabel => '切换路径';

  String get sActionUseCameraHint => '使用相机';

  String get sNameDurationLabel => '时长';

  String get sUnitAssetCountLabel => '数量';

  /// Fallback delegate for semantics determined by platform.
  ///
  /// The purpose of this field is to provide a fallback delegate references
  /// when a language does not supported by Talkback or VoiceOver. Set this to
  /// another text delegate makes screen readers read accordingly.
  ///
  /// See also:
  ///  * Talkback: https://support.google.com/accessibility/android/answer/11101402)
  ///  * VoiceOver: https://support.apple.com/en-us/HT206175
  AssetPickerTextDelegate get semanticsTextDelegate => this;
}

/// [AssetPickerTextDelegate] implements with English.
/// English Localization
class EnglishAssetPickerTextDelegate extends AssetPickerTextDelegate {
  const EnglishAssetPickerTextDelegate();

  @override
  String get languageCode => 'en';

  @override
  String get confirm => 'Confirm';

  @override
  String get cancel => 'Cancel';

  @override
  String get edit => 'Edit';

  @override
  String get gifIndicator => 'GIF';

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
      'Click to update accessible assets';

  @override
  String get accessAllTip => 'App can only access some assets on the device. '
      'Go to system settings and allow app to access all assets on the device.';

  @override
  String get goToSystemSettings => 'Go to system settings';

  @override
  String get accessLimitedAssets => 'Continue with limited access';

  @override
  String get accessiblePathName => 'Accessible assets';

  @override
  String get sTypeAudioLabel => 'Audio';

  @override
  String get sTypeImageLabel => 'Image';

  @override
  String get sTypeVideoLabel => 'Video';

  @override
  String get sTypeOtherLabel => 'Other asset';

  @override
  String get sActionPlayHint => 'play';

  @override
  String get sActionPreviewHint => 'preview';

  @override
  String get sActionSelectHint => 'select';

  @override
  String get sActionSwitchPathLabel => 'switch path';

  @override
  String get sActionUseCameraHint => 'use camera';

  @override
  String get sNameDurationLabel => 'duration';

  @override
  String get sUnitAssetCountLabel => 'count';
}

/// [AssetPickerTextDelegate] implements with Hebrew.
/// תרגום בשפה העברית
class HebrewAssetPickerTextDelegate extends AssetPickerTextDelegate {
  const HebrewAssetPickerTextDelegate();

  @override
  String get languageCode => 'he';

  @override
  String get confirm => 'אישור';

  @override
  String get cancel => 'ביטול';

  @override
  String get edit => 'עריכה';

  @override
  String get gifIndicator => 'GIF';

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

  @override
  String get sTypeAudioLabel => 'שמע';

  @override
  String get sTypeImageLabel => 'תמונה';

  @override
  String get sTypeVideoLabel => 'סרטון';

  @override
  String get sTypeOtherLabel => 'קובץ אחר';

  @override
  String get sActionPlayHint => 'נגן';

  @override
  String get sActionPreviewHint => 'תצוגה מקדימה';

  @override
  String get sActionSelectHint => 'בחר';

  @override
  String get sActionSwitchPathLabel => 'החלף תיקייה';

  @override
  String get sActionUseCameraHint => 'השתמש במצלמה';

  @override
  String get sNameDurationLabel => 'משך';

  @override
  String get sUnitAssetCountLabel => 'כמות';

  @override
  AssetPickerTextDelegate get semanticsTextDelegate {
    if (Platform.isAndroid) {
      return const EnglishAssetPickerTextDelegate();
    }
    return this;
  }
}

/// [AssetPickerTextDelegate] implementiert mit der deutschen Übersetzung.
/// Deutsche Textimplementierung.
class GermanAssetPickerTextDelegate extends AssetPickerTextDelegate {
  const GermanAssetPickerTextDelegate();

  @override
  String get languageCode => 'de';

  @override
  String get confirm => 'Bestätigen';

  @override
  String get cancel => 'Abbrechen';

  @override
  String get edit => 'Bearbeiten';

  @override
  String get gifIndicator => 'GIF';

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

  @override
  String get sTypeAudioLabel => 'Audio';

  @override
  String get sTypeImageLabel => 'Bild';

  @override
  String get sTypeVideoLabel => 'Video';

  @override
  String get sTypeOtherLabel => 'Andere Medien';

  @override
  String get sActionPlayHint => 'Abspielen';

  @override
  String get sActionPreviewHint => 'Vorschau';

  @override
  String get sActionSelectHint => 'Auswählen';

  @override
  String get sActionSwitchPathLabel => 'Dateipfad ändern';

  @override
  String get sActionUseCameraHint => 'Kamera benutzen';

  @override
  String get sNameDurationLabel => 'Dauer';

  @override
  String get sUnitAssetCountLabel => 'Anzahl';
}

/// [AssetPickerTextDelegate] implements with Russian.
/// Локализация на русский язык.
class RussianAssetPickerTextDelegate extends AssetPickerTextDelegate {
  const RussianAssetPickerTextDelegate();

  @override
  String get languageCode => 'ru';

  @override
  String get confirm => 'Готово';

  @override
  String get cancel => 'Отмена';

  @override
  String get edit => 'Изменить';

  @override
  String get gifIndicator => 'GIF';

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

  @override
  String get sTypeAudioLabel => 'Аудио';

  @override
  String get sTypeImageLabel => 'Изображение';

  @override
  String get sTypeVideoLabel => 'Видео';

  @override
  String get sTypeOtherLabel => 'Другой файл';

  @override
  String get sActionPlayHint => 'воспроизвести';

  @override
  String get sActionPreviewHint => 'просмотреть';

  @override
  String get sActionSelectHint => 'выбрать';

  @override
  String get sActionSwitchPathLabel => 'изменить путь';

  @override
  String get sActionUseCameraHint => 'использовать камеру';

  @override
  String get sNameDurationLabel => 'продолжительность';

  @override
  String get sUnitAssetCountLabel => 'количество';
}

/// [AssetPickerTextDelegate] implements with Japanese.
/// 日本語の TextDelegate
class JapaneseAssetPickerTextDelegate extends AssetPickerTextDelegate {
  const JapaneseAssetPickerTextDelegate();

  @override
  String get languageCode => 'ja';

  @override
  String get confirm => '確認';

  @override
  String get cancel => 'キャンセル';

  @override
  String get edit => '編集';

  @override
  String get gifIndicator => 'GIF画像';

  @override
  String get loadFailed => '読み込みに失敗しました';

  @override
  String get original => '元の画像';

  @override
  String get preview => 'プレビュー';

  @override
  String get select => '選択';

  @override
  String get emptyList => 'リストが空です';

  @override
  String get unSupportedAssetType => '未対応のフォーマット';

  @override
  String get unableToAccessAll => 'すべてのリソースへのアクセスができない';

  @override
  String get viewingLimitedAssetsTip => 'アプリは一部のリソースと'
      '写真にしかアクセスできない';

  @override
  String get changeAccessibleLimitedAssets => 'アクセスできるリソースを設定する';

  @override
  String get accessAllTip => 'アプリがデバイスのリソースの一部にのみ'
      'アクセスするように設定されています。'
      '「すべてのリソース」へのアクセスを許可することを推奨します';

  @override
  String get goToSystemSettings => '「システム設定」に移動';

  @override
  String get accessLimitedAssets => 'リソースの一部へのアクセスを続行';

  @override
  String get accessiblePathName => 'アクセスできるリソース';

  @override
  String get sTypeAudioLabel => 'オーディオ';

  @override
  String get sTypeImageLabel => '画像';

  @override
  String get sTypeVideoLabel => '動画';

  @override
  String get sTypeOtherLabel => 'その他のリソース';

  @override
  String get sActionPlayHint => '再生';

  @override
  String get sActionPreviewHint => 'プレビュー';

  @override
  String get sActionSelectHint => '選択';

  @override
  String get sActionSwitchPathLabel => 'パス切り替え';

  @override
  String get sActionUseCameraHint => 'カメラを使う';

  @override
  String get sNameDurationLabel => '動画の時間';

  @override
  String get sUnitAssetCountLabel => '数';
}

/// [AssetPickerTextDelegate] implements with Arabic.
/// الترجمة العربية
class ArabicAssetPickerTextDelegate extends AssetPickerTextDelegate {
  const ArabicAssetPickerTextDelegate();

  @override
  String get languageCode => 'ar';

  @override
  String get confirm => 'تاكيد';

  @override
  String get cancel => 'إلغاء';

  @override
  String get edit => 'تعديل';

  @override
  String get gifIndicator => 'GIF';

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

  @override
  String get sTypeAudioLabel => 'صوتي';

  @override
  String get sTypeImageLabel => 'صورة';

  @override
  String get sTypeVideoLabel => 'فيديو';

  @override
  String get sTypeOtherLabel => 'آخر';

  @override
  String get sActionPlayHint => 'تشغيل';

  @override
  String get sActionPreviewHint => 'معاينة';

  @override
  String get sActionSelectHint => 'تحديد';

  @override
  String get sActionSwitchPathLabel => 'تبديل المسار';

  @override
  String get sActionUseCameraHint => 'استخدم الكاميرا';

  @override
  String get sNameDurationLabel => 'مدة';

  @override
  String get sUnitAssetCountLabel => 'عدد';
}

/// [AssetPickerTextDelegate] implements with French.
/// Délégué texte français
class FrenchAssetPickerTextDelegate extends AssetPickerTextDelegate {
  const FrenchAssetPickerTextDelegate();

  @override
  String get languageCode => 'fr';

  @override
  String get confirm => 'OK';

  @override
  String get cancel => 'Annuler';

  @override
  String get edit => 'Modifier';

  @override
  String get gifIndicator => 'GIF';

  @override
  String get loadFailed => 'Echec du chargement';

  @override
  String get original => 'Original';

  @override
  String get preview => 'Aperçu';

  @override
  String get select => 'Choisir';

  @override
  String get emptyList => 'Liste vide';

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
  String get sTypeAudioLabel => "l'audio";

  @override
  String get sTypeImageLabel => 'image';

  @override
  String get sTypeVideoLabel => 'vidéo';

  @override
  String get sTypeOtherLabel => 'Autre';

  @override
  String get sActionPlayHint => 'jouer';

  @override
  String get sActionPreviewHint => 'aperçu';

  @override
  String get sActionSelectHint => 'choisir';

  @override
  String get sActionSwitchPathLabel => 'changer le dossier';

  @override
  String get sActionUseCameraHint => 'Utiliser la Caméra';

  @override
  String get sNameDurationLabel => 'durée';

  @override
  String get sUnitAssetCountLabel => 'quantité';
}
