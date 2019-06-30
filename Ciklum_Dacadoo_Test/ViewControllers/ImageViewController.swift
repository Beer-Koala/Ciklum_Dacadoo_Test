//
//  ImageViewController.swift
//  Ciklum_Dacadoo_Test
//
//  Created by BeerKoala on 7/1/19.
//  Copyright © 2019 a.kryvchykov. All rights reserved.
//

import UIKit

class ImageViewController: UIViewController {

    var url: URL?
    @IBOutlet weak var imageView: ImageLoader!

    override func viewDidLoad() {
        if let url = url {
            imageView.setImage(with: url)
        }
//        imageView.kf.indicatorType = .activity
//        imageView.kf.setImage(with: url)
    }

}
