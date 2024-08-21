//
//  HomeViewModel.swift
//  FlippyMath
//
//  Created by Enrico Maricar on 05/08/24.
//

import Foundation
import RxSwift
import Speech

class HomeViewModel: ObservableObject {
    @Inject(name: "CoreDataManager") var service: DataService
    
    @Published var snowflakes: [Snowflake] = []
    @Published var animate = false
    @Published var isMusicOn = true
    
    private let numberOfSnowflakes = 75
    private let disposeBag = DisposeBag()
    
    func createSnowflakes(in size: CGSize) {
        snowflakes.removeAll()
        for _ in 0..<numberOfSnowflakes {
            let xPosition = CGFloat.random(in: 0...size.width)
            let duration = Double.random(in: 5...15)
            let delay = Double.random(in: 0...20)
            let snowflakeSize = CGFloat.random(in: 10...30)
            let imageName = Bool.random() ? "snow1" : "snow2" // Replace with your snowflake asset names
            let rotationDuration = Double.random(in: 3...10)
            let snowflake = Snowflake(xPosition: xPosition, duration: duration, delay: delay, size: snowflakeSize, imageName: imageName, rotationDuration: rotationDuration)
            snowflakes.append(snowflake)
        }
    }
    
//    func testingData() {
//        service.insertAllData()
//        print(service.getInCompleteQuestion().count)
//    }
}
