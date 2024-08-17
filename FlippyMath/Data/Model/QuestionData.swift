//
//  QuestionData.swift
//  BambiniMath
//
//  Created by Rajesh Triadi Noftarizal on 14/08/24.
//

import Foundation

struct QuestionData: Codable {
    let id: Int
    let sequence : Int
    let background: String
    let is_complete: Bool
    let stories: [StoryData]
    let problems: [ProblemData]
}

struct StoryData: Codable {
    let id: Int
    let sequence : Int
    let story: String
    let audio: String
    let appretiation: String
    let audio_apretiation: String
}

struct ProblemData: Codable {
    let id: Int
    let sequence : Int
    let color : String
    let problem: String
    let isOperator: Bool
    let isQuestion: Bool
    let isSpeech: Bool
}
