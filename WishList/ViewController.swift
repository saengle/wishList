//
//  ViewController.swift
//  WishList
//
//  Created by 쌩 on 4/11/24.
//

import UIKit

class ViewController: UIViewController {
    
    @IBAction func itemChangeButton(_ sender: Any) {
        fetchData()
        itemImageView.load(url: temp.thumbnail)
    }
    var temp = WishListModel(id: 1, title: "임시제목", description: "설명입니다.", price: 150, discountPercentage: 15.5, rating: 5.0, stock: 32, brand: "Samsung", category: "Phone", thumbnail: "https://cdn.dummyjson.com/product-images/92/thumbnail.jpg", images: ["aaa", "aaa"])
    
    @IBOutlet weak var itemImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchData()
        itemImageView.load(url: temp.thumbnail)
        // Do any additional setup after loading the view.
    }
    
    func fetchData() {
        //도메인 넣어서 URL 컴포넌트 생성
        var components = URLComponents(string: "https://dummyjson.com/products")
        //도메인 뒤에 API 주소 삽입
        components?.path = "/products/\(Int.random(in: 1...100))"
        //파라미터 추가할거 있으면 작성
        //           let parameters = [URLQueryItem(name: "postId", value: "1"),
        //                             URLQueryItem(name: "id", value: "2")]
        //           components?.percentEncodedQueryItems = parameters
        //URL 생성
        guard let url = components?.url else { return }
//                print(url)
        //리퀘스트 생성
        var request: URLRequest = URLRequest(url: url)
        //통신 방법 지정
        request.httpMethod = "GET"
        //태스크 생성
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            //여기서 에러 체크 및 받은 데이터 가공하여 사용
            guard let data,
                  let str = String(data: data, encoding:.utf8) else { return }
            
            //     Mark: 데이터 모델화 ... 진행하기
            do {
                let decoder = JSONDecoder()
                let jsonData = try decoder.decode(WishListModel.self, from: data) // Data -> FollowingModel 타입
                self.temp = jsonData // 리스트만 추출
            } catch {
                print("error:\(error)")
            }
        }
        //실행
        task.resume()
        
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
