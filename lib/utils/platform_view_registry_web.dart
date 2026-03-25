import 'dart:html';
import 'dart:ui_web' as ui_web;

void registerIframeViewWithSrc(String viewId, String url) {
  ui_web.platformViewRegistry.registerViewFactory(
      viewId,
      (int id) => IFrameElement()
        ..width = '640'
        ..height = '600'
        ..src = url
        ..style.border = 'none');
}
