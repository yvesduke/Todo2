//
//  MockedTodoNetworkManager.swift
//  TodoTests
//
//  Created by Yves Dukuze on 23/11/2023.
//

import Foundation
@testable import Todo

class MockedTodoNetworkManager: Networkable {
    
    var isApiSuccessful = true
    
    
    func getTodos(completion: @escaping (Result<Data, Error>) -> Void) {
        
        if isApiSuccessful {
            do {
                let jsonData = try JSONEncoder().encode(Todo.mockedTodoResponse)
                completion(.success(jsonData))
            } catch {
                completion(.failure(error))
            }
        } else {
            completion(.failure(NetworkError.dataNotFound))
        }
    }
    
    func addTodo(_ request: Todo, completion: @escaping (Result<Data, Error>) -> Void) {
        if isApiSuccessful {
            do {
                let jsonData = try JSONEncoder().encode(request)
                completion(.success(jsonData))
            } catch {
                completion(.failure(error))
            }
        } else {
            completion(.failure(NetworkError.dataNotFound))
        }
    }
    
    func updateTodo(todo: Todo, completion: @escaping (Result<Data, Error>) -> Void) {
        if isApiSuccessful {
            do {
                let jsonData = try JSONEncoder().encode(todo)
                completion(.success(jsonData))
            } catch {
                completion(.failure(error))
            }
        } else {
            completion(.failure(NetworkError.dataNotFound))
        }
    }
    
    func deleteTodo(id: String, completion: @escaping (Result<Data, Error>) -> Void) {
        if isApiSuccessful {
            do {
                let jsonData = try JSONEncoder().encode(["message": "Successfully deleted todo with id: \(id)"])
                completion(.success(jsonData))
            } catch {
                completion(.failure(error))
            }
        } else {
            completion(.failure(NetworkError.dataNotFound))
        }
    }
}


extension Todo {
    
    static var mockedTodoResponse = [
        Todo(createdAt: "2023-11-18 22:52:22 +0000", title: "John Dee 123 Edited", Description: "John Dee 123 Description", Completed: false, id: "4"),
        Todo(createdAt: "2023-11-19 00:40:07 +0000", title: "Todo item 3", Description: "Todo Item 3 Description", Completed: false, id: "5"),
        Todo(createdAt: "2023-11-19 00:40:31 +0000", title: "Pick up a parcel", Description: "Pick up a parcel description", Completed: false, id: "6"),
        Todo(createdAt: "2023-11-22 09:45:16 +0000", title: "ITC Todo Edited Title", Description: "ITC Todo description Edited", Completed: false, id: "7")
    ]
    
}
