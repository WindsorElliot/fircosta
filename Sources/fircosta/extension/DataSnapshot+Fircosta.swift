//
//  DataSnapshot+Fircosta.swift
//  
//
//  Created by Elliot Cunningham on 13/12/2021.
//

import Foundation
import FirebaseDatabase

/* for a future implementation
enum DecodeMode {
    case noExistHasError
    case noExistHasNil
}
*/

public extension DataSnapshot {
    func decode<C: Codable>(decoder: JSONDecoder = JSONDecoder(), serializerOption: JSONSerialization.WritingOptions = .sortedKeys) throws -> C {
        guard true == self.exists() else {
            throw NSError(domain: "Firebase", code: 404, userInfo: [NSLocalizedDescriptionKey: "Error, DataSnapshot is empty"])
        }
        guard let dict = self.value as? [String: Any] else {
            throw NSError(domain: "Firebase", code: 400, userInfo: [NSLocalizedDescriptionKey: "Error, DataSnapshot is not comform to Decodable"])
        }
        
        let data = try JSONSerialization.data(withJSONObject: dict, options: serializerOption)
        let value = try decoder.decode(C.self, from: data)
        
        return value
    }
    
    static func encode<C: Codable>(_ value: C, encoder: JSONEncoder = JSONEncoder(), serializerOption: JSONSerialization.ReadingOptions = .mutableContainers) throws -> [String: Any] {
        let data = try encoder.encode(value)
        let json = try JSONSerialization.jsonObject(with: data, options: serializerOption)
        
        guard let dict = json as? [String: Any] else {
            throw NSError(domain: "Firebase", code: 400, userInfo: [NSLocalizedDescriptionKey: "Error, Codable is not comform to [String: Any]"])
        }
        
        return dict
    }
}
