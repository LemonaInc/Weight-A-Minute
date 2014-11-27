## Fleksy Keyboard for iOS
![Fleksy Keyboard SDK](http://fleksy.com/2014/wp-content/uploads/2014/02/Git-Banner21.png)

Give your users the choice of an alternative keyboard for the _first time ever_ on iOS!

## Usage
1. Add `Fleksy.framework` to your project, as well as `AudioToolbox.framework` and `QuartzCore.framework`

2. Set the following flags under “Other Linker Flags”: `-lc++` and `-ObjC`

3. Add a custom URL Type under the “Info” tab in your project: `fleksy-YOUR_BUNDLE_ID`

4. (Optional) Mention "Fleksy" in your app description and we'll promote your app on our [website](http://fleksy.com/appswithfleksy/) and in the Fleksy app

**That’s it!** _(no code is required)_

Users can now switch between Fleksy and the iOS keyboard by invoking the Edit menu on any input field (long tap or double tap).

![Fleksy Edit menu switch](http://fleksy.com/2014/wp-content/uploads/2014/02/Fleksy-Keyboard-Switch-04.gif)

## Affiliate setup
Optionally, implement this in your UIApplicationDelegate and return your affiliate ID: `- (NSString *)fleksyAffiliateID;`

## Notes
- If the Fleksy app is not installed, the user will be prompted to install it from the App Store.
- App Store is unavailable under the Simulator, so you should test Fleksy on a device.
- The following is no longer required: UIApplicationDelegate: `- (BOOL) fleksyShouldEnableCustomViewSupport;`
- For more information about affiliates, see the [Apple Affiliate Program](https://www.apple.com/itunes/affiliates/)
- We will feature your app on [our website and inside the Fleksy app](http://fleksy.com/appswithfleksy/) as long as you mention "Fleksy" in your App Store listing. Add "Fleksy" as an App Store keyword to further increase discoverability.

## Questions?
Please see the [Wiki](https://github.com/Fleksy/FleksySDK/wiki) and use the [Issues](https://github.com/Fleksy/FleksySDK/issues) page for making feature requests and reporting issues.

## _Happy Typing!_
![Fleksy SDK Keyboard Specs](http://fleksy.com/2014/wp-content/uploads/2014/02/Github-Banner-Footer.png)
©2013-2014 Fleksy, v1.0
©2013-2014 Fleksy, v1.1
©2013-2014 Fleksy, v2.0
©2013-2014 Fleksy, v3.0
