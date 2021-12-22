import Foundation
import UIKit
import CatLoader
#if DEBUG
import SwiftUI
#endif

class DetailViewController: UIViewController {

    // MARK: Outlet

    @IBOutlet weak var catImage: UIImageView!
    @IBOutlet weak var catName: UILabel!
    @IBOutlet weak var adaptability: UISlider!
    @IBOutlet weak var vocalization: UISlider!
    @IBOutlet weak var affection: UISlider!
    @IBOutlet weak var socialNeeds: UISlider!
    @IBOutlet weak var shedding: UISlider!
    @IBOutlet weak var rare: UISlider!
    @IBOutlet weak var catDescription: UILabel!
    @IBOutlet weak var favoriteStar: UIImageView!

    // MARK: Properties

    var cat: Cat?
    var catUIImage: UIImage?
    var localRepository: CoreDataRepository?

    // MARK: ViewController Lifecycle

    // TODO: Move it to CatUIComposer
    convenience init(cat: Cat, catImage: UIImage, localRepository: CoreDataRepository) {
        self.init()
        self.cat = cat
        self.catUIImage = catImage
        self.localRepository = localRepository
    }

    override func viewDidLoad() {
        setupUI()
    }

    override func viewDidAppear(_ animated: Bool) {
        if self.catUIImage == UIImage() {
            if let imageURL = self.cat?.imageUrl {
                if let url = URL(string: imageURL) {
                    if let data = try? Data(contentsOf: url) {
                        DispatchQueue.global(qos: .background).async {
                            let image = UIImage(data: data)
                            DispatchQueue.main.async {
                                self.catImage.image = image
                            }
                        }
                    }
                }
            } else {
                self.catUIImage = UIImage(named: "cat")
                self.catImage.image = self.catUIImage
            }
        } else {
            self.catImage.image = self.catUIImage
        }
        self.catName.text = self.cat?.name
        self.checkIfFavorite()
        self.adaptability.value = Float(self.cat?.adaptability ?? 0)
        self.vocalization.value = Float(self.cat?.vocalisation ?? 0)
        self.affection.value = Float(self.cat?.affectionLevel ?? 0)
        self.socialNeeds.value = Float(self.cat?.socialNeeds ?? 0)
        self.rare.value = Float(self.cat?.rare ?? 0)
        self.catDescription.text = self.cat?.catDescription
    }

    private func setupUI() {
        self.adaptability.maximumValue = 5
        self.adaptability.minimumValue = 1
        self.vocalization.maximumValue = 5
        self.vocalization.minimumValue = 1
        self.affection.maximumValue = 5
        self.affection.minimumValue = 1
        self.socialNeeds.maximumValue = 5
        self.socialNeeds.minimumValue = 1
        self.rare.maximumValue = 1
        self.rare.minimumValue = 0
        self.favoriteStar.tintColor = .systemGray
        let tapGestureRecognizer = UITapGestureRecognizer(
            target: self,
            action: #selector(imageTapped(tapGestureRecognizer:))
        )
        favoriteStar.isUserInteractionEnabled = true
        self.favoriteStar.addGestureRecognizer(tapGestureRecognizer)
    }

    private func checkIfFavorite() {
        guard let lRepository = localRepository, let catName = cat?.name else { return }
        lRepository.getFavorites(by: catName) { [weak self] result in
            guard self != nil else { return }
            switch result {
            case .success(let cats):
                if cats.count > 0 {
                    self?.favoriteStar.tintColor = .red
                } else {
                    self?.favoriteStar.tintColor = .systemGray
                }
            case .failure:
                self?.favoriteStar.tintColor = .systemGray
            }

        }
    }

    @objc func imageTapped(tapGestureRecognizer: UITapGestureRecognizer) {
        guard let tappedImage = tapGestureRecognizer.view as? UIImageView else { return }
        if tappedImage == favoriteStar {
            manageFavorite()
            switchStarColor()
        }
    }

    private func switchStarColor() {
        if favoriteStar.tintColor == .red {
            favoriteStar.tintColor = .systemGray
        } else {
            favoriteStar.tintColor = .red
        }
    }

    private func manageFavorite() {
        guard let mCat = cat, let mCatImage = catImage.image else { return }
        if isNotFavorite() {
            favoriteIt(cat: mCat, image: mCatImage)
        } else {
            guard let catName = mCat.name, mCat.name != "" else { return }
            unFavoriteIt(name: catName)
        }
    }

    private func isNotFavorite() -> Bool {
        return favoriteStar.tintColor == .systemGray
    }

    private func favoriteIt(cat: Cat, image: UIImage) {
        if let binaryImage = image.jpegData(withCompressionQuality: 1.0) {
            localRepository?.saveFavorite(with: cat, catImage: binaryImage) { [weak self] result in
                guard self != nil else { return }
                switch result {
                case .success:
                    print("ok")
                case .failure:
                    print("nao salvou ou já existia")
                }

            }
        }
    }

    private func unFavoriteIt(name: String) {
        localRepository?.deleteFavorite(name: name) { [weak self] result in
            guard self != nil else { return }
            switch result {
            case .success:
                print("apagou ok")
            case .failure(let error):
                print(error)
            }
        }
    }
}

#if DEBUG
struct DetaukViewController_Previews: PreviewProvider {
    static var previews: some View {
        ViewControllerPreview {
            DetailViewController()
        }
    }
}
#endif
