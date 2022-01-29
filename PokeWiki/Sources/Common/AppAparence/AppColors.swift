//
//  AppColors.swift
//  PokeWiki
//
//  Created by George Vilnei Arboite Gomes on 28/01/22.
//

import UIKit

struct AppColors {

   static let icedWhite = #colorLiteral(red: 0.9116200267, green: 0.9764705882, blue: 1, alpha: 1)
   static let dullGray = #colorLiteral(red: 0.4156862745098039, green: 0.4156862745098039, blue: 0.4156862745098039, alpha: 1)

   static var bgColor: UIColor {
      return UIColor.dynamicColor(light: AppColors.icedWhite, dark: AppColors.dullGray)
   }
}
