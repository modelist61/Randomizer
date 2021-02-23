//
//  Extensions.swift
//  PonyRunning
//
//  Created by Dmitry Tokarev on 12.02.2021.
//

import SwiftUI

let screenWidth = (UIScreen.main.bounds.width - 16)
let screenHeight = UIScreen.main.bounds.height
let mainTimer = Timer
    .publish(every: 0.25, on: .main, in: .common)
    .autoconnect()

//let startOffSet: CGFloat = -180
