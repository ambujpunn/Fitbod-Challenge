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

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var weightLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        nameLabel.text = ""
        weightLabel.text = ""
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}

extension ExerciseTableViewCell: ReusableView {
    func set<T>(viewModel: T) where T : ViewModel {
        if let exerciseViewModel = viewModel as? ExerciseCellViewModel {
            nameLabel.text = exerciseViewModel.name
            weightLabel.text = exerciseViewModel.oneRepMaxWeight
        }
    }
}
