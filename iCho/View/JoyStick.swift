//
//  JoyStick.swift
//  iCho
//
//  Created by Kudzaiishe Mhou on 2021/12/27.
//

import Foundation
import SwiftUI

struct JoyStick: View {
    
    let direction: (Direction)->Void
    
    var body: some View {
        VStack(spacing: 0){
            Button(action: {
                direction(.up)
                
            }, label: {
                Image("up")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 60, height: 50)
            })
            
            HStack(spacing: 0) {
                Button(action: {
                    direction(.left)
                    
                }, label: {
                    Image("left")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 60, height: 50)
                })
                
                Image("ball")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 40, height: 40)
                
                Button(action: {
                    direction(.right)
                    
                }, label: {
                    Image("right")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 60, height: 50)
                })
            }
            .frame(width: 100)
            
            Button(action: {
                direction(.down)
                
            }, label: {
                Image("down")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 60, height: 50)
            })
        }.background(
            Circle()
                .fill(Color("background4"))
                                .frame(width: 120, height: 120)
                                .shadow(color: Color("darkShadow"), radius: 8, x: 8, y: 8)

        )
    }
}

struct JoyStick_Previews: PreviewProvider {
    static var previews: some View {
        JoyStick() { _ in
            
        }
    }
}
