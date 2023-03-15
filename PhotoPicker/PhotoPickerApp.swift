//
//  PhotoPickerApp.swift
//  PhotoPicker
//
//  Created by Mesut Aygün on 14.03.2023.
//

import SwiftUI

@main
struct PhotoPickerApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(UserViewModel())
        }
    }
}
