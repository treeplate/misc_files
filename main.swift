// for a very simple polytrack custom map in theory (just start and end), but there's too much imprecision for this to be consistent

import CoreGraphics

func pressKey(key: CGKeyCode) {
  let event: CGEvent = CGEvent(keyboardEventSource: nil, virtualKey: key, keyDown: true)!
  event.post(tap: CGEventTapLocation.cghidEventTap)
}
func releaseKey(key: CGKeyCode) {
  let event: CGEvent = CGEvent(keyboardEventSource: nil, virtualKey: key, keyDown: false)!
  event.post(tap: CGEventTapLocation.cghidEventTap)
}
Task {
  pressKey(key: 59)
  do {
    try await Task.sleep(nanoseconds: 1_000_000 * 20)
  }
  pressKey(key: 123)
  releaseKey(key: 123)
  releaseKey(key: 59)
  sleep(1)
  pressKey(key: 17)
  releaseKey(key: 17)
  do {
    pressKey(key: 126)
    try await Task.sleep(nanoseconds: 1_000_000 * 100)
    releaseKey(key: 126)
    try await Task.sleep(nanoseconds: 1_000_000 * 200)
    pressKey(key: 126)
  }
}

// left: 123
// right: 124
// down: 125
// up: 126
// ctrl: 59
// T: 17
sleep(5)
releaseKey(key: 126)
