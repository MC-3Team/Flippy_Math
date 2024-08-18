//
//  DataService.swift
//  FlippyMath
//
//  Created by Enrico Maricar on 05/08/24.
//

import Foundation

protocol DataService : AnyObject {
    func insertAllData()
    func getInCompleteQuestion() -> [MathQuestion]
    func getCompleteQuestion() -> [MathQuestion]
    func updateCompletedQuestion(mathQuestion: MathQuestion, isComplete: Bool)
}
