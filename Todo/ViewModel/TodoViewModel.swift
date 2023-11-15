//
//  TodViewModel.swift
//  Todo
//
//  Created by Yves Dukuze on 14/11/2023.
//

import Combine
import Foundation

let endPoint = "https://jsonplaceholder.typicode.com/"


final class TodoViewModel: ObservableObject {
    
    @Published var todos: [Todo] = []
    
    func getTodo(withID id : Int) {
        
        let urlString = endPoint + "todos/\(id)"
        
        if let url = URL.init(string: urlString) {
            let task = URLSession.shared.dataTask(with: url) { data, response, error in
                if let data = data {
                    do {
                        let newTodos = try JSONDecoder().decode([Todo].self, from: data)
                        DispatchQueue.main.async {
                            self.todos = newTodos
                        }
                    } catch {
                        print("Error decoding JSON: \(error)")
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
                if let data = data {
                    do {
                        let newTodos = try JSONDecoder().decode([Todo].self, from: data)
                        DispatchQueue.main.async {
                            self.todos = newTodos
                        }
                    } catch {
                        print("Error decoding JSON: \(error)")
                    }
                }
            }
            task.resume()
        }
    }
    
    
    func addTodo(_ request: Todo) {
        print("Attempting to add a todo")
        let urlString = endPoint + "todos/"
        
        var req = URLRequest.init(url: URL.init(string: urlString)!)
        req.httpMethod = "POST"
        req.httpBody = try? JSONEncoder().encode(request)
        
        let task = URLSession.shared.dataTask(with: req) { (data, response, error) in
            print (String.init(data: data!, encoding: .ascii) ?? "no data")
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
