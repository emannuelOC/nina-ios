//
//  DailyResult+Criteria.swift
//  Nina
//
//  Created by Emannuel Carvalho on 28/04/20.
//  Copyright © 2020 Emannuel Carvalho. All rights reserved.
//

import Foundation

extension DailyResult {
    
    var branchInformations: [BranchesCriteria: Answer] {
        var info = [BranchesCriteria: Answer]()
        if readingAdded {
            info[.reading] = .yesOrNo(readingScore == 10)
        }
        if languagesAdded {
            info[.languages] = .number(languagesScore)
        }
        if skillsAdded {
            info[.skills] = .yesOrNo(skillsScore == 10)
        }
        return info
    }
    
    var soilInformations: [SoilCriteria: Answer] {
        var info = [SoilCriteria: Answer]()
        if exercisesAdded {
            info[.exercises] = .number(exercisesScore)
        }
        if foodAdded {
            info[.food] = .number(foodScore)
        }
        if sleepAdded {
            info[.sleep] = .number(sleepScore)
        }
        return info
    }
    
}
