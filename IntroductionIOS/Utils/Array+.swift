//
//  Array+.swift
//  IntroductionIOS
//
//  Created by Jonas Freres on 22/02/2022.
//

import Foundation

extension Array {
    
    func element(at index: Int) -> Element? {
        guard index >= 0 && index < self.count else { return nil }
        return self[index]
    }
}
