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

    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

extension OneRepMaxViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // TODO :
        return tableView.dequeueReusableCell(withIdentifier: "exercise_cell", for: indexPath)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // TODO:
        return 1
    }
}

extension OneRepMaxViewController: UITableViewDelegate {

}

