//
//  AuthManager.swift
//  CINESCOPE
//
//  Created by Jimmy Aguilar on 4/3/26.
//


import Foundation
import Combine
import Supabase
import Auth

@MainActor
final class AuthManager: ObservableObject {

    @Published var isLoggedIn = false

    func restoreSession() {
        isLoggedIn = SupabaseService.shared.client.auth.currentSession != nil
    }

    func logOut() async {
        do {
            try await SupabaseService.shared.client.auth.signOut()
        } catch {
            print("Logout error:", error)
        }

        isLoggedIn = false
    }
}
