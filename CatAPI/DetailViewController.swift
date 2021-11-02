import Foundation
import UIKit
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

    // MARK: Properties

    var cat: Cats?
    var catUIImage: UIImage?

    // MARK: ViewController Lifecycle

    convenience init(cat: Cats, catImage: UIImage) {
        self.init()
        self.cat = cat
        self.catUIImage = catImage
    }

    override func viewDidLoad() {
        setupUI()
    }

    override func viewDidAppear(_ animated: Bool) {
        if self.catUIImage == UIImage() {
            if let imageURL = self.cat?.image?.url {
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
            }
        } else {
            self.catImage.image = self.catUIImage
        }
        self.catName.text = self.cat?.name
        self.adaptability.value = Float(self.cat?.adaptability ?? 0)
        self.vocalization.value = Float(self.cat?.vocalisation ?? 0)
        self.affection.value = Float(self.cat?.affectionLevel ?? 0)
        self.socialNeeds.value = Float(self.cat?.socialNeeds ?? 0)
        self.rare.value = Float(self.cat?.rare ?? 0)
        self.catDescription.text = self.cat?.description
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
