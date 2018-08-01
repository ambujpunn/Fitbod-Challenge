//
//  ExerciseTableViewCell.swift
//  Fitbod-Challenge
//
//  Created by Ambuj Punn on 8/1/18.
//  Copyright © 2018 Ambuj Punn. All rights reserved.
//

import UIKit

protocol ReusableView {
    func set<T>(viewModel: T)
    //func set<T>(viewModel: T)
}

class ExerciseTableViewCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var weightLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

}

extension ExerciseTableViewCell: ReusableView where ViewModel == ExerciseCellViewModel {
    
}
