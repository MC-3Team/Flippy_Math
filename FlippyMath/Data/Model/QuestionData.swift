//
//  QuestionData.swift
//  FlippyMath
//
//  Created by Rajesh Triadi Noftarizal on 14/08/24.
//

import Foundation

struct QuestionData: Codable, Equatable{
    let id: Int
    let sequence : Int
    let background: String
    var is_complete: Bool
    let stories: [StoryData]
    let problems: [ProblemData]
}

struct StoryData: Codable, Equatable{
    let id: Int
    let sequence : Int
    let story: String
    let audio: String
    let appretiation: String
    let audio_apretiation: String
}

struct ProblemData: Codable, Equatable {
    let id: Int
    let sequence : Int
    let color : String
    let problem: String
    let isOperator: Bool
    let isQuestion: Bool
    let isSpeech: Bool
}
