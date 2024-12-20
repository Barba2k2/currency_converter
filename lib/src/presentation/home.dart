import 'dart:developer';

import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../controller/currency_controller.dart';
import '../helper/ad_helper.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

// TODO: Add Ads for Android and iOs, move to production

class _HomeState extends State<Home> {
  final CurrencyController controller = CurrencyController();
  BannerAd? _bannerAd;
  InterstitialAd? _interstitialAd;

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
          setState(() {});
        },
        onAdFailedToLoad: (ad, error) {
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
          _interstitialAd = ad;
        },
        onAdFailedToLoad: (error) {
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
    if (_bannerAd == null) {
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
    return Container(
      color: AppColors.white,
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 80),
            child: Row(
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
                  'Exchange',
                  style: AppTheme.theme.textTheme.titleLarge,
                ),
              ],
            ),
          ),
          Align(
            alignment: Alignment.center,
            child: SizedBox(
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
                              'Conversor de moedas',
                              style: AppTheme.theme.textTheme.titleLarge,
                            ),
                          ),
                          Text(
                            'Digite o valor escolha as moedas de conversão',
                            style: AppTheme.theme.textTheme.bodySmall,
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      _buildCurrencyField(
                        textController: controller.topController,
                        selectedCurrency: controller.topCurrency,
                        onCurrencyChanged: (value) =>
                            setState(() => controller.setTopCurrency(value)),
                        isTop: true,
                        label: '\$ 100.00',
                      ),
                      Align(
                        alignment: Alignment.center,
                        child: GestureDetector(
                          onTap: () {
                            log('Updated');
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
                        label: 'R\$ 100.00',
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 80,
            left: 0,
            right: 0,
            child: _buildBannerAd(),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 30),
              child: GestureDetector(
                onTap: () async {
                  const url = 'https://linkedin.com/in/lorenzo-dz';
                  log('Developed by Barba Tech');
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
                    children: [
                      const Icon(
                        Icons.code,
                        size: 16,
                        color: AppColors.gray100,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Developed by Barba Tech',
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
          ),
        ],
      ),
    );
  }
}
