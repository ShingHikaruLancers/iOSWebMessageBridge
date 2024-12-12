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
        // リスナーを付与
        let contentController = WKUserContentController()
        contentController.add(context.coordinator, name: "iosListener")
        
        let config = WKWebViewConfiguration()
        config.userContentController = contentController
        
        let webView = WKWebView(frame: .zero, configuration: config)
        
        // 今回はプロジェクトローカルに存在するindex.htmlをロードするように設定
        // 以下のようなファイルのパスが取得できる
        // ../../../WebViewMessageApp.app/index.html
        if let filePath = Bundle.main.path(forResource: "index", ofType: "html") {
            // filePathに変換する
            // file:///../../../../WebViewMessageApp.app/index.html
            let fileURL = if #available(iOS 16.0, *) {
                URL(filePath: filePath, directoryHint: .notDirectory) 
            } else {
                URL(fileURLWithPath: filePath)
            }
            // 今回の場合、index.htmlファイルへのアクセス権限のみ必要であるため、index.htmlファイルへの読み取り権限を付与しているが、CSS, JSなどの他のWebコンテンツがある場合、アプリのディレクトリに対する権限付与が必要になるため、以下のように変更。
            // fileURL -> fileURL.deletingLastPathComponent()
            webView.loadFileURL(fileURL, allowingReadAccessTo: fileURL)
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
