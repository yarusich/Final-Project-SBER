//
//  PhotoSearchController.swift
//  FinalProject
//
//  Created by Антон Сафронов on 13.07.2021.
//

import UIKit

final class PhotoSearchController: UISearchController {
    var searchedPhotos = [PhotoDTO]()
    
    let networkService = NetworkService()
    
}

//extension PhotoSearchController: UISearchBarDelegate {
//    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
//        <#code#>
//    }
//}

//extension PhotoSearchController {
//    @objc func startSearch(_ searchBar: UISearchBar) {
////        guard let query = searchBar.text, query.trimmingCharacters(in: .whitespaces) != "" else {
////            print("nothing to search")
////            return
////        }
//        guard let query = searchBar.text else { return }
//        let cursor = Cursor()
//        cursor.zeroPage()
//        let page = cursor.nextPage()
//
//}


