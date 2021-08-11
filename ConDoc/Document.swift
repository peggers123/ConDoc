//
//  ConDocDocument.swift
//  ConDoc
//
//  Created by Philip Pegden on 11/08/2021.
//

import SwiftUI
import UniformTypeIdentifiers

extension UTType {
    static var conDocExample: UTType {
        UTType(importedAs: "com.example.conDoc")
    }
}

final class Document: ReferenceFileDocument {	
	typealias Snapshot = DocumentSnapshot
	
	static var readableContentTypes: [UTType] { [.conDocExample] }
	
	@Published var content: RecordsViewModel?
	
	init() {
		Task { await MainActor.run { self.content = RecordsViewModel() } }
	}
	
	init(configuration: ReadConfiguration) throws {
		guard let data = configuration.file.regularFileContents else {
			throw CocoaError(.fileReadCorruptFile)
		}
		let decoder = JSONDecoder()
		let store = try decoder.decode(Records.self, from: data)
		Task { self.content = await RecordsViewModel(fromStore: store) }
	}
	
	struct DocumentSnapshot { var data: Data }
	
	func snapshot(contentType: UTType) throws -> DocumentSnapshot { DocumentSnapshot(data: Data()) }
	
	func fileWrapper(snapshot: DocumentSnapshot, configuration: WriteConfiguration) throws -> FileWrapper {
		FileWrapper(regularFileWithContents: snapshot.data)
	}
}
