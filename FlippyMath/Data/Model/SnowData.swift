//
//  SnowData.swift
//  BambiniMath
//
//  Created by William Handoko on 17/08/24.
//

import Foundation

struct Snowflake: Identifiable {
    let id = UUID()
    let xPosition: CGFloat
    let duration: Double
    let delay: Double
    let size: CGFloat
    let imageName: String
    let rotationDuration: Double
}
