//
//  HomeInteracorTests.swift
//  IntroductionIOSTests
//
//  Created by Jonas Freres on 22/02/2022.
//

import XCTest
@testable import IntroductionIOS

class HomeInteractorTests: XCTestCase {
    
    class MockRepository: HomeRepositoryProtocol {
        var texts: [TextData] = []
        
        func loadTexts(completion: @escaping ([TextData]) -> Void) {
            completion(texts)
        }
        
        func save(texts: [TextData]) {
            self.texts = texts
        }
    }
    

    func testLoadingNoData() throws {
        // Given
        let repository = MockRepository()
        let interacor = HomeInteractor(repository: repository)
       
        var result: [TextViewData] = []
        
        // When
        let expectation = expectation(description: "Load data")
        interacor.loadAllTexts { texts in
            result = texts
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 0.5)
        
        
        // Then
        XCTAssertEqual(result.count, 0)
    }
    
    func testLoadingWithData() throws {
        // Given
        let data = TextData(id: "1", text: "text 1")
        let expected = TextViewData(id: "1", text: "text 1")
        
        let repository = MockRepository()
        repository.texts = [data]
        let interacor = HomeInteractor(repository: repository)
        
        var result: [TextViewData] = []
        
        // When
        let expectation = expectation(description: "Load data")
        interacor.loadAllTexts { texts in
            result = texts
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 0.5)
        
        
        // Then
        XCTAssertEqual(result.count, 1)
        XCTAssertEqual(result.first?.id, expected.id)
        XCTAssertEqual(result.first?.text, expected.text)
    }
    
    func testAddData() throws {
        // Given
        let initalData = [TextData(id: "1", text: "text 1")]
        let newData = TextViewData(id: "2", text: "text 2")
        
        let repository = MockRepository()
        repository.texts = initalData
        let interacor = HomeInteractor(repository: repository)
        
        var result: [TextViewData] = []
        
        // When
        let expectation = expectation(description: "Load data")
        interacor.saveNew(text: newData) { texts in
            result = texts
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 0.5)
        
        
        // Then
        XCTAssertEqual(result.count, 2)
        XCTAssertEqual(result.first?.id, "1")
        XCTAssertEqual(result.last?.id, "2")
    }
    
    func testRemoveData() throws {
        // Given
        let initalData = [TextData(id: "1", text: "text 1"),
                          TextData(id: "2", text: "text 2")]
        let dataToRemove = TextViewData(id: "2", text: "text 2")
        
        let repository = MockRepository()
        repository.texts = initalData
        let interacor = HomeInteractor(repository: repository)
        
        var result: [TextViewData] = []
        
        // When
        let expectation = expectation(description: "Load data")
        interacor.delete(text: dataToRemove) { texts in
            result = texts
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 0.5)
        
        
        // Then
        XCTAssertEqual(result.count, 1)
        XCTAssertEqual(result.first?.id, "1")
    }
}
