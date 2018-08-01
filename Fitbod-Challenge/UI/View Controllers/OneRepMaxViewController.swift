//
//  OneRepMaxViewController.swift
//  Fitbod-Challenge
//
//  Created by Ambuj Punn on 7/30/18.
//  Copyright © 2018 Ambuj Punn. All rights reserved.
//

import UIKit

class OneRepMaxViewController: UIViewController {
    let workoutData: WorkoutData? = WorkoutData.shared
    var exerciseData = [Exercise]()

    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let dataImport = workoutData {
            dataImport.delegate = self
            dataImport.parseCSVFile()
        }
        else {
            // Show popup that csv file is invalid
        }
        tableView.dataSource = self
        tableView.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

extension OneRepMaxViewController: WorkoutDataReporting {
    
    func didImport(exerciseData: [Exercise]) {
        self.exerciseData = exerciseData
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    // MARK - Private
    
    func viewModels(from exercise: Exercise) -> ExerciseCellViewModel {
        // Converting weight from Float to Int
        return ExerciseCellViewModel(name: exercise.name, oneRepMaxWeight: Int(exercise.allTimeMax))
    }
}

extension OneRepMaxViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "exercise_cell", for: indexPath) as! ExerciseTableViewCell
        let viewModel = viewModels(from: exerciseData[indexPath.row])
        cell.set(viewModel: viewModel)
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.exerciseData.count
    }
}

extension OneRepMaxViewController: UITableViewDelegate {

}

