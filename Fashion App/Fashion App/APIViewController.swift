//
//  APIViewController.swift
//  Fashion App
//
//  Created by Mac on 28/04/22.
//

import UIKit
class APIViewController: UIViewController {
    //MARK : Label Outlets
    @IBOutlet weak var imageLabel : UIImageView!
    @IBOutlet weak var titleLabel : UILabel!
    @IBOutlet weak var descriptionLabel : UILabel!
    @IBOutlet weak var categoryLabel : UILabel!
    @IBOutlet weak var rateLabel : UILabel!
    @IBOutlet weak var countLabel : UILabel!
    
    var imageContainer : String?
    var titleContainer : String?
    var descriptionContainer: String?
    var categoryContainer: String?
    var rateContainer: String?
    var countContainer: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let imageUrl = URL(string: imageContainer!)!
        imageLabel.downloadImage(from: imageUrl)
        
        self.titleLabel.text = self.titleContainer
        self.descriptionLabel.text = self.descriptionContainer
        self.categoryLabel.text = self.categoryContainer
        self.rateLabel.text = self.rateContainer
        self.countLabel.text = self.countContainer
    }
}
// MARK:
extension  UIImageView{
    func downloadImage(from url: URL){
        let session = URLSession(configuration: .default)
        let dataTask = session.dataTask(with : url) {
            data, response, error in
            let image = UIImage(data: data!)
            DispatchQueue.main.async {
                self.image = image
            }
        }
        dataTask.resume()
    }
}
