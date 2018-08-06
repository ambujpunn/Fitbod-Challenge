//
//  OneRepMaxViewController.swift
//  Fitbod-Challenge
//
//  Created by Ambuj Punn on 7/30/18.
//  Copyright © 2018 Ambuj Punn. All rights reserved.
//

import UIKit
import NVActivityIndicatorView

extension UIColor {
    static let fitBod = UIColor.customColor(red: 255, green: 110, blue: 96, alpha: 1)
    
    static private func customColor(red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat) -> UIColor {
        return UIColor(red: red/255.0, green: green/255.0, blue: blue/255.0, alpha: alpha)
    }
}

class OneRepMaxViewController: UIViewController {
    let workoutData: WorkoutData? = WorkoutData.shared
    var exerciseData = [Exercise]()
    
    lazy var errorAlert: UIAlertController = {
        return UIAlertController(title: "Non Existent CSV File", message: "Couldn't find file. Please close the app and import valid CSV file in project.", preferredStyle: .alert)
    }()
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let dataImport = workoutData {
            dataImport.delegate = self
            dataImport.parseCSVFile()

            // Since parsing the CSV file happens on the background queue asynchronously, ensure the data source and delegate method are set up on the main queue
            DispatchQueue.main.async {
                self.startAnimating(message: "Importing CSV File...", type: NVActivityIndicatorType.orbit, color: .fitBod, textColor: .fitBod)
                self.tableView.dataSource = self
                self.tableView.separatorStyle = UITableViewCellSeparatorStyle.singleLine
                
                // Gets rid of extra separators on simulator
                self.tableView.tableFooterView = UIView(frame: .zero)
            }
        }
        else {
            self.present(errorAlert, animated: true, completion: nil)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let selectedRow = tableView.indexPathForSelectedRow {
            tableView.deselectRow(at: selectedRow, animated: true)
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let selectedRow = tableView.indexPathForSelectedRow {
            navigationItem.backBarButtonItem?.tintColor = .fitBod
            let exercise = exerciseData[selectedRow.row]
            // Okay to force unwrap since we've made the segue specifically to the ExerciseChartViewController
            // Benefits of this is that it will be caught during development if the storyboard is not created correctly
            let exerciseChartViewController = segue.destination as! ExerciseChartViewController
            exerciseChartViewController.exercise = exercise
        }
    }
}

extension OneRepMaxViewController: NVActivityIndicatorViewable {}

extension OneRepMaxViewController: WorkoutDataReporting {
    
    func didImport(exerciseData: [Exercise]) {
        self.exerciseData = exerciseData
        DispatchQueue.main.async {
            self.stopAnimating()
            self.tableView.reloadData()
        }
    }
    
    func importProgress(numberOfLinesImported: Int) {
        DispatchQueue.main.async {
            if self.isAnimating {
                NVActivityIndicatorPresenter.sharedInstance.setMessage("Imported \(numberOfLinesImported) lines...")
            }
        }
    }
    
    func importFailed() {
        DispatchQueue.main.async {
            if self.isAnimating {
                self.stopAnimating()
            }
            self.errorAlert.title = "Invalid Data File"
            self.errorAlert.message = "Could not import data file."
            self.present(self.errorAlert, animated: true, completion: nil)
        }
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
        return exerciseData.count
    }
    
    // MARK - Private
    
    func viewModels(from exercise: Exercise) -> ExerciseCellViewModel {
        // Converting weight from Float to Int
        return ExerciseCellViewModel(name: exercise.name, oneRepMaxWeight: String(Int(exercise.allTimeMax)))
    }
}
