//
//  Stubable.swift
//  
//
//  Created by Elliot Cunningham on 13/12/2021.
//

import Foundation

public protocol Stubable {
    static func stub<C: Codable>() -> C
}
