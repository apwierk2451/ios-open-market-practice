//
//  ProductList.swift
//  OpenMarket
//
//  Created by bonf, kiwi on 2022/08/09.
//

struct ProductsList: Decodable {
    let pageNumber: Int
    let itemsPerPage: Int
    let totalCount: Int
    let offset: Int
    let limit: Int
    let pages: [ProductDetail]
    let lastPage: Int
    let hasNext: Bool
    let hasPrevious: Bool
    
    private enum CodingKeys: String, CodingKey {
        case pageNumber = "page_no"
        case itemsPerPage = "items_per_page"
        case totalCount = "total_count"
        case offset
        case limit
        case pages
        case lastPage = "last_page"
        case hasNext = "has_next"
        case hasPrevious = "has_prev"
    }
}
