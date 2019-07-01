//
//  CollectionViewController.swift
//  Ciklum_Dacadoo_Test
//
//  Created by BeerKoala on 6/26/19.
//  Copyright © 2019 a.kryvchykov. All rights reserved.
//

import UIKit

class CollectionViewController: UIViewController {

    var photos: [PhotoTumblr] = []

    let activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var searchBar: UISearchBar!

    override func viewDidLoad() {
        super.viewDidLoad()

        self.collectionView.addSubview(activityIndicator)
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.centerXAnchor.constraint(equalTo: self.collectionView.centerXAnchor).isActive = true
        activityIndicator.centerYAnchor.constraint(equalTo: self.collectionView.centerYAnchor).isActive = true

        activityIndicator.style = .gray
        activityIndicator.isHidden = true
    }

    private func updateData() {
        collectionView.reloadData()
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Constants.segueIdentifier.rawValue {
            guard let destination = segue.destination as? ImageViewController,
                let cell = sender as? ImageViewCell,
                let selectedIndex = collectionView.indexPath(for: cell) else {
                    print("Cant find selected cell")
                    return
            }
            destination.url = photos[selectedIndex.row].url
        }
    }
}

// MARK: UISearchBarDelegate
extension CollectionViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        view.endEditing(true)

        guard let searchText = searchBar.text,
            !searchText.isEmpty else {
                photos = []
                updateData()
                return
        }

        activityIndicator.isHidden = false
        activityIndicator.startAnimating()

        Network.shared.getData(for: searchText) { [weak self] photos, error in
            self?.activityIndicator.isHidden = true
            self?.activityIndicator.stopAnimating()

            if let error = error {
                print(error as Any)

                let alert = UIAlertController(title: Constants.errorText.rawValue, message: error.localizedDescription, preferredStyle: .alert)
                let okButton = UIAlertAction(title: Constants.okText.rawValue, style: .default, handler: nil)
                alert.addAction(okButton)
                self?.present(alert, animated: true, completion: nil)
                return
            }

            self?.photos = photos
            self?.updateData()
        }
    }

    // clear searchBar
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText == "" {
            photos = []
            updateData()
        }
    }
}

// MARK: UICollectionViewDataSource
extension CollectionViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photos.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.cellIdentifier.rawValue, for: indexPath) as? ImageViewCell
            ?? ImageViewCell()

        cell.imageView.setImage(with: photos[indexPath.row].url, andSet: ImageViewCell.imageWidth)

        // with Kingfisher it can be easier
        //        cell.imageView.kf.indicatorType = .activity
        //        cell.imageView.kf.setImage(
        //            with: photos[indexPath.row].url,
        //            placeholder: nil,
        //            options: [
        //                .processor(DownsamplingImageProcessor(size: CGSize(width: 300, height: 300))),
        //                .scaleFactor(UIScreen.main.scale),
        //                .cacheOriginalImage
        //            ])

        return cell
    }
}
