//
//  SoundAnalysisService.swift
//  FlippyMath
//
//  Created by Enrico Maricar on 05/08/24.
//

import Foundation
import RxSwift

protocol SoundAnalysisService {
    func startAnalysis() -> Observable<(String?, Bool)>
    func stopAnalysis()
}
