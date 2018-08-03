//
//  OneRepMaxViewController.swift
//  Fitbod-Challenge
//
//  Created by Ambuj Punn on 7/30/18.
//  Copyright © 2018 Ambuj Punn. All rights reserved.
//

import UIKit

extension UIColor {
    static let fitBod = UIColor(red: 255, green: 110, blue: 96, alpha: 1)
}

class OneRepMaxViewController: UIViewController {
    let workoutData: WorkoutData? = WorkoutData.shared
    var exerciseData = [Exercise]()
    
    @IBOutlet weak var tableView: UITableView!
    
    private lazy var activityIndicatorView: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.whiteLarge)
        indicator.backgroundColor = UIColor.clear
        //indicator.color = UIColor.fitBod
        return indicator
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        if let dataImport = workoutData {
            dataImport.delegate = self
            dataImport.parseCSVFile()
        }
        else {
            // Show popup that csv file is invalid
        }
        // Since parsing the CSV file happens on the background queue asynchronously, ensure the data source and delegate method are set up on the main queue
        DispatchQueue.main.async {
            self.view.addSubview(self.activityIndicatorView)
            self.tableView.dataSource = self
            self.tableView.delegate = self
            self.tableView.separatorStyle = UITableViewCellSeparatorStyle.singleLine
            //self.tableView.tableFooterView = UIView(frame: .zero)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let selectedRow = tableView.indexPathForSelectedRow {
            tableView.deselectRow(at: selectedRow, animated: true)
        }
    }

    override func viewDidLayoutSubviews() {
        activityIndicatorView.frame = .init(x: view.bounds.width/2, y: view.bounds.height/2, width: 40, height: 40)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        /*
        let coffeeDetailsViewController = segue.destination as! CoffeeDetailsViewController
        // Dependencies
        coffeeDetailsViewController.coffeeViewModel = viewModel(for: selectedCoffee)
        coffeeDetailsViewController.coffeeInfo = (selectedCoffeeIndex, selectedCoffee.id)
        coffeeDetailsViewController.networkManager = networkManager
 */
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
        return ExerciseCellViewModel(name: exercise.name, oneRepMaxWeight: String(Int(exercise.allTimeMax)))
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
        let exerciseCount = self.exerciseData.count
        // TODO: Test with bigger data set
        exerciseCount == 0 ? activityIndicatorView.startAnimating() : activityIndicatorView.stopAnimating()
        return exerciseCount
    }
}

extension OneRepMaxViewController: UITableViewDelegate {

    /*
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let exerciseChartViewController = ExerciseChartViewController()
        self.navigationController?.pushViewController(exerciseChartViewController, animated: true)
    }*/
}

