//
//  HomeRepositoryTests.swift
//  IntroductionIOSTests
//
//  Created by Jonas Freres on 22/02/2022.
//

import XCTest
@testable import IntroductionIOS

class HomeRepositoryTests: XCTestCase {

    func testStorage() throws {
        // Given
        let repository = HomeRepository(fileName: "test-storage-1")
        let data = TextData(id: "1", text: "text 1")
        let expected = TextData(id: "1", text: "text 1")
        var result: [TextData] = []
        
        // When
        repository.save(texts: [data])
        sleep(1)
        let expectation = expectation(description: "Read correct value")
        
        repository.loadTexts { texts in
            result = texts
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 2)
        
        
        // Then
        XCTAssertEqual(result.count, 1)
        XCTAssertEqual(result.first?.id, expected.id)
        XCTAssertEqual(result.first?.text, expected.text)
    }
}
