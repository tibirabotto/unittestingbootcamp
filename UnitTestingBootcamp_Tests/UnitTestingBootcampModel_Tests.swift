//
//  UnitTestingBootcampModel_Tests.swift
//  UnitTestingBootcamp_Tests
//
//  Created by Tibirica Neto on 2022-11-07.
//

import XCTest
@testable import UnitTestingBootcamp
import Combine

final class UnitTestingBootcampModel_Tests: XCTestCase {
    
    var viewModel: UnitTestingBootcampModel?
    var cancellables = Set<AnyCancellable>()

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        viewModel = UnitTestingBootcampModel(isPremium: Bool.random())
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        viewModel = nil
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        // Any test you write for XCTest can be annotated as throws and async.
        // Mark your test throws to produce an unexpected failure when your test encounters an uncaught error.
        // Mark your test async to allow awaiting for asynchronous code to complete. Check the results with assertions afterwards.
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
    func test_UnitTestingBootcampViewModel_isPremium_shouldBeTrue() {
        let userIsPremium: Bool = true
        
        let vm = UnitTestingBootcampModel(isPremium: userIsPremium)
        
        
        XCTAssertTrue(vm.isPremium)
    }
    
    func test_UnitTestingBootcampViewModel_isPremium_shouldBeFalse() {
        let userIsPremium: Bool = false
        
        let vm = UnitTestingBootcampModel(isPremium: userIsPremium)
        
        XCTAssertFalse(vm.isPremium)
    }
    
    func test_UnitTestingBootcampViewModel_isPremium_shouldBeInjectedValue() {
        let userIsPremium: Bool = Bool.random()
        
        let vm = UnitTestingBootcampModel(isPremium: userIsPremium)
        
        XCTAssertEqual(vm.isPremium, userIsPremium)
    }
    
    func test_UnitTestingBootcampViewModel_isPremium_shouldBeInjectedValue_stress() {
        
        for _ in 0..<10 {
            let userIsPremium: Bool = Bool.random()
            
            let vm = UnitTestingBootcampModel(isPremium: userIsPremium)
            
            XCTAssertEqual(vm.isPremium, userIsPremium)
        }
        
    }
    
    func test_UnitTestingBootcampViewModel_dataArray_shouldBeEmpty() {
        
        let vm = UnitTestingBootcampModel(isPremium: Bool.random())
        
        XCTAssertTrue(vm.dataArray.isEmpty)
        XCTAssertEqual(vm.dataArray.count, 0)
    }
    
    func test_UnitTestingBootcampViewModel_dataArray_shouldAddItems() {
        
        let vm = UnitTestingBootcampModel(isPremium: Bool.random())
        
        let loopCount: Int = Int.random(in: 1..<100)
        
        for _ in 0..<loopCount {
            vm.addItem(item: UUID().uuidString)
        }
        
        XCTAssertTrue(!vm.dataArray.isEmpty)
        XCTAssertFalse(vm.dataArray.isEmpty)
        XCTAssertEqual(vm.dataArray.count, loopCount)
        XCTAssertNotEqual(vm.dataArray.count, 0)
        XCTAssertGreaterThan(vm.dataArray.count, 0)
    }
    
    func test_UnitTestingBootcampViewModel_dataArray_shouldNotBlankString() {
        
        let vm = UnitTestingBootcampModel(isPremium: Bool.random())
        
        vm.addItem(item: "")
        
        
        XCTAssertTrue(vm.dataArray.isEmpty)
    }
    
    func test_UnitTestingBootcampViewModel_dataArray_shouldNotBlankString2() {
        
        guard let vm = viewModel else {
            XCTFail()
            return
        }
        
        
        vm.addItem(item: "")
        
        XCTAssertTrue(vm.dataArray.isEmpty)
    }
    
    func test_UnitTestingBootcampViewModel_seletedItem_shouldStartAsNil() {
        
        let vm = UnitTestingBootcampModel(isPremium: Bool.random())
        
        
        XCTAssertTrue(vm.seletedItem == nil)
        XCTAssertNil(vm.seletedItem)
    }
    
    func test_UnitTestingBootcampViewModel_seletedItem_shouldBeNilSelectingInvalidItem() {
        
        let vm = UnitTestingBootcampModel(isPremium: Bool.random())
        
        
        let newItem = UUID().uuidString
        vm.addItem(item: newItem)
        vm.seletedItem(item: newItem)
        
        vm.seletedItem(item: UUID().uuidString)
        

        XCTAssertNil(vm.seletedItem)
    }
    
    func test_UnitTestingBootcampViewModel_seletedItem_shouldBeSeleted() {
        
        let vm = UnitTestingBootcampModel(isPremium: Bool.random())
        
        let newItem = UUID().uuidString
        vm.addItem(item: newItem)
        vm.seletedItem(item: newItem)
        

        XCTAssertNotNil(vm.seletedItem)
        XCTAssertEqual(vm.seletedItem, newItem)
    }
    
    func test_UnitTestingBootcampViewModel_seletedItem_shouldSeleted_stress() {
        
        let vm = UnitTestingBootcampModel(isPremium: Bool.random())
        
        let loopCount: Int = Int.random(in: 1..<100)
        var itemsArray: [String] = []
        
        for _ in 0..<loopCount {
            let newItem = UUID().uuidString
            vm.addItem(item: newItem)
            itemsArray.append(newItem)
        }
        
        
        let randomItem = itemsArray.randomElement() ?? ""
        vm.seletedItem(item: randomItem)
        

        XCTAssertNotNil(vm.seletedItem)
        XCTAssertFalse(randomItem.isEmpty)
        XCTAssertEqual(vm.seletedItem, randomItem)
    }
    
    func test_UnitTestingBootcampViewModel_saveItem_shouldThrowError_itemNotFound() {
        
        let vm = UnitTestingBootcampModel(isPremium: Bool.random())
        
        let loopCount: Int = Int.random(in: 1..<100)
        
        
        for _ in 0..<loopCount {
            vm.addItem(item: UUID().uuidString)
        }
        
        XCTAssertThrowsError(try vm.saveItem(item: UUID().uuidString))
        
        XCTAssertThrowsError(try vm.saveItem(item: UUID().uuidString), "Should throw Item Not Found") { error in
            let returned = error as? UnitTestingBootcampModel.DataError
            XCTAssertEqual(returned, UnitTestingBootcampModel.DataError.itemNotFound)
        }
    }
    
    func test_UnitTestingBootcampViewModel_saveItem_shouldThrowError_noData() {
        
        let vm = UnitTestingBootcampModel(isPremium: Bool.random())
        
        let loopCount: Int = Int.random(in: 1..<100)
        
        
        for _ in 0..<loopCount {
            vm.addItem(item: UUID().uuidString)
        }
        
        do {
            try vm.saveItem(item: "")
        } catch let error {
            let returned = error as? UnitTestingBootcampModel.DataError
            XCTAssertEqual(returned, UnitTestingBootcampModel.DataError.noData)
        }
        
    }
    
    func test_UnitTestingBootcampViewModel_saveItem_shouldSaveItem() {
        
        let vm = UnitTestingBootcampModel(isPremium: Bool.random())
        
        let loopCount: Int = Int.random(in: 1..<100)
        var itemsArray: [String] = []
        
        for _ in 0..<loopCount {
            let newItem = UUID().uuidString
            vm.addItem(item: newItem)
            itemsArray.append(newItem)
        }
        
        
        let randomItem = itemsArray.randomElement() ?? ""
        XCTAssertFalse(randomItem.isEmpty)
        
        XCTAssertNoThrow(try vm.saveItem(item: randomItem))
        
        do {
            try vm.saveItem(item: randomItem)
        } catch {
            XCTFail()
        }
    }
    
    func test_UnitTestingBootcampViewModel_downloadWithEscaping_shouldReturnItems() {
        
        let vm = UnitTestingBootcampModel(isPremium: Bool.random())
        
        let expectation = XCTestExpectation(description: "Should retun items after3 seconds")
        
        vm.$dataArray
            .dropFirst()
            .sink { returnItems in
                expectation.fulfill()
            }
            .store(in: &cancellables)
        
        vm.downloadWithEscaping()
        
        wait(for: [expectation] , timeout: 5)
        
        XCTAssertGreaterThan(vm.dataArray.count, 0)
    }
    
    func test_UnitTestingBootcampViewModel_downloadWithCombine_shouldReturnItems() {
        
        let vm = UnitTestingBootcampModel(isPremium: Bool.random())
        
        let expectation = XCTestExpectation(description: "Should retun items after a second")
        
        vm.$dataArray
            .dropFirst()
            .sink { returnItems in
                expectation.fulfill()
            }
            .store(in: &cancellables)
        
        vm.downloadItemWithCombine()
        
        wait(for: [expectation] , timeout: 5)
        
        XCTAssertGreaterThan(vm.dataArray.count, 0)
    }

}
