//
//  HomeView.swift
//  IntroductionIOS
//
//  Created by Jonas Freres on 22/02/2022.
//

import UIKit
import EasyPeasy

class HomeView: UIView {
    
    let tableView = UITableView(frame: .zero)
    
    init() {
        super.init(frame: .zero)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.easy.layout(Edges())
    }
}
