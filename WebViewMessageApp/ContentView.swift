//
//  ContentView.swift
//  WebViewMessageApp
//
//  Created by shing.hikaru on 2024/12/09.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        WebView()
            .ignoresSafeArea(.container, edges: .all)
    }
}

#if DEBUG

#Preview {
    ContentView()
}

#endif
