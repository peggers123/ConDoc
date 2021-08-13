//
//  Document.swift
//  ConDoc
//
//  Created by Philip Pegden on 11/08/2021.
//

import SwiftUI
import UniformTypeIdentifiers

extension UTType {
    static var conDocExample: UTType { UTType(importedAs: "com.example.condoc") }
}

final class Document: ReferenceFileDocument {
	
	@Published var content: Records
	
	init() { self.content = Records() }
	
	static var readableContentTypes: [UTType] { [.conDocExample] }
	
	init(configuration: ReadConfiguration) throws {
		guard let data = configuration.file.regularFileContents else {
			throw CocoaError(.fileReadCorruptFile)
		}
		self.content = try JSONDecoder().decode(Records.self, from: data)
	}
	
	struct DocumentSnapshot { var data: Data }
	
	typealias Snapshot = DocumentSnapshot
	
	func snapshot(contentType: UTType) throws -> DocumentSnapshot {
		DocumentSnapshot(data: try JSONEncoder().encode(self.content))
	}
	
	func fileWrapper(snapshot: DocumentSnapshot, configuration: WriteConfiguration) throws -> FileWrapper {
		FileWrapper(regularFileWithContents: snapshot.data)
	}
}
