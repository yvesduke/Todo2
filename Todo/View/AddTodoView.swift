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
    @State var id: Int = 9
    @State var userId: Int = 9
    @State var completed: Bool = false
    
    @Binding var path: [NavigationTrack]
    @StateObject var todoVm = TodoViewModel()
    
    
    var body: some View {
        
        VStack {
            TextField("Title", text: $title)
                .padding()
                .background(Color.gray.opacity(0.2))
                .cornerRadius(8)
                .padding(.horizontal)
                .toolbar {
                    ToolbarItem {
                        Button(action: saveTodos) {
                            Text("Save")
                        }
                    }
                }
        }
        Spacer()
    }
    
    private func saveTodos() {
        if !title.isEmpty {
            withAnimation {
                todoVm.addTodo(Todo(userId: userId, id: id, title: title, completed: completed))
                path.removeLast()
            }
        }
    }
}
