//
//  Second_HelpingApp.swift
//  Second-Helping
//
//  Created by Nathan Blanchard on 9/24/24.
//

import SwiftUI
import Firebase

@main
struct Second_HelpingApp: App {
    init() {
        FirebaseApp.configure()
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
