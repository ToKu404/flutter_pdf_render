import 'dart:js_interop';
import 'dart:js_interop_unsafe';
import 'dart:typed_data';
import 'package:web/web.dart' as web;

/// [Uint8] is not defined for Flutter Web. This is just a dummy definition.
class Uint8 {}

/// Works only for [Uint8];
class Pointer<T> {
  final int _address;
  Pointer._(this._address);
  factory Pointer.fromAddress(int address) => Pointer._(address);

  int get address => _address;
  Uint8List get buffer => getBufferByFakeAddress(address);
}

/// Get buffer for Pointer<Uint8>.
extension Uint8Pointer on Pointer<Uint8> {
  Uint8List asTypedList(int length) => buffer;
}

int _fakeAddress = 0;

/// Associate an address with the specified buffer and return the address.
int pinBufferByFakeAddress(Uint8List buffer) {
  web.window.setProperty('pdf_render_buffer_$_fakeAddress'.toJS, buffer.toJS);
  return _fakeAddress++;
}

/// Get the associated buffer for the address.
Uint8List getBufferByFakeAddress(int address) {
  return (web.window.getProperty('pdf_render_buffer_$address'.toJS) as JSUint8Array).toDart;
}

/// Release the associated buffer for the address.
void unpinBufferByFakeAddress(int address) {
  web.window.setProperty('pdf_render_buffer_$address'.toJS, null);
}
