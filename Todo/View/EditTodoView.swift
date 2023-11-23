//
//  EditTodoView.swift
//  Todo
//
//  Created by Yves Dukuze on 18/11/2023.
//

import SwiftUI

struct EditTodoView: View {
    
    @Binding var todo: Todo
    @StateObject var todoVm: TodoViewModel
    @State var isCompleted = false
    
    var body: some View {
        
        if todoVm.error == nil {
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
        } else {
            ProgressView().alert(isPresented: .constant(true)){
                Alert(title: Text("Error Occured"),message: Text("Something went wrong, Please try again later!"),
                      dismissButton: .default(Text("Ok")))
            }
        }
    }
    
    private func saveTodo() {
        todoVm.updateTodo(todo: Todo(createdAt: todo.createdAt, title: todo.title, Description: todo.Description, Completed: isCompleted, id: todo.id))
    }
}

struct EditTodoView_Previews: PreviewProvider {
    static var previews: some View {
        EditTodoView(todo: .constant(Todo(createdAt: "", title: "", Description: "", Completed: false, id: "")) , todoVm: TodoViewModel(networkManager: NetworkManager()))
    }
}
