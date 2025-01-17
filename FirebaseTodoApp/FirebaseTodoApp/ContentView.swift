//
//  ContentView.swift
//  FirebaseTodoApp
//
//  Created by Jonas Shoukri on 2025-01-17.
//

import SwiftUI

struct ContentView: View {
    @State private var todos: [ToDo] = []
    @State private var newTodoText: String = ""
    @State private var isLoading: Bool = false
    private let firestoreService = FirestoreService()
    
    var body: some View {
            NavigationView {
                VStack {
                    if isLoading {
                        ProgressView("Loading...")
                    } else {
                        List {
                            ForEach(todos) { todo in
                                HStack {
                                    Text(todo.title)
                                    Spacer()
                                    Button(action: {
                                        updateTodo(todo)
                                    }) {
                                            Image(systemName: todo.isCompleted ? "checkmark.circle.fill" : "circle").foregroundColor(todo.isCompleted ? .green : .red)
                                    }
                                    .buttonStyle(BorderlessButtonStyle())
                                    
                                    Button(action: {
                                        if let id = todo.id {
                                            deleteTodo(id)
                                        }
                                    }) {
                                        Image(systemName: "trash")
                                            .foregroundColor(.red)
                                    }
                                }
                            }
                        }
                    }
                    
                    TextField("New ToDo", text: $newTodoText)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding()
                    
                    Button(action: addTodos) {
                        Text("Add")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(8)
                    }
                    .padding(.horizontal, 16)
                }
                .navigationTitle("ToDos")
                .onAppear(perform: loadTodos)
            }
        }
    
    private func loadTodos() {
        isLoading = true
        firestoreService.fetchTodos { fetchedTodos, error in
            DispatchQueue.main.async {
                isLoading = false
                if let error = error {
                    print("Error fetching todos: \(error)")
                } else {
                    todos = fetchedTodos ?? []
                }
            }
        }
    }
    
    private func addTodos(){
        guard !newTodoText.isEmpty else { return }
        let newTodo = ToDo(id: nil, title: newTodoText, isCompleted: false)
        firestoreService.addTodo(newTodo) { error in
            if let error = error {
                print("Error adding todo: \(error)")
            } else {
                newTodoText = ""
                loadTodos()
            }
        }
    }
    
    private func deleteTodo(_ id: String) {
        firestoreService.deleteTodo(id) { error in
            if let error = error {
                print("Error deleting todo: \(error)")
            } else {
                loadTodos()
            }
        }
    }
    
    private func updateTodo(_ todo: ToDo){
        var updatedTodo = todo
        updatedTodo.isCompleted.toggle()
        firestoreService.updateTodo(updatedTodo) { error in
            if let error = error {
                    print("Error updating todo: \(error)")
            } else {
                loadTodos()
            }
        }
    }
}

#Preview {
    ContentView()
}
