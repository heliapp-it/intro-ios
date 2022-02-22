//
//  Interactor.swift
//  IntroductionIOS
//
//  Created by Jonas Freres on 22/02/2022.
//

import Foundation

protocol HomeInteractorProcotol {
    /**
     Ask interactor all the texts
     - Parameter completion: the completion called once all the data is available
     */
    func loadAllTexts(completion: @escaping ([TextViewData]) -> Void)
    
    /**
     Ask interactor to save a new text
     - Parameters:
        - text: the new data to save
        - completion: the completion called once all the new set of data is available
     */
    func saveNew(text: TextViewData, completion: @escaping ([TextViewData]) -> Void)
    
    /**
     Ask interactor to delete a text
     - Parameters:
        - text: the data to delete
        - completion: the completion called once all the new set of data is available
     */
    func delete(text: TextViewData, completion: @escaping ([TextViewData]) -> Void)
}

class HomeInteractor: HomeInteractorProcotol {
    
    private let repository: HomeRepositoryProtocol
    private var isLoading: Bool = false
    
    init(repository: HomeRepositoryProtocol = HomeRepository()) {
        self.repository = repository
    }
    
    func loadAllTexts(completion: @escaping ([TextViewData]) -> Void) {
        guard !isLoading else { return }
        
        repository.loadTexts { [weak self] result in
            self?.isLoading = false
            DispatchQueue.main.sync {
                completion(result.map { TextViewData(id: $0.id, text: $0.text) })
            }
        }
    }
    
    func saveNew(text: TextViewData, completion: @escaping ([TextViewData]) -> Void) {
        guard !isLoading else { return }
        repository.loadTexts { [weak self] localData in
            var newData = localData
            newData.append(TextData(id: text.id, text: text.text))
            self?.repository.save(texts: newData)
            self?.isLoading = false
            DispatchQueue.main.sync {
                completion(newData.map { TextViewData(id: $0.id, text: $0.text) })
            }
        }
    }
    
    func delete(text: TextViewData, completion: @escaping ([TextViewData]) -> Void) {
        guard !isLoading else { return }
        repository.loadTexts { [weak self] localData in
            var newData = localData
            if let index = newData.firstIndex(where: { $0.id == text.id }) {
                newData.remove(at: index)
            }
            self?.repository.save(texts: newData)
            self?.isLoading = false
            DispatchQueue.main.sync {
                completion(newData.map { TextViewData(id: $0.id, text: $0.text) })
            }
        }
    }
    
}
