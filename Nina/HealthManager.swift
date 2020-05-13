//
//  HealthManager.swift
//  Nina
//
//  Created by Emannuel Carvalho on 25/04/20.
//  Copyright © 2020 Emannuel Carvalho. All rights reserved.
//

import Foundation
import HealthKit
import os.log

class HealthManager {
    
    var isAvailable = false
    
    var exercises = 0.0
    
    let log = Nina.log(for: HealthManager.self)
    
    init() {
        authorizeHealthKit()
    }
    
    func retrieveExercises(completion: @escaping (Double) -> Void) {
        let query = HKActivitySummaryQuery(predicate: nil) { (query, summaries, error) in
            DispatchQueue.main.async {
                guard let summary = summaries?.last else {
                    completion(0.0)
                    return
                }
                let exercises = (summary.appleExerciseTime.doubleValue(for: .minute()))
                self.exercises = exercises
                completion(exercises)
            }
        }
        HKHealthStore().execute(query)
    }
    
    fileprivate func authorizeHealthKit() {
        guard HKHealthStore.isHealthDataAvailable() else {
            isAvailable = false
            return
        }
        let healthKitTypesToRead: Set<HKObjectType> = [
            HKObjectType.activitySummaryType(),
            HKObjectType.workoutType()
        ]
                
        HKHealthStore()
            .requestAuthorization(toShare: Set<HKSampleType>(), read: healthKitTypesToRead) { [weak self] (authorized, error) in
                guard let self = self else { return }
                DispatchQueue.main.async {
                    self.isAvailable = authorized
                }
                if error != nil {
                    os_log("Failed to authorize HealthKit at @{PUBLIC}", log: self.log, type: .error, #function)
                }
        }
    }
    
}
