//
//  FirestoreService.swift
//  FirebaseTodoApp
//
//  Created by Jonas Shoukri on 2025-01-17.
//

import Foundation
import FirebaseFirestore


class FirestoreService {
    private let db = Firestore.firestore()
    
    func addTodo(_ todo: ToDo, completion: @escaping (Error?) -> Void) {
        do {
            var newTodo = todo
            if newTodo.id == nil {
                newTodo.id = UUID().uuidString
            }
            guard let id = newTodo.id else {
                completion(NSError(domain: "FirestoreService", code: -1, userInfo: [NSLocalizedDescriptionKey: "Failed to generate a valid ID"]))
                return
            }
            let _ = try db.collection("ToDos").document(id).setData(from: newTodo)
            completion(nil)
        } catch {
            completion(error)
        }
    }
    
    func fetchTodos(completion: @escaping ([ToDo]?, Error?) -> Void) {
        db.collection("ToDos").getDocuments { snapshot, error in
            if let error = error {
                completion(nil, error)
                return
            }
                    
            guard let documents = snapshot?.documents else {
                completion([], nil)
                return
            }
                    
            let todos: [ToDo] = documents.compactMap { document in
                return try? document.data(as: ToDo.self)
            }
            completion(todos, nil)
        }
    }
    
    func updateTodo(_ todo: ToDo, completion: @escaping (Error?) -> Void) {
        do {
            guard let id = todo.id else {
                completion(NSError(domain: "FirestoreService", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid ID for updating todo"]))
                return
            }
            let _ = try db.collection("ToDos").document(id).setData(from: todo)
            completion(nil)
        } catch {
            completion(error)
        }
    }
    
    func deleteTodo(_ id: String, completion: @escaping (Error?) -> Void) {
        db.collection("ToDos").document(id).delete { error in
                    completion(error)
        }
    }
}
