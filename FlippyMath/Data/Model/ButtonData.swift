//
//  ButtonData.swift
//  FlippyMath
//
//  Created by William Handoko on 17/08/24.
//

import Foundation
import SwiftUI

struct ButtonData: Identifiable {
    let id = UUID()
    let title: String
    let imageName: String
    let destinationView: AnyView
    let isPassed: Bool
    let questionIndex: Int // New field to store the question index
}

