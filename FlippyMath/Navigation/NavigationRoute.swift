//
//  NavigationRoute.swift
//  FlippyMath
//
//  Created by Enrico Maricar on 22/08/24.
//

import Foundation
import Routing
import SwiftUI

enum NavigationRoute: Routable {
    case home
    case history
    case question(Int, Parameter)
    case credit
    
    var body: some View {
        switch self {
        case .home:
            HomeView()
        case .history:
            HistoryGridView()
        case .question(let sequence, let parameter):
            QuestionView(sequenceLevel: sequence, parameter: parameter)
        case .credit:
            CreditsView()
        }
    }
}
