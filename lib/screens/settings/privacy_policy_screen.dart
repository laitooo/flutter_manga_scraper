import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:manga_scraper/theme/app_colors.dart';
import 'package:manga_scraper/theme/app_fonts.dart';
import 'package:manga_scraper/translation/language.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  final policy = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.getPrimaryColor(),
        toolbarHeight: 40,
        title: Text(
          Language.of(context).privacyPolicy,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
          ),
          strutStyle: AppFonts.getStyle(),
        ),
        centerTitle: true,
        automaticallyImplyLeading: false,
        actions: [
          SizedBox(width: 10),
          IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: SvgPicture.asset(
              'assets/icons/close_icon.svg',
              color: Colors.white,
              width: 20,
              height: 20,
            ),
          ),
        ],
      ),
      body: WebView(
        initialUrl: '',
        javascriptMode: JavascriptMode.unrestricted,
        navigationDelegate: (request) async {
          await canLaunch(request.url)
              ? await launch(request.url)
              : throw 'Could not launch ${request.url}';
          return NavigationDecision.prevent;
        },
        gestureNavigationEnabled: true,
        onWebViewCreated: (controller) async {
          String fileText =
              await rootBundle.loadString('assets/htmls/policy.html');

          controller.loadUrl(Uri.dataFromString(fileText,
                  mimeType: 'text/html', encoding: Encoding.getByName('UTF-8'))
              .toString());
        },
      ),
    );
  }
}
