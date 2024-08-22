//
//  CreditView.swift
//  FlippyMath
//
//  Created by Enrico Maricar on 22/08/24.
//

import Foundation
import SwiftUI

struct CreditsView: View {
    @State private var animate = false
    @State private var showNextView = false
    @State private var showTextCredit = false
    
    var body: some View {
        if showNextView {
//            NextView() // Tampilan tujuan setelah kredit selesai
        } else {
            ZStack {
                Image("Credit bg")
                    .resizable()
                    .scaledToFill()
                    .ignoresSafeArea()
                
                GeometryReader { geometry in
                    ZStack {
                        ScrollView {
                            VStack(spacing: 20) {
                                ForEach(credits, id: \.self) { credit in
                                    Text(credit)
                                        .font(.custom("PilcrowRoundedVariable-Regular", size: 52))
                                        .fontWeight(.bold)
                                        .foregroundColor(.white)
                                        .padding()
                                }
                                Spacer()
                                    .frame(height: geometry.size.height / 2) // Ruang kosong untuk logo
                            }
                            .offset(y: animate ? -geometry.size.height : geometry.size.height)
                        }
                        
                        if showTextCredit {
                            Image("Logo")
                                .resizable()
                                .frame(width: 100, height: 100)
                                .foregroundColor(.white)
                        }
                        
                    }
                    .position(x: geometry.size.width / 2, y: geometry.size.height * 0.5)
                    .onAppear {
                        withAnimation(.linear(duration: 20)) {
                            animate = true
                        }
                        DispatchQueue.main.asyncAfter(deadline: .now() + 15) { // 20 detik animasi + 3 detik berhenti
                            withAnimation {
                                showTextCredit = true
                            }
                            DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                                
                            }
                        }
                    }
                }
            }
        }
    }
    
    func calculateLogoOffset(geometry: GeometryProxy) -> CGFloat {
        let logoPosition = geometry.size.height / 2
        let logoHeight: CGFloat = 100 // Tinggi logo
        let offset = max(-geometry.size.height, logoPosition - logoHeight / 2)
        return offset
    }
    
    let credits = [
        "Flippy Math",
        "By Childhood",
        "Ayatullah Ma'arif",
        "Enrico Olivian Maricar",
        "Muh.Fathin Abdillah",
        "Rajesh Triadi Noftarizal",
        "William Jonathan Handoko"
    ]
}


#Preview {
    CreditsView()
        .previewInterfaceOrientation(.landscapeLeft)
}
