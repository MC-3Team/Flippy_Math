//
//  CustomAlertView.swift
//  FlippyMath
//
//  Created by Enrico Maricar on 01/09/24.
//

import Foundation
import SwiftUI

struct CustomAlertView: View {
    var primaryButtonTitle: String
    var primaryButtonAction: () -> Void
    var secondaryButtonTitle: String? = nil
    var secondaryButtonAction: (() -> Void)? = nil
    @EnvironmentObject private var audioHelper : AudioHelper
    
    var body: some View {
        ZStack {
            Image("background_alert")

            
            GeometryReader { geometry in
                VStack(spacing: 0) {
                    
                    Text("Jaringan tidak tersedia. Harap periksa apakah kamu terhubung ke jaringan seluler atau Wi-Fi yang dapat digunakan.")
                        .font(.custom("PilcrowRoundedVariable-Regular", size: 16))
                        .fontWeight(.bold)
                        .foregroundColor(Color("darkBluePrimary"))
                        .multilineTextAlignment(.center)
                    
                    HStack(spacing: 10) {
                        if let secondaryButtonTitle = secondaryButtonTitle, let secondaryButtonAction = secondaryButtonAction {
                            Button(action: {
                                audioHelper.playSoundEffect(named: "click", fileType: "wav")
                                secondaryButtonAction()
                            }) {
                                Text(secondaryButtonTitle)
                                    .font(.custom("PilcrowRoundedVariable-Regular", size: 18))
                                    .fontWeight(.bold)
                                    .foregroundColor(.white)
                                    .padding(10)
                                    .frame(width: 100)
                                    .background(Color.white)
                                    .cornerRadius(8)
                            }
                        }
                        
                        
                        Button(action: {
                            audioHelper.playSoundEffect(named: "click", fileType: "wav")
                            primaryButtonAction()
                        }) {
                            Text(primaryButtonTitle)
                                .font(.custom("PilcrowRoundedVariable-Regular", size: 18))
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                                .padding(10)
                                .frame(width: 100)
                                .background(Color("bluePrimary"))
                                .cornerRadius(8)
                        }
                    }
                    .padding(.top, 20)
                }
                .frame(maxWidth: geometry.size.width * 0.75)
                .position(x: geometry.size.width / 2, y: geometry.size.height * 0.7)
            }
        }
    }
}
