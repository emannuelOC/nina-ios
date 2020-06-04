//
//  QuestionsInformation.swift
//  Nina
//
//  Created by Emannuel Carvalho on 09/05/20.
//  Copyright © 2020 Emannuel Carvalho. All rights reserved.
//

import Foundation

struct Information {
    var title: String
    var question: String
    var options: [String: Answer]
}

protocol Criteria: CaseIterable {
    var information: Information { get }
    
    static func criteria(for string: String) -> Self?
    
    func validate(answer: Answer) -> Bool
}

let exercisesQuestion = NSLocalizedString("Did you exercise for more than 30 minutes today?", comment: "")
let exercisesOptions = [NSLocalizedString("Yes", comment: ""): Answer.yesOrNo(true), NSLocalizedString("No", comment: ""): Answer.yesOrNo(false)]
let foodQuestion = NSLocalizedString("How would you classify your food today?", comment: "")
let foodOptions: [String: Answer] = [
    NSLocalizedString("Very healthy", comment: ""): .number(10),
    NSLocalizedString("Healthy", comment: ""): .number(7.5),
    NSLocalizedString("Regular", comment: ""): .number(5),
    NSLocalizedString("Not very healthy", comment: ""): .number(2.5),
    NSLocalizedString("Not healthy at all", comment: ""): .number(0)
]
let sleepQuestion = NSLocalizedString("How was your sleep last night?", comment: "")
let sleepOptions: [String: Answer] = [
    NSLocalizedString("Very good", comment: ""): .number(10),
    NSLocalizedString("Good", comment: ""): .number(7.5),
    NSLocalizedString("Regular", comment: ""): .number(5),
    NSLocalizedString("Bad", comment: ""): .number(2.5),
    NSLocalizedString("Terrible", comment: ""): .number(0)
]

let readingQuestion = NSLocalizedString("Did you read a book or a scientific article today?", comment: "")
let readingOptions = [NSLocalizedString("Yes", comment: ""): Answer.yesOrNo(true), NSLocalizedString("No", comment: ""): Answer.yesOrNo(false)]
let languageQuestion = NSLocalizedString("Are you studying a new language? And did you practice today?", comment: "")
let languageOptions: [String: Answer] = [
    NSLocalizedString("I am studying and I practiced it today", comment: ""): Answer.number(10),
    NSLocalizedString("I am studying but I didn't practice today", comment: ""): Answer.number(5),
    NSLocalizedString("I am not studying a new language", comment: ""): Answer.number(1)
]
let skillsQuestion = NSLocalizedString("Are you learning a new skill?", comment: "")
let skillsOptions: [String: Answer] = [
    NSLocalizedString("Yes", comment: ""): Answer.yesOrNo(true),
    NSLocalizedString("No", comment: ""): Answer.yesOrNo(false)
]

enum SoilCriteria: Criteria {
    case exercises, food, sleep
    
    static func criteria(for string: String) -> SoilCriteria? {
        return SoilCriteria.allCases.filter {
            $0.information.title == string
        }.first
    }
    
    var information: Information {
        switch self {
        case .exercises:
            return Information(title: NSLocalizedString("Exercises", comment: "Physical activities"), question: exercisesQuestion, options: exercisesOptions)
        case .food:
            return Information(title: NSLocalizedString("Food", comment: ""), question: foodQuestion, options: foodOptions)
        case .sleep:
            return Information(title: NSLocalizedString("Sleep", comment: ""), question: sleepQuestion, options: sleepOptions)
        }
    }
    
    func validate(answer: Answer) -> Bool {
        switch (self, answer) {
        case (.exercises, .number(let minutes)):
            return minutes >= 30
        case (_, .number(let quality)):
            return quality == 5
        default:
            return false
        }
    }
}

enum BranchesCriteria: Criteria {
    case reading, languages, skills
    
    static func criteria(for string: String) -> BranchesCriteria? {
        return BranchesCriteria.allCases.filter {
            $0.information.title == string
        }.first
    }
    
    var information: Information {
        switch self {
        case .reading:
            return Information(title: NSLocalizedString("Reading", comment: ""), question: readingQuestion, options: readingOptions)
        case .languages:
            return Information(title: NSLocalizedString("Languages", comment: ""), question: languageQuestion, options: languageOptions)
        case .skills:
            return Information(title: NSLocalizedString("Skills", comment: ""), question: skillsQuestion, options: skillsOptions)
        }
    }
    
    func validate(answer: Answer) -> Bool {
        switch (self, answer) {
        case (.skills, .text(let skill)):
            return !skill.isEmpty
        case (_, .yesOrNo(let done)):
            return done
        default:
            return false
        }
    }
}
