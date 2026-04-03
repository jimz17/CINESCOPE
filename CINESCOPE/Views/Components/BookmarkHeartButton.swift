//
//  BookmarkHeartButton.swift
//  CINESCOPE
//
//  Created by Jimmy Aguilar on 4/3/26.
//

import SwiftUI

struct BookmarkHeartButton: View {

    let isBookmarked: Bool
    let action: () -> Void

    @State private var localBookmarked: Bool

    init(isBookmarked: Bool, action: @escaping () -> Void) {
        self.isBookmarked = isBookmarked
        self.action = action
        _localBookmarked = State(initialValue: isBookmarked)
    }

    var body: some View {
        Button {
            withAnimation(.easeInOut(duration: 0.15)) {
                localBookmarked.toggle()
            }
            action()
        } label: {
            Image(systemName: localBookmarked ? "heart.fill" : "heart")
                .foregroundColor(.red)
                .padding(8)
                .background(.ultraThinMaterial)
                .clipShape(Circle())
        }
        .buttonStyle(.plain)
    }
}
