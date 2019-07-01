//
//  Network.swift
//  Ciklum_Dacadoo_Test
//
//  Created by BeerKoala on 6/29/19.
//  Copyright © 2019 a.kryvchykov. All rights reserved.
//

import Foundation

class Network { // singletone for example

    let requestURL = "http://api.tumblr.com/v2/tagged"
    let tagName = "tag"
    let apiKeyName = "api_key"
    let apiKeyValue = "CcEqqSrYdQ5qTHFWssSMof4tPZ89sfx6AXYNQ4eoXHMgPJE03U" // better save to keychain

    // MARK: initialization of Singletone
    private init() {
    }

    static let shared = Network()

    // MARK: class functions
    func getData(for text: String, completion: @escaping ([PhotoTumblr], Error?) -> Void) {

        guard var urlComps = URLComponents(string: requestURL) else {
            completion([], NetworkError.urlError)
            return
        }

        let queryItems = [URLQueryItem(name: tagName, value: text), URLQueryItem(name: apiKeyName, value: apiKeyValue)]
        urlComps.queryItems = queryItems

        guard let url = urlComps.url else {
            completion([], NetworkError.urlParamsError)
            return
        }

        DispatchQueue.global(qos: .userInitiated).async {
            do {
                let data = try Data(contentsOf: url)
                let response = try JSONDecoder().decode(ServerResponse.self, from: data)
                DispatchQueue.main.async {
                        completion(response.photos, nil)
                }
            } catch {
                 DispatchQueue.main.async {
                    completion([], error)
                }
            }
        }
    }

    // MARK: errors
    enum NetworkError: Error {
        case urlError
        case urlParamsError
    }

}

extension Network.NetworkError: LocalizedError {
    public var errorDescription: String? {
                    switch self {
                    case .urlError:
                        return NSLocalizedString("Wrong url", comment: "")
                    case .urlParamsError:
                        return NSLocalizedString("Wrong url parameters", comment: "")
                    }
    }
}
