v3.0.1:

- Removes deprecated API call 

v3.0: Requires UPDATED version of Fleksy app 3.3, link included in README.

- More languages supported
- Autocorrection now includes space breaking and missed letter prediction
- Bug fixes

v2.0.2: Requires UPDATED version of Fleksy app, link included in README.

- Improve handling of left shiftKey.
- Bug fixes

v2.0: Requires UPDATED version of Fleksy app, link included in README.

- More languages supported
- UIWebView support
- Auto-correction setting
- Fast Delete settings
- Dictionary words learned, forgotten. persisted and shared among Fleksy-enabled apps
- iOS7.1 tested
- Tutorial progress from one Fleksy-enabled app is passed to another.
- Fleksy-enabled app keyboard always follows Spacebar Row and Invisble Keyboard settings from server. 
- Bug fixes and performance improvements  

v1.1:

- Support for UIAlertView
- Delegate callback to Return key press is fixed
- Linker flag issues fixed
- Fleksy unsupported alert message included for iOS Simulator
- Explicit prompt for users to install Fleksy from App Store
- Other bug fixes

v1.0:

- Improved support for custom views (see README for callback message)
- Resolved edit menu item issues (not appearing, ordering of existing items)
- Delegate callbacks follow iOS keyboard behavior
- Improved secure field entry
- Removed libz.dylib dependency
- UI tweaks and other bugfixes
 
v0.9:
 
- Faster initialization
- Does not use NSUserDefaults
- Presents default iOS keypad for numeric entries
- Respects programmatic setting of the text property in UITextFields
- UI tweaks and other bugfixes

v0.8.1: 

- Now works with latest App Store Fleksy app, and should be tested against that
- Programmatically changing selectedRange now works for UITextViews
- Language switching no longer requires app restart
- Support for dynamic removal of UIResponder elements
- Tutorial-like animations
- Affiliate ID support
- Other bugfixes


v0.8: Requires **UPDATED** version of Fleksy app, link included in README.

- Eliminated warnings
- 64-bit support (both arm64 and x86_64 slices)
- Respect other .inputViews
- Respect delegates
- Move cursor programmatically works
- Stability improvements
- Support for responders on different UIWindows
- UI tweaks and other bugfixes
