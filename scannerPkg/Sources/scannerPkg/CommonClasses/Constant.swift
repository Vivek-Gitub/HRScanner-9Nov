

import Foundation
import SwiftUI

public struct Colors {
    public static let appBackGroundColor = UIColor(red: 44.0/255.0, green:  69.0/255.0, blue:  91.0/255.0, alpha: 1.0)
}

public struct StaticText {
    public static let Disclaimer_title = "Disclaimer"
    public static let Disclaimer_txt = "This is not a medical device and only indicative in nature."
    
    public static let Instruction_txt = "Place finger on the camera until it covers the window."
    public static let instruction_txt_1 = "1. Avoid testing in high light variations surroundings."
    public static let instruction_txt_2 = "2. Cover camera and flashlight with your index finger."
    public static let instruction_txt_3 = "3. Keep your finger from moving around (to avoid making the camera refocus)."
    public static let instruction_txt_4 = "4. Press only very lightly to properly cover the camera (if you press too hard you will reduce the blood flow and it will be impossible to read the pulse)."
    
    public static let Pulse_txt = "Detecting Pulse"
    public static let Alert_txt = "Need camera access permission to continue."
    public static let Alertbtn_txt = "Settings"
    public static let Landing_title = "How to use HRScanner"
    public static let Landing_txt = "Cover the back camera and flashlight with your forefinger."
    public static let Nextbtn_txt = "Next"
    
    public static let output_Title = "Heart Rate"
    public static let output_navTitle = "Your Result"
    public static let Output_DisclaimerTxt = "For information purpose only. Consult your local medical authority for advice."
    public static let beats_txt = "beats per minute"
    public static let saveLogBtnName = "Save HR logs"
    public static let saveLogMessage = "Heart Rate logs saved successfully."
    public static let Success = "Success"
    public static let OK = "OK"
    public static let logsJSONFileName = "HRLogFile.json"
    public static let shareBtnName = "Share"
    public static let PlaceYourFinger = "Place your finger"
    public static let DetectingPulse = "Detecting Pulse"
    public static let Measuring = "Measuring"
}

struct PulseValueCount: Codable {
    var dateAndTime: String
    var pulseValue: Int
    var timeStamp: String
    let peakPoint: String
    var count: Int
}


// Create a structure to hold RR intervals and timestamps
//struct RRIntervalData {
//    let peakPoint: String
//    let timestamp: String // Timestamp in milliseconds
//}

extension Notification.Name {
    static let ReadHeartRate = Notification.Name("ReadHeartRate")
}
