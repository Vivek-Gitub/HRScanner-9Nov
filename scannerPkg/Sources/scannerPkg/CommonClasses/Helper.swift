

import Foundation
import AVFoundation
import SwiftUI

// MARK: - === CAMERA ACCESS PERMISSIONs ===
class Helper: ObservableObject {
    
    static let shared = Helper()
    
    public func requestCameraAccess(isAccessed: @escaping (Bool)->()) {
        AVCaptureDevice.requestAccess(for: .video) { granted in
            DispatchQueue.main.async {
                if granted {
                    isAccessed(true)
                } else {
                    isAccessed(false)
                }
            }
        }
    }
}


// MARK: - === EXTENSION TO SUPPORT METHODS BELOW IOS 14.0 ===
public extension View {
    @ViewBuilder
    func expandIgnoringSafeArea(_ edges: Edge.Set = .all) -> some View {
        if #available(iOS 14, *) {
            self.ignoresSafeArea(edges: edges)
        } else {
            self.edgesIgnoringSafeArea(edges)
        }
    }
}


// MARK: - === EXTENSION TO SUPPORT METHODS BELOW IOS 14.0 ===
public extension View {
    @ViewBuilder func onChangeBackwardsCompatible<T: Equatable>(of value: T, perform completion: @escaping (T) -> Void) -> some View {
        if #available(iOS 14.0, *) {
            self.onChange(of: value, perform: completion)
        } else {
            self.onReceive([value].publisher.first()) { (value) in
                completion(value)
            }
        }
    }
}


public extension View {
    
    // MARK: GET CURRENT DATE TIME
    func getCurrentTimeDate() -> String {
        let currentDate = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss:SSS"
        let formattedDate = dateFormatter.string(from: currentDate)
        return formattedDate
    }
    
    // MARK: GET MILLISECONDS
    func getTimeMilliseconds() -> String {
        let currentDate = Date()
        let currentTimeInMilliseconds = Int(currentDate.timeIntervalSince1970 * 1000)
        return "\(currentTimeInMilliseconds)"
    }
    
}
