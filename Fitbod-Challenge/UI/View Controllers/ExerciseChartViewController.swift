//
//  ExerciseChartViewController.swift
//  Fitbod-Challenge
//
//  Created by Ambuj Punn on 8/1/18.
//  Copyright © 2018 Ambuj Punn. All rights reserved.
//

import UIKit
import Charts

class ExerciseChartViewController: UIViewController {
    var exercise: Exercise!

    @IBOutlet weak var exerciseInfoView: ExerciseTableViewCell!
    @IBOutlet weak var lineChartView: LineChartView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .black
        setupInfoView()
        setupLineChart()
    }
    
    // MARK - Private
    
    private func setupInfoView() {
        let viewModel = ExerciseCellViewModel(name: exercise.name, oneRepMaxWeight: String(Int(exercise.allTimeMax)))
        exerciseInfoView.set(viewModel: viewModel)
    }
    
    private func setupLineChart() {
        let entries = exercise.maxRepMap.sorted { $0 < $1 }
            .map { (date, maxRep) in
                return ChartDataEntry(x: date.timeIntervalSince1970, y: Double(maxRep))
        }
        let dataSet = LineChartDataSet(values: entries, label: nil)
        dataSet.colors = [.fitBod]
        dataSet.valueColors = [.fitBod]
        dataSet.circleColors = [.fitBod]
        dataSet.circleRadius = 3.0
        
        let lineData = LineChartData(dataSet: dataSet)
        lineChartView.data = lineData
        lineChartView.maxVisibleCount = 0
        lineChartView.legend.form = .none
        lineChartView.chartDescription = nil

        DispatchQueue.main.async {
            self.lineChartView.notifyDataSetChanged()
        }
    }
}
