//
//  ContentView.swift
//  Todo
//
//  Created by Yves Dukuze on 14/11/2023.
//

import SwiftUI

enum NavigationTrack {
    case addTodos
}

struct TodosView: View {
    
    @ObservedObject var todoVm: TodoViewModel
    @State var path: [NavigationTrack] = []
    
    var body: some View {
        
        NavigationStack(path: $path) {
            
            if todoVm.error == nil {
                VStack {
                    Text("Todos")
                        .font(.title3)
                        .padding()
                        .foregroundColor(.blue)
                    Divider()
                    List {
                        ForEach(todoVm.todos.indices, id: \.self) { todoIndex in
                            NavigationLink(destination: EditTodoView(todo: $todoVm.todos[todoIndex], todoVm: TodoViewModel(networkManager: NetworkManager()))) {
                                Text(todoVm.todos[todoIndex].title)
                            }
                       }.onDelete { indexSet in
                           if let firstIndex = indexSet.first {
                               let itemIdToDelete = todoVm.todos[firstIndex].id
                               todoVm.deleteTodo(id: itemIdToDelete)
                           }
                       }
                    }
                }
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button {
                            path.append(.addTodos)
                        } label: {
                            Label("Add Todo", systemImage: "plus")
                        }
                    }
                }
                .navigationDestination(for: NavigationTrack.self) { page in
                    switch page {
                    case .addTodos:
                        AddTodoView(path: $path, todoVm: TodoViewModel(networkManager: NetworkManager()))
                    }
                }
                .onAppear {
                    todoVm.getTodos()
                }
                
                
            } else {
                ProgressView().alert(isPresented: .constant(true)){
                    Alert(title: Text("Error Occured"),message: Text("Something went wrong, Please try again later!"),
                          dismissButton: .default(Text("Ok")))
                }
            }
        }
    }
}

struct TodosView_Previews: PreviewProvider {
    static var previews: some View {
        TodosView(todoVm: TodoViewModel(networkManager: NetworkManager()))
    }
}
