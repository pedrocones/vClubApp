// dart format width=80

/// GENERATED CODE - DO NOT MODIFY BY HAND
/// *****************************************************
///  FlutterGen
/// *****************************************************

// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: deprecated_member_use,directives_ordering,implicit_dynamic_list_literal,unnecessary_import

import 'package:flutter/widgets.dart';

class $LibGen {
  const $LibGen();

  /// Directory path: lib/Assets
  $LibAssetsGen get assets => const $LibAssetsGen();
}

class $LibAssetsGen {
  const $LibAssetsGen();

  /// Directory path: lib/Assets/flags
  $LibAssetsFlagsGen get flags => const $LibAssetsFlagsGen();

  /// Directory path: lib/Assets/icons
  $LibAssetsIconsGen get icons => const $LibAssetsIconsGen();

  /// Directory path: lib/Assets/img
  $LibAssetsImgGen get img => const $LibAssetsImgGen();
}

class $LibAssetsFlagsGen {
  const $LibAssetsFlagsGen();

  /// File path: lib/Assets/flags/en-CA-250x125.png
  AssetGenImage get enCA250x125 =>
      const AssetGenImage('lib/Assets/flags/en-CA-250x125.png');

  /// File path: lib/Assets/flags/en-UK-256x128.png
  AssetGenImage get enUK256x128 =>
      const AssetGenImage('lib/Assets/flags/en-UK-256x128.png');

  /// File path: lib/Assets/flags/es-ES-250x167.png
  AssetGenImage get esES250x167 =>
      const AssetGenImage('lib/Assets/flags/es-ES-250x167.png');

  /// File path: lib/Assets/flags/fr-FR-250x167.png
  AssetGenImage get frFR250x167 =>
      const AssetGenImage('lib/Assets/flags/fr-FR-250x167.png');

  /// List of all assets
  List<AssetGenImage> get values => [
    enCA250x125,
    enUK256x128,
    esES250x167,
    frFR250x167,
  ];
}

class $LibAssetsIconsGen {
  const $LibAssetsIconsGen();

  /// File path: lib/Assets/icons/Facebook Round.png
  AssetGenImage get facebookRound =>
      const AssetGenImage('lib/Assets/icons/Facebook Round.png');

  /// File path: lib/Assets/icons/Flickr round.png
  AssetGenImage get flickrRound =>
      const AssetGenImage('lib/Assets/icons/Flickr round.png');

  /// File path: lib/Assets/icons/Google plus round new.png
  AssetGenImage get googlePlusRoundNew =>
      const AssetGenImage('lib/Assets/icons/Google plus round new.png');

  /// File path: lib/Assets/icons/Instagram round social media icon free.png
  AssetGenImage get instagramRoundSocialMediaIconFree => const AssetGenImage(
    'lib/Assets/icons/Instagram round social media icon free.png',
  );

  /// File path: lib/Assets/icons/Linkedin round.png
  AssetGenImage get linkedinRound =>
      const AssetGenImage('lib/Assets/icons/Linkedin round.png');

  /// File path: lib/Assets/icons/Pinterest round.png
  AssetGenImage get pinterestRound =>
      const AssetGenImage('lib/Assets/icons/Pinterest round.png');

  /// File path: lib/Assets/icons/Skype round social media icon free.png
  AssetGenImage get skypeRoundSocialMediaIconFree => const AssetGenImage(
    'lib/Assets/icons/Skype round social media icon free.png',
  );

  /// File path: lib/Assets/icons/Snapchat  round social media icon Free plain.png
  AssetGenImage get snapchatRoundSocialMediaIconFreePlain =>
      const AssetGenImage(
        'lib/Assets/icons/Snapchat  round social media icon Free plain.png',
      );

  /// File path: lib/Assets/icons/Snapchat  round social media icon Free.png
  AssetGenImage get snapchatRoundSocialMediaIconFree => const AssetGenImage(
    'lib/Assets/icons/Snapchat  round social media icon Free.png',
  );

  /// File path: lib/Assets/icons/Tumblr round.png
  AssetGenImage get tumblrRound =>
      const AssetGenImage('lib/Assets/icons/Tumblr round.png');

  /// File path: lib/Assets/icons/Twitter round.png
  AssetGenImage get twitterRound =>
      const AssetGenImage('lib/Assets/icons/Twitter round.png');

  /// File path: lib/Assets/icons/Whatsapp free social media icon round.png
  AssetGenImage get whatsappFreeSocialMediaIconRound => const AssetGenImage(
    'lib/Assets/icons/Whatsapp free social media icon round.png',
  );

  /// File path: lib/Assets/icons/Youtube round.png
  AssetGenImage get youtubeRound =>
      const AssetGenImage('lib/Assets/icons/Youtube round.png');

  /// List of all assets
  List<AssetGenImage> get values => [
    facebookRound,
    flickrRound,
    googlePlusRoundNew,
    instagramRoundSocialMediaIconFree,
    linkedinRound,
    pinterestRound,
    skypeRoundSocialMediaIconFree,
    snapchatRoundSocialMediaIconFreePlain,
    snapchatRoundSocialMediaIconFree,
    tumblrRound,
    twitterRound,
    whatsappFreeSocialMediaIconRound,
    youtubeRound,
  ];
}

class $LibAssetsImgGen {
  const $LibAssetsImgGen();

  /// File path: lib/Assets/img/donate.png
  AssetGenImage get donate => const AssetGenImage('lib/Assets/img/donate.png');

  /// File path: lib/Assets/img/neigborhood 100x100.png
  AssetGenImage get neigborhood100x100 =>
      const AssetGenImage('lib/Assets/img/neigborhood 100x100.png');

  /// File path: lib/Assets/img/stongerTogether.png
  AssetGenImage get stongerTogether =>
      const AssetGenImage('lib/Assets/img/stongerTogether.png');

  /// File path: lib/Assets/img/vicinumShiel_TranspBG.png
  AssetGenImage get vicinumShielTranspBG =>
      const AssetGenImage('lib/Assets/img/vicinumShiel_TranspBG.png');

  /// File path: lib/Assets/img/vicinumShield_whiteBG.png
  AssetGenImage get vicinumShieldWhiteBG =>
      const AssetGenImage('lib/Assets/img/vicinumShield_whiteBG.png');

  /// List of all assets
  List<AssetGenImage> get values => [
    donate,
    neigborhood100x100,
    stongerTogether,
    vicinumShielTranspBG,
    vicinumShieldWhiteBG,
  ];
}

class Assets {
  const Assets._();

  static const $LibGen lib = $LibGen();
}

class AssetGenImage {
  const AssetGenImage(
    this._assetName, {
    this.size,
    this.flavors = const {},
    this.animation,
  });

  final String _assetName;

  final Size? size;
  final Set<String> flavors;
  final AssetGenImageAnimation? animation;

  Image image({
    Key? key,
    AssetBundle? bundle,
    ImageFrameBuilder? frameBuilder,
    ImageErrorWidgetBuilder? errorBuilder,
    String? semanticLabel,
    bool excludeFromSemantics = false,
    double? scale,
    double? width,
    double? height,
    Color? color,
    Animation<double>? opacity,
    BlendMode? colorBlendMode,
    BoxFit? fit,
    AlignmentGeometry alignment = Alignment.center,
    ImageRepeat repeat = ImageRepeat.noRepeat,
    Rect? centerSlice,
    bool matchTextDirection = false,
    bool gaplessPlayback = true,
    bool isAntiAlias = false,
    String? package,
    FilterQuality filterQuality = FilterQuality.medium,
    int? cacheWidth,
    int? cacheHeight,
  }) {
    return Image.asset(
      _assetName,
      key: key,
      bundle: bundle,
      frameBuilder: frameBuilder,
      errorBuilder: errorBuilder,
      semanticLabel: semanticLabel,
      excludeFromSemantics: excludeFromSemantics,
      scale: scale,
      width: width,
      height: height,
      color: color,
      opacity: opacity,
      colorBlendMode: colorBlendMode,
      fit: fit,
      alignment: alignment,
      repeat: repeat,
      centerSlice: centerSlice,
      matchTextDirection: matchTextDirection,
      gaplessPlayback: gaplessPlayback,
      isAntiAlias: isAntiAlias,
      package: package,
      filterQuality: filterQuality,
      cacheWidth: cacheWidth,
      cacheHeight: cacheHeight,
    );
  }

  ImageProvider provider({AssetBundle? bundle, String? package}) {
    return AssetImage(_assetName, bundle: bundle, package: package);
  }

  String get path => _assetName;

  String get keyName => _assetName;
}

class AssetGenImageAnimation {
  const AssetGenImageAnimation({
    required this.isAnimation,
    required this.duration,
    required this.frames,
  });

  final bool isAnimation;
  final Duration duration;
  final int frames;
}
