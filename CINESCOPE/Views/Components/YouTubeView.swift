//
//  YouTubeView.swift
//  CINESCOPE
//
//  Created by Jimmy Aguilar on 3/11/26.
//

import SwiftUI
import WebKit

struct YouTubeView: UIViewRepresentable {

    let videoKey: String

    func makeUIView(context: Context) -> WKWebView {

        let config = WKWebViewConfiguration()
        config.allowsInlineMediaPlayback = true
        config.mediaTypesRequiringUserActionForPlayback = []

        let webView = WKWebView(frame: .zero, configuration: config)
        webView.scrollView.isScrollEnabled = false
        webView.backgroundColor = .clear
        webView.isOpaque = false

        return webView
    }

    func updateUIView(_ webView: WKWebView, context: Context) {

        let embedURL = """
        https://www.youtube.com/embed/\(videoKey)?playsinline=1&rel=0&modestbranding=1
        """

        let html = """
        <!DOCTYPE html>
        <html>
        <head>
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <style>
        body {
            margin: 0;
            background-color: black;
        }
        iframe {
            position: absolute;
            width: 100%;
            height: 100%;
            left: 0;
            top: 0;
        }
        </style>
        </head>
        <body>
        <iframe
            src="\(embedURL)"
            frameborder="0"
            allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture"
            allowfullscreen>
        </iframe>
        </body>
        </html>
        """

        webView.loadHTMLString(html, baseURL: nil)
    }
}
