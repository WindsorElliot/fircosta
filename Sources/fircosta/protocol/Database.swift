//
//  Database.swift
//  
//
//  Created by Elliot Cunningham on 13/12/2021.
//

import Foundation
import FirebaseDatabase

public protocol FircostaDatabase {
    @available(iOS 15.0.0, *)
    func observeSingleEvent<C: Codable>(of: DataEventType) async throws -> C
    @available(iOS 15.0.0, *)
    func updateChildValues<C: Codable>(_ values: C) async throws -> DatabaseReference
    @available(iOS 15.0.0, *)
    func removeValues() async throws -> DatabaseReference
    
    func observeEvent<C: Codable>(of: DataEventType, onEvent: @escaping(_ value: C) -> Void, onError: ((Error) -> Void)?) -> DatabaseHandle
    
    func observeSingleEvent<C: Codable>(of: DataEventType, completion: @escaping(Result<C, Error>) -> Void)
    func updateChildValues<C: Codable>(_ values: C, completion: @escaping(Result<DatabaseReference, Error>) -> Void)
    func removeValue(completion: @escaping(_ error: Error?) -> Void)
}
