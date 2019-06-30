//
//  ImageLoader.swift
//  Ciklum_Dacadoo_Test
//
//  Created by BeerKoala on 7/1/19.
//  Copyright © 2019 a.kryvchykov. All rights reserved.
//

import UIKit

let imageCache = NSCache<AnyObject, UIImage>()

class ImageLoader: UIImageView {

    var imageUrl: URL?
    let activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        self.addSubview(activityIndicator)

        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        activityIndicator.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true

        activityIndicator.style = .gray
        activityIndicator.isHidden = true
    }

    func setImage(with url: URL, andSet width: CGFloat? = nil) {

        self.image = nil

        self.imageUrl = url

        activityIndicator.isHidden = false
        activityIndicator.startAnimating()

        // retrieves image if already available in cache
        if let imageFromCache = imageCache.object(forKey: url as AnyObject) {
            self.image = imageFromCache.scale(to: width)
            activityIndicator.stopAnimating()
            activityIndicator.isHidden = true
            return
        }

        // image does not available in cache.. so retrieving it from url...
        URLSession.shared.dataTask(with: url, completionHandler: { (data, _, error) in

            if error != nil {
                print(error as Any)
                DispatchQueue.main.async(execute: {
                    //self.activityIndicator.stopAnimating() //???
                })
                return
            }

            DispatchQueue.global(qos: .userInitiated).async {
                if let data = try? Data(contentsOf: url) {//???
                    DispatchQueue.main.async {
                        if self.imageUrl == url,
                            let image = UIImage(data: data) {
                            imageCache.setObject(image, forKey: url as AnyObject)

                            //??? change width to 300px
                            self.image = image.scale(to: width)
                            self.activityIndicator.stopAnimating()
                            self.activityIndicator.isHidden = true
                        }
                    }
                }
            }
        }).resume()
    }
}
