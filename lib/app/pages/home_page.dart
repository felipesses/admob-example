import 'dart:io';

import 'package:firebase_admob/firebase_admob.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  BannerAd _bannerAd;
  NativeAd _nativeAd;
  InterstitialAd _interstitialAd;
  int _coins = 0;

  BannerAd createBannerAd() {
    return BannerAd(
      adUnitId: BannerAd.testAdUnitId,
      size: AdSize.banner,
      listener: (MobileAdEvent event) {
        print("BannerAd event $event");
      },
    );
  }

  InterstitialAd createInterstitialAd() {
    return InterstitialAd(
      adUnitId: InterstitialAd.testAdUnitId,
      listener: (MobileAdEvent event) {
        print("InterstitialAd event $event");
      },
    );
  }

  NativeAd createNativeAd() {
    return NativeAd(
      adUnitId: NativeAd.testAdUnitId,
      factoryId: 'adFactoryExample',
      listener: (MobileAdEvent event) {
        print("$NativeAd event $event");
      },
    );
  }

  @override
  void initState() {
    super.initState();
    FirebaseAdMob.instance.initialize(appId: FirebaseAdMob.testAppId);
    _bannerAd = createBannerAd()..load();
    RewardedVideoAd.instance.listener =
        (RewardedVideoAdEvent event, {String rewardType, int rewardAmount}) {
      print("RewardedVideoAd event $event");
      if (event == RewardedVideoAdEvent.rewarded) {
        setState(() {
          _coins += rewardAmount;
        });
      }
    };
  }

  @override
  void dispose() {
    _bannerAd?.dispose();
    _nativeAd?.dispose();
    _interstitialAd?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('AdMob Plugin example app'),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              RaisedButton(
                child: const Text('SHOW BANNER'),
                onPressed: () {
                  _bannerAd ??= createBannerAd();
                  _bannerAd
                    ..load()
                    ..show();
                },
              ),
              RaisedButton(
                  child: const Text('SHOW BANNER WITH OFFSET'),
                  onPressed: () {
                    _bannerAd ??= createBannerAd();
                    _bannerAd
                      ..load()
                      ..show(horizontalCenterOffset: -50, anchorOffset: 100);
                  }),
              RaisedButton(
                  child: const Text('REMOVE BANNER'),
                  onPressed: () {
                    _bannerAd?.dispose();
                    _bannerAd = null;
                  }),
              RaisedButton(
                child: const Text('LOAD INTERSTITIAL'),
                onPressed: () {
                  _interstitialAd?.dispose();
                  _interstitialAd = createInterstitialAd()..load();
                },
              ),
              RaisedButton(
                child: const Text('SHOW INTERSTITIAL'),
                onPressed: () {
                  _interstitialAd?.show();
                },
              ),
              RaisedButton(
                child: const Text('SHOW NATIVE'),
                onPressed: () {
                  _nativeAd ??= createNativeAd();
                  _nativeAd
                    ..load()
                    ..show(
                      anchorType: Platform.isAndroid
                          ? AnchorType.bottom
                          : AnchorType.top,
                    );
                },
              ),
              RaisedButton(
                child: const Text('REMOVE NATIVE'),
                onPressed: () {
                  _nativeAd?.dispose();
                  _nativeAd = null;
                },
              ),
              RaisedButton(
                child: const Text('LOAD REWARDED VIDEO'),
                onPressed: () {
                  RewardedVideoAd.instance.load(
                    adUnitId: RewardedVideoAd.testAdUnitId,
                  );
                },
              ),
              RaisedButton(
                child: const Text('SHOW REWARDED VIDEO'),
                onPressed: () {
                  RewardedVideoAd.instance.show();
                },
              ),
              Text("You have $_coins coins."),
            ].map((Widget button) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: button,
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
}
