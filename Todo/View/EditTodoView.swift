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
                    .frame(height:200.0)
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
        }.padding()
        
        Spacer()
    }
    
    
}

//struct EditTodoView_Previews: PreviewProvider {
//    static var previews: some View {
//        EditTodoView(todo: <#Binding<Todo>#>)
//    }
//}
