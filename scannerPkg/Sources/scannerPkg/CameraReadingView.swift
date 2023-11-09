

import SwiftUI


public struct CameraReadingView: View  {
    
    @StateObject private var model = CameraReadingModel()
    @State private var pulseValueCountArray: [PulseValueCount] = []
    
    @State private var timer: Timer? = nil
    @State private var remainingTime = 60
    var readings : Int
    var backgroundColor : UIColor
    var disclaimerTitle : String
    var disclaimerText : String
    var instruction : String
    @State var isActive = false
    @State private var sumHeartRate = 0
    
//    @State var averageHeartRate: String = ""
    @State var finalHeartRate: String = ""
    
    private var timeDuration: Int
    @State private var backBtn: Bool = false
    @State private var count: Int = 0
    @State private var isCameraAppear: Bool = false
    
    // For heart beat impact
    let impactFeddBack = UIImpactFeedbackGenerator(style: .heavy)
    @State var trimValue1 : CGFloat = 0
    @State var trimValue2 : CGFloat = 0
    
    @State private var position: CGFloat = 0
    
    public init(remainingTime: Int, readings: Int, backgroundColor: UIColor, disclaimerTitle: String, disclaimerText: String, instruction: String) {
        self.remainingTime = remainingTime
        self.readings = readings
        self.backgroundColor = backgroundColor
        self.disclaimerTitle = disclaimerTitle
        self.disclaimerText = disclaimerText
        self.instruction = instruction
        
        self.timeDuration = remainingTime
        
        impactFeddBack.prepare()
    }
    
    public var body: some View {
        NavigationView{
            ZStack{
                Color(Colors.appBackGroundColor).expandIgnoringSafeArea()
                // MARK: *** Disclaimer Text ***
                VStack{
                    
                    Text(StaticText.Disclaimer_title)
                        .font(.system(size: 26))
                        .foregroundColor(.white)
                        .padding(.top,20)
                        
                    Text(StaticText.Disclaimer_txt)
                        .font(.system(size: 20))
                        .foregroundColor(.white)
                        .padding(EdgeInsets(top: 5, leading: 30, bottom: 0, trailing: 30))
                        .multilineTextAlignment(.center)
                    // MARK: *** Timer Text ***
                    Text(formattedTime)
                        .font(.largeTitle)
                        .frame(maxWidth: .infinity,alignment: .trailing)
                        .foregroundColor(.white)
                        .padding(EdgeInsets(top: 15, leading: 0, bottom: 0, trailing: 30))
                    
                    // MARK: *** Circular Camera ***
                    ZStack(alignment: .top) {
                        FrameView(image: model.frame)
                            .frame(width: 280,height: 280)
                            .clipShape(Circle())
                            .padding(.top,45)
                            .onAppear {
                                isCameraAppear.toggle()
                            }
                            .onDisappear {
                                model.pulseTitle = StaticText.PlaceYourFinger
                                isCameraAppear.toggle()
                            }
                        if isCameraAppear {
                            VStack {
                                Text(model.pulseTitle)
                                    .foregroundColor(.white)
                                    .font(.system(size: 18))
                                    .padding(.top,100)
                                
                                Text(model.pulselabel)
                                    .font(.system(size: 60))
                                    .bold()
                                    .foregroundColor(.white)
                                    .padding(.top, 35)
                                    .onReceive(model.pulselabel.publisher) { newValue in
                                        
                                        if model.isFingerPlaced && model.isTimeStarted {
                                           
                                            print("pulsle \(model.pulselabel)")
                                            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                                                
                                                count += 1
//                                                sumHeartRate += Int(model.pulselabel) ?? 0
                                                
                                                
                                                pulseValueCountArray.append(PulseValueCount(dateAndTime: getCurrentTimeDate(), pulseValue: Int(model.pulselabel) ?? 0, timeStamp: getTimeMilliseconds(), peakPoint: model.rrIntervalValue, count: count))
                                            }
 
                                        }
                                    }
                            }
                        }
                    }
                    
                    VStack{
                        //MARK: *** Pushed to Phone camera settings ***
                        if model.showAlert == model.showAlert {
                            if #available(iOS 15.0, *) {
                                Text("")
                                    .alert(StaticText.Alert_txt, isPresented: $model.showAlert) {
                                        Button(StaticText.Alertbtn_txt) {
                                            if let url = URL(string: UIApplication.openSettingsURLString) {
                                                if UIApplication.shared.canOpenURL(url) {
                                                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
                                                }
                                            }
                                        }
                                    }
                            }
                        }
                        NavigationLink(destination: ShowMeasurementView(finalHeartRate: finalHeartRate, backBtn: $backBtn, pulseValueCountArray: pulseValueCountArray), isActive: $isActive) {
                            EmptyView()
                        }
                    }
                    
                    if (model.isFingerPlaced && model.isTimeStarted) {
                        ZStack {
                            HeartBeat()
                                    .stroke(lineWidth: 4)
                                    .foregroundColor(Color.black.opacity(0.1))
                            
                            HeartBeat()
                                    .trim(from: trimValue1, to: trimValue2)
                                    .stroke(lineWidth: 4)
                                    .foregroundColor(.white)
                                    .background(
                                        Text(model.rrIntervalValue)
                                            .fontWeight(.bold)
                                            .foregroundColor(Color.red).opacity(0.7)
                                            .offset(x: 75,y: -25)
                                    )
                            

                        }
                        .onAppear {
                            
                            if trimValue1 == 0.0 && trimValue2 == 0.0{
                                withAnimation(Animation.easeInOut(duration: 2.0).repeatForever(autoreverses: false), {
                                    trimValue1 = 0.0
                                    trimValue2 = 1.0
                                })
                            } else {
                                trimValue1 = 0.0
                                trimValue2 = 0.0
                            }
                            
                           
                            
                        }
                    }
                    
                    Spacer()
                    // MARK: *** Instruction Text ***
                    VStack{
                        Text(StaticText.Instruction_txt)
                            .multilineTextAlignment(.center)
                            .padding(EdgeInsets(top: 0, leading: 30, bottom: 20, trailing: 30))
                            .font(.system(size: 20))
                            .foregroundColor(.white)
                    }
                }
            }
            .onDisappear(perform: {
                model.timer.invalidate()
            })
            .onAppear {
                print(model.measurementStartedFlag)
                
                if isActive {
                    model.pulselabel = ""
                    model.heartRateConfigure()
                    remainingTime = timeDuration
                    if model.measurementStartedFlag && timer == nil {
                        restartTimer()
                    }
                }
            }
        }
        .navigationBarTitle("", displayMode: .inline)
            .navigationBarBackButtonHidden(true)
            .navigationBarHidden(true)
            .onChangeBackwardsCompatible(of: model.measurementStartedFlag && model.isStartedCapturingPulseRate, perform: { startedFlag in
                if startedFlag && timer == nil {
                    startTimer()
                }
            })
    }
}


struct CameraReadingView_Previews: PreviewProvider {
    static var previews: some View {
        CameraReadingView(remainingTime: 60, readings: 0, backgroundColor: Colors.appBackGroundColor, disclaimerTitle: StaticText.Disclaimer_title, disclaimerText: StaticText.Disclaimer_txt, instruction: StaticText.Instruction_txt)
    }
}


extension CameraReadingView {
    
    var formattedTime: String {
        let seconds = remainingTime % 60
        return String(format: ":%02d", seconds)
    }
    
    // MARK: *** Starting Timer ***
    func startTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
            if remainingTime > 0 {
                if model.isFingerPlaced {
                    model.isTimeStarted = true
                    
                    // for heart rate sound
//                    impactFeddBack.impactOccurred(intensity: 1.0)
//                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
//                        impactFeddBack.impactOccurred(intensity: 0.8)
//                    }
                    
                    
//                    if let pulseValue = Int(model.pulselabel) {
//                        if remainingTime % 5 == 0{
//                            sumHeartRate += pulseValue
////                            count += 1
////                            pulseValueCountArray.append(PulseValueCount(dateAndTime: getCurrentTimeDate(), pulseValue: pulseValue, timeStamp: getTimeMilliseconds(), peakPoint: model.rrIntervalValue, count: count))
//
//                        }
//
//                    }
                    remainingTime -= 1
                } else {
                    self.timer?.invalidate()
                    self.timer = nil
                }
            } else {
                
                print("sum data \(sumHeartRate) and total count \(count)")
//                self.averageHeartRate = "\(sumHeartRate / count)"
                self.finalHeartRate = model.pulselabel
                self.timer?.invalidate()
                timer = nil
                model.stopRunningCapture()
                sumHeartRate = 0
                count = 0
                self.isActive.toggle()
            }
        }
     

    }
    
    func restartTimer() {
        remainingTime = timeDuration
        startTimer()
    }
    
}

struct HeartBeat : Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: rect.minX, y: rect.midY))
        path.addLine(to: CGPoint(x: rect.midX-20, y: rect.midY))
        path.addLine(to: CGPoint(x: rect.midX, y: (rect.midY+rect.maxY)/2))
        path.addLine(to: CGPoint(x: rect.midX+10, y: rect.midY))
        path.addLine(to: CGPoint(x: rect.midX+20, y: (rect.midY/2)))
        path.addLine(to: CGPoint(x: rect.midX+40, y: rect.midY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.midY))
        return path
    }
}
