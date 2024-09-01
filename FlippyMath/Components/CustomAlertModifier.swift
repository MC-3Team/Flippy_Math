//
//  CustomAlertModifier.swift
//  FlippyMath
//
//  Created by Enrico Maricar on 01/09/24.
//

import Foundation
import SwiftUI

struct CustomAlertModifier: ViewModifier {
    @Binding var isPresented: Bool
    let alertContent: () -> CustomAlertView
    
    func body(content: Content) -> some View {
        ZStack {
            content
                .blur(radius: isPresented ? 2 : 0)
                .animation(.easeInOut, value: isPresented)
            
            if isPresented {
                alertContent()
                    .frame(width: 300, height: 200)
                    .transition(.scale)
                    .animation(.easeInOut, value: isPresented)
            }
        }
    }
}
