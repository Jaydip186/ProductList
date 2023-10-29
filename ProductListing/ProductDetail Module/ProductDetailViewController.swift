//
//  ProductDetailViewController.swift
//  ProductListing
//
//  Created by Moksh Marakana on 29/10/23.
//

import UIKit

class ProductDetailViewController: UIViewController {

    @IBOutlet weak var thumbnailImageview: UIImageView!
    
    @IBOutlet weak var imageCollectionView: UICollectionView!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var stockLbl: UILabel!
    @IBOutlet weak var categoryLbl: UILabel!
    @IBOutlet weak var descriptionLbl: UILabel!
    @IBOutlet weak var discountLbl: UILabel!
    @IBOutlet weak var brandLbl: UILabel!
    @IBOutlet weak var quantityLbl: UILabel!
    
    var ProductId = Int()
    private let viewModel = ProductListViewModel()
    var arrmages = [String]()
    var prodctDict = [String:Int]()
    var quantity = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getProductDetail()
        
    }
    
    func getProductDetail(){
        if Reachability.isConnectedToNetwork() {
            showHud("Please wait..")
            viewModel.fetchProductData(apiUrl: "https://dummyjson.com/products/\(ProductId)", completion: { result in
                self.hideHUD()
                
                switch result {
                case .success(let data):
                    
                    
                    let decoder = JSONDecoder()
                    do {
                        let jsonDecoder = JSONDecoder()
                        let responseModel = try jsonDecoder.decode(ProductElement.self, from: data)
                        DispatchQueue.main.async {
                            self.thumbnailImageview.sd_setImage(with: URL(string: responseModel.thumbnail ?? ""), placeholderImage: nil)
                            
                            self.titleLbl.text = responseModel.title
                            self.categoryLbl.text = "Category : \(responseModel.category ?? "")"
                            self.stockLbl.text = "Stock : \(responseModel.stock ?? 0)"
                            self.descriptionLbl.text = "Description: \(responseModel.description ?? "")"
                            self.discountLbl.text = "Discount : \(responseModel.discountPercentage ??  0.0)"
                            self.brandLbl.text = "Brand : \(responseModel.brand ?? "")"
                            self.arrmages = responseModel.images ?? []
                            self.imageCollectionView.reloadData()
                            
                            
                            if let cartdict = UserDefaults.standard.dictionary(forKey: "Cart") as? [String:Int] {
                                self.prodctDict = cartdict
                                if self.prodctDict.keys.contains(responseModel.title ?? "") {
                                    self.quantityLbl.text = "\(self.prodctDict[responseModel.title ?? ""]!)"
                                    self.quantity = self.prodctDict[responseModel.title ?? ""]!
                                }
                            }
                            
                        }
                        
                        
                    } catch {
                        print(error)
                    }
                    
                    break
                    // Parse and handle the data (e.g., decode JSON)
                    // Update the UI with the weather information
                case .failure(let error):
                    print("Error fetching weather data: \(error)")
                }
            })
            
        } else {
            self.show_alert(msg: "Please check internet connection")
        }
    }

    @IBAction func btnBackPress(_ sender: UIButton) {
        btnAddPress(sender)
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnAddPress(_ sender: UIButton) {
        if quantity > 0 {
            prodctDict[titleLbl.text ?? ""] = quantity
            
        } else {
            if prodctDict.keys.contains(titleLbl.text ?? "") {
                prodctDict.removeValue(forKey: titleLbl.text ?? "")
            }
        }
        UserDefaults.standard.setValue(prodctDict, forKey: "Cart")
    }
    
    @IBAction func btnMinusPress(_ sender: UIButton) {
        if quantity>0 {
            quantity -= 1
        }
        quantityLbl.text = "\(quantity)"
    }
    @IBAction func btnPlusPress(_ sender: UIButton) {
        quantity += 1
        quantityLbl.text = "\(quantity)"
    }
}

extension ProductDetailViewController : UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrmages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "imageCell", for: indexPath)
        let productImageview = cell.contentView.viewWithTag(101) as! UIImageView
        productImageview.sd_setImage(with: URL(string: arrmages[indexPath.item]), placeholderImage: nil)
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 60.0, height: 60.0)
    }
}
