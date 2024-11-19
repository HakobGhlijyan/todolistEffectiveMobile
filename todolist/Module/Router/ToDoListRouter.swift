//
//  ToDoListRouter.swift
//  todolist
//
//  Created by Hakob Ghlijyan on 19.11.2024.
//

import SwiftUI

final class ToDoListRouter {
    func navigateToAddToDo(completion: @escaping (String) -> Void) {
        let newToDoInputView = ToDoInputView { title in
            completion(title) // Передаем только текст, создание объекта произойдет в Interactor
        }
        let hostingController = UIHostingController(rootView: newToDoInputView)

        // Получаем текущий rootViewController для презентации
        if let rootViewController = UIApplication.shared.connectedScenes
            .compactMap({ ($0 as? UIWindowScene)?.keyWindow?.rootViewController })
            .first {
            rootViewController.present(hostingController, animated: true)
        }
    }
}
