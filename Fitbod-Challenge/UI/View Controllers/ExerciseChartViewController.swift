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
                return ChartDataEntry(x: date.timeIntervalSince1970, y: Double(Int(maxRep)))
        }
        let dataSet = LineChartDataSet(values: entries, label: nil)
        dataSet.colors = [.fitBod]
        dataSet.circleColors = [.fitBod]
        dataSet.highlightColor = .fitBod
        dataSet.circleRadius = 3.0
        
        let lineData = LineChartData(dataSet: dataSet)
        lineChartView.data = lineData
        lineChartView.maxVisibleCount = 0
        lineChartView.legend.form = .none
        lineChartView.chartDescription = nil
        
        // Touch Interaction
        lineChartView.dragEnabled = false
        lineChartView.doubleTapToZoomEnabled = false
        
        // Axis
        // Disable grid lines
        lineChartView.xAxis.drawGridLinesEnabled = false
        lineChartView.leftAxis.drawGridLinesEnabled = false
        lineChartView.rightAxis.drawGridLinesEnabled = false
        
        // Disable axis lines
        lineChartView.xAxis.drawAxisLineEnabled = false
        lineChartView.leftAxis.drawAxisLineEnabled = false
        lineChartView.rightAxis.drawAxisLineEnabled = false
        
        // Disable labels on left y axis
        lineChartView.leftAxis.drawLabelsEnabled = false
        
        // Show x-axis values on bottom
        lineChartView.xAxis.labelPosition = .bottom
        
        // Customize axis labels
        lineChartView.xAxis.labelTextColor = .fitBod
        lineChartView.rightAxis.labelTextColor = .fitBod
        lineChartView.rightAxis.labelFont = .systemFont(ofSize: 12)
        lineChartView.xAxis.labelFont = .systemFont(ofSize: 12)
        lineChartView.rightAxis.setLabelCount(2, force: true)
        lineChartView.xAxis.setLabelCount(4, force: true)
        
        // Format x axis date values
        lineChartView.xAxis.valueFormatter = XAxisDateFormatter()
        
        // Set up offsets
        lineChartView.setExtraOffsets(left: 30, top: 0, right: 0, bottom: 0)
        lineChartView.xAxis.yOffset = 30

        DispatchQueue.main.async {
            self.lineChartView.notifyDataSetChanged()
        }
    }
}
