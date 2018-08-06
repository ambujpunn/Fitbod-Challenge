//
//  WorkoutData.swift
//  Fitbod-Challenge
//
//  Created by Ambuj Punn on 7/30/18.
//  Copyright © 2018 Ambuj Punn. All rights reserved.
//

import Foundation
import CSVImporter

enum CSVFileConstants {
    static let numberOfItemsInLine = 5
    static let fileName = "workoutData"
}

// Possibly name this "OneExerciseSet" or something related to the CSV file per line case
struct ExerciseSet: Hashable {
    let name: String
    let date: Date
    let reps: Int
    let weight: Float
}

extension DateFormatter {
    static let exerciseDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d yyyy"
        formatter.calendar = Calendar.current
        formatter.timeZone = TimeZone.current
        formatter.locale = Locale.current
        return formatter
    }()
}

struct Exercise {
    var name = ""
    var maxRepMap = [Date: Float]()
    var allTimeMax: Float = 0.0
    var allTimeMaxDate = Date.init()
}

protocol WorkoutDataReporting {
    func importProgress(numberOfLinesImported: Int)
    func didImport(exerciseData: [Exercise])
    func importFailed()
}

class WorkoutData {
    private let importer: CSVImporter<ExerciseSet?>
    static let shared = WorkoutData(csvFileName: CSVFileConstants.fileName)
    
    var delegate: WorkoutDataReporting?
    
    /*
    File name is crucial to the app working. If it doesn't exist, gracefully return nil through the usage of a failing init and allow caller to handle repercussions of failed init
    */
    private init?(csvFileName: String) {
        guard let filePath = Bundle.main.path(forResource: csvFileName, ofType: "txt") else {
            return nil
        }
        // Importing work will happen on .utility global background queue, callback will be called on the user interactive queue
        // Note: Not choosing main queue as we want only actual UI updates on main queue, user interactive is sufficient here as the callback needs to happen fast so the UI can be updated right after on the main queue
        importer = CSVImporter<ExerciseSet?>(path: filePath, workQosClass: .utility, callbacksQosClass: .userInteractive)
    }
    
    // MARK - Public

    func parseCSVFile() {
        importer.startImportingRecords { exerciseValues -> ExerciseSet? in
            guard exerciseValues.count == CSVFileConstants.numberOfItemsInLine, let date = DateFormatter.exerciseDateFormatter.date(from: exerciseValues[0]), !exerciseValues[1].isEmpty, let reps = Int(exerciseValues[3]), let weight = Float(exerciseValues[4]) else {
                return nil
            }
            let name = exerciseValues[1]
            return ExerciseSet(name: name, date: date, reps: reps, weight: weight)
        }.onProgress { [weak self] numberOfImportedLines in
            self?.delegate?.importProgress(numberOfLinesImported: numberOfImportedLines)
        }.onFail { [weak self] in
            self?.delegate?.importFailed()
        }.onFinish { [weak self] exerciseSets in
            var exerciseMap = [String: Exercise]()
            for exercise in exerciseSets {
                if let validExercise = exercise {
                    let name = validExercise.name
                    if exerciseMap[name] == nil {
                        var exercise = Exercise()
                        exercise.name = name
                        exerciseMap[name] = exercise
                    }
                    
                    // Calculate one rep max
                    let date = validExercise.date
                    let newOneRepMax = self?.calculateOneRepMax(validExercise.weight, validExercise.reps) ?? 0
                    let prevOneRepMax = exerciseMap[name]?.maxRepMap[date] ?? 0
                    
                    // One rep max for specific date
                    let currentMax = max(prevOneRepMax, newOneRepMax)
                    exerciseMap[name]?.maxRepMap[date] = currentMax
                    
                    // One rep max of all time for exercise
                    if let allTimeMax = exerciseMap[name]?.allTimeMax, currentMax >= allTimeMax {
                        exerciseMap[name]?.allTimeMax = currentMax
                        exerciseMap[name]?.allTimeMaxDate = date
                    }
                }
            }
            self?.delegate?.didImport(exerciseData: Array(exerciseMap.values))
        }
    }
    
    // Note: Using exact insead of approximation
    func calculateOneRepMax(_ weight: Float, _ reps: Int) -> Float {
        return Float(weight) * (36.0 / (37.0 - Float(reps)))
    }
}
