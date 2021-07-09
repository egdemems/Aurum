//
//  pointApp.swift
//  point
//
//  Created by Harrison Sherwood on 7/3/21.
//

import SwiftUI
import Firebase

@main
struct pointApp: App {
    
    init() {
        FirebaseApp.configure()
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
