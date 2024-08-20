//
//  CoreDataManager.swift
//  FlippyMath
//
//  Created by Enrico Maricar on 05/08/24.
//

import Foundation
import CoreData

class CoreDataManager: DataService {
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "DataModel")
        container.loadPersistentStores { storeDescription, error in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
        return container
    }()
    
    var viewContext: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    func insertAllData() {
        guard let fileURL = Bundle.main.url(forResource: "dataRaw", withExtension: "json") else {
            print("File not found in bundle")
            return
        }
        
        do {
            let jsonData = try Data(contentsOf: fileURL)
            let decoder = JSONDecoder()
            let mathQuestions = try decoder.decode(ListMathQuestion.self, from: jsonData)
            
            for mathQuestionJSON in mathQuestions.math_question {
                let mathQuestion = MathQuestion(context: viewContext)
                mathQuestion.id = UUID()
                mathQuestion.sequence = Int64(mathQuestionJSON.sequence)
                mathQuestion.background = mathQuestionJSON.background
                mathQuestion.is_complete = mathQuestionJSON.is_complete
                mathQuestion.historyLevel = mathQuestionJSON.historyLevel
                
                for storyJSON in mathQuestionJSON.stories {
                    let story = Story(context: viewContext)
                    story.id = UUID()
                    story.sequence = Int64(storyJSON.sequence)
                    story.story = storyJSON.story
                    story.audio = storyJSON.audio
                    story.apretiation = storyJSON.apretiation
                    story.audio_apretiation = storyJSON.audio_apretiation
                    mathQuestion.addToStories(story)
                }
                
                for problemJSON in mathQuestionJSON.problems {
                    let problem = Problem(context: viewContext)
                    problem.id = UUID()
                    problem.sequence = Int64(problemJSON.sequence)
                    problem.color = problemJSON.color
                    problem.problem = problemJSON.problem
                    problem.is_operator = problemJSON.isOperator
                    problem.is_question = problemJSON.isQuestion
                    problem.is_speech = problemJSON.isSpeech
                    mathQuestion.addToProblems(problem)
                }
            }
            
            saveContext()
            
            print("Data inserted successfully from bundle")
            
        } catch {
            print("Failed to insert data: \(error.localizedDescription)")
        }
    }
    
    func getAllQuestion() -> [MathQuestion] {
        let fetchRequest: NSFetchRequest<MathQuestion> = MathQuestion.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "sequence", ascending: true)]
        
        do {
            return try viewContext.fetch(fetchRequest)
        } catch {
            print("Failed to fetch questions: \(error)")
            return []
        }
    }
    
    func getInCompleteQuestion() -> [MathQuestion] {
        let fetchRequest: NSFetchRequest<MathQuestion> = MathQuestion.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "is_complete == %d", false)
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "sequence", ascending: true)]
        
        do {
            return try viewContext.fetch(fetchRequest)
        } catch {
            print("Failed to fetch questions: \(error)")
            return []
        }
        
    }
    
    func getCompleteQuestion() -> [MathQuestion] {
        let fetchRequest: NSFetchRequest<MathQuestion> = MathQuestion.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "is_complete == %d", true)
        do {
            return try viewContext.fetch(fetchRequest)
        } catch {
            print("Failed to fetch questions: \(error)")
            return []
        }
    }
    
    func updateCompletedQuestion(mathQuestion: MathQuestion, isComplete: Bool) {
        mathQuestion.is_complete = isComplete
        saveContext()
    }
    
    func getMathQuestion(by sequence: Int) -> MathQuestion? {
        let fetchRequest: NSFetchRequest<MathQuestion> = MathQuestion.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "sequence == %d", sequence)
        
        do {
            let result = try viewContext.fetch(fetchRequest)
            return result.first
        } catch {
            print("Failed to fetch MathQuestion: \(error)")
            return nil
        }
    }
    
    private func saveContext() {
        if viewContext.hasChanges {
            do {
                try viewContext.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}
