//
//  ExerciseChartViewController.swift
//  Fitbod-Challenge
//
//  Created by Ambuj Punn on 8/1/18.
//  Copyright © 2018 Ambuj Punn. All rights reserved.
//

import UIKit

class ExerciseChartViewController: UIViewController {
    var exercise: Exercise!

    @IBOutlet weak var exerciseInfoView: ExerciseTableViewCell!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .black
        setupInfoView()
    }
    
    // MARK - Private
    
    private func setupInfoView() {
        let viewModel = ExerciseCellViewModel(name: exercise.name, oneRepMaxWeight: String(Int(exercise.allTimeMax)))
        exerciseInfoView.set(viewModel: viewModel)
    }
}
