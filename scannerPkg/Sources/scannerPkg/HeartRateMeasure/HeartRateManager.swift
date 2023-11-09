

import Foundation
import AVFoundation


struct VideoSpec {
    var fps: Int32?
}

typealias ImageBufferHandler = ((_ imageBuffer: CMSampleBuffer) -> ())

class HeartRateManager: NSObject {
    
    private let captureSession = AVCaptureSession()
    private var videoDevice: AVCaptureDevice!
    private var videoConnection: AVCaptureConnection!
    
    @Published var cameraAccessDenied = false
    var imageBufferHandler: ImageBufferHandler?
    
    init(preferredSpec: VideoSpec?) {
        super.init()
        // MARK: - Setup Video Format
        do {
            captureSession.sessionPreset = .low
        }
        self.configureCaptureSession()
    }
    
    //MARK: *** Camera Capture Session ***
     func configureCaptureSession() {
         
         if let device = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back) {
             videoDevice = device
         } else if let device = AVCaptureDevice.default(.builtInUltraWideCamera, for: .video, position: .back) {
             videoDevice = device
         } else if let device = AVCaptureDevice.default(.builtInTelephotoCamera, for: .video, position: .back) {
             videoDevice = device
         }
        do {
            let input = try AVCaptureDeviceInput(device: videoDevice)
            captureSession.addInput(input)
            let output = AVCaptureVideoDataOutput()
            output.setSampleBufferDelegate(self, queue: DispatchQueue.global(qos: .background))
            captureSession.addOutput(output)
            
            //MARK: - Configure ISO, white balance, and focus settings
//            configureISOSettings(device: videoDevice)
//            configureWhiteBalanceSettings(device: videoDevice)
            configureFocusSettings(device: videoDevice)
            
            DispatchQueue.global(qos: .background).async { [weak self] in
                self?.captureSession.startRunning()
            }
        } catch {
            print("Error setting up camera: \(error.localizedDescription)")
        }
    }
    
    func startCapture() {
        if captureSession.isRunning {
            print("Capture Session is already running 🏃‍♂️.")
            return
        }
        captureSession.startRunning()
    }
    
    func stopCapture() {
        if !captureSession.isRunning {
            print("Capture Session has already stopped 🛑.")
            return
        }
        captureSession.stopRunning()
    }
    
    //MARK: Set ISO settings here
    func configureISOSettings(device: AVCaptureDevice) {
        do {
            if device.isExposureModeSupported(.custom) {
                
                try device.lockForConfiguration()
                device.exposureMode = .continuousAutoExposure
                device.whiteBalanceMode = .locked
                device.unlockForConfiguration()
            }

        } catch(let error) {
            print("Error setting ISO settings: \(error.localizedDescription)")
        }
    }
    
    // MARK: - Configure White Balance Settings (This can be helpful in scenarios where the lighting conditions may vary )
    func configureWhiteBalanceSettings(device: AVCaptureDevice) {
        do {
            if device.isWhiteBalanceModeSupported(.continuousAutoWhiteBalance) {
                try device.lockForConfiguration()
                device.whiteBalanceMode = .continuousAutoWhiteBalance
                device.unlockForConfiguration()
            }
        } catch(let error) {
            print("Error setting white balance settings: \(error.localizedDescription)")
        }
    }
    
    // MARK: - Configure Focus Settings (It ensure the camera maintains a stable focus on the user's finger)
    func configureFocusSettings(device: AVCaptureDevice) {
        do {
            try device.lockForConfiguration()
            device.focusMode = .continuousAutoFocus  // useful when the user's finger or the camera itself is in motion.
            device.focusPointOfInterest = CGPoint(x: 0.5, y: 0.5)  // (x: 0.5, y: 0.5) -> central area of the captured image
            device.focusMode = .locked
            device.unlockForConfiguration()
        } catch (let error) {
            print("Error setting focus settings: \(error.localizedDescription)")
        }
    }
}

extension HeartRateManager: AVCaptureVideoDataOutputSampleBufferDelegate {
    
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        
        if connection.videoOrientation != .portrait {
            connection.videoOrientation = .portrait
            return
        }
//        if let imageBufferHandler = imageBufferHandler {
//            imageBufferHandler(sampleBuffer)
//        }
    }
}
