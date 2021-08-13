//
//  Model.swift
//  Model
//
//  Created by Philip Pegden on 11/08/2021.
//

import Foundation

@globalActor
struct MyActor {
	actor ActorType { }
	
	static let shared: ActorType = ActorType()
}

struct Record: Codable, Identifiable {
	let id: UUID
	var value: Int
	
	init(_ value: Int) {
		self.id = UUID()
		self.value = value
	}
}

final class Records: ObservableObject, Codable {
	@Published var records: [Record]
	@MyActor private var iRecords: [Record]
	
	init() {
		self.records = []
		self.iRecords = []
	}
	
	enum CodingKeys: String, CodingKey { case records }
	
	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		let records = try values.decode([Record].self, forKey: .records)
		self.iRecords = records
		self.records = records
	}
	
	func encode(to encoder: Encoder) throws {
		var container = encoder.container(keyedBy: CodingKeys.self)
		try container.encode(records, forKey: .records)
	}
	
	@MyActor
	func append(_ value: Int) -> [Record] {
		self.iRecords.append(Record(value))
		return iRecords
	}
	
	func addRecord() {
		Task() {
			let newNumber = Int.random(in: 0...10) // Assume lots of processing here, hence we run it as a Task
			let newRecords = await self.append(newNumber)
			await MainActor.run { self.records = newRecords }
		}
	}
	
	
}
