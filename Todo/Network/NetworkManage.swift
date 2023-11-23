//
//  NetworkManage.swift
//  Todo
//
//  Created by Yves Dukuze on 23/11/2023.
//

import Foundation

let endPoint = "https://62bc4a356b1401736cf7083b.mockapi.io/"

protocol Networkable {
    
    func getTodos(completion: @escaping (Result<Data, Error>) -> Void)
    func addTodo(_ request: Todo, completion: @escaping (Result<Data, Error>) -> Void)
    func updateTodo(todo: Todo, completion: @escaping (Result<Data, Error>) -> Void)
    func deleteTodo(id: String, completion: @escaping (Result<Data, Error>) -> Void)
}

class NetworkManager: Networkable {
        
    func getTodos(completion: @escaping (Result<Data, Error>) -> Void) {
        let urlString = endPoint + "todo/"
        if let url = URL(string: urlString) {
            let task = URLSession.shared.dataTask(with: url) { data, response, error in
                
                if let error = error {
                    completion(.failure(error))
                    return
                }
                
                guard let data = data else {
                    let emptyDataError = NSError(domain: "mockapi.io", code: 42, userInfo: nil)
                    completion(.failure(emptyDataError))
                    return
                }
                completion(.success(data))
            }
            task.resume()
        }
    }
    
    
    func addTodo(_ request: Todo, completion: @escaping (Result<Data, Error>) -> Void) {
        
        let urlString = endPoint + "todo"
        var req = URLRequest.init(url: URL.init(string: urlString)!)
        req.httpMethod = "POST"
        req.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        
        do {
            let jsonData = try encoder.encode(request)
            req.httpBody = jsonData
        } catch {
            print("Error  encodin todo object: \(error)")
        }
        
        let task = URLSession.shared.dataTask(with: req) { (data, response, error) in
            
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                let emptyDataError = NSError(domain: "mockapi.io", code: 42, userInfo: nil)
                completion(.failure(emptyDataError))
                return
            }
            
            completion(.success(data))
            
        }
        task.resume()
    }
    
    
    
    
    func updateTodo(todo: Todo, completion: @escaping (Result<Data, Error>) -> Void) {
        
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
                    completion(.failure(error))
                    return
                }
                
                guard let data = data else {
                    let emptyDataError = NSError(domain: "mockapi.io", code: 42, userInfo: nil)
                    completion(.failure(emptyDataError))
                    return
                }
                
                completion(.success(data))
                
            }
            task.resume()
        } catch {
            print("Error encoding Todo object: \(error)")
        }
    }
    
    
    func deleteTodo(id: String, completion: @escaping (Result<Data, Error>) -> Void) {

        let urlString = endPoint + "todo/\(id)"
        var req = URLRequest.init(url: URL.init(string: urlString)!)
        req.httpMethod = "DELETE"
        
        let task = URLSession.shared.dataTask(with: req) { (data, response, error) in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let response = response as? HTTPURLResponse, 200  ~= response.statusCode else {
                let emptyDataError = NSError(domain: "mockapi.io", code: 42, userInfo: nil)
                completion(.failure(emptyDataError))
                return
            }
            
            guard let data = data else {
                let emptyDataError = NSError(domain: "mockapi.io", code: 42, userInfo: nil)
                completion(.failure(emptyDataError))
                return
            }
            
            completion(.success(data))
        }
        task.resume()
    }
}
