//
//  Double + Extension.swift
//  InTouch
//
//  Created by Red Wang on 2023/12/22.
//

import Foundation

extension Double {
    func rounded(toPlaces places: Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
}
