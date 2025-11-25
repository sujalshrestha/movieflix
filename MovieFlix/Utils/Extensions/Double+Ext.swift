//
//  Double+Ext.swift
//  MovieFlix
//
//  Created by Sujal on 25/11/2025.
//

import Foundation

extension Double {
    func rounded(to decimals: Int) -> Double {
        let multiplier = pow(10.0, Double(decimals))
        return (self * multiplier).rounded() / multiplier
    }
}
