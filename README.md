![logo](/Demo/logo.png)
# Weatherly

*Weather time machine. Travel through past, present and future weather conditions and have fun!*

![platform](https://img.shields.io/badge/platform-iOS-green.svg)
![swift](https://img.shields.io/badge/swift-5.0-brightgreen.svg)
![xcode](https://img.shields.io/badge/xcode-10.3-orange.svg)

## How it looks like
![logo](/Demo/animation.gif)

## What for
It's for me to practise Swift.
Check current, past and future weather for different locations.

## What new I've learned

- Get data from DarkSky API using SwiftSky library
- UITableView and custom cells
- Custom cell design with custom .xib
- UIDatePickerView
- CoreLocation
- CoreData
- DateFormatter
- NotificationCenter
- Swift Package Manager

## To-do

- [x] Get and present current weather data from DarkSkyAPI
- [x] Get and present future weather forecast
- [x] Get and present past weather forecast and allow user to choose date
- [x] Get and present hourly forecast on Now view controller
- [x] UI color inverse based on time of the day
- [x] Let user choose location manually
- [x] Persist user favorite locations
- [ ] Replace "Change UI colors based on daytime" with native iOS 13 darkmode
- [ ] Use of MVC and SOLID design patterns
- [ ] Tailor UI and UX
- [ ] Unit Tests

## Api key

In order to run this app create Secret.plist file with text as in an example and put it in Secrets folder.

Replace XXX with your api-key. You can get free DarkSky api-key here: *[DarkSky](https://darksky.net/dev)*

```
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>apiKey</key>
    <string>XXX</string>
</dict>
</plist>
```

## Requirements

- Xcode 11 with iOS SDK (13.1)
- Swift Package Manager
- ~~CocoaPods 1.7.5 or higher~~

## Credits
- *[DarkSky](https://darksky.net/dev)*
- *[Alamofire](https://github.com/Alamofire/Alamofire)*
- *[SwiftSky](https://github.com/appcompany/SwiftSky)*
- *[JGProgressHUD](https://github.com/JonasGessner/JGProgressHUD)*
- *[~~SVProgressHUD~~](https://github.com/SVProgressHUD/SVProgressHUD)*


## Who is who
Marek Skrzelowski, mskrzelowski@vandermesis.com

*.swift learning month four*
