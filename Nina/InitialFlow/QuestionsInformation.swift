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

let exercisesQuestion = "Você se exercitou por mais de 30 minutos hoje?"
let exercisesOptions = ["Sim": Answer.yesOrNo(true), "Não": Answer.yesOrNo(false)]
let foodQuestion = "Como você classificaria a sua alimentação hoje?"
let foodOptions: [String: Answer] = [
    "Muito saudável": .number(10),
    "Saudável": .number(7.5),
    "Regular": .number(5),
    "Não muito saudável": .number(2.5),
    "Nada saudável": .number(0)
]
let sleepQuestion = "Como você classificaria o seu sono hoje?"
let sleepOptions: [String: Answer] = [
    "Muito bom": .number(10),
    "Bom": .number(7.5),
    "Regular": .number(5),
    "Ruim": .number(2.5),
    "Péssimo": .number(0)
]

let readingQuestion = "Você leu algum livro ou artigo científico hoje?"
let readingOptions = ["Sim": Answer.yesOrNo(true), "Não": Answer.yesOrNo(false)]
let languageQuestion = "Você está estudando algum idioma estrangeiro? E fez alguma atividade nesse idioma hoje?"
let languageOptions: [String: Answer] = [
    "Estou estudando e realizei exercícios": Answer.number(10),
    "Estou estudando mas não realizei exercícios": Answer.number(5),
    "Não estou estudando nenhum idioma": Answer.number(1)
]
let skillsQuestion = "Você está aprendendo alguma habilidade nova?"
let skillsOptions: [String: Answer] = [
    "Sim": Answer.yesOrNo(true),
    "Não": Answer.yesOrNo(false)
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
            return Information(title: "Exercícios", question: exercisesQuestion, options: exercisesOptions)
        case .food:
            return Information(title: "Alimentação", question: foodQuestion, options: foodOptions)
        case .sleep:
            return Information(title: "Sono", question: sleepQuestion, options: sleepOptions)
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
            return Information(title: "Leitura", question: readingQuestion, options: readingOptions)
        case .languages:
            return Information(title: "Idiomas", question: languageQuestion, options: languageOptions)
        case .skills:
            return Information(title: "Habilidades", question: skillsQuestion, options: skillsOptions)
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
