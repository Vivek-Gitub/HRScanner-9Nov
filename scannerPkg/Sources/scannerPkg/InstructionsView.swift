

import SwiftUI

public struct InstructionsView: View {
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @State var isActive = false
    @State var ps_record_timing = 50
    
    
    //MARK: TO MAKE THIS CLASS GLOBAL TO ACCESS THROUGHOUT THE PROJECT
    public init() {}
    
    public var body: some View {
        NavigationView {
            ZStack {
                // MARK: - ==== LANDING PAGE ====
                Color(Colors.appBackGroundColor).expandIgnoringSafeArea()
                VStack {
                    // TITLE
                    Text(StaticText.Landing_title)
                        .font(.system(size: 30))
                        .bold()
                        .foregroundColor(.white)
                        .padding(.top, 50)
                        .multilineTextAlignment(.center)
                    // DESCRIPTION POINTS
                    Group {
                        Text(StaticText.instruction_txt_1)
                            .font(.system(size: 20))
                            .foregroundColor(.white)
                            .padding(EdgeInsets(top: 15, leading: 30, bottom: 10, trailing: 30))
                            .multilineTextAlignment(.center)
                        Text(StaticText.instruction_txt_2)
                            .font(.system(size: 20))
                            .foregroundColor(.white)
                            .padding(EdgeInsets(top: 0, leading: 30, bottom: 10, trailing: 30))
                            .multilineTextAlignment(.center)
                        Text(StaticText.instruction_txt_3)
                            .font(.system(size: 20))
                            .foregroundColor(.white)
                            .padding(EdgeInsets(top: 10, leading: 30, bottom: 10, trailing: 30))
                            .multilineTextAlignment(.center)
                        Text(StaticText.instruction_txt_4)
                            .font(.system(size: 20))
                            .foregroundColor(.white)
                            .padding(EdgeInsets(top: 10, leading: 30, bottom: 10, trailing: 30))
                            .multilineTextAlignment(.center)
                        // NEXT BUTTON
                        Button(action: {
                            self.isActive.toggle()
                            
                        }) {
                            Text(StaticText.Nextbtn_txt)
                                .frame(width: UIScreen.main.bounds.width - 60, height: 55, alignment: .center)
                        }
                        .background(Color.white)
                        .foregroundColor(Color.black)
                        .cornerRadius(25.0)
                        .padding(EdgeInsets(top: 15, leading: 30, bottom: 0, trailing: 30))
                        NavigationLink(destination: CameraReadingView(remainingTime: ps_record_timing, readings: 0, backgroundColor: Colors.appBackGroundColor, disclaimerTitle: StaticText.Disclaimer_title, disclaimerText: StaticText.Disclaimer_txt, instruction: StaticText.Instruction_txt), isActive: $isActive) {
                            EmptyView()
                        }
                    }
                }
            }
        }
        .navigationBarTitle("", displayMode: .inline)
        .navigationBarBackButtonHidden(true)
        .navigationBarHidden(true)
    }
}

struct InstructionsView_Previews: PreviewProvider {
    static var previews: some View {
        InstructionsView()
    }
}
