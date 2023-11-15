//
//  TodViewModel.swift
//  Todo
//
//  Created by Yves Dukuze on 14/11/2023.
//

//let endPoint = "https://jsonplaceholder.typicode.com/"
//
//final class TodoViewModel: ObservableObject {
//    
//     func getTodos(completionHandler: @escaping ([Todo])->Void) {
//        let urlString = endPoint + "todos/"
//        
//        if let url = URL.init(string: urlString) {
//            let task = URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) in
//                print(String.init(data: data!, encoding: .ascii) ?? "no data")
//                if let newMusic = try? JSONDecoder().decode([Todo].self, from: data!) {
//                    completionHandler(newMusic)
//                }
//            })
//            task.resume()
//        }
//    }
//}


