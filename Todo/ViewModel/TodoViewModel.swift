//
//  TodViewModel.swift
//  Todo
//
//  Created by Yves Dukuze on 14/11/2023.
//

import Combine
import Foundation
import SwiftUI

let endPoint = "https://62bc4a356b1401736cf7083b.mockapi.io/"

protocol Networkable {
    func getTodos()
    func addTodo(_ request: Todo)
    func updateTodo(todo: Todo)
    func deleteTodo(id: String)
}

final class TodoViewModel: ObservableObject, Networkable {

    @Published var todos: [Todo] = []
    @Published var error: NetworkError?

    func getTodos() {
        let urlString = endPoint + "todo/"
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
    
    
    func addTodo(_ request: Todo) {
        let urlString = endPoint + "todo"
        var req = URLRequest.init(url: URL.init(string: urlString)!)
        req.httpMethod = "POST"
        req.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted // makes json data more readable
        
        do {
            let jsonData = try encoder.encode(request)
            req.httpBody = jsonData
        } catch {
            print("Error  encodin todo object: \(error)")
        }
        let task = URLSession.shared.dataTask(with: req) { (data, response, error) in

            if let error = error {
                self.error = .apiError
                print("===>:\(String(describing: error))")
            } else if let data = data {
                let responseString = String(data: data, encoding: .utf8)
            }
        }
        task.resume()
    }
    
    

    
    func updateTodo(todo: Todo) {
        
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        
        do {
            let urlString = endPoint + "todo/\(todo.id)"
            let jsonData = try encoder.encode(todo)
            var req = URLRequest.init(url: URL.init(string: urlString)!)
            req.httpMethod = "PUT"
            req.addValue("application/json", forHTTPHeaderField: "Content-Type")
            req.httpBody = jsonData
            
            let task = URLSession.shared.dataTask(with: req) { (data, response, error) in
                if let error = error {
                    self.error = .apiError
                    print(error)
                } else if let data = data {
                    let responseString = String(data: data, encoding: .utf8)
                    print("Response: \(responseString ?? "")")
                    DispatchQueue.main.async {
                        self.error = nil
                        print("Todo Updated Successfuly !")
                    }
                }
//                if let response = response as? HTTPURLResponse, 200  ~= response.statusCode {
//                    print("Delete response is Successfuly : \(response.statusCode)")
//                    self.getTodos()
//                    DispatchQueue.main.async {
//                        self.error = nil
//                    }
//                } else {
//                    DispatchQueue.main.async {
//                        self.error = .invalidURL
//                    }
//                }
            }
            task.resume()
        } catch {
            print("Error encoding Todo object: \(error)")
        }
    }
    
    
    func deleteTodo(id: String) {
        
        print("Attempting to delete a todo with an Id : \(id)")
        let urlString = endPoint + "todo/\(id)"
        var req = URLRequest.init(url: URL.init(string: urlString)!)
        req.httpMethod = "DELETE"

        let task = URLSession.shared.dataTask(with: req) { (data, response, error) in
            if let response = response as? HTTPURLResponse, 200  ~= response.statusCode {
                print("Delete response is Successfuly : \(response.statusCode)")
                self.getTodos()
                DispatchQueue.main.async {
                    self.error = nil
                }
            } else {
                DispatchQueue.main.async {
                    self.error = .invalidURL
                }
            }
        }
        task.resume()
    }
}
