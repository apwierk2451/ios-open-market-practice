//
//  NameSpace.swift
//  OpenMarket
//
//  Created by bonf, kiwi on 2022/08/09.
//

enum Product {
    case page
    case itemPerPage
    
    var text: String {
        switch self {
        case .page:
            return "page_no"
        case .itemPerPage:
            return "items_per_page"
        }
    }
}
