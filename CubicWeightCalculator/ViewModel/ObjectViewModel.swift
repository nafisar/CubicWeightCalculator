//
//  ObjectViewModel.swift
//  CubicWeightCalculator
//
//  Created by Nafisa Rahman on 11/16/19.
//  Copyright © 2019 com.nafisa. All rights reserved.
//

import Foundation

class ObjectViewModel {
    var objectNetworking = ObjectNetworking()
    var sum: Double
    let conversionFactor: Double = 250
    
    init(){
        sum = 0.0
    }
}

extension ObjectViewModel {
    func getAvgCubicWeight(completion: @escaping (String) -> Void) {
        
        objectNetworking.getData { (objects) in
            
            DispatchQueue.main.async { [weak self]  in
                if let weakSelf = self {
                   
                    objects.forEach({(object) in
                        if let width = object.size?.width, let height = object.size?.height, let length = object.size?.length {
                            let cubicWeight = weakSelf.getCubicWeight(width: width, height: height, length: length)
                            let _ =  weakSelf.updateSum(cubicWeight: cubicWeight)
                        }
                    })
                    
                    let avgCubicWeight = weakSelf.getAverage(sum: weakSelf.sum, count: objects.count)
                    completion(weakSelf.formatAvgCubicWeight(weight: avgCubicWeight))
                }
            }
        }
    }
    
    private func getCubicWeight(width: Double, height: Double, length: Double) -> Double {
        return (width * height * length * conversionFactor) / (100 * 100 * 100)
    }
    
    private func updateSum(cubicWeight: Double) -> Double {
        sum += cubicWeight
        return sum
    }
    
    private func getAverage(sum: Double, count: Int) -> Double {
        guard count > 0 else { return 0 }
        
        return sum / Double(count)
    }
    
    private func formatAvgCubicWeight(weight: Double) -> String {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        numberFormatter.maximumFractionDigits = 4
        
        return numberFormatter.string(from: NSNumber(value: weight)) ?? "0"
    }
}
