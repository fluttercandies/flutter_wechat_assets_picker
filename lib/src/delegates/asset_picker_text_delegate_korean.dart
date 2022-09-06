import 'package:munto_assets_picker/munto_assets_picker.dart';

class KoreanAssetPickerTextDelegate extends AssetPickerTextDelegate {
  const KoreanAssetPickerTextDelegate();
  @override
  String get languageCode => 'ko';

  @override
  String get confirm => '확인';

  @override
  String get cancel => '취소';

  @override
  String get edit => '편집';

  @override
  String get gifIndicator => 'GIF 이미지';

  @override
  String get loadFailed => '로딩에 실패했습니다';

  @override
  String get original => '원본';

  @override
  String get preview => '미리보기';

  @override
  String get select => '선택';

  @override
  String get emptyList => '목록이 비었습니다';

  @override
  String get unSupportedAssetType => '지원하지 않는 포맷';

  @override
  String get unableToAccessAll => '멤버님의 사진들을 확인할 수 없어요!';

  @override
  String get viewingLimitedAssetsTip => '앱은 일부 파일과 사진에만 접근할 수 있습니다';

  @override
  String get changeAccessibleLimitedAssets => '클릭해서 접근 가능한 파일을 설정';

  @override
  String get accessAllTip => '사진 접근 허용이 제한되어 휴대폰에 저장된 사진을 볼 수 없어요. '
      '[시스템 설정 > MUNTO > 사진 접근 허용 > 모든 사진]으로 설정해야 모든 사진을 볼 수 있어요.';

  @override
  String get goToSystemSettings => '시스템 설정으로 가기';

  @override
  String get accessLimitedAssets => '접근 허용한 사진 선택하기';

  @override
  String get accessiblePathName => '접근 허용한 사진 목록';

  @override
  String get sTypeAudioLabel => '오디오';

  @override
  String get sTypeImageLabel => '이미지';

  @override
  String get sTypeVideoLabel => '비디오';

  @override
  String get sTypeOtherLabel => '다른 파일';

  @override
  String get sActionPlayHint => '재생';

  @override
  String get sActionPreviewHint => '미리보기';

  @override
  String get sActionSelectHint => '선택';

  @override
  String get sActionSwitchPathLabel => '경로 변경';

  @override
  String get sActionUseCameraHint => '카메라 사용';

  @override
  String get sNameDurationLabel => '영상 길이';

  @override
  String get sUnitAssetCountLabel => '개수';
}
