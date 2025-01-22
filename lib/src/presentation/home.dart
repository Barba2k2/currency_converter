import 'dart:developer';

import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../controller/currency_controller.dart';
import '../helper/ad_helper.dart';
import '../helpers/l10n.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final CurrencyController controller = CurrencyController();
  BannerAd? _bannerAd;
  InterstitialAd? _interstitialAd;
  bool _isBannerAdLoaded = false;

  @override
  void initState() {
    super.initState();
    controller.topController.addListener(controller.onTopValueChanged);
    controller.bottomController.addListener(controller.onBottomValueChanged);
    _loadInitialData();
    _initAds();
  }

  Future<void> _loadInitialData() async {
    await controller.loadCurrencies();
    if (mounted) setState(() {});
  }

  Future<void> _initAds() async {
    await MobileAds.instance.initialize();

    _loadBannerAd();

    _loadInterstitialAd();
  }

  void _loadBannerAd() {
    _bannerAd = BannerAd(
      adUnitId: AdHelper.bannerAdUnitId,
      size: AdSize.banner,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          setState(() {
            _isBannerAdLoaded = true;
          });
        },
        onAdFailedToLoad: (ad, error) {
          log('Banner Ad failed to load: $error');
          ad.dispose();
        },
      ),
    );
    _bannerAd?.load();
  }

  void _loadInterstitialAd() {
    InterstitialAd.load(
      adUnitId: AdHelper.interstitialAdUnitId,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          setState(() {
            _interstitialAd = ad;
          });
        },
        onAdFailedToLoad: (error) {
          log('Interstitial Ad failed to load: $error');
          _loadInterstitialAd();
        },
      ),
    );
  }

  @override
  void dispose() {
    _bannerAd?.dispose();
    _interstitialAd?.dispose();
    controller.dispose();
    super.dispose();
  }

  Widget _buildCurrencyField({
    required TextEditingController textController,
    required String selectedCurrency,
    required Function(String) onCurrencyChanged,
    required String label,
    required bool isTop,
  }) {
    return TextInputDs(
      controller: textController,
      onTap: () {
        controller.isConvertingTop = isTop;
      },
      itemBuilder: (BuildContext context) => controller.currencies
          .map(
            (currency) => PopupMenuItem(
              value: currency['code'],
              child: Text('${currency['code']} - ${currency['name']}'),
            ),
          )
          .toList(),
      isFilled: true,
      onCurrencyChanged: onCurrencyChanged,
      label: label,
      selectedCurrency: selectedCurrency,
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide.none,
        borderRadius: BorderRadius.circular(8),
      ),
    );
  }

  Widget _buildBannerAd() {
    if (_bannerAd == null || !_isBannerAdLoaded) {
      return const SizedBox();
    }

    return SizedBox(
      width: _bannerAd!.size.width.toDouble(),
      height: _bannerAd!.size.height.toDouble(),
      child: AdWidget(ad: _bannerAd!),
    );
  }

  @override
  Widget build(BuildContext context) {
    final translator = AppLocalizations.of(context);

    return Scaffold(
      backgroundColor: AppColors.white,
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          spacing: 80,
          children: [
            const SizedBox(height: 10),
            Row(
              spacing: 8,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 32,
                  height: 32,
                  child: SvgPicture.asset(
                    AppImage.arrows,
                    package: AppImage.packageName,
                  ),
                ),
                Text(
                  translator.translate('title'),
                  style: AppTheme.theme.textTheme.titleLarge,
                ),
              ],
            ),
            SizedBox(
              width: 360,
              height: 380,
              child: Container(
                padding: const EdgeInsets.fromLTRB(24, 24, 24, 28),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: AppColors.gray400,
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    spacing: 16,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        spacing: 8,
                        children: [
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              translator.translate('exchange'),
                              style: AppTheme.theme.textTheme.titleLarge,
                            ),
                          ),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              translator.translate('enter_value'),
                              style: AppTheme.theme.textTheme.bodySmall,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      _buildCurrencyField(
                        textController: controller.topController,
                        selectedCurrency: controller.topCurrency,
                        onCurrencyChanged: (value) =>
                            setState(() => controller.setTopCurrency(value)),
                        isTop: true,
                        label: translator.translate('label_top'),
                      ),
                      Align(
                        alignment: Alignment.center,
                        child: GestureDetector(
                          onTap: () {
                            if (controller.topController.text.isNotEmpty) {
                              controller.isConvertingTop = true;
                              controller.onTopValueChanged();
                            } else if (controller.bottomController.text.isNotEmpty) {
                              controller.isConvertingTop = false;
                              controller.onBottomValueChanged();
                            }
                          },
                          child: SizedBox(
                            width: 32,
                            height: 32,
                            child: SvgPicture.asset(
                              AppImage.arrowsCurrency,
                              package: AppImage.packageName,
                            ),
                          ),
                        ),
                      ),
                      _buildCurrencyField(
                        textController: controller.bottomController,
                        selectedCurrency: controller.bottomCurrency,
                        onCurrencyChanged: (value) =>
                            setState(() => controller.setBottomCurrency(value)),
                        isTop: false,
                        label: translator.translate('label_bottom'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            _buildBannerAd(),
            Padding(
              padding: const EdgeInsets.only(bottom: 30),
              child: GestureDetector(
                onTap: () async {
                  const url = 'https://linkedin.com/in/lorenzo-dz';
                  try {
                    await launchUrlString(
                      url,
                      mode: LaunchMode.externalApplication,
                    );
                  } catch (e) {
                    log(e.toString());
                  }
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: AppColors.gray400.withOpacity(0.9),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    spacing: 8,
                    children: [
                      const Icon(
                        Icons.code,
                        size: 16,
                        color: AppColors.gray100,
                      ),
                      Text(
                        translator.translate('developed_by'),
                        style: AppTheme.theme.textTheme.bodySmall?.copyWith(
                          fontWeight: FontWeight.w500,
                          letterSpacing: 0.5,
                          color: AppColors.gray100,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
