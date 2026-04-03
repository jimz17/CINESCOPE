//
//  AuthView.swift
//  CINESCOPE
//
//  Created by Jimmy Aguilar on 4/3/26.
//

import SwiftUI
import Supabase
import Auth

struct AuthView: View {

    let onAuthenticated: () -> Void

    @State private var email = ""
    @State private var password = ""
    @State private var isLoading = false
    @State private var errorMessage: String?

    var body: some View {
        VStack(spacing: 20) {

            Text("CineScope Login")
                .font(.title.bold())

            TextField("Email", text: $email)
                .textFieldStyle(.roundedBorder)
                .keyboardType(.emailAddress)
                .textInputAutocapitalization(.never)
                .autocorrectionDisabled()

            SecureField("Password", text: $password)
                .textFieldStyle(.roundedBorder)

            if let errorMessage {
                Text(errorMessage)
                    .foregroundColor(.red)
                    .font(.caption)
            }

            Button {
                Task {
                    await signIn()
                }
            } label: {
                if isLoading {
                    ProgressView()
                        .frame(maxWidth: .infinity)
                } else {
                    Text("Sign In")
                        .frame(maxWidth: .infinity)
                }
            }
            .buttonStyle(.borderedProminent)
            .disabled(isLoading)

            Button {
                Task {
                    await signUp()
                }
            } label: {
                Text("Sign Up")
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.bordered)
            .disabled(isLoading)
        }
        .padding()
    }

    private func signIn() async {
        isLoading = true
        errorMessage = nil
        defer { isLoading = false }

        do {
            try await SupabaseService.shared.client.auth.signIn(
                email: email,
                password: password
            )

            await waitForSession()
            onAuthenticated()
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    private func signUp() async {
        isLoading = true
        errorMessage = nil
        defer { isLoading = false }

        do {
            try await SupabaseService.shared.client.auth.signUp(
                email: email,
                password: password
            )

            await waitForSession()
            onAuthenticated()
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    private func waitForSession() async {
        for _ in 0..<10 {
            if SupabaseService.shared.client.auth.currentSession != nil {
                return
            }
            try? await Task.sleep(nanoseconds: 200_000_000)
        }
    }
}
