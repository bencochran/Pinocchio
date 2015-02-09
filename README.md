Pinocchio
=========

[![Pinocchio](http://bencochran.com/picdrop/PinocchioDancing.gif)](https://www.youtube.com/watch?v=iAykOz1gWi4)

A spiritual successor to [CompactConstraint](http://github.com/marcoarment/CompactConstraint), but without the strings. Pinocchio aims to be a thin wrapper around creating constraints and not much more.

**Note: This is mostly a proof of concept at this point. I’ll probably develop this into something real as time passes, but for now I wouldn’t ship anything based on this.**

# Syntax

The syntax almost exactly matches CompactConstraint, except without those peskt `"`s. (Also the operators for priority and identifier are different)

```swift
view.addConstraints([
    label.centerX == view.centerX,
    label.centerY == view.centerY,
    label.leading >= view.leading + 16,
    label.trailing <= view.trailing - 16,
    label.top >= view.top + 16,
    label.bottom <= view.bottom - 16,
    label.height == 50 % 750 • "Suggested height"
])
```

Top and bottom layout guides are there too:

```swift
view.addConstraints([
    header.top > viewController.topLayoutGuideTop,
])
```

It’s even smart enough to not let you make invalid constraints. The following won’t compile:

```swift
var invalidConstraints = [
    label.centerX == 100,
    view.baseline == 90
]
```
