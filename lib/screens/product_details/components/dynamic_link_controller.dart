import 'package:flutter_share/flutter_share.dart';
import 'package:get/get.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';

class DynamicLinkController extends GetxController {
  @override
  void onInit() {
    initDynamicLinks();
    super.onInit();
  }

  Future<Uri> createDynamicLink(index) async {
    final DynamicLinkParameters parameters = DynamicLinkParameters(
      uriPrefix: 'https://marketmela.page.link/',
      navigationInfoParameters:
          NavigationInfoParameters(forcedRedirectEnabled: true),
      link: Uri.parse('https://marketmela.page.link/' + index.toString()),
      androidParameters: AndroidParameters(
        packageName: 'com.marketmela.app',
      ),
      iosParameters: IosParameters(
        bundleId: 'com.axactstudios.ecom',
        appStoreId: '1576741080',
      ),
    );
    return await parameters.buildUrl();
  }

  void initDynamicLinks() async {
    FirebaseDynamicLinks.instance.onLink(
        onSuccess: (PendingDynamicLinkData dynamicLink) async {
      final Uri deepLink = dynamicLink?.link;
      if (deepLink != null) {
        Get.toNamed('/products', arguments: int.parse(deepLink.path));
      }
    }, onError: (OnLinkErrorException e) async {
      print('onLinkError');
      print(e.message);
    });
  }

  Future<void> share(String link, String title, String details) async {
    await FlutterShare.share(
        title: title,
        text: title,
        linkUrl: link,
        chooserTitle: 'Share Product');
  }
}
