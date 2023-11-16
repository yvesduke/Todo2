//
//  LocalTodo.swift
//  Todo
//
//  Created by Yves Dukuze on 15/11/2023.
//

import Foundation

var localTodos: [LocalTodo] = []

struct LocalTodo: Codable {
    var id = UUID()
    let title: String
}
