import 'package:flutter/foundation.dart';
import 'platform_view_registry_stub.dart' if (dart.library.html) 'platform_view_registry_web.dart';

void registerWebView(String viewId, String url) {
  registerIframeViewWithSrc(viewId, url);
}
