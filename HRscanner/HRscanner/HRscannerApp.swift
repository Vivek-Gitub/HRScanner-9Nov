

import SwiftUI
import scannerPkg

@available(iOS 14.0, *)
@main
struct HRscannerApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
    
    init() {
        deleteSavedDataFile()
    }
}

// Function to delete the file
func deleteSavedDataFile() {
    
    if let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
        let fileURL = documentsDirectory.appendingPathComponent(StaticText.logsJSONFileName)
        // Check if the file exists
        do {
            if FileManager.default.fileExists(atPath: fileURL.path) {
                // Delete the file
                try FileManager.default.removeItem(at: fileURL)
                print("File deleted successfully")
            } else {
                print("File does not exist")
            }
        } catch {
            print("Error deleting file: \(error)")
        }
    }
}
