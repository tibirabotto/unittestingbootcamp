//
//  NewMockDataService_Tests.swift
//  UnitTestingBootcamp_Tests
//
//  Created by Tibirica Neto on 2022-11-07.
//

import XCTest
@testable import UnitTestingBootcamp
import Combine

final class NewMockDataService_Tests: XCTestCase {
    
    var cancellables = Set<AnyCancellable>()

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        cancellables.removeAll()
    }

    func test_NewMockDataService_init_doesValuesCorrectly() {
        
        let items: [String]? = nil
        let items2: [String]? = []
        let item3: [String]? = [
            UUID().uuidString,
            UUID().uuidString,
            UUID().uuidString
        ]
        
        let dataService = NewMockDataService(items: items)
        let dataService2 = NewMockDataService(items: items2)
        let dataService3 = NewMockDataService(items: item3)
        
        XCTAssertFalse(dataService.items.isEmpty)
        XCTAssertTrue(dataService2.items.isEmpty)
        XCTAssertEqual(dataService3.items.count, item3?.count)
    }
    
    func test_NewMockDataService_downloadItemWithEscaping_doesReturnedValues() {
        
        let dataService = NewMockDataService(items: nil)
        var items: [String] = []
        let expectation = XCTestExpectation()
        
        dataService.downloadItemWithEscaping { returnedItems in
            items = returnedItems
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 5)
        XCTAssertEqual(items.count, dataService.items.count)
    }
    
    func test_NewMockDataService_downloadItemWithCombine_doesReturnedValues() {
        
        let dataService = NewMockDataService(items: nil)
        var items: [String] = []
        let expectation = XCTestExpectation()
        
        dataService.downloadItemWithCombine()
            .sink { completion in
                switch completion {
                case .finished:
                    expectation.fulfill()
                case .failure:
                    XCTFail()
                }
            } receiveValue: { returnedItems in
                items = returnedItems
            }
            .store(in: &cancellables)

        
        wait(for: [expectation], timeout: 5)
        XCTAssertEqual(items.count, dataService.items.count)
    }
    
    func test_NewMockDataService_downloadItemWithCombine_doesFail() {
        
        let dataService = NewMockDataService(items: [])
        var items: [String] = []
        let expectation = XCTestExpectation(description: "Does throw an error")
        let expectation2 = XCTestExpectation(description: "Does URLError.badServerResponse")
        
        dataService.downloadItemWithCombine()
            .sink { completion in
                switch completion {
                case .finished:
                    XCTFail()
                case .failure(let error):
                    expectation.fulfill()
                    let urlError = error as? URLError
                    XCTAssertEqual(urlError, URLError(.badServerResponse))
                    if urlError == URLError(.badServerResponse) {
                        expectation2.fulfill()
                    }
                }
            } receiveValue: { returnedItems in
                items = returnedItems
            }
            .store(in: &cancellables)

        
        wait(for: [expectation, expectation2], timeout: 5)
        XCTAssertEqual(items.count, dataService.items.count)
    }

}
