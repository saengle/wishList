// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let welcome = try? JSONDecoder().decode(Welcome.self, from: jsonData)

import Foundation

// MARK: - Welcome
struct WishListModel: Codable {
    let id: Int
    let title, description: String
    let price: Int
//    let discountPercentage, rating: Double
//    let stock: Int
//    let brand, category: String
    let thumbnail: String
//    let images: [String]
}
