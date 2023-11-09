
import SwiftUI
import UIKit

struct ShowMeasurementView: View {
    
    @Environment(\.presentationMode) var presentationMode
    
//    var averageHeartRate: String
    var finalHeartRate: String
    
    var pulseValueCountArray: [PulseValueCount]
    @State private var isSaveSuccess = false
    @Binding private var backBtn: Bool
//    @State private var isSharing = false
    @State private var isShareBtnHide:Bool = true
    @State private var sharedFileURL: URL?
    
    
    
    init(finalHeartRate: String, backBtn: Binding<Bool>, pulseValueCountArray: [PulseValueCount]) {
        
        let appearance = UINavigationBarAppearance()
        appearance.titleTextAttributes = [.foregroundColor: UIColor.white]
        UINavigationBar.appearance().standardAppearance = appearance
        
//        self.averageHeartRate = averageHeartRate
        self.finalHeartRate = finalHeartRate
        self._backBtn = backBtn
        self.pulseValueCountArray = pulseValueCountArray
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                Color(Colors.appBackGroundColor).expandIgnoringSafeArea()
                VStack {
                    VStack(spacing: 0) {
                        Text(StaticText.output_Title)
                            .font(.system(size: 26))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity,alignment: .leading)
                            .padding(EdgeInsets(top: 22, leading: 22, bottom: 5, trailing: 0))
                        Text(finalHeartRate)
                            .foregroundColor(Color.white)
                            .font(.system(size: 100))
                            .padding(.vertical, 10)
                        Text(StaticText.beats_txt)
                            .foregroundColor(Color.white).opacity(0.6)
                            .font(.system(size: 20))
                            .padding(.bottom, 22)
                    }
                    .overlay(
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(Color.white, lineWidth: 2)
                    )
                    .frame(maxWidth: .infinity,alignment: .top)
                    .padding(.horizontal, 30)
                    Text(StaticText.Output_DisclaimerTxt)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 25)
                        .foregroundColor(Color.white)
                        .font(.system(size: 18))
                        .opacity(0.6)
                        .padding(.top, 30)
                    HStack {
                        Button {
                            savePulseValue(pulseValueCountArray: pulseValueCountArray)
                            isShareBtnHide = false
                           
                        } label: {
                            Text(StaticText.saveLogBtnName)
                                .frame(width: 140, height: 50)
                                .foregroundColor(Color(Colors.appBackGroundColor))
                                .font(.system(size: 18, weight: .bold))
                                .background(Color.white)
                                .cornerRadius(10)
                                .padding(.top, 20)
                        }
                        if(!isShareBtnHide) {
                            Button {
//                                isSharing.toggle()
                                // If you want to show share option like other app . comment  the sheet for that
                                if let fileURL = sharedFileURL {
                                    let av = UIActivityViewController(activityItems: [fileURL], applicationActivities: nil)
                                    UIApplication.shared.windows.first?.rootViewController?.present(av, animated: true, completion: nil)
                                }
                                
                            } label: {
                                Text(StaticText.shareBtnName)
                                    .frame(width: 140, height: 50)
                                    .foregroundColor(Color(Colors.appBackGroundColor))
                                    .font(.system(size: 18, weight: .bold))
                                    .background(Color.white)
                                    .cornerRadius(10)
                                    .padding(.top, 20)
                            }
                        }
                    }.padding(.top, 20)
                    Spacer()
                }.padding(.top, 130)
            }
            
        }.navigationBarTitle(
            Text(StaticText.output_navTitle),
            displayMode: .inline
        ).navigationBarItems(leading: Button(action: {
            self.backBtn.toggle()
            self.presentationMode.wrappedValue.dismiss()
        }, label: {
            Image(systemName: "arrow.backward.square")
                .resizable()
                .scaledToFit()
                .foregroundColor(Color.white)
                .frame(width: 60,height: 30)
        })
        )
        .navigationBarBackButtonHidden(true)
        .alert(isPresented: $isSaveSuccess) {
            Alert(
                title: Text(StaticText.Success),
                message: Text(StaticText.saveLogMessage),
                dismissButton: .default(Text(StaticText.OK))
            )
        }
//        .sheet(isPresented: $isSharing) {
//            ShareSheetView(fileURL: sharedFileURL)
//        }
    }
}


struct ShowMeasurementView_Previews: PreviewProvider {
    static var previews: some View {
        ShowMeasurementView(finalHeartRate: "79", backBtn: .constant(false), pulseValueCountArray: [PulseValueCount(dateAndTime: "6", pulseValue: 80, timeStamp: "34556",  peakPoint: "4.552 ", count: 0)])
    }
}


extension ShowMeasurementView {
    
    //MARK: Saving the JSON file only within your app's sandboxed document directory
    func savePulseValue(pulseValueCountArray: [PulseValueCount]) {
        
        let jsonEncoder = JSONEncoder()
        do {
            let jsonData = try jsonEncoder.encode(pulseValueCountArray)
            if let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
                let fileURL = documentsDirectory.appendingPathComponent(StaticText.logsJSONFileName)
                do {
                    // Append new data in the file
                    if FileManager.default.fileExists(atPath: fileURL.path) {
                        try jsonData.write(to: fileURL)
                        print("file exist and data is saved")
                    } else {
                        do {
                            // Create a new file if it doesn't exist
                            try jsonData.write(to: fileURL, options: .atomicWrite)
                            print("Data written to a new file.")
                        } catch {
                            print("Error writing to the file: \(error)")
                        }
                    }
                    
                    print("Pulse data saved to \(fileURL)")
                    isSaveSuccess = true
                    sharedFileURL = fileURL
                } catch (let error) {
                    print("Error writing to file: \(error)")
                }
            }
        } catch (let error) {
            print("Error encoding data to JSON: \(error)")
        }
    }
    
    
    // Function to print values from the JSON file to the console
    func printValuesFromJSONFile() {
        if let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
            let fileURL = documentsDirectory.appendingPathComponent(StaticText.logsJSONFileName)
            do {
                let jsonData = try Data(contentsOf: fileURL)
                let decoder = JSONDecoder()
                let pulseValueCountArray = try decoder.decode([PulseValueCount].self, from: jsonData)
                // Print the values to the console
                for pulseValueCount in pulseValueCountArray {
                    print("Pulse Value: \(pulseValueCount.pulseValue), Count: \(pulseValueCount.count)")
                }
            } catch {
                print("Error reading from or decoding the JSON file: \(error)")
            }
        }
    }
    
}


struct ShareSheetView: UIViewControllerRepresentable {
    
    var fileURL: URL?
    var applicationActivities: [UIActivity]? = nil

    func makeUIViewController(context: Context) -> UIActivityViewController {
        if let fileURL = fileURL {
            return UIActivityViewController(activityItems: [fileURL], applicationActivities: applicationActivities)
        } else {
            return UIActivityViewController(activityItems: [], applicationActivities: nil)
        }
    }

    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {
        // NOTHING TO DO
    }
    
}
