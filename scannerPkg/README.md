# scannerPkg

HeartRatePkg is the library for measuring Heart Rate and can be installed your new or existing project using Swift Package Manager. It requires mobile device back camera to measure heart rate. Additionally, it is designed in SwiftUI.


![swift v5.3](https://img.shields.io/badge/swift-v5.3-orange.svg)
![platform iOS](https://img.shields.io/badge/platform-iOS-blue.svg)
![deployment target iOS 13](https://img.shields.io/badge/deployment%20target-iOS%2013-blueviolet)
[![SwiftPM compatible](https://img.shields.io/badge/SwiftPM-compatible-brightgreen.svg)](https://swift.org/package-manager/)


## Installation
### Swift Package Manager
Using <a href="https://swift.org/package-manager/" rel="nofollow">Swift Package Manager</a>, add it as a Swift Package in Xcode 14.0 or later, `select File > Add Packages` and add the repository URL:
```
https://github.com/Bvoy-life/hrScanner.git
```

### Requirements
- iOS 13.0+
- Swift 5.3+
- Xcode 14.0+

## Import

Import `scannerPkg` into your `View`

```
import scannerPkg
```

## How to Use

- Step 1: Using Notification Observer, you need to define method in any of your class wherein add notification and add its action method to record measuring heart rate. Below is the code:

``` 
    func notificationObserver() {
        NotificationCenter.default.addObserver(forName: Notification.Name.ReadHeartRate, object: nil, queue: nil, using: getReadings(_:))
    }
    
    func getReadings(_ notification: Notification) {
        if let notificationData = notification.object as? Double {
            // USE READING IN YOUR CODE
            print("ACTUAL READING :> \(notificationData)")
        }
    }
```


- Step 2: Call 'initiateHRMeasuring()' method to start/initiate measurement of Heart Rate.
- Step 3: Also call 'notificationObserver()' method defined in step 1, below is the code:

```
    // CALL BELOW METHOD IS START MEASUREMENT
    self.initiateHRMeasuring()
    self.notificationObserver()
```



## Demo project

For a comprehensive Demo project check out: 
<Need to add a demo project>


