//
//  ViewController.swift
//  ProductListing
//
//  Created by Moksh Marakana on 29/10/23.
//

import UIKit
import Alamofire
import SDWebImage
import SystemConfiguration


class ViewController: UIViewController {

    @IBOutlet weak var lblQuantity: UILabel!
    @IBOutlet weak var tblProduct: UITableView!
    var isProductAvailable = true
    private let viewModel = ProductListViewModel()
    var arrProduct = [ProductElement]()
    var prodctDict = [String:Int]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
            getProductList()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if let cartdict = UserDefaults.standard.dictionary(forKey: "Cart") as? [String:Int] {
            self.prodctDict = cartdict
            lblQuantity.isHidden = false
            var sum = 0

        
            for value in prodctDict.values {
                sum += value
            }
            lblQuantity.text = "\(sum)"
            
        } else {
            lblQuantity.isHidden = true
        }
    }
    func getProductList(){
        if Reachability.isConnectedToNetwork() {
            
            if isProductAvailable {
                showHud("Please wait..")
                viewModel.fetchProductData(apiUrl: "https://dummyjson.com/products?limit=10&skip=\(arrProduct.count)", completion: { result in
                    self.hideHUD()
                    
                    switch result {
                    case .success(let data):
                        
                        
                        let decoder = JSONDecoder()
                        do {
                            let jsonDecoder = JSONDecoder()
                            let responseModel = try jsonDecoder.decode(Product.self, from: data)
                            DispatchQueue.main.async {
                                self.arrProduct.append(contentsOf: responseModel.products ?? [])
                                self.tblProduct.reloadData()
                            }
                            if self.arrProduct.count < responseModel.total ?? 0 {
                                self.isProductAvailable = true
                            } else {
                                self.isProductAvailable = false
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
                self.show_alert(msg: "No more product available")
            }
        } else {
            self.show_alert(msg: "Please check internet connection")
        }
    }
}

extension ViewController :UITableViewDataSource,UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrProduct.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "productcell")!
        let productImageview = cell.contentView.viewWithTag(101) as! UIImageView
        let productTitleLabel = cell.contentView.viewWithTag(102) as! UILabel
        let productPriceLabel = cell.contentView.viewWithTag(103) as! UILabel
        let productObj = arrProduct[indexPath.row]
        productTitleLabel.text = productObj.title ?? ""
        productPriceLabel.text = "\(productObj.price ?? 0)"
       
        productImageview.sd_setImage(with: URL(string: productObj.thumbnail ?? ""), placeholderImage: nil)
        
        
        cell.selectionStyle = .none
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let productDetail = self.storyboard?.instantiateViewController(withIdentifier: "ProductDetailViewController") as! ProductDetailViewController
        productDetail.ProductId = arrProduct[indexPath.row].id ?? 1
        self.navigationController?.pushViewController(productDetail, animated: true)
    }
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if arrProduct.count-1 == indexPath.row{
            getProductList()
        }
    }
}










