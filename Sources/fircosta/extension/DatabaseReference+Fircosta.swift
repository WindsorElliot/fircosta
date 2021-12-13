//
//  DatabaseReference+Fircosta.swift
//  
//
//  Created by Elliot Cunningham on 13/12/2021.
//

import Foundation
import FirebaseDatabase

extension DatabaseReference: FircostaDatabase {
    @available(iOS 15.0.0, *)
    public func observeSingleEvent<C: Codable>(of: DataEventType) async throws -> C {
        return try await withCheckedThrowingContinuation({
            (continuation: CheckedContinuation<C, Error>) in
            self.observeSingleEvent(of: of) { snapshot in
                do {
                    let value: C = try snapshot.decode()
                    continuation.resume(returning: value)
                }
                catch {
                    continuation.resume(throwing: error)
                }
            } withCancel: { error in
                continuation.resume(throwing: error)
            }

        })
    }
    
    @available(iOS 15.0.0, *)
    public func updateChildValues<C: Codable>(_ values: C) async throws -> DatabaseReference {
        return try await withCheckedThrowingContinuation({
            (continuation: CheckedContinuation<DatabaseReference, Error>) in
            do {
                let dict = try DataSnapshot.encode(values)
                self.updateChildValues(dict) { error, ref in
                    if let error = error {
                        continuation.resume(throwing: error)
                    } else {
                        continuation.resume(returning: ref)
                    }
                }
            }
            catch {
                continuation.resume(throwing: error)
            }
        })
    }
    
    @available(iOS 15.0.0, *)
    public func removeValues() async throws -> DatabaseReference {
        return try await withCheckedThrowingContinuation({
            (continuation: CheckedContinuation<DatabaseReference, Error>) in
            self.removeValue { error in
                if let error = error {
                    continuation.resume(throwing: error)
                } else {
                    continuation.resume(returning: self.ref)
                }
            }
        })
    }
    
    public func observeEvent<C: Codable>(of: DataEventType, onEvent: @escaping(C) -> Void, onError: ((Error) -> Void)?) -> DatabaseHandle {
        self.observe(of) { snapshot in
            do {
                let value: C = try snapshot.decode()
                onEvent(value)
            }
            catch {
                if let onError = onError {
                    onError(error)
                }
            }
        } withCancel: { error in
            if let onError = onError {
                onError(error)
            }
        }

    }
    
    public func observeSingleEvent<C: Codable>(of: DataEventType, completion: @escaping (Result<C, Error>) -> Void) {
        self.observe(of) { snapshot in
            do {
                let value: C = try snapshot.decode()
                completion(.success(value))
            }
            catch {
                completion(.failure(error))
            }
        } withCancel: { error in
            completion(.failure(error))
        }
    }
    
    public func updateChildValues<C>(_ values: C, completion: @escaping (Result<DatabaseReference, Error>) -> Void) where C : Decodable, C : Encodable {
        do {
            let dict = try DataSnapshot.encode(values)
            self.updateChildValues(dict) { error, ref in
                if let error = error {
                    completion(.failure(error))
                } else {
                    completion(.success(ref))
                }
            }
        }
        catch {
            completion(.failure(error))
        }
    }
    
    public func removeValue(completion: @escaping (Error?) -> Void) {
        self.removeValue { error, _ in
            completion(error)
        }
    }
    
    
}
