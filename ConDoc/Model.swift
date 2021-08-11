//
//  Model.swift
//  Model
//
//  Created by Philip Pegden on 11/08/2021.
//

import Foundation

struct Record: Codable, Identifiable {
	let id: UUID
	var value: Int
	
	init(value: Int) {
		self.id = UUID()
		self.value = value
	}
}

actor RecordsModel: Decodable {
	var records: [Record] = []
	
	enum CodingKeys: String, CodingKey {
		case records
	}
	
	init() {}
	
	init(from decoder: Decoder) async throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		self.records = try values.decode([Record].self, forKey: .records)
	}
	
	// Unable to conform to Encodable at present with this implementation
	func encode(to encoder: Encoder) async throws {
		var container = encoder.container(keyedBy: CodingKeys.self)
		try container.encode(records, forKey: .records)
	}
		
	func addRecord() -> [Record] {
		self.records.append(Record(value: Int.random(in: 0...10))) // Assume it takes a long time to compute `value`
		return self.records
	}
}

@MainActor
class RecordsViewModel: ObservableObject {
	@Published var records: [Record]
	private let recordsModel: RecordsModel
	
	init() {
		self.records = []
		self.recordsModel = RecordsModel()
	}
	
	init(fromRecordsModel recordsModel: RecordsModel) async {
		self.records = await recordsModel.records
		self.recordsModel = recordsModel
	}
	
	func addRecord() {
		// Given addRecord takes time to complete, we run it in the background
		Task {
			self.records = await recordsModel.addRecord()
		}
	}
}
