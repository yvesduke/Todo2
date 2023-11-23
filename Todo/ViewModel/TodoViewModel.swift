//
//  TodViewModel.swift
//  Todo
//
//  Created by Yves Dukuze on 14/11/2023.
//

import SwiftUI


final class TodoViewModel: ObservableObject {
    
    @Published var todos: [Todo] = []
    @Published var error: NetworkError?
    
    var networkManager: Networkable
    
    init(networkManager: Networkable) {
        self.networkManager = networkManager
    }
    
    func getTodos() {
        networkManager.getTodos { result in
            switch result {
            case .success(let data):
                print("Data Received \(data)")
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
            case .failure(let error):
                print("Error \(error.localizedDescription)")
                DispatchQueue.main.async {
                    self.error = .apiError
                    print("Error decoding JSON: \(error)")
                }
            }
        }
    }
    
    func addTodo(_ request: Todo) {
        networkManager.addTodo(request) { result in
            switch result {
            case .success(let data):
                print("Receive data: \(data.count)")
                DispatchQueue.main.async {
                    self.error = nil
                }
                self.getTodos()
            case .failure(let error):
                print("Error: \(error.localizedDescription)")
                DispatchQueue.main.async {
                    self.error = .apiError
                }
            }
        }
    }
    
    func updateTodo(todo: Todo) {
        networkManager.updateTodo(todo: todo) { result in
            switch result {
            case .success(let data):
                print("Received data \(data)")
                DispatchQueue.main.async {
                    self.error = nil
                }
            case .failure(let error):
                print("Error: \(error.localizedDescription)")
                DispatchQueue.main.async {
                    self.error = .apiError
                }
            }
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
                    self.error = .apiError
                }
            }
        }
        task.resume()
    }
}
