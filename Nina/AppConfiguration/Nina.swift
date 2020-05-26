//
//  Nina.swift
//  Nina
//
//  Created by Emannuel Carvalho on 04/05/20.
//  Copyright © 2020 Emannuel Carvalho. All rights reserved.
//

import Foundation
import os.log

struct Nina {
    static let subsystemName = "com.oc.Nina"

    static func log(for type: AnyClass) -> OSLog {
        OSLog(subsystem: subsystemName, category: String(describing: type))
    }
}
