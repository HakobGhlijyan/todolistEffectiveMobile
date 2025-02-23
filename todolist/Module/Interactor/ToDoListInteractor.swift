//
//  ToDoListInteractor.swift
//  todolist
//
//  Created by Hakob Ghlijyan on 19.11.2024.
//

import CoreData

final class ToDoListInteractor {
    private let context = CoreDataManager.shared.context

    // Добавляем параметр для текста поиска
        func fetchToDos(filter: FilterOption, searchText: String) -> [ToDo] {
            let request: NSFetchRequest<ToDo> = ToDo.fetchRequest()

            // Применяем фильтр по статусу
            switch filter {
            case .all:
                request.predicate = nil
            case .completed:
                request.predicate = NSPredicate(format: "isCompleted == true")
            case .active:
                request.predicate = NSPredicate(format: "isCompleted == false")
            }

            // Применяем фильтрацию по поисковому тексту
            if !searchText.isEmpty {
                let searchPredicate = NSPredicate(format: "title CONTAINS[cd] %@ OR descriptionText CONTAINS[cd] %@", searchText, searchText)
                request.predicate = request.predicate != nil ? NSCompoundPredicate(andPredicateWithSubpredicates: [request.predicate!, searchPredicate]) : searchPredicate
            }

            request.sortDescriptors = [NSSortDescriptor(key: "dateCreated", ascending: false)]

            do {
                return try context.fetch(request)
            } catch {
                print("Error fetching filtered ToDos: \(error)")
                return []
            }
        }
    
    func addToDo(title: String, description: String, priority: Int, dueDate: Date?) {
        let newToDo = ToDo(context: context)
        newToDo.id = UUID()
        newToDo.title = title
        newToDo.descriptionText = description
        newToDo.priority = Int16(priority)
        newToDo.dueDate = dueDate  // Может быть nil
        newToDo.isCompleted = false
        newToDo.dateCreated = Date()
        
        saveContext()
    }
        
    private func saveContext() {
        do {
            try context.save()
        } catch {
            print("Error saving context: \(error)")
        }
    }
    
    func deleteToDo(_ todo: ToDo) {
        context.delete(todo)
        saveContext()
    }
    
    func toggleCompletion(for todo: ToDo) {
        todo.isCompleted.toggle()
        saveContext()
    }
    
    // Метод для обновления задачи
    func updateToDo(_ todo: ToDo) {
        saveContext() // Сохраняем изменения в Core Data
    }
    
}

//MARK: - метод для доступа к контексту, чтобы он был доступен для тестов
extension ToDoListInteractor {
    // Новый метод для доступа к context в тестах
    func getContext() -> NSManagedObjectContext {
        return context
    }
}
