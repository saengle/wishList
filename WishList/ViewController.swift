//
//  ViewController.swift
//  WishList
//
//  Created by 쌩 on 4/11/24.
//

import UIKit
import CoreData

class ViewController: UIViewController {
    
    var persistentContainer: NSPersistentContainer? {
        (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer
    }
    
    @IBAction func itemChangeButton(_ sender: Any) {
        fetchData()
        itemImageView.load(url: wishItem.thumbnail)
        itemNameLabel.text = wishItem.title
        itemDescriptionTextView.text = "\(wishItem.description) \n\n Price : \(wishItem.price)$"
    }
    @IBAction func addMYWishListButton(_ sender: Any) {
        saveDataToModel()
        fetchData()
        itemImageView.load(url: wishItem.thumbnail)
    }
    @IBAction func watchMyWishListButton(_ sender: Any) {
        loadDataFromModel()
    }
    
    
    var wishItem = WishListModel(id: 15, title: "다른상품 보기를 눌러주세요.", description: "현재 상품의 정보가 없습니다. 다른 상품 보기를 눌러주세요.", price: 150, thumbnail: "")
    
    @IBOutlet weak var itemImageView: UIImageView!
    
    @IBOutlet weak var itemNameLabel: UILabel!
    @IBOutlet weak var itemDescriptionTextView: UITextView!
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchData()
        itemImageView.load(url: wishItem.thumbnail)
        
        saveDataToModel()
        loadDataFromModel()
        
        // Do any additional setup after loading the view.
    }
    
    func saveDataToModel() {
        

        guard let context = self.persistentContainer?.viewContext else { return }
        
        let myWishList = MyWishList(context: context)

        myWishList.id = Int64(wishItem.id)
        myWishList.title = wishItem.title
        myWishList.explanation = wishItem.description
        myWishList.price = Int64(wishItem.price)
        myWishList.thumbnail = wishItem.thumbnail

        try? context.save()
    }
    
    func loadDataFromModel() {
        guard let context = self.persistentContainer?.viewContext else { return }

        let request = MyWishList.fetchRequest()
        let myWishList = try? context.fetch(request)

        print(myWishList)
        
    }
    
    func fetchData() {
        //도메인 넣어서 URL 컴포넌트 생성
        var components = URLComponents(string: "https://dummyjson.com")
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
                // 데이터 WishListModel화
                let jsonData = try decoder.decode(WishListModel.self, from: data)
                self.wishItem = jsonData // temp에 데이터 주입
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

extension UILabel {
    func load(string: String) {
        self.text? = string
    }
}
