//
//  LoadingIndicator.swift
//  VideoGameCollection
//
//  Created by Jonathon Lannon on 7/18/21.
//

import UIKit
import SwiftUI

/**
 UIKit view that displays an activity indicator to the user when called
 */
struct ActivityIndicator: UIViewRepresentable {
    @Binding var shouldAnimate: Bool
    func makeUIView(context: Context) -> UIActivityIndicatorView {
        return UIActivityIndicatorView()
    }
    
    func updateUIView(_ uiView: UIActivityIndicatorView, context: Context) {
        //start animating when the parameter received is true, stop animating otherwise
        if self.shouldAnimate {
            uiView.startAnimating()
        }
        else {
            uiView.stopAnimating()
        }
    }
}
