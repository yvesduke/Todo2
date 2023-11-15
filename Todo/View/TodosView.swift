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
    
    @ObservedObject var todoVm = TodoViewModel()
    @State var path: [NavigationTrack] = []
    
    var body: some View {
        
        NavigationStack(path: $path) {
            
            VStack {
                Text("Todos")
                    .font(.title)
                    .padding()
                
                List(todoVm.todos, id: \.id) { todo in
                    Text(todo.title)
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
                ToolbarItem(placement: .navigationBarLeading) {
                    EditButton()
                }
            }
            .navigationTitle(Text(LocalizedStringKey("Notes")))
            .navigationDestination(for: NavigationTrack.self) { page in
                switch page {
                case .addTodos:
                    AddTodoView(path: $path)
                }
            }
            .onAppear {
                todoVm.getTodos()
            }
        }
        
    }
}

struct TodosView_Previews: PreviewProvider {
    static var previews: some View {
        TodosView()
    }
}
