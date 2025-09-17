@JS()
library pdf.js;

import 'dart:js_interop';
import 'dart:js_interop_unsafe';
import 'dart:typed_data';

import 'package:web/web.dart';

@JS('pdfjsLib.getDocument')
external _PDFDocumentLoadingTask _pdfjsGetDocument(JSAny data);

@JS('pdfRenderOptions')
external JSObject _pdfRenderOptions;

@JS('PDFDocumentLoadingTask')
extension type _PDFDocumentLoadingTask._(JSObject _) implements JSObject {
  external JSPromise<PdfjsDocument> get promise;
}

Map<String, dynamic> _getParams(Map<String, dynamic> jsParams) {
  final params = {
    'cMapUrl': (_pdfRenderOptions.getProperty('cMapUrl'.toJS) as JSString?)?.toDart,
    'cMapPacked': (_pdfRenderOptions.getProperty('cMapPacked'.toJS) as JSBoolean?)?.toDart,
  }..addAll(jsParams);
  final otherParams = _pdfRenderOptions.getProperty('params'.toJS)?.dartify();
  if (otherParams is Map) {
    params.addAll(otherParams.cast<String, dynamic>());
  }
  return params;
}

Future<PdfjsDocument> _pdfjsGetDocumentJsParams(Map<String, dynamic> jsParams) {
  return _pdfjsGetDocument(_getParams(jsParams).jsify()!).promise.toDart;
}

Future<PdfjsDocument> pdfjsGetDocument(String url, {Map<String, dynamic>? headers}) =>
    _pdfjsGetDocumentJsParams({'url': url, 'httpHeaders': headers});

Future<PdfjsDocument> pdfjsGetDocumentFromData(ByteBuffer data) => _pdfjsGetDocumentJsParams({'data': data});

extension type PdfjsDocument._(JSObject _) implements JSObject {
  external JSPromise<PdfjsPage> getPage(int pageNumber);
  external int get numPages;
  external void destroy();
}

extension type PdfjsPage._(JSObject _) implements JSObject {
  external PdfjsViewport getViewport(PdfjsViewportParams params);

  /// `viewport` for [PdfjsViewport] and `transform` for
  external PdfjsRender render(PdfjsRenderContext params);
  external int get pageNumber;
  external List<double> get view;
}

extension type PdfjsViewportParams._(JSObject _) implements JSObject {
  external factory PdfjsViewportParams({
    double scale,
    int rotation, // 0, 90, 180, 270
    double offsetX = 0,
    double offsetY = 0,
    bool dontFlip = false,
  });

  external double get scale;
  external set scale(double scale);
  external int get rotation;
  external set rotation(int rotation);
  external double get offsetX;
  external set offsetX(double offsetX);
  external double get offsetY;
  external set offsetY(double offsetY);
  external bool get dontFlip;
  external set dontFlip(bool dontFlip);
}

@JS('PageViewport')
extension type PdfjsViewport._(JSObject _) implements JSObject {
  external List<double> get viewBox;
  external set viewBox(List<double> viewBox);

  external double get scale;
  external set scale(double scale);

  /// 0, 90, 180, 270
  external int get rotation;
  external set rotation(int rotation);
  external double get offsetX;
  external set offsetX(double offsetX);
  external double get offsetY;
  external set offsetY(double offsetY);
  external bool get dontFlip;
  external set dontFlip(bool dontFlip);

  external double get width;
  external set width(double w);
  external double get height;
  external set height(double h);

  external List<double>? get transform;
  external set transform(List<double>? m);
}

extension type PdfjsRenderContext._(JSObject _) implements JSObject {
  external factory PdfjsRenderContext({
    required CanvasRenderingContext2D canvasContext,
    required PdfjsViewport viewport,
    String intent = 'display',
    bool renderInteractiveForms = false,
    List<double>? transform,
    dynamic imageLayer,
    dynamic canvasFactory,
    dynamic background,
  });

  external CanvasRenderingContext2D get canvasContext;
  external set canvasContext(CanvasRenderingContext2D ctx);
  external PdfjsViewport get viewport;
  external set viewport(PdfjsViewport viewport);
  external String get intent;

  /// `display` or `print`
  external set intent(String intent);
  external bool get renderInteractiveForms;
  external set renderInteractiveForms(bool renderInteractiveForms);
  external List<int>? get transform;
  external set transform(List<int>? transform);
  external dynamic get imageLayer;
  external set imageLayer(dynamic imageLayer);
  external dynamic get canvasFactory;
  external set canvasFactory(dynamic canvasFactory);
  external dynamic get background;
  external set background(dynamic background);
}

extension type PdfjsRender._(JSObject _) implements JSObject {
  external JSPromise get promise;
}
