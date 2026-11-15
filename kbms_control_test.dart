// lib/kbms_control_test.dart //

// AI GENERATED CODE BELOW
import 'dart:ffi';

// Bind to the macOS ApplicationServices framework
final DynamicLibrary quartz = DynamicLibrary.open(
  '/System/Library/Frameworks/ApplicationServices.framework/Versions/A/ApplicationServices',
);

// Define the native Core Graphics types and signatures
typedef CGEventCreateMouseEventNative = Pointer Function(
  Pointer,
  Int32,
  Double,
  Double,
  Int32,
);
typedef CGEventCreateMouseEventDart = Pointer Function(
  Pointer,
  int mouseType,
  double x,
  double y,
  int button,
);

typedef CGEventPostNative = Void Function(Int32 tap, Pointer event);
typedef CGEventPostDart = void Function(int tap, Pointer event);
final postEvent = quartz.lookupFunction<CGEventPostNative, CGEventPostDart>(
    'CGEventPost',
  );
void simulateMacClick(double x, double y) {
  final createMouseEvent = quartz
      .lookupFunction<
        CGEventCreateMouseEventNative,
        CGEventCreateMouseEventDart
      >('CGEventCreateMouseEvent');
  

  // 1 = Left Mouse Down, 2 = Left Mouse Up, 0 = kCGHIDEventTap
  Pointer mouseDown = createMouseEvent(nullptr, 1, x, y, 0);
  Pointer mouseUp = createMouseEvent(nullptr, 2, x, y, 0);

  postEvent(0, mouseDown);
  postEvent(0, mouseUp);
}

// END AI GENERATED CODE

// ignore_for_file: camel_case_types
typedef CFunc_CGEventCreateKeyboardEvent = Pointer Function(
  Pointer,
  Int16,
  Bool,
);
typedef DartFunc_CGEventCreateKeyboardEvent = Pointer Function(
  Pointer,
  int,
  bool,
);

// ignore_for_file: constant_identifier_names
enum CGKeyCode {
  kVK_ANSI_A,
  kVK_ANSI_S,
  kVK_ANSI_D,
  kVK_ANSI_F,
  kVK_ANSI_H,
  kVK_ANSI_G,
  kVK_ANSI_Z,
  kVK_ANSI_X,
  kVK_ANSI_C,
  kVK_ANSI_V,
  uk_section_sign,
  kVK_ANSI_B,
  kVK_ANSI_Q,
  kVK_ANSI_W,
  kVK_ANSI_E,
  kVK_ANSI_R,
  kVK_ANSI_Y,
  kVK_ANSI_T,
  kVK_ANSI_1,
  kVK_ANSI_2,
  kVK_ANSI_3,
  kVK_ANSI_4,
  kVK_ANSI_6,
  kVK_ANSI_5,
  kVK_ANSI_Equal,
  kVK_ANSI_9,
  kVK_ANSI_7,
  kVK_ANSI_Minus,
  kVK_ANSI_8,
  kVK_ANSI_0,
  kVK_ANSI_RightBracket,
  kVK_ANSI_O,
  kVK_ANSI_U,
  kVK_ANSI_LeftBracket,
  kVK_ANSI_I,
  kVK_ANSI_P,
  kVK_Return,
  kVK_ANSI_L,
  kVK_ANSI_J,
  kVK_ANSI_Quote,
  kVK_ANSI_K,
  kVK_ANSI_Semicolon,
  kVK_ANSI_Backslash,
  kVK_ANSI_Comma,
  kVK_ANSI_Slash,
  kVK_ANSI_N,
  kVK_ANSI_M,
  kVK_ANSI_Period,
  kVK_Tab,
  kVK_Space,
  kVK_ANSI_Grave,
  kVK_Delete,
  uk34,
  kVK_Escape,
  uk36,
  kVK_Command,
  kVK_Shift,
  kVK_CapsLock,
  kVK_Option,
  kVK_Control,
  kVK_RightShift,
  kVK_RightOption,
  kVK_RightControl,
  kVK_Function,
  kVK_F17,
  kVK_ANSI_KeypadDecimal,
  uk42,
  kVK_ANSI_KeypadMultiply,
  uk44,
  kVK_ANSI_KeypadPlus,
  uk46,
  kVK_ANSI_KeypadClear,
  kVK_VolumeUp,
  kVK_VolumeDown,
  kVK_Mute,
  kVK_ANSI_KeypadDivide,
  kVK_ANSI_KeypadEnter,
  uk4d,
  kVK_ANSI_KeypadMinus,
  kVK_F18,
  kVK_F19,
  kVK_ANSI_KeypadEquals,
  kVK_ANSI_Keypad0,
  kVK_ANSI_Keypad1,
  kVK_ANSI_Keypad2,
  kVK_ANSI_Keypad3,
  kVK_ANSI_Keypad4,
  kVK_ANSI_Keypad5,
  kVK_ANSI_Keypad6,
  kVK_ANSI_Keypad7,
  kVK_F20,
  kVK_ANSI_Keypad8,
  kVK_ANSI_Keypad9,
  uk5d,
  uk5e,
  uk5f,
  kVK_F5,
  kVK_F6,
  kVK_F7,
  kVK_F3,
  kVK_F8,
  kVK_F9,
  uk66,
  kVK_F11,
  uk68,
  kVK_F13,
  kVK_F16,
  kVK_F14,
  uk6c,
  kVK_F10,
  uk6e,
  kVK_F12,
  uk70,
  kVK_F15,
  kVK_Help,
  kVK_Home,
  kVK_PageUp,
  kVK_ForwardDelete,
  kVK_F4,
  kVK_End,
  kVK_F2,
  kVK_PageDown,
  kVK_F1,
  kVK_LeftArrow,
  kVK_RightArrow,
  kVK_DownArrow,
  kVK_UpArrow,
}

void pressKey(CGKeyCode key) {
  postEvent(0, quartz.lookupFunction<
    CFunc_CGEventCreateKeyboardEvent,
    DartFunc_CGEventCreateKeyboardEvent
  >('CGEventCreateKeyboardEvent')(nullptr, CGKeyCode.values.indexOf(key), true));
}

void releaseKey(CGKeyCode key) {
  postEvent(0, quartz.lookupFunction<
    CFunc_CGEventCreateKeyboardEvent,
    DartFunc_CGEventCreateKeyboardEvent
  >('CGEventCreateKeyboardEvent')(nullptr, CGKeyCode.values.indexOf(key), false));
}

// bin/kbms_control_test.dart //

// see the swift version of this file for explanation

import 'package:kbms_control_test/kbms_control_test.dart';

Map<int, CGKeyCode> presses = {
  0: .kVK_ANSI_W,
  110: .kVK_ANSI_D,
  559: .kVK_ANSI_D,
  1610: .kVK_ANSI_D,
  1711: .kVK_ANSI_S,
  2843: .kVK_ANSI_W,
};

Map<int, CGKeyCode> releases = {
  300: .kVK_ANSI_D,
  676: .kVK_ANSI_D,
  1643: .kVK_ANSI_W,
  2726: .kVK_ANSI_S,
  3768: .kVK_ANSI_D,
  3769: .kVK_ANSI_W,
};

void main() async {
  pressKey(.kVK_Control);
  await Future.delayed(Duration(milliseconds: 15));
  pressKey(.kVK_LeftArrow);
  releaseKey(.kVK_Control);
  releaseKey(.kVK_LeftArrow);
  await Future.delayed(Duration(seconds: 1));
  pressKey(.kVK_ANSI_T);
  releaseKey(.kVK_ANSI_T);
  await Future.delayed(Duration(milliseconds: 100));
  Stopwatch stopwatch = Stopwatch()..start();
  for (MapEntry press in presses.entries) {
    Future.delayed(
      Duration(milliseconds: press.key),
      () {
        pressKey(press.value);
        print(stopwatch.elapsedMilliseconds-press.key);
      },
    );
  }
  for (MapEntry release in releases.entries) {
    Future.delayed(
      Duration(milliseconds: release.key),
      () {
        releaseKey(release.value);
        print(stopwatch.elapsedMilliseconds-release.key);
      },
    );
  }
}
