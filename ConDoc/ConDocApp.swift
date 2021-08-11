//
//  ConDocApp.swift
//  ConDoc
//
//  Created by Philip Pegden on 11/08/2021.
//

import SwiftUI

@main
struct ConDocApp: App {
    var body: some Scene {
		DocumentGroup(newDocument: Document.init) { file in
            ContentView()
				.environmentObject(file.document)
        }
    }
}
