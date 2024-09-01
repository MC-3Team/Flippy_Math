//
//  Extension.swift
//  FlippyMath
//
//  Created by Enrico Maricar on 01/09/24.
//

import Foundation
import SwiftUI

extension View {
    func customAlert(isPresented: Binding<Bool>, alertContent: @escaping () -> CustomAlertView) -> some View {
        self.modifier(CustomAlertModifier(isPresented: isPresented, alertContent: alertContent))
    }
}

