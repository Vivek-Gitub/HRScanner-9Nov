

import SwiftUI

struct FrameView: View {
    
    var image: CGImage?
    private let label = Text("")
    
    var body: some View {
        if let image = image {
            GeometryReader { geometry in
                Image(image, scale: 1.0, orientation: .upMirrored, label: label)
                    .resizable()
                    .scaledToFill()
                    .overlay(Circle().stroke(Color.white, lineWidth: 10))
                    .shadow(radius: 10)
                    .frame(
                        width: geometry.size.width,
                        height: geometry.size.height,
                        alignment: .center)
                    .clipped()
            }
        } else {
            EmptyView()
        }
    }
}

struct FrameView_Previews: PreviewProvider {
    static var previews: some View {
        FrameView()
    }
}
