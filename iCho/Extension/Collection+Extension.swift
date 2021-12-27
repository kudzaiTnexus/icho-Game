//
//  Collection+Extension.swift
//  iCho
//
//  Created by Kudzaiishe Mhou on 2021/12/27.
//

import Foundation

extension Collection where Indices.Iterator.Element == Index {
   public subscript(safe index: Index) -> Iterator.Element? {
     return (startIndex <= index && index < endIndex) ? self[index] : nil
   }
}
