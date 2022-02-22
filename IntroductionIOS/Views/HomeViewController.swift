//
//  ViewController.swift
//  IntroductionIOS
//
//  Created by Jonas Freres on 16/02/2022.
//

import UIKit

class HomeViewController: UIViewController {
    
    private let viewModel: HomeViewModelProtocol
    
    private let homeView = HomeView()
    
    init(viewModel: HomeViewModelProtocol = HomeViewModel()) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        self.view = homeView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = .Title.home
        
        homeView.tableView.register(
            HomeTableViewCell.self,
            forCellReuseIdentifier: HomeTableViewCell.Key.identifier
        )
        homeView.tableView.delegate = self
        homeView.tableView.dataSource = self
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .add,
            target: self,
            action: #selector(onAddButtonPressed)
        )
        
        viewModel.delegate = self
    }
}

extension HomeViewController {
    
    @objc func onAddButtonPressed() {
        viewModel.userClickedOnAddItemButton()
    }
}

extension HomeViewController: HomeDelegate {
    
    func onRefreshData() {
        homeView.tableView.reloadData()
    }
    
    func openDetail(for text: TextViewData) {
        let alert = UIAlertController(title: .Title.detail, message: text.text, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: .Action.close, style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: .Action.delete, style: .destructive, handler: { [weak self] _ in
            self?.viewModel.delete(text: text)
        }))
        present(alert, animated: true, completion: nil)
    }
    
    func openNewForm() {
        let alert = UIAlertController(title: .Title.newText, message: .Message.newText, preferredStyle: .alert)
        alert.addTextField { textField in
            textField.placeholder = .PlaceHolder.newText
        }
        alert.addAction(UIAlertAction(title: .Action.cancel, style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: .Action.save, style: .default, handler: { [weak self] _ in
            if let text = alert.textFields?.element(at: 0)?.text, !text.isEmpty {
                self?.viewModel.insert(text: text)
            }
        }))
        present(alert, animated: true, completion: nil)
    }
}

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.text(selectedAt: indexPath)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: HomeTableViewCell.Key.identifier,
            for: indexPath
        )
        if let cell = cell as? HomeTableViewCell {
            cell.text = viewModel.text(at: indexPath)
        }
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.numberOfSection
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfRows(for: section)
    }
}
