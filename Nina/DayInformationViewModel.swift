//
//  DayInformationViewModel.swift
//  Nina
//
//  Created by Emannuel Carvalho on 28/04/20.
//  Copyright © 2020 Emannuel Carvalho. All rights reserved.
//

import Foundation
import CoreData

protocol DayInformationViewModelType {
    func setScore<T: Criteria>(criteria: T, answer: Answer)
}

class DayInformationViewModel: DayInformationViewModelType {
    
    var context: NSManagedObjectContext
    
    lazy var dailyResult: DailyResult = {
        return setupDailyResult()
    }()
    
    init(context: NSManagedObjectContext) {
        self.context = context
    }
    
    func setScore<T>(criteria: T, answer: Answer) where T : Criteria {
        if let criteria = criteria as? BranchesCriteria {
            setBranchesScore(criteria: criteria, answer: answer)
        } else if let criteria = criteria as? SoilCriteria {
            setSoilScore(criteria: criteria, answer: answer)
        }
    }
    
    fileprivate func setBranchesScore(criteria: BranchesCriteria, answer: Answer) {
        switch (criteria, answer) {
        case (.reading, .yesOrNo(let done)):
            dailyResult.readingScore = done ? 10 : 0
            dailyResult.readingAdded = true
        case (.languages, .number(let note)):
            dailyResult.languagesScore = note
            dailyResult.languagesAdded = true
        case (.skills, .yesOrNo(let done)):
            dailyResult.skillsScore = done ? 10 : 0
            dailyResult.skillsAdded = true
        default:
            break
        }
        do {
            try context.save()
        } catch {
            print("deu errado")
        }
    }
    
    fileprivate func setSoilScore(criteria: SoilCriteria, answer: Answer) {
        switch (criteria, answer) {
        case (.exercises, .yesOrNo(let done)):
            dailyResult.exercisesScore = done ? 10 : 0
            dailyResult.exercisesAdded = true
        case (.exercises, .number(let note)):
            dailyResult.exercisesScore = note
            dailyResult.exercisesAdded = true
        case (.food, .number(let note)):
            dailyResult.foodScore = note
            dailyResult.foodAdded = true
        case (.sleep, .number(let note)):
            dailyResult.sleepScore = note
            dailyResult.sleepAdded = true
        default:
            break
        }
        do {
            try context.save()
        } catch {
            print("deu errado")
        }
    }
    
    fileprivate func setupDailyResult() -> DailyResult {
        var calendar = Calendar.current
        calendar.timeZone = .autoupdatingCurrent
        
        let dateFrom = calendar.startOfDay(for: Date())
        let dateTo = calendar.date(byAdding: .day, value: 1, to: dateFrom) ?? Date()
        
        let fromPredicate = NSPredicate(format: "date >= %@", dateFrom as NSDate)
        let toPredicate = NSPredicate(format: "date < %@", dateTo as NSDate)
        let datePredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [fromPredicate, toPredicate])

        let request = DailyResult.fetchRequest() as NSFetchRequest<DailyResult>
        request.predicate = datePredicate
        
        if let result = try? context.fetch(request).last {
            return result
        }
        
        return createNewResult()
    }
    
    fileprivate func createNewResult() -> DailyResult {
        let result = DailyResult(context: context)
        result.date = Date()
        context.insert(result)
        try? context.save()
        return result
    }
    
}
