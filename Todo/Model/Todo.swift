//
//  Todo.swift
//  Todo
//
//  Created by Yves Dukuze on 14/11/2023.
//

import Foundation

struct Todo: Codable {
    let createdAt: String
    var title, Description: String
    let Completed: Bool
    let id: String
}

extension Todo: Identifiable {}

