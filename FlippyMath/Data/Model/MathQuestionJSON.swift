//
//  MathQuestionJSON.swift
//  BambiniMath
//
//  Created by Enrico Maricar on 14/08/24.
//

import Foundation

struct ListMathQuestion: Codable {
    let math_question: [MathQuestionJSON]
}

struct MathQuestionJSON: Codable {
    let id: Int
    let sequence : Int
    let background: String
    let is_complete: Bool
    let stories: [StoryJSON]
    let problems: [ProblemJSON]
}

struct StoryJSON: Codable {
    let id: Int
    let sequence : Int
    let story: String
    let audio: String
    let apretiation: String
}

struct ProblemJSON: Codable {
    let id: Int
    let sequence : Int
    let color : String
    let problem: String
    let isOperator: Bool
    let isQuestion: Bool
    let isSpeech: Bool
}
