//
//  BoxView.swift
//  iCho
//
//  Created by Kudzaiishe Mhou on 2021/12/27.
//

import Foundation
import SwiftUI

struct SelectionView: View {
    let index: Int
    let isPlayer: Bool
    
    @Binding var selected: Bool
    
    let onTap: (Int)->Void
    
    init(index: Int, isPlayer: Bool, selected: Binding<Bool>, onTap: @escaping (Int)->Void) {
        self.index = index
        self.isPlayer = isPlayer
        _selected = selected
        self.onTap = onTap
    }
    
    var body: some View {
        VStack {
            Image(isPlayer ? "player-\(index)" : "monster-\(index)")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 40, height: 40)
        }
        .background(selected ? Color.white : .clear )
        .cornerRadius(8)
        .onTapGesture {
            onTap(index)
        }
    }
}
