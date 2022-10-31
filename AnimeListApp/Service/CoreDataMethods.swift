//
//  CoreDataMethods.swift
//  AnimeListApp
//
//  Created by Luiz Sena on 20/10/22.
//

import Foundation
import CoreData

class CoreDataStack {

    static let shared: CoreDataStack = CoreDataStack()

    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "AnimeListApp")
        container.loadPersistentStores(completionHandler: { (_, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    var context: NSManagedObjectContext { persistentContainer.viewContext }

    func fetchAnimeEntity() -> [AnimeEntity] {
        do {
            let animeRequest = AnimeEntity.fetchRequest() as NSFetchRequest<AnimeEntity>
            return try context.fetch(animeRequest)
        } catch {
            print("Error while fetching Animes.")
            print(error)
            return []
        }
    }

    func searchFromCD(with query: String) -> [Anime]? {
        do {
            let animeRequest = AnimeEntity.fetchRequest() as NSFetchRequest<AnimeEntity>
            animeRequest.predicate = NSPredicate(format: "title CONTAINS[c] %@", "\(query)")
            let fetch = try context.fetch(animeRequest)
            let animeCD = fetch.map({ minhaLista in
                return Anime(minhaLista)
            })
            return animeCD
        } catch {
            print("Error while fetching Animes.")
            return []
        }
    }

    private func checkAnimeEntity(with animeData: AnimeData) -> Bool {
        let animes = fetchAnimeEntity()
        var bool = true
        for anime in animes {
            if anime.malID == animeData.malId! {
                bool = false
                break
            } else {
                bool = true
            }
        }
        return bool
    }

    func createAnimeEntity(animeData: AnimeData) -> AnimeEntity? {
        let check = checkAnimeEntity(with: animeData)
        if check {
            let newAnimeEntity = AnimeEntity(context: context)
            newAnimeEntity.malID = Int64(animeData.malId!)
            newAnimeEntity.malRating = animeData.score!
            newAnimeEntity.animeImage = animeData.images?.jpg?.imageUrl
            newAnimeEntity.detailText = animeData.synopsis
            newAnimeEntity.title = animeData.title
            newAnimeEntity.isOnMyList = true
            return newAnimeEntity
        } else {
            return nil
        }
    }

    func animeOnListID(at animeData: AnimeData) -> NSManagedObjectID {
        let animes = fetchAnimeEntity()
        var id: NSManagedObjectID?
        for anime in animes {
            if anime.malID == animeData.malId! {
                id = anime.objectID
                print(id!)
                break
            } else {
                id = nil
            }
        }
        return id!
    }

    // revisar essa funcao de deletar e implementar
    func deleteAnimeEntity(anime: AnimeData) {
        let id = animeOnListID(at: anime)
        let object = context.object(with: id)
        context.delete(object)
    }

    func printAllAnimeEntity() {
        let animes = fetchAnimeEntity()
        if !animes.isEmpty {
            for anime in animes {
                print("title: \(anime.title ?? "error"), malID: \(anime.malID), isOnMyList: \(anime.isOnMyList)")
            }
        } else {
            print("Something wrong, your coredata are empty")
        }
    }

}
