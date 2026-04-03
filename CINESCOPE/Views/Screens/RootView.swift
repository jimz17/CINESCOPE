//
//  RootView.swift
//  CINESCOPE
//
//  Created by Jimmy Aguilar on 4/3/26.
//

import SwiftUI

struct RootView: View {

    @StateObject private var authManager = AuthManager()

    var body: some View {
        Group {
            if authManager.isLoggedIn {
                ContentView(onLogout: {
                    Task {
                        await authManager.logOut()
                    }
                })
            } else {
                AuthView(onAuthenticated: {
                    authManager.isLoggedIn = true
                })
            }
        }
        .task {
            authManager.restoreSession()
        }
    }
}
