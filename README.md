Many flutter project earning with Google Admob and using firebase for analytics, This package help
you can config AdMob ads with Firebase Remote Config and A/B testing on them

## Features

1. on/off Ads
2. Config Ads Unit Id
3. A/B testing ads position
4. Setup width/height of Ads
5. ... continue

## Getting started

This package depends on:

1. google_mobile_ads
2. firebase_remote_config

If you don't have, please follow below tutorials to setup them

## Usage

Setup firebase remote config with a key you want to using like this:

1. Your config key: `banner_ad`
2. Your config data:

```json
{
  "enable": true,
  "ad_unit_id_android": "ca-app-pub-3940256099942544/6300978111",
  "ad_unit_id_ios": "ca-app-pub-3940256099942544/2934735716",
  "position": null,
  "distance": null,
  "width": null,
  "height": null
}
```

1. Your config key: `interstitial_ad`
2. Your config data:

```json
{
  "enable": true,
  "ad_unit_id_android": "ca-app-pub-3940256099942544/1033173712",
  "ad_unit_id_ios": "ca-app-pub-3940256099942544/4411468910",
  "request_time_to_show": 10,
  "fail_time_to_stop": 3,
  "init_request_time": 0
}
```

like this

<p align="center">
   <img src="https://raw.githubusercontent.com/hautvfami/firebase_admob_config/main/example/snapshots/Screen%20Shot%202022-06-06%20at%2001.37.59.png" alt="example config" width="300"/>
</p>

Add your Ads widget to anywhere with a key you want integrate with:

```flutter
//
// Interstitial Ads from Firebase Remote Config
final interstitialAd = AppInterstitialAd.fromKey(
 keyConfig: 'interstitial_ad',
);
  
// Banner Ads from Firebase Remote Config
AppBannerAd.fromKey(configKey: 'banner_ad'),

// InterstitialAd run
TextButton(
    onPressed: () => interstitialAd.run(),
    child: const Text('InterstitialAd'),
),
```

<p align="center">
<img src="https://raw.githubusercontent.com/hautvfami/firebase_admob_config/main/example/snapshots/Screenshot_1654454073.png" alt="example ads" width="300"/>
</p>

#### Setup Google Admob

Config your google admob like this tutorial

[Google Admob](https://developers.google.com/admob/android/quick-start#import_the_mobile_ads_sdk)

1. In your project-level build.gradle file, include Google's Maven repository and Maven central
   repository in both your buildscript and allprojects sections:

```groovy
buildscript {
    repositories {
        google()
        mavenCentral()
    }
}

allprojects {
    repositories {
        google()
        mavenCentral()
    }
}
```

2. Add the dependencies for the Google Mobile Ads SDK to your module's app-level Gradle file,
   normally app/build.gradle:

```groovy
dependencies {
    implementation 'com.google.android.gms:play-services-ads:21.0.0'
}
```

3. Add your AdMob app ID (identified in the AdMob UI) to your app's AndroidManifest.xml file. To do
   so, add a <meta-data> tag with android:name="com.google.android.gms.ads.APPLICATION_ID". You can
   find your app ID in the AdMob UI. For android:value, insert your own AdMob app ID, surrounded by
   quotation marks.

```xml

<manifest>
    <application>
        <!-- Sample AdMob app ID: ca-app-pub-3940256099942544~3347511713 -->
        <meta-data android:name="com.google.android.gms.ads.APPLICATION_ID"
            android:value="ca-app-pub-xxxxxxxxxxxxxxxx~yyyyyyyyyy" />
    </application>
</manifest>
```

In a real app, use your actual AdMob app ID, not the one listed above. If you're just looking to
experiment with the SDK in a Hello World app, you can use the sample app ID shown above.

Note also that failure to add the <meta-data> tag as shown above results in a crash with the
message:
```The Google Mobile Ads SDK was initialized incorrectly.```

#### Setup Firebase remote config

Setup firebase remote config like this tutorials:

[Flutter Config](https://pub.dev/packages/firebase_remote_config/example)

[Native Config](https://firebase.google.com/docs/flutter/setup?platform=android)

## Additional information

Tell me if you want a support

## Give me a coffee

[PayPal](https://paypal.me/hautvfami)