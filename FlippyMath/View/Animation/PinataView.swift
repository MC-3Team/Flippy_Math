//
//  PinataView.swift
//  FlippyMath
//
//  Created by Ayatullah Ma'arif on 18/08/24.
//

import SwiftUI
import RiveRuntime

struct PinataView: View {
    @StateObject var riveVM = RiveViewModel(fileName: "pinata", stateMachineName: "State Machine 1")
    
    
    var body: some View {
        VStack{
            riveVM.view()
                .ignoresSafeArea()
              
        }
       
    }
}

struct SwingingPinataView: View {
    @StateObject var riveVM = RiveViewModel(fileName: "pinata2", stateMachineName: "State Machine 1")
    
    
    var body: some View {
        VStack{
            riveVM.view()
                .ignoresSafeArea()
            
        }
        
    }
}



#Preview {
    PinataView()
}

#Preview {
    SwingingPinataView()
}
