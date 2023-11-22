//
//  EditTodoView.swift
//  Todo
//
//  Created by Yves Dukuze on 18/11/2023.
//

import SwiftUI

struct EditTodoView: View {
    
    @Binding var todo: Todo
    
    @StateObject var todoVm = TodoViewModel()
    @State var isCompleted = false
    
    var body: some View {
        
        VStack {
            TextField("Title", text: $todo.title)
                .padding()
                .background(Color.gray.opacity(0.2))
                .cornerRadius(8)
                .padding(.horizontal)
            ZStack(alignment: .topLeading) {
                TextEditor(text: $todo.Description)
                    .padding()
//                    .frame(height:200.0)
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(8)
                    .padding(.horizontal)
                    Text("Add Desc")
                        .foregroundColor(.gray)
                        .padding(.leading, 25)
            }
            .toolbar {
                ToolbarItem {
//                    Button(action: todoVm.getTodos()) {
//                        Text("Save")
//                    }
                }
            }
            Toggle("Completed", isOn: $isCompleted)
                .onTapGesture {
                    isCompleted.toggle()
                }
        }.padding()
            .toolbar {
                ToolbarItem {
                    Button(action: saveTodo) {
                        Text("Save")
                    }
                }
            }
        
        Spacer()
    }
    
    private func saveTodo() {
//        print("Updated todo ID : \(todo.id)")
        todoVm.updateTodo(todo: Todo(createdAt: todo.createdAt, title: todo.title, Description: todo.Description, Completed: isCompleted, id: todo.id))
    }
}

//struct EditTodoView_Previews: PreviewProvider {
//    static var previews: some View {
//        EditTodoView(todo: <#Binding<Todo>#>)
//    }
//}
