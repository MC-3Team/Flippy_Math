//
//  BambiniRiveView.swift
//  BambiniMath
//
//  Created by Ayatullah Ma'arif on 14/08/24.
//

import SwiftUI
import RiveRuntime

enum BambiniValue: Hashable {
    case bool(Bool)
    case float(Float)
    
    // Returns the underlying value as a type-erased Any
    func getValue() -> Any {
        switch self {
        case .bool(let value):
            return value
        case .float(let value):
            return value
        }
    }
}

struct BambiniRiveInput: Hashable {
    
    var key: BambiniKeyInput
    var value: BambiniValue
    
    static func == (lhs: BambiniRiveInput, rhs: BambiniRiveInput) -> Bool {
        return lhs.key == rhs.key && lhs.value == rhs.value
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(key)
        hasher.combine(value)
    }
}

enum BambiniKeyInput: String {
    case talking, isSad, isRightHandsUp, isLeftHandsUp
}


struct BambiniRiveView: View {
    
    @StateObject var riveVM = RiveViewModel(fileName: "bambini", stateMachineName: "State Machine 1")
    
    @Binding var riveInput : [BambiniRiveInput]
    
    var body: some View {
        ZStack{
            riveVM.view()
                .aspectRatio(contentMode: .fit)
            
        }
        .onChange(of: riveInput) {_ , _ in
            riveInput.forEach(){ input in
                
                if type(of: input.value.getValue()) == Bool.self{
                    riveVM.setInput(input.key.rawValue, value: input.value.getValue() as! Bool)
                }
                else{
                    riveVM.setInput(input.key.rawValue, value: input.value.getValue() as! Float)
                }
                
            }

        }
    }
}

//#Preview {
//    BambiniRiveView(riveInput: [
//        BambiniRiveInput(key: .talking, value: BambiniValue.float(0.0)),
//        BambiniRiveInput(key: .isSad, value: .bool(true)),
//        BambiniRiveInput(key: .isRightHandsUp, value: .bool(true)),
//        BambiniRiveInput(key: .isLeftHandsUp, value: .bool(true))
//    ])
//}
