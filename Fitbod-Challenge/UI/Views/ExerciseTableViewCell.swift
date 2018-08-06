//
//  ExerciseTableViewCell.swift
//  Fitbod-Challenge
//
//  Created by Ambuj Punn on 8/1/18.
//  Copyright © 2018 Ambuj Punn. All rights reserved.
//

import UIKit

protocol ReusableView {
    func set<T: ViewModel>(viewModel: T)
}

class ExerciseTableViewCell: UITableViewCell {

    @IBOutlet var exerciseView: UITableViewCell!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var weightLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        nameLabel.text = ""
        weightLabel.text = ""
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        Bundle.main.loadNibNamed("ExerciseTableViewCell", owner: self, options: nil)
        exerciseView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        addSubview(exerciseView)
    }
}

extension ExerciseTableViewCell: ReusableView {
    func set<T>(viewModel: T) where T : ViewModel {
        if let exerciseViewModel = viewModel as? ExerciseCellViewModel {
            DispatchQueue.main.async {
                self.nameLabel.text = exerciseViewModel.name
                self.weightLabel.text = exerciseViewModel.oneRepMaxWeight
                self.setNeedsLayout()
            }
        }
    }
}
