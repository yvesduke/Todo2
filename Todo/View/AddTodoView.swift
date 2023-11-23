//
//  AddTodoView.swift
//  Todo
//
//  Created by Yves Dukuze on 15/11/2023.
//

import SwiftUI
import Foundation

struct AddTodoView: View {
    
    @State var title: String = ""
    @State var description: String = ""
    
    @Binding var path: [NavigationTrack]
    @StateObject var todoVm = TodoViewModel(networkManager: NetworkManager())

    var body: some View {
        
        VStack {
            TextField("Title", text: $title)
                .padding()
                .background(Color.gray.opacity(0.2))
                .cornerRadius(8)
                .padding(.horizontal)
            ZStack(alignment: .topLeading) {
                TextEditor(text: $description)
                    .padding()
                    .frame(height:200.0)
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(8)
                    .padding(.horizontal)
                if description.isEmpty {
                    Text("Add Desc")
                        .foregroundColor(.gray)
                        .padding(.leading, 25)
                }
            }
            .toolbar {
                ToolbarItem {
                    Button(action: saveTodos) {
                        Text("Save")
                    }
                }
            }
        }.padding()
        Spacer()
    }
    
    private func saveTodos() {
        if !title.isEmpty && !description.isEmpty {
            withAnimation {
                todoVm.addTodo(Todo(createdAt:"\(Date.now)" , title: title, Description: description, Completed: false, id: "\(UUID())"))
                path.removeLast()
            }
        }
    }
}
