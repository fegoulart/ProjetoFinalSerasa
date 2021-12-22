//
//  CoreDataRepository.swift
//  CatAPI
//
//

import Foundation
import CoreData
import CatLoader

enum APIError: Error {
    case connectivity
    case serverError
    case notFound
}

class CoreDataRepository {

    let context =  DataBaseController.persistentContainer.viewContext

    func getFavoritesFromLocal(completion: @escaping (Result<[Cat], ErrorAPI>) throws -> Void) throws {
        guard let favorites = try? DataBaseController.persistentContainer
                .viewContext.fetch(Favorite.fetchRequest()) else {
                    try completion(Result.failure(ErrorAPI.noData))
                    return
                }
        let cats = favorites.map { favoriteMapper($0) }
        try completion(Result.success(cats))
    }

    func saveFavorite(with newCat: Cat, catImage: Data, completion: @escaping ((Result<Void, APIError>) -> Void)) {

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

    func deleteFavorite(name: String, completion: @escaping ((Result<Void, APIError>) -> Void)) {
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

    func getFavorites(by name: String, completion: @escaping((Result<[Cat], APIError>) -> Void)) {
        let fetchRequest = NSFetchRequest<Favorite>(entityName: "Favorite")
        fetchRequest.predicate =  NSPredicate(format: "name =%@", name)
        do {
            let fetchedBreeds = try context.fetch(fetchRequest)
            let cats = fetchedBreeds.map { favoriteMapper($0) }
            completion(Result.success(cats))
        } catch {
            completion(Result.failure(APIError.notFound))
            return
        }
    }

    private func favoriteMapper(_ input: Favorite ) -> Cat {
        let result = Cat(
            adaptability: Int(input.adaptability),
            hypoallergenic: nil,
            identity: nil,
            imageUrl: nil,
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
            catDescription: input.catDescription
        )
        return result
    }
}

// MARK: - All breeds

enum LocalRepositoryError: Error {
    case insertError
    case noBreedsInserted
    case bulkInsertionError
    case retrievalError
    case truncateError
}

protocol BreedsLocalRepository {
    func saveBreeds(breeds: [Cat], completion: @escaping (Result<Void, LocalRepositoryError>) -> Void)
    func retrieveBreeds(completion: @escaping (Result<[Cat], LocalRepositoryError>) -> Void)
    func truncateBreeds(completion: @escaping (Result<Void, LocalRepositoryError>) -> Void)
}

extension CoreDataRepository: BreedsLocalRepository {

    func saveBreeds(breeds: [Cat], completion: @escaping (Result<Void, LocalRepositoryError>) -> Void) {
        guard breeds.count > 0 else {
            completion(.failure(.noBreedsInserted))
            return
        }
        context.perform {
            for item in breeds {
                let newBreedEntity = NSEntityDescription.insertNewObject(
                    forEntityName: "Breed",
                    into: self.context
                ) as? Breed
                newBreedEntity?.catDescription = item.catDescription
                newBreedEntity?.affectionLevel = Int32(item.affectionLevel ?? 1)
                newBreedEntity?.vocalisation = Int32(item.vocalisation ?? 1)
                newBreedEntity?.socialNeeds = Int32(item.socialNeeds ?? 1)
                newBreedEntity?.sheddingLevel = Int32(item.sheddingLevel ?? 1)
                newBreedEntity?.adaptability = Int32(item.adaptability ?? 1)
                newBreedEntity?.rare = Int32(item.rare ?? 0)
                newBreedEntity?.name = item.name
                newBreedEntity?.imageUrl = item.imageUrl
            }
            do {
                try self.context.save()
                completion(.success(()))
            } catch {
                completion(.failure(LocalRepositoryError.bulkInsertionError))
            }
            self.context.reset()
        }
    }

    func retrieveBreeds(completion: @escaping (Result<[Cat], LocalRepositoryError>) -> Void) {
        guard let breeds = try? DataBaseController.persistentContainer
                .viewContext.fetch(Breed.fetchRequest()) else {
                    completion(Result.failure(LocalRepositoryError.retrievalError))
                    return
                }
        let localBreeds = breeds.map { breedMapper($0) }
        completion(Result.success(localBreeds))
    }

    func truncateBreeds(completion: @escaping (Result<Void, LocalRepositoryError>) -> Void) {
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "Breed")
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)

        do {
            try context.execute(deleteRequest)
            try self.context.save()
            completion(.success(()))
        } catch let error as NSError {
            print(error.localizedDescription)
            completion(.failure(LocalRepositoryError.truncateError))
        }
    }

    private func breedMapper(_ input: Breed ) -> Cat {
        let result = Cat(
            adaptability: Int(input.adaptability),
            hypoallergenic: nil,
            identity: nil,
            imageUrl: nil,
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
            catDescription: input.catDescription
        )
        return result
    }
}
