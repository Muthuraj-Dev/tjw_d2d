import 'dart:convert';

import '../helper/update_checker.dart';


// class AppConfigService {
//   AppConfig _appConfig = AppConfig(
//       appName: "Heavenly", baseApiUrl: "", firebaseNotificationApiKey: "");
//  // AppEnvironment? _appEnvironment;
//   String? _packageName;
//
// //  AppEnvironment? get appEnvironment => _appEnvironment;
//
//   String get envString {
//     if (_packageName?.endsWith(".dev") == true) {
//       return "DEVELOP";
//     } else if (_packageName?.endsWith(".uat") == true) {
//       return "UAT";
//     } else {
//       return "PROD";
//     }
//   }
//
//   Color get color {
//     if (_packageName?.endsWith(".dev") == true) {
//       return Colors.red;
//     } else if (_packageName?.endsWith(".uat") == true) {
//       return Colors.orange;
//     } else {
//       return Colors.green;
//     }
//   }
//
//   AppConfig get config {
//     return _appConfig;
//   }
//
//   // setConfig(String value, AppEnvironment appEnvironment, String packageName) {
//   //   _packageName = packageName;
//   //   _appConfig = AppConfig.fromJson(jsonDecode(value));
//   //   _appEnvironment = appEnvironment;
//   // }
// }

class AppConfigService {
  AppConfig _appConfig = AppConfig(
    appName: "TJW",
    baseApiUrl: "",
  );

  String? _packageName;

  String get envString {
    if (_packageName?.endsWith(".dev") == true) {
      return "DEVELOP";
    } else if (_packageName?.endsWith(".uat") == true) {
      return "UAT";
    } else {
      return "PROD";
    }
  }

  AppConfig get config => _appConfig;

  void setConfig(Map<String, dynamic> value) {
    _appConfig = AppConfig.fromJson(value);
    print(
      'AppConfig loaded:\n${const JsonEncoder.withIndent('  ').convert(_appConfig.toJson())}',
    );
  }

  void setPackageName(String packageName) {
    _packageName = packageName;
  }
}


class AppConfig {
  String? appName;
  String? baseApiUrl;
  bool? isAppActive;
  AndroidConfig? android;
  IOSConfig? ios;
  UpdateConfig? update;

  AppConfig({
    this.appName,
    this.baseApiUrl,
    this.isAppActive,
    this.android,
    this.ios,
    this.update,
  });

  factory AppConfig.fromJson(Map<String, dynamic> json) {
    return AppConfig(
      appName: json['AppName'],
      baseApiUrl: json['BaseApiUrl'],
      isAppActive: json['isAppActive'],
      android:
      json['Android'] != null ? AndroidConfig.fromJson(json['Android']) : null,
      ios: json['IOS'] != null ? IOSConfig.fromJson(json['IOS']) : null,
      update:
      json['Update'] != null ? UpdateConfig.fromJson(json['Update']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'AppName': appName,
      'BaseApiUrl': baseApiUrl,
      'isAppActive': isAppActive,
      'Android': android?.toJson(),
      'IOS': ios?.toJson(),
      'Update': update?.toJson(),
    };
  }
}


class AndroidConfig {
  String? url;
  String? version;
  String? appId;

  AndroidConfig({this.url, this.version, this.appId});

  factory AndroidConfig.fromJson(Map<String, dynamic> json) {
    return AndroidConfig(
      url: json['Url'],
      version: json['Version'],
      appId: json['AppID'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'Url': url,
      'Version': version,
      'AppID': appId,
    };
  }
}


class IOSConfig {
  String? url;
  String? version;
  String? appId;

  IOSConfig({this.url, this.version, this.appId});

  factory IOSConfig.fromJson(Map<String, dynamic> json) {
    return IOSConfig(
      url: json['Url'],
      version: json['Version'],
      appId: json['AppId'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'Url': url,
      'Version': version,
      'AppId': appId,
    };
  }
}


class UpdateConfig {
  String? title;
  String? subtitle;
  bool? forceUpdate;

  UpdateConfig({this.title, this.subtitle, this.forceUpdate});

  factory UpdateConfig.fromJson(Map<String, dynamic> json) {
    return UpdateConfig(
      title: json['Title'],
      subtitle: json['Subtitle'],
      forceUpdate: json['ForceUpdate'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'Title': title,
      'Subtitle': subtitle,
      'ForceUpdate': forceUpdate,
    };
  }
}






// class AppConfig {
//   String appName;
//   String baseApiUrl;
//   String? firebaseNotificationApiKey;
//   Android? android;
//   IOS? iOS;
//   List<String>? banners;
//   String? termsAndConditions;
//   bool? forceUpdate;
//
//   AppConfig({
//     required this.appName,
//     required this.baseApiUrl,
//     this.firebaseNotificationApiKey,
//     this.android,
//     this.iOS,
//     this.banners,
//     this.termsAndConditions,
//     this.forceUpdate
//   });
//
//   factory AppConfig.fromJson(Map<String, dynamic> json) {
//     return AppConfig(
//       appName: json['AppName'] ?? '',
//       baseApiUrl: json['BaseApiUrl'] ?? '',
//       firebaseNotificationApiKey: json['FirebaseNotificationApiKey'],
//       android: json['Android'] != null ? Android.fromJson(json['Android']) : null,
//       iOS: json['IOS'] != null ? IOS.fromJson(json['IOS']) : null,
//       banners: (json['Banners'] as List<dynamic>?)
//           ?.map((e) => e as String)
//           .toList(),
//       termsAndConditions: json['TermsAndConditions']
//     );
//   }
//
//   Map<String, dynamic> toJson() {
//     final data = <String, dynamic>{
//       'AppName': appName,
//       'BaseApiUrl': baseApiUrl,
//       'FirebaseNotificationApiKey': firebaseNotificationApiKey,
//       'TermsAndConditions' : termsAndConditions,
//     };
//     if (android != null) data['Android'] = android!.toJson();
//     if (iOS != null) data['IOS'] = iOS!.toJson();
//     if (banners != null) data['Banners'] = banners;
//     return data;
//   }
// }
//
// class Android {
//   String? url;
//   String? version;
//   String? appID;
//
//   Android({this.url, this.version, this.appID});
//
//   factory Android.fromJson(Map<String, dynamic> json) {
//     return Android(
//       url: json['Url'],
//       version: json['Version'],
//       appID: json['AppID'],
//     );
//   }
//
//   Map<String, dynamic> toJson() {
//     return {
//       'Url': url,
//       'Version': version,
//       'AppID': appID,
//     };
//   }
// }
//
// class IOS {
//   String? url;
//   String? version;
//   String? appId;
//
//   IOS({this.url, this.version, this.appId});
//
//   factory IOS.fromJson(Map<String, dynamic> json) {
//     return IOS(
//       url: json['Url'],
//       version: json['Version'],
//       appId: json['AppId'],
//     );
//   }
//
//   Map<String, dynamic> toJson() {
//     return {
//       'Url': url,
//       'Version': version,
//       'AppId': appId,
//     };
//   }
// }

