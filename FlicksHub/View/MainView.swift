//
//  MainView.swift
//  FlicksHub
//
//  Created by Lucas Remigio on 05/10/2024.
//

import SwiftUI

struct MainView: View {
    @ObservedObject var mainViewModel = MainViewModel()
    @State var searchText: String = ""
    
    var body: some View {
        Text("Movie list")
    }
}

#Preview {
    MainView()
}
