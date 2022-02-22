//
//  HomeViewModel.swift
//  IntroductionIOS
//
//  Created by Jonas Freres on 22/02/2022.
//

import Foundation

protocol HomeDelegate: AnyObject {
    /**
     Indicates the delegate it should refresh its views
     */
    func onRefreshData()
    
    /**
     Ask the presenter to show the detail of the text to the user
        - Parameter text: `TextViewData` object containing the text to display
     */
    func openDetail(for text: TextViewData)
    
    /**
     Ask the presenter to show the a form for user to add a new item
     */
    func openNewForm()
}

protocol HomeViewModelProtocol: AnyObject {
    
    /**
     The delegate object that will recieve updates notifications
     */
    var delegate: HomeDelegate? { get set }
    
    /**
     Ask the viewModel to load the data
     */
    func load()
    
    /**
     Indicates to the viewModel the user selected an item in a list
        - Parameter indexPath: `IndexPath` the item's index in the list
     */
    func text(selectedAt indexPath: IndexPath)
    
    /**
     Ask the viewModel the text corresponding at an indexPath
        - Parameter indexPath: `IndexPath` the item's index in the list
        - Returns: `String?` corresponding to the text at the index path or nil if doesn't exist
     */
    func text(at indexPath: IndexPath) -> String?
    
    /**
     Indicates the viewModel the user clicked on the add button
     */
    func userClickedOnAddItemButton()
    
    /**
     Ask the viewModel tho add a new text into the data list
        - Parameter text: `String` the new item
     */
    func insert(text: String)
    
    /**
     Ask the viewModel tho delete an item in the data list
        - Parameter text: `TextViewData` the item to delete
     */
    func delete(text: TextViewData)
    
    /**
     Ask the viewModel tho number of row for a section
        - Parameter section: `Int` the section of a list
        - Returns: `Int` the number of row for the given section
     */
    func numberOfRows(for section: Int) -> Int
    
    /**
     The number of section we want to display in the list
     */
    var numberOfSection: Int { get }
}

class HomeViewModel: HomeViewModelProtocol {
    
    weak var delegate: HomeDelegate?
    
    private var texts: [TextViewData] = [] {
        didSet {
            delegate?.onRefreshData()
        }
    }
    private let interactor: HomeInteractorProcotol
    
    init(interactor: HomeInteractorProcotol = HomeInteractor()) {
        self.interactor = interactor
    }
    
    // MARK: - Actions
    
    func load() {
        interactor.loadAllTexts { [weak self] newSet in
            self?.texts = newSet
        }
    }
    
    func userClickedOnAddItemButton() {
        // Do action if needed before triggering UI
        delegate?.openNewForm()
    }
    
    // MARK: - Data Manipulation
    
    func insert(text: String) {
        let newData = TextViewData(id: UUID().uuidString, text: text)
        interactor.saveNew(text: newData) { [weak self] newSet in
            self?.texts = newSet
        }
    }
    
    func delete(text: TextViewData) {
        interactor.delete(text: text) { [weak self] newSet in
            self?.texts = newSet
        }
    }
    
    // MARK: - Table View
    
    func text(selectedAt indexPath: IndexPath) {
        if let data = texts.element(at: indexPath.row) {
            delegate?.openDetail(for: data)
        }
    }
    
    func text(at indexPath: IndexPath) -> String? {
        return texts.element(at: indexPath.row)?.text
    }
    
    func numberOfRows(for section: Int) -> Int {
        return section == 0 ? texts.count : 0
    }
    
    var numberOfSection = 1
}
