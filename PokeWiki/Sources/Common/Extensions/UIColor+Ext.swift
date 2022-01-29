//
//  UIColor+Ext.swift
//  PokeWiki
//
//  Created by George Vilnei Arboite Gomes on 28/01/22.
//

import UIKit

extension UIColor {

   public class func dynamicColor(light: UIColor, dark: UIColor) -> UIColor {
      if #available(iOS 13.0, *) {
         return UIColor {
            switch $0.userInterfaceStyle {
            case .dark:
               return dark
            default:
               return light
            }
         }
      } else {
         return light
      }
   }
}
