//
//  ViewController.swift
//  Fashion App
//
//  Created by Mac on 27/04/22.
//

import UIKit
class ViewController: UIViewController {
    //MARK: Outlet Of CollectionView1
    @IBOutlet weak var dataBaseCollectionView : UICollectionView!
    var apiDetailedArray : [ApiDetails] = []
    var imageUrl : URL?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dataBaseCollectionView.dataSource = self
        dataBaseCollectionView.delegate = self
        urlParseToJson()
    }
    
    //MARK : URLParseToJson
    func urlParseToJson() {
        let urlString = "https://fakestoreapi.com/products"
        guard let url = URL(string: urlString) else{
            print("URL is Invalid")
            return
        }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        let session = URLSession(configuration: .default)
        let dataTask = session.dataTask(with: request) { [weak self]
            data, response, error in
            
            guard let response = response as? HTTPURLResponse,
                  response.statusCode == 200,
                  let data = data
            else {
                print("Data is Invalid OR Status Code is not proper")
                return
            }
            do{
                guard let jsonObject = try JSONSerialization.jsonObject(with: data) as? [[String:Any]] else {
                    print("JSON not in expected format")
                    return
                }
                for dictionary in jsonObject {
                    let postImage = dictionary["image"] as! String
                    let postTitle = dictionary["title"] as! String
                    let postDescription = dictionary["description"] as! String
                    let postPrice = dictionary["price"] as! Double
                    let postCategory = dictionary["category"] as! String
                    let postRating = dictionary["rating"] as! [String:Any]
                    let postRate = postRating["rate"] as! Double
                    let postCount = postRating["count"] as! Int
                    
                    let api1 = ApiDetails(image: postImage, title: postTitle, price: postPrice, description: postDescription, category: postCategory, rate: postRate, count: postCount)
                    self?.apiDetailedArray.append(api1)
                    DispatchQueue.main.async {
                        self?.dataBaseCollectionView.reloadData()
                    }
                }
            }
            catch {
                print("Got error while converting Data to Json -\(error.localizedDescription) ")
            }
        }
        dataTask.resume()
    }
    
    // MARK: ToggleSwitch Action
    @IBAction func toggleSwitch(_ sender : UISwitch){
        if sender.isOn{
            view.backgroundColor = .green
            urlParseToJson()
        }
        else {
            view.backgroundColor = .black
            print("Toggle Switch Is OFF")
        }
    }
}

// MARK : UICollectionViewDataSource
extension ViewController : UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        apiDetailedArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = self.dataBaseCollectionView.dequeueReusableCell(withReuseIdentifier: "DataBaseCollectionViewCell", for: indexPath) as? DataBaseCollectionViewCell else{
            return UICollectionViewCell()
        }
        let apiArrayFromObject = apiDetailedArray[indexPath.row]
        cell.titleLabel.text = apiArrayFromObject.title
        cell.pricelabel.text = String(apiArrayFromObject.price)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath){
        guard let apiVc = self.storyboard?.instantiateViewController(withIdentifier: "APIViewController") as? APIViewController else{
            return
        }
        let api = apiDetailedArray[indexPath.row]
        apiVc.imageContainer = api.image
        apiVc.titleContainer = api.title
        apiVc.descriptionContainer = api.description
        apiVc.categoryContainer = api.category
        apiVc.rateContainer = String(api.rate)
        apiVc.countContainer = String(api.count)
        self.navigationController?.pushViewController(apiVc, animated: true)
    }
}

//MARK : UICollectionViewDelegate
extension ViewController : UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize{
        return CGSize(width: 200, height: 200)
    }
    
}

