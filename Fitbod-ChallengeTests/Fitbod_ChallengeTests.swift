//
//  Fitbod_ChallengeTests.swift
//  Fitbod-ChallengeTests
//
//  Created by Ambuj Punn on 7/30/18.
//  Copyright © 2018 Ambuj Punn. All rights reserved.
//

import XCTest
@testable import Fitbod_Challenge

class Fitbod_ChallengeTests: XCTestCase {
    var workoutData: WorkoutData!
    var importedExerices: [Exercise]!
    var numberOfLinesImported: Int!
    var delegateExpectation: XCTestExpectation!
    
    override func setUp() {
        super.setUp()
        workoutData = WorkoutData.shared
        importedExerices = [Exercise]()
        workoutData.delegate = self
    }
    
    override func tearDown() {
        workoutData = nil
        importedExerices = nil
        delegateExpectation = nil
        super.tearDown()
    }
    
    func testOneRepMaxCalculation() {
        let oneMaxRep = workoutData.calculateOneRepMax(225, 8)
        
        // Using exact formula
        let expected = Float(225) * (36.0 / (37.0 - Float(8)))
        XCTAssertEqual(oneMaxRep, expected, "One Max Rep calculated incorrectly")
    }
    
    func testIfWorkoutDataFileExists() {
        XCTAssertThrowsError(try workoutData.parseCSV(file: "test1"), "Error not thrown") { (error) in
            if let nonExistentFileError = error as? WorkoutDataImportingError {
                XCTAssertEqual(nonExistentFileError, WorkoutDataImportingError.nonExistentWorkoutFile, "Wrong error thrown")
            }
        }
    }
    
    func testDataFileImport() {
        delegateExpectation = expectation(description: "Importing data from test file")
        if let _ = try? workoutData.parseCSV(file: "test") {
            var expected: Set = ["Front", "Bench", "Back Squat"]
            wait(for: [delegateExpectation], timeout: 200)
            for exercise in importedExerices {
                XCTAssert(expected.contains(exercise.name), "Expected exercise missing")
                expected.remove(exercise.name)
            }
        }
    }
    
    func testImportedExerciseData() {
        delegateExpectation = expectation(description: "Importing data from test file")
        if let _ = try? workoutData.parseCSV(file: "test") {
            wait(for: [delegateExpectation], timeout: 200)
            for exercise in importedExerices {
                XCTAssert(!exercise.name.isEmpty, "Exercise name is empty")
                XCTAssert(exercise.allTimeMax > 0, "Exercise all time max is invalid")
                XCTAssert(!exercise.maxRepMap.isEmpty, "Exercise max reps dictionary is empty")
            }
        }
    }
}

extension Fitbod_ChallengeTests: WorkoutDataReporting {
    func importProgress(numberOfLinesImported: Int) {
    }
    
    func didImport(exerciseData: [Exercise]) {
        importedExerices = exerciseData
        delegateExpectation.fulfill()
    }
    
    func importFailed() {
    }
}
