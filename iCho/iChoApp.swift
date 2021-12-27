//
//  iChoApp.swift
//  iCho
//
//  Created by Kudzaiishe Mhou on 2021/12/27.
//

import SwiftUI

@main
struct iChoApp: App {
    var gameSettings = Settings()

    var body: some Scene {
        WindowGroup {
            GameWorldView()
                .background(Image("ola").scaledToFill())
                .environmentObject(GameViewModel(from: gameSettings))
        }
    }
}
