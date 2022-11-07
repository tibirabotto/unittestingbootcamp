//
//  ContentView.swift
//  UnitTestingBootcamp
//
//  Created by Tibirica Neto on 2022-11-07.
//

import SwiftUI


struct ContentView: View {
    
    @StateObject private var vm: UnitTestingBootcampModel
    
    init(isPremium: Bool) {
        _vm = StateObject(wrappedValue: UnitTestingBootcampModel(isPremium: isPremium))
    }
    
    var body: some View {
        Text(vm.isPremium.description)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(isPremium: true)
    }
}
