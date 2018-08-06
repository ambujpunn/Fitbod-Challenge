//
//  XAxisDateFormatter.swift
//  Fitbod-Challenge
//
//  Created by Ambuj Punn on 8/5/18.
//  Copyright © 2018 Ambuj Punn. All rights reserved.
//

import Foundation
import Charts

extension DateFormatter {
    static let xAxisDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d"
        formatter.calendar = Calendar.current
        formatter.timeZone = TimeZone.current
        formatter.locale = Locale.current
        return formatter
    }()
}

class XAxisDateFormatter: IAxisValueFormatter {
    func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        if axis is XAxis {
            return DateFormatter.xAxisDateFormatter.string(from: Date(timeIntervalSince1970: value))
        }
        return ""
    }
}
