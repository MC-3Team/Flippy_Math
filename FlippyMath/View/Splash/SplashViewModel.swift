//
//  SplashViewModel.swift
//  BambiniMath
//
//  Created by Enrico Maricar on 15/08/24.
//

import Foundation

class SplashViewModel : ObservableObject {
    @Inject(name: "CoreDataManager") var service: DataService
    
    func insertAllData() {
        service.insertAllData()
    }
}
