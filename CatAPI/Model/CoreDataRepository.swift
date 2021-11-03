//
//  CoreDataRepository.swift
//  CatAPI
//
//

import Foundation
import CoreData

class CoreDataRepository {

    let context =  DataBaseController.persistentContainer.viewContext

    func getCatsFromLocal(completion: @escaping (Result<[Cats], ErrorAPI>) throws -> Void) throws {
        guard let favorites = try? DataBaseController.persistentContainer
                .viewContext.fetch(Favorite.fetchRequest()) else {
                    try completion(Result.failure(ErrorAPI.noData))
                    return
                }
        let cats = favorites.map { catMapper($0) }
        try completion(Result.success(cats))
    }

    func saveCat(with newCat: Cats, catImage: Data, completion: @escaping ((Result<Void, APIError>) -> Void)) {

        let favorite = Favorite(context: context)
        favorite.catDescription = newCat.catDescription
        favorite.affectionLevel = Int32(newCat.affectionLevel ?? 1)
        favorite.vocalisation = Int32(newCat.vocalisation ?? 1)
        favorite.socialNeeds = Int32(newCat.socialNeeds ?? 1)
        favorite.sheddingLevel = Int32(newCat.sheddingLevel ?? 1)
        favorite.adaptability = Int32(newCat.adaptability ?? 1)
        favorite.rare = Int32(newCat.rare ?? 0)
        favorite.name = newCat.name
        favorite.image = catImage
        DataBaseController.saveContext { [weak self] result in
            guard self != nil else { return }
            switch result {
            case .success:
                print("O gato foi adicionado aos favoritos com sucesso.")
                completion(Result.success(()))
            case .failure(let error):
                print(error)
                completion(Result.failure(APIError.connectivity))
            }
        }
    }

    func deleteCat(name: String, completion: @escaping ((Result<Void, APIError>) -> Void)) {
        let fetchRequest = NSFetchRequest<Favorite>(entityName: "Favorite")
        fetchRequest.predicate =  NSPredicate(format: "name =%@", name)
        do {
            let fetchedBreeds = try context.fetch(fetchRequest)
            for object in fetchedBreeds {
                context.delete(object)
            }
            do {
                try context.save()
                completion(Result.success(()))
                return
            } catch {
                completion(Result.failure(APIError.serverError))
                return
            }
        } catch {
            completion(Result.failure(APIError.notFound))
            return
        }
    }

    func getFavorites(by name: String, completion: @escaping((Result<[Cats], APIError>) -> Void)) {
        let fetchRequest = NSFetchRequest<Favorite>(entityName: "Favorite")
        fetchRequest.predicate =  NSPredicate(format: "name =%@", name)
        do {
            let fetchedBreeds = try context.fetch(fetchRequest)
            let cats = fetchedBreeds.map { catMapper($0) }
            completion(Result.success(cats))
        } catch {
            completion(Result.failure(APIError.notFound))
            return
        }
    }

    private func catMapper(_ input: Favorite ) -> Cats {
        let result = Cats(
            adaptability: Int(input.adaptability),
            hypoallergenic: nil,
            identity: nil,
            image: nil,
            indoor: nil,
            intelligence: nil,
            lap: nil,
            lifeSpan: nil,
            name: input.name,
            natural: nil,
            origin: nil,
            rare: Int(input.rare),
            rex: nil,
            sheddingLevel: Int(input.sheddingLevel),
            shortLegs: nil,
            socialNeeds: Int(input.socialNeeds),
            strangerFriendly: nil,
            suppressedTail: nil,
            temperament: nil,
            vocalisation: Int(input.vocalisation),
            weight: nil,
            affectionLevel: Int(input.affectionLevel),
            catDescription: input.catDescription)
        return result
    }
}
