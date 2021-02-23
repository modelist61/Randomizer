//
//  RunningScrView.swift
//  PoniRunning
//
//  Created by Dmitry Tokarev on 10.02.2021.
//

import SwiftUI

struct RunningScrView: View {
    
    @StateObject private var ponyCount = RunningScreenViewModel()
    
    var body: some View {
        NavigationView {
            ScrollView {
                
                Text("\(ponyCount.pony)")
                    .font(.largeTitle)

            }
            .navigationBarTitle("Pony Running")
            .navigationBarItems(trailing: Button("Refresh") {
                ponyCount.changeCount()
            })
        }
    }
}

struct RunningScrView_Previews: PreviewProvider {
    static var previews: some View {
        RunningScrView()
    }
}
