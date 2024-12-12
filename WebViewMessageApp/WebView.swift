//
//  WebView.swift
//  WebViewMessageApp
//
//  Created by shing.hikaru on 2024/12/09.
//

import SwiftUI
import WebKit

struct WebView: UIViewRepresentable {
    func makeUIView(context: Context) -> WKWebView {
        let contentController = WKUserContentController()
        contentController.add(context.coordinator, name: "iosListener")
        
        let config = WKWebViewConfiguration()
        config.userContentController = contentController
        
        let webView = WKWebView(frame: .zero, configuration: config)
        
        // ローカルのHTMLファイルをロードする
        if let filePath = Bundle.main.path(forResource: "index", ofType: "html") {
            let fileURL = URL(fileURLWithPath: filePath)
            webView.loadFileURL(fileURL, allowingReadAccessTo: fileURL.deletingLastPathComponent())
        }
        
        return webView
    }

    func updateUIView(_ uiView: WKWebView, context: Context) {}
    
    func makeCoordinator() -> Coordinator {
        Coordinator()
    }
    
    class Coordinator: NSObject, WKScriptMessageHandler {
        func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
            if message.name == "iosListener", let messageBody = message.body as? String {
                // Web側から以下のスクリプトが実行されたタイミングで、以下のログ出力が実行されるようにする
                print("Received message from JavaScript: \(messageBody)")
            }
        }
    }
}
