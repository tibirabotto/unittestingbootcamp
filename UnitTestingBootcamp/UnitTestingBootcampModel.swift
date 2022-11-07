//
//  UnitTestingBootcampModel.swift
//  UnitTestingBootcamp
//
//  Created by Tibirica Neto on 2022-11-07.
//

import Foundation
import SwiftUI
import Combine


class UnitTestingBootcampModel: ObservableObject {
    
    @Published var isPremium: Bool
    @Published var dataArray: [String] = []
    @Published var seletedItem: String? = nil
    var cancellables = Set<AnyCancellable>()
    
    let dataService: NewDataServiceProtocol
    
    init(isPremium: Bool, dataService: NewDataServiceProtocol = NewMockDataService(items: nil)) {
        self.isPremium = isPremium
        self.dataService = dataService
    }
    
    func addItem(item: String) {
        guard !item.isEmpty else {return}
        self.dataArray.append(item)
    }
    
    func seletedItem(item: String) {
        if let x = dataArray.first(where: { $0 == item }) {
            seletedItem = x
        } else {
            seletedItem = nil
        }
    }
    
    func saveItem(item: String) throws {
        guard !item.isEmpty else {
            throw DataError.noData
        }
        
        if let x = dataArray.first(where: { $0 == item }) {
            print("Save item here!!! \(x)")
        } else {
            throw DataError.itemNotFound
        }
    }
    
    enum DataError: LocalizedError {
        case noData
        case itemNotFound
    }
    
    func downloadWithEscaping() {
        dataService.downloadItemWithEscaping { [weak self] returnedItems in
            self!.dataArray = returnedItems
        }
    }
    
    func downloadItemWithCombine() {
        dataService.downloadItemWithCombine()
            .sink { _ in
                
            } receiveValue: { [weak self] returnedItems in
                self!.dataArray = returnedItems
            }
            .store(in: &cancellables)

    }
}
