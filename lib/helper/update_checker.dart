import 'dart:io';

import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:get/get.dart';

import '../core/res/colors.dart';
import '../core/res/spacing.dart';
import '../locator.dart';
import '../services/appconfig_service.dart';
import '../ui/widgets/button.dart';

class UpdateChecker {
  versionCheck() async {
    final PackageInfo info = await PackageInfo.fromPlatform();
    final String currentVersion = info.version;

    try {
      final AppConfig appConfig = locator<AppConfigService>().config;

      final String version =
          Platform.isAndroid
              ? appConfig.android?.version ?? ''
              : appConfig.ios?.version ?? '';

      final String url =
          Platform.isAndroid
              ? appConfig.android?.url ?? ''
              : appConfig.ios?.url ?? '';

      final UpdateConfig? update = appConfig.update;

      if (version.isEmpty || url.isEmpty) return;

      final int remoteVersion = int.parse(version.replaceAll(".", ""));
      final int localVersion = int.parse(currentVersion.replaceAll(".", ""));

      print("remoteVersion $remoteVersion");
      print("localVersion $localVersion");
      print("update ${update?.title}");
      print("update ${update?.subtitle}");
      print("update ${update?.forceUpdate}");

      if (remoteVersion > localVersion) {
        // Use update dialog content from Remote Config
        final String title = update?.title ?? 'Update Available';
        final String subtitle = update?.subtitle ??
            'A new version is available. Please update to continue.';
        final bool forceUpdate = update?.forceUpdate ?? false;

        await Get.dialog(
          AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            content: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  VerticalSpacing.custom(value: 24),
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  VerticalSpacing.custom(value: 12),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: Color(0xff414141),
                    ),
                    textAlign: TextAlign.center,
                  ),
                  VerticalSpacing.custom(value: 20),
                  Button(
                    "Update",
                    key: UniqueKey(),
                    onPressed: () async {
                      if (await canLaunchUrl(Uri.parse(url))) {
                        await launchUrl(
                          Uri.parse(url),
                          mode: LaunchMode.externalApplication,
                        );
                      }
                      if (!forceUpdate) Get.back();
                    },
                  ),
                  if (!forceUpdate)
                    VerticalSpacing.custom(value: 12),
                  if (!forceUpdate)
                    Button(
                      "Cancel",
                      key: UniqueKey(),
                      color: AppColor.divider,
                      textStyle: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: Color(0xff312D4A),
                      ),
                      onPressed: () {
                        Get.back(); // Close dialog
                      },
                    ),
                ],
              ),
            ),
          ),
          barrierDismissible: !forceUpdate, // force update blocks dismiss
        );
      }
    } catch (exception, stacktrace) {
      // Logger.e("Unable to check for version info", e: exception, s: stacktrace);
      print("Version check failed $stacktrace");
    }
  }
}


