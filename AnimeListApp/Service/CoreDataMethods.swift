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

    func createAnimeEntity(animeData: AnimeData) -> AnimeEntity {
        let newAnimeEntity = AnimeEntity(context: context)
        newAnimeEntity.malID = Int64(animeData.malId!)
        newAnimeEntity.malRating = animeData.score!
        newAnimeEntity.animeImage = animeData.images?.jpg?.imageUrl
        newAnimeEntity.detailText = animeData.synopsis
        newAnimeEntity.title = animeData.title
        newAnimeEntity.isOnMyList = true
        return newAnimeEntity
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
