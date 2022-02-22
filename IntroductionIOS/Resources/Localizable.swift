//
//  Localizable.swift
//  IntroductionIOS
//
//  Created by Jonas Freres on 22/02/2022.
//

import Foundation

extension String {
    
    struct Title {
        static var home: String { "title.home".localizable }
        static var detail: String { "title.detail".localizable }
        static var newText: String { "title.new_text".localizable }
    }
    
    struct Message {
        static var newText: String { "message.new_text".localizable }
    }
    
    struct Action {
        static var save: String { "action.save".localizable }
        static var delete: String { "action.delete".localizable }
        static var cancel: String { "action.cancel".localizable }
        static var close: String { "action.close".localizable }
    }
    
    struct PlaceHolder {
        static var newText: String { "placeholder.new_text".localizable }
    }
}


extension String {
    
    var localizable: String {
        return NSLocalizedString(self, comment: self)
    }
}
