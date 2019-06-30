//
//  ViewController.swift
//  Ciklum_Dacadoo_Test
//
//  Created by BeerKoala on 6/26/19.
//  Copyright © 2019 a.kryvchykov. All rights reserved.
//

import UIKit
import Kingfisher

class ViewController: UIViewController {

    var photos: [PhotoTumblr] = []

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var searchBar: UISearchBar!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    private func updateData() {
        collectionView.reloadData()
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "openImage" {
            guard let destination = segue.destination as? ImageViewController,
                let cell = sender as? ImageViewCell,
                let selectedIndex = collectionView.indexPath(for: cell) else { return } //??? error
            destination.url = photos[selectedIndex.row].url
        }
    }

}

extension ViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let searchText = searchBar.text else { return }
        //??? what if cleared search?!

        Network.shared.getData(for: searchText) { [weak self] photos in
            self?.photos = photos
            self?.updateData()
        }
    }
}

extension ViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photos.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        //??? identifier in conctant
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as? ImageViewCell ?? ImageViewCell()

        cell.imageView.kf.indicatorType = .activity
        cell.imageView.kf.setImage(
            with: photos[indexPath.row].url,
            placeholder: nil,
            options: [
                .processor(DownsamplingImageProcessor(size: CGSize(width: 300, height: 300))), //??? 300 points? or px?!
                .scaleFactor(UIScreen.main.scale),
                .cacheOriginalImage
            ])

        return cell
    }
}
