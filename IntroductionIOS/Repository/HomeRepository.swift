//
//  HomeRepository.swift
//  IntroductionIOS
//
//  Created by Jonas Freres on 22/02/2022.
//

import Foundation

protocol HomeRepositoryProtocol {
    
    /**
    Ask the repository to load the texts
     - Parameter completion: The completion that will return the data
     */
    func loadTexts(completion: @escaping ([TextData]) -> Void)
    
    /**
    Ask the repository to save the given texts
     */
    func save(texts: [TextData])
    
}

class HomeRepository: HomeRepositoryProtocol {
    
    private let fileName: String
    
    init(fileName: String = "texts") {
        self.fileName = fileName
    }
    
    private var documentPath: URL? {
        FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
    }
    
    private var filePath: URL? {
        documentPath?.appendingPathComponent(fileName)
    }
    
    func loadTexts(completion: @escaping ([TextData]) -> Void) {
        DispatchQueue.global().async { [weak self] in
            guard let self = self else { return }
            let decoder = JSONDecoder()
            if let url = self.filePath,
               let data = try? Data(contentsOf: url) {
                do {
                    let texts = try decoder.decode([TextData].self, from: data)
                    DispatchQueue.main.sync {
                        completion(texts)
                    }
                    
                } catch {
                    print(error)
                    DispatchQueue.main.sync {
                        completion([])
                    }
                }
            } else {
                DispatchQueue.main.sync {
                    completion([])
                }
            }
        }
    }
    
    func save(texts: [TextData]) {
        DispatchQueue.global().async { [weak self] in
            guard let self = self else { return }
            let encoder = JSONEncoder()
            if let jsondata = try? encoder.encode(texts),
               let url = self.filePath {
                do {
                    try jsondata.write(to: url)
                } catch {
                    print(error)
                }
            }
        }
    }
}
