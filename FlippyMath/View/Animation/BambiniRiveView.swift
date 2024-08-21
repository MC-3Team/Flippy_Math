//
//  FlippyRiveView.swift
//  FlippyMath
//
//  Created by Ayatullah Ma'arif on 14/08/24.
//

import SwiftUI
import RiveRuntime

enum FlippyValue: Hashable {
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

struct FlippyRiveInput: Hashable {
    
    var key: FlippyKeyInput
    var value: FlippyValue
    
    static func == (lhs: FlippyRiveInput, rhs: FlippyRiveInput) -> Bool {
        return lhs.key == rhs.key && lhs.value == rhs.value
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(key)
        hasher.combine(value)
    }
}

enum FlippyKeyInput: String {
    case talking, isSad, isRightHandsUp, isLeftHandsUp
}


struct FlippyRiveView: View {
    
    @StateObject var riveVM = RiveViewModel(fileName: "flippy", stateMachineName: "State Machine 1")
    
    @Binding var riveInput : [FlippyRiveInput]
    
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
//    FlippyRiveView(riveInput: [
//        FlippyRiveInput(key: .talking, value: FlippyValue.float(0.0)),
//        FlippyRiveInput(key: .isSad, value: .bool(true)),
//        FlippyRiveInput(key: .isRightHandsUp, value: .bool(true)),
//        FlippyRiveInput(key: .isLeftHandsUp, value: .bool(true))
//    ])
//}
