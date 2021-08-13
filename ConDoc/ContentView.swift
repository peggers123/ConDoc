//
//  ContentView.swift
//  ConDoc
//
//  Created by Philip Pegden on 11/08/2021.
//

import SwiftUI

struct ContentView: View {
	@EnvironmentObject var document: Document
	
	var body: some View {
		VStack {
			Button("Add new value") { document.content.addRecord() }
			if let content = document.content { RecordsView(content: content) }
			Spacer()
		}
		.padding()
		.frame(width: 200, height: 200)
	}
}

struct RecordsView: View {
	@ObservedObject var content: Records
	
	var body: some View {
		VStack {
			ForEach(content.records) {
				Text("\($0.value)")
			}
		}
	}
}
