//
//  UIImage+extension.swift
//  Ciklum_Dacadoo_Test
//
//  Created by BeerKoala on 7/1/19.
//  Copyright © 2019 a.kryvchykov. All rights reserved.
//

import UIKit

extension UIImage {

    func scale(to newWidth: CGFloat) -> UIImage {

        let aspectRatio = newWidth / self.size.width
        let newHeight = self.size.height * aspectRatio

        return self.resized(newSize: CGSize(width: newWidth, height: newHeight))
    }

    func resized(newSize: CGSize) -> UIImage {
        let hasAlpha = false

        //UIScreen.main.scale
        let scale: CGFloat = 1 // for pixels, not points!
        //0.0 is Automatically use scale factor of main screen

        UIGraphicsBeginImageContextWithOptions(size, !hasAlpha, scale)
        self.draw(in: CGRect(origin: CGPoint.zero, size: size))

        let scaledImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return scaledImage!
        }
}
