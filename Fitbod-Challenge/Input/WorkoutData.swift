//
//  WorkoutData.swift
//  Fitbod-Challenge
//
//  Created by Ambuj Punn on 7/30/18.
//  Copyright © 2018 Ambuj Punn. All rights reserved.
//

import Foundation
import CSVImporter

struct ExerciseSet {
    let name: String
    let date: Date
    let reps: Int
    let weight: Float
}

// Possibly make this Singleton
struct WorkoutData {
    private let fileName: String
    
    init(_ csvFileName: String) {
        fileName = csvFileName
    }
    
    // MARK - Private
    
    func convertCSVFile(_ fileName: String) -> String {
        return ""
    }
}
