//
//  HomeTableViewCell.swift
//  IntroductionIOS
//
//  Created by Jonas Freres on 22/02/2022.
//

import UIKit
import EasyPeasy

class HomeTableViewCell: UITableViewCell {
    
    struct Key {
        static let identifier = "HomeTableViewCell"
    }
    
    private let label = UILabel()
    
    var text: String? {
        get { label.text }
        set { label.text = newValue }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        layout()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        layout()
    }
    
    private func layout() {
        contentView.addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.preferredFont(forTextStyle: .body, compatibleWith: .current)
        label.easy.layout(Edges(16))
    }
}
