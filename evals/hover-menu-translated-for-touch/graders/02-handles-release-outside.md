---
type: llm
---

PASS if the code handles the case where the finger or pointer is released outside the button: the pressed or lit state is reset and the menu action does not fire. Any AS2 mechanism counts, for example `onReleaseOutside`, `onDragOut`, or a Mouse listener that checks `hitTest` on mouse up.
FAIL if a press that ends outside the button still triggers the action, or leaves the button stuck in its pressed or lit state, or if the reply never addresses releasing outside.
