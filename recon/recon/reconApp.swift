//
//  reconApp.swift
//  recon
//
//  Created by Dreamfora on 2023/04/14.
//

import SwiftUI

@main
struct reconApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            MainView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
