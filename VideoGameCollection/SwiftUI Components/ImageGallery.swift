//
//  ImageGallery.swift
//  VideoGameCollection
//
//  Created by Jon Iger on 8/13/21.
//

import SwiftUI

struct ImageGallery: View {
    @State private var fullScreenImage: UIImage = UIImage()
    @State private var linkToggle = false
    @Environment(\.horizontalSizeClass) var sizeClass
    let screenCollection: GameScreenshot
    let screenshots: [String:UIImage]
    var body: some View {
        ScrollView(.horizontal, showsIndicators: true){
            HStack{
                ForEach(screenCollection.results, id: \.self){ game in
                    if sizeClass == .regular{
                        //set the width and height of the images to whatever width and height numbers for it where returned from the data
                        NavigationLink {
                            ImageViewer(fullScreenImage: self.fullScreenImage)
                        } label: {
                            Image(uiImage: screenshots[game.image]!)
                                .resizable()
                                .scaledToFit()
                                .frame(width: CGFloat(game.width), height: CGFloat(game.height))
                                .border(Color.blue, width: 5)
                                .padding()
                                .onTapGesture {
                                    fullScreenImage = screenshots[game.image]!
                                }
                        }
                    }
                    else{
                        //set the width and height of the images to whatever width and height numbers for it where returned from the data
                        NavigationLink() {
                            ImageViewer(fullScreenImage: self.fullScreenImage)
                        } label: {
                            Image(uiImage: screenshots[game.image]!)
                                .resizable()
                                .scaledToFit()
                                .frame(width: CGFloat(315), height: CGFloat(250))
                                .border(Color.blue, width: 2)
                                .padding()
                                .onTapGesture {
                                    fullScreenImage = screenshots[game.image]!
                                    linkToggle.toggle()
                                }
                        }
                        .disabled(linkToggle)
                    }
                }
            }
        }
    }
}

struct ImageGallery_Previews: PreviewProvider {
    static var previews: some View {
        ImageGallery(screenCollection: GameScreenshot(), screenshots: [:])
    }
}
