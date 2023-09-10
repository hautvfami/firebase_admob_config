import 'package:flutter/material.dart';

import 'app_native_ad.dart';

class NativeGroupAds extends StatefulWidget {
  final String configKey;

  const NativeGroupAds({Key? key, required this.configKey}) : super(key: key);

  @override
  State<NativeGroupAds> createState() => _NativeGroupAdsState();
}

class _NativeGroupAdsState extends State<NativeGroupAds>
    with AutomaticKeepAliveClientMixin {
  late NativeAdController _nativeAdController;

  @override
  void initState() {
    _nativeAdController = NativeAdController.fromKey(
      configKey: widget.configKey,
    );
    super.initState();
  }

  @override
  void dispose() {
    _nativeAdController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    if (_nativeAdController.adUnitId.isEmpty) return const SizedBox();

    return FutureBuilder<bool>(
      future: _nativeAdController.adsLoad.future,
      builder: (_, sns) {
        return sns.data == true
            ? ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Container(
                  height: _nativeAdController.adHeight?.toDouble() ??
                      _nativeAdController.height,
                  color: Theme.of(context).cardColor,
                  child: _nativeAdController.widget,
                ),
              )
            : const SizedBox();
      },
    );
  }

  @override
  bool get wantKeepAlive => true;
}
