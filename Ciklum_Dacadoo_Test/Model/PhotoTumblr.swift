//
//  PhotoTumblr.swift
//  Ciklum_Dacadoo_Test
//
//  Created by BeerKoala on 6/30/19.
//  Copyright © 2019 a.kryvchykov. All rights reserved.
//

import Foundation

struct PhotoTumblr: Decodable {
    var url: URL
    // title, summary etc

    enum CodingKeys: String, CodingKey {
        case originalSize = "original_size"
        case url
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        let imageWithOriginalSize = try values.nestedContainer(keyedBy: CodingKeys.self, forKey: .originalSize)
        self.url = try imageWithOriginalSize.decode(URL.self, forKey: .url)
    }
}

private struct RawServerResponse: Decodable {
    var photos: [PhotoTumblr]

    enum CodingKeys: String, CodingKey {
        case photos
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)

        photos = []
        if values.contains(.photos) { // for some types of posrs may not be photos
            photos = try values.decode([PhotoTumblr].self, forKey: .photos)
        }
    }
}

struct ServerResponse: Decodable {
    var status: Int
    var message: String
    var photos: [PhotoTumblr]

    enum CodingKeys: String, CodingKey {
        case meta
        case status
        case message = "msg"
        case response
        //case photos
    }
//
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)

        // meta: status and msg
        let meta = try values.nestedContainer(keyedBy: CodingKeys.self, forKey: .meta)
        self.status = try meta.decode(Int.self, forKey: .status)
        self.message = try meta.decode(String.self, forKey: .message)

        // response
        if self.status == 200 {
            let response = try values.decode([RawServerResponse].self, forKey: CodingKeys.response)

            self.photos = response.flatMap {$0.photos}
        } else {
            self.photos = []
        }
    }
}
