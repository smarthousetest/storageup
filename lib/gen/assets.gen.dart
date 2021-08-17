/// GENERATED CODE - DO NOT MODIFY BY HAND
/// *****************************************************
///  FlutterGen
/// *****************************************************

import 'package:flutter/widgets.dart';

class $AssetsAuthGen {
  const $AssetsAuthGen();

  AssetGenImage get facebook => const AssetGenImage('assets/auth/facebook.png');
  AssetGenImage get google => const AssetGenImage('assets/auth/google.png');
  AssetGenImage get leftBackgroung =>
      const AssetGenImage('assets/auth/left_backgroung.png');
  String get logo => 'assets/auth/logo.svg';
  AssetGenImage get manLeft => const AssetGenImage('assets/auth/man_left.png');
  AssetGenImage get manRight =>
      const AssetGenImage('assets/auth/man_right.png');
  AssetGenImage get oblaka => const AssetGenImage('assets/auth/oblaka.png');
  AssetGenImage get rightBackground =>
      const AssetGenImage('assets/auth/right_background.png');
}

class Assets {
  Assets._();

  static const $AssetsAuthGen auth = $AssetsAuthGen();
  static const AssetGenImage hidePassword =
      AssetGenImage('assets/hide_password.png');
  static const AssetGenImage showPassword =
      AssetGenImage('assets/show_password.png');
}

class AssetGenImage extends AssetImage {
  const AssetGenImage(String assetName) : super(assetName);

  Image image({
    Key? key,
    ImageFrameBuilder? frameBuilder,
    ImageLoadingBuilder? loadingBuilder,
    ImageErrorWidgetBuilder? errorBuilder,
    String? semanticLabel,
    bool excludeFromSemantics = false,
    double? width,
    double? height,
    Color? color,
    BlendMode? colorBlendMode,
    BoxFit? fit,
    AlignmentGeometry alignment = Alignment.center,
    ImageRepeat repeat = ImageRepeat.noRepeat,
    Rect? centerSlice,
    bool matchTextDirection = false,
    bool gaplessPlayback = false,
    bool isAntiAlias = false,
    FilterQuality filterQuality = FilterQuality.low,
  }) {
    return Image(
      key: key,
      image: this,
      frameBuilder: frameBuilder,
      loadingBuilder: loadingBuilder,
      errorBuilder: errorBuilder,
      semanticLabel: semanticLabel,
      excludeFromSemantics: excludeFromSemantics,
      width: width,
      height: height,
      color: color,
      colorBlendMode: colorBlendMode,
      fit: fit,
      alignment: alignment,
      repeat: repeat,
      centerSlice: centerSlice,
      matchTextDirection: matchTextDirection,
      gaplessPlayback: gaplessPlayback,
      isAntiAlias: isAntiAlias,
      filterQuality: filterQuality,
    );
  }

  String get path => assetName;
}
