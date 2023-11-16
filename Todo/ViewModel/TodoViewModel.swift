//
//  TodViewModel.swift
//  Todo
//
//  Created by Yves Dukuze on 14/11/2023.
//

import Combine
import Foundation
import SwiftUI

let endPoint = "https://jsonplaceholder.typicode.com/"


final class TodoViewModel: ObservableObject {
    
    @Published var todos: [Todo] = []
//    @Published var localTodos: [LocalTodo]?
    @Published var error: NetworkError?
    
    let defaults = UserDefaults.standard
    @Published var lcTodos: [LocalTodo] = []
        
    func getTodo(withID id : Int) {
        
        let urlString = endPoint + "todos/\(id)"
        
        if let url = URL.init(string: urlString) {
            let task = URLSession.shared.dataTask(with: url) { data, response, error in
                
                if let _ = error {
                    self.error = .apiError
                    print("===>:\(String(describing: error))")
                    return
                }
                
                if let data = data {
                    do {
                        let newTodos = try JSONDecoder().decode([Todo].self, from: data)
                        DispatchQueue.main.async {
                            self.todos = newTodos
                            self.error = nil
                        }
                    } catch {
                        DispatchQueue.main.async {
                            self.error = .apiError
                            print("Error decoding JSON: \(error)")
                        }
                    }
                }
            }
            task.resume()
        }
    }
    
    func getTodos() {
        
        let urlString = endPoint + "todos/"
        
        if let url = URL(string: urlString) {
            let task = URLSession.shared.dataTask(with: url) { data, response, error in
                
                if let _ = error {
                    self.error = .dataNotFound
                    print("===>:\(String(describing: error))")
                    return
                }
                
                if let data = data {
                    do {
                        let newTodos = try JSONDecoder().decode([Todo].self, from: data)
                        DispatchQueue.main.async {
                            // add newly added todo in the the new list or add it innto a user default
                            self.todos = newTodos
                            self.error = nil
                        }
                    } catch {
                        DispatchQueue.main.async {
                            self.error = .apiError
                            print("Error decoding JSON: \(error)")
                        }
                    }
                }
            }
            task.resume()
        }
    }
    
    private func decodeMixedDictionary(from jsonString: String, todo: Todo) throws -> [String: Todo] {
        guard let jsonData = jsonString.data(using: .utf8) else {
            throw NetworkError.parsingError
        }
        do {
            if let jsonObject = try JSONSerialization.jsonObject(with: jsonData, options: []) as? [String: Any] {
                var resultDictionary: [String: Todo] = [:]
                for (key, value) in jsonObject {
                    if value is Int {
                        resultDictionary[key] = todo
                    } else if let todoDict = value as? [String: Any],
                              let todoData = try? JSONSerialization.data(withJSONObject: todoDict),
                              let todo = try? JSONDecoder().decode(Todo.self, from: todoData) {
                        resultDictionary[key] = todo
                    }
                }
                return resultDictionary
            } else {
                throw NetworkError.parsingError
            }
        } catch {
            throw error
        }
    }

    
    func getLocalTodos() {
        if let decodedTodo = try? JSONDecoder().decode([LocalTodo].self, from: defaults.object(forKey: "Todos") as? Data ?? Data()) {
            self.lcTodos = decodedTodo
        }
    }
    
    
    func addTodo(_ request: Todo) {
        let urlString = endPoint + "todos"
        var req = URLRequest.init(url: URL.init(string: urlString)!)
        req.httpMethod = "POST"
        req.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        req.setValue("application/json", forHTTPHeaderField: "Accept")
        req.httpBody = try? JSONEncoder().encode(request)
        
        let task = URLSession.shared.dataTask(with: req) { (data, response, error) in
            
            if let _ = error {
                self.error = .apiError
                print("===>:\(String(describing: error))")
                return
            }
            
            if let data = data {
                let newTodo = String(data: data, encoding: .ascii)
                if let newTodo = newTodo {
                    do {
                        let decodedDictionary = try self.decodeMixedDictionary(from: newTodo, todo: Todo(userId: request.userId, id: request.id, title: request.title, completed: request.completed))
                        
                        for (_, value) in decodedDictionary {
                            if let title = value.title {
                                DispatchQueue.main.async {
                                    localTodos.append(LocalTodo(title: title))
                                    
                                    if let encodedTodo = try? JSONEncoder().encode(localTodos) {
                                        self.defaults.set(encodedTodo, forKey: "Todos")
                                    }
                                }
                            }
                        }
                    } catch {
                        print("error \(error)")
                    }
                }
            }
        }
        task.resume()
    }
    
    
    func updateTodo(id: Int) {
        print("Attempting to Update a todo")
//        let urlString = endPoint + "todos/\(id)"
//
//        var req = URLRequest.init(url: URL.init(string: urlString)!)
//        req.httpMethod = "PUT"
//        req.httpBody = try? JSONEncoder().encode()
//
//        let task = URLSession.shared.dataTask(with: req) { (data, response, error) in
//            print (String.init(data: data!, encoding: .ascii) ?? "no data")
//        }
//        task.resume()
    }
    
    func deleteTodo(id: Int) {
        
        print("Attempting to delete a todo")
//        let urlString = endPoint + "todos/\(id)"
//
//        var req = URLRequest.init(url: URL.init(string: urlString)!)
//        req.httpMethod = "DELETE"
//
//        let task = URLSession.shared.dataTask(with: req) { (data, response, error) in
//            print (String.init(data: data!, encoding: .ascii) ?? "no data")
//        }
//        task.resume()
    }
    
    
}
