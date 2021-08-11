//
//  Model.swift
//  Model
//
//  Created by Philip Pegden on 11/08/2021.
//

import Foundation
import SwiftUI

struct Record: Codable, Identifiable {
	let id: UUID
	var value: Int
	
	init(value: Int) {
		self.id = UUID()
		self.value = value
	}
}

actor Records: Decodable {
	var records: [Record] = []
	
	enum CodingKeys: String, CodingKey {
		case records
	}
	
	init() {}
	
	init(from decoder: Decoder) async throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		self.records = try values.decode([Record].self, forKey: .records)
	}
	
	func encode(to encoder: Encoder) throws {
		var container = encoder.container(keyedBy: CodingKeys.self)
		try container.encode(records, forKey: .records)
	}
		
	func addValue() -> [Record] {
		self.records.append(Record(value: Int.random(in: 0...10))) // Assume it takes a long time to compute `value`
		return self.records
	}
}

@MainActor
class RecordsViewModel: ObservableObject {
	@Published var records: [Record]
	private let store: Records
	
	init() {
		self.records = []
		self.store = Records()
	}
	
	init(fromStore store: Records) async {
		self.records = await store.records
		self.store = store
	}
	
	func addValue() {
		Task {
			self.records = await store.addValue()
		}
	}
}
