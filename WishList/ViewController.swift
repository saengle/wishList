//
//  ViewController.swift
//  WishList
//
//  Created by 쌩 on 4/11/24.
//

import UIKit

class ViewController: UIViewController {
    
    var temp = WishListModel(id: 1, title: "임시제목", description: "설명입니다.", price: 150, discountPercentage: 15.5, rating: 5.0, stock: 32, brand: "Samsung", category: "Phone", thumbnail: "https://cdn.dummyjson.com/product-images/92/thumbnail.jpg", images: ["aaa", "aaa"])
    
    @IBOutlet weak var itemImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        itemImageView.load(url: temp.thumbnail)
        // Do any additional setup after loading the view.
    }
}

extension UIImageView {
    func load(url: String) {
        let myUrl = URL(string: url) ?? URL(string: "https://previews.123rf.com/images/yoginta/yoginta2212/yoginta221200705/196018859-%EC%82%AC%EC%9A%A9-%EA%B0%80%EB%8A%A5%ED%95%9C-%EC%9D%B4%EB%AF%B8%EC%A7%80%EA%B0%80-%EC%97%86%EC%8A%B5%EB%8B%88%EB%8B%A4-%EC%82%AC%EC%A7%84-%EA%B3%A7-%EC%82%AC%EC%A7%84-%EC%9D%B4%EB%AF%B8%EC%A7%80%EA%B0%80-%EC%97%86%EC%8A%B5%EB%8B%88%EB%8B%A4-%EB%B2%A1%ED%84%B0-%EC%9D%BC%EB%9F%AC%EC%8A%A4%ED%8A%B8-%EB%A0%88%EC%9D%B4.jpg")!
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: myUrl) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self?.image = image
                    }
                }
            }
        }
    }
}
