//
//  RunningScrViewModel.swift
//  PoniRunning
//
//  Created by Dmitry Tokarev on 10.02.2021.
//

import Foundation

class RunningScreenViewModel: ObservableObject {
    @Published var pony = 999
    
    func changeCount() {
        pony = pony == 999 ? 100 : 999
    }
}
