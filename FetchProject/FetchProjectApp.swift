//
//  FetchProjectApp.swift
//  FetchProject
//
//  Created by Kelvin Reid on 2/4/25.
//

import SwiftUI

@main
struct FetchProjectApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
