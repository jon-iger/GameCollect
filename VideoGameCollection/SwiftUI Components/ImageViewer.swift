//
//  ImageViewer.swift
//  VideoGameCollection
//
//  Created by Jonathon Lannon on 8/13/21.
//

import SwiftUI

struct ImageViewer: View {
    let fullScreenImage: UIImage
    @State private var lastScaleValue: CGFloat = 1.0
    @State private var offset = CGSize.zero
    var body: some View {
        // a drag gesture that updates offset and isDragging as it moves around
        let dragGesture = DragGesture()
            .onChanged { value in self.offset = value.translation; print("Being dragged") }
            .onEnded { _ in
                withAnimation {
                    self.offset = .zero
                }
            }
        let pressGesture = LongPressGesture()
            .onChanged{ action in
                withAnimation{
                    print("Pressing...")
                }
            }
            .onEnded { value in
                withAnimation {
                    print("Long press")
                }
            }
        VStack{
            Image(uiImage: fullScreenImage)
                .resizable()
                .scaledToFit()
                .scaleEffect(lastScaleValue)
                .offset(offset)
                .onTapGesture {
                    withAnimation{
                        //showImageFullScreen = false
                    }
                }
                .gesture(MagnificationGesture()
                            .onChanged{ value in
                                withAnimation{
                                }
                                self.lastScaleValue = value.magnitude
                            }
                            .onEnded{ value in
                                withAnimation{
                                    self.lastScaleValue = 1.0
                                }
                            }
                )
                .gesture(pressGesture.sequenced(before: dragGesture))
        }
    }
}

struct ImageViewer_Previews: PreviewProvider {
    static var previews: some View {
        ImageViewer(fullScreenImage: UIImage())
    }
}
