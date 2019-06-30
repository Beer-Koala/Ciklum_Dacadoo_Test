//
//  Network.swift
//  Ciklum_Dacadoo_Test
//
//  Created by BeerKoala on 6/29/19.
//  Copyright © 2019 a.kryvchykov. All rights reserved.
//

import Foundation
import Alamofire

class Network {

    let requestURL = "http://api.tumblr.com/v2/tagged"
    let tagName = "tag"
    let apiKeyName = "api_key"
    let apiKeyValue = "CcEqqSrYdQ5qTHFWssSMof4tPZ89sfx6AXYNQ4eoXHMgPJE03U"

    // MARK: initialization of Singletone
    private init() {
    }

    static let shared = Network()

    // MARK: class functions
    func getData(for text: String, completion: @escaping ([PhotoTumblr]) -> Void) {

        guard var urlComps = URLComponents(string: requestURL) else { return } //??? error?!

        let queryItems = [URLQueryItem(name: tagName, value: text), URLQueryItem(name: apiKeyName, value: apiKeyValue)]
        urlComps.queryItems = queryItems

        guard let url = urlComps.url else { return } //??? error?!

        let data = try? Data(contentsOf: url)
        let response = try? JSONDecoder().decode(ServerResponse.self, from: data!)

        if let response = response { //???
            completion(response.photos)
        }
    }
}
