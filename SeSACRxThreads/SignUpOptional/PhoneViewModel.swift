//
//  PhoneViewModel.swift
//  SeSACRxThreads
//
//  Created by Jinyoung Yoo on 8/5/24.
//

import Foundation
import RxSwift
import RxCocoa

final class PhoneViewModel {
    
    struct Intput {
        let phoneNumber: ControlProperty<String>
        let nextButtonTapped: ControlEvent<Void>
    }
    
    struct Output {
        let initialText: Observable<String>
        let allValidation: SharedSequence<DriverSharingStrategy, Bool>
        let nextButtonTapped: ControlEvent<Void>
    }
    
    func transform(input: Intput) -> Output {
        let numberValidation = input.phoneNumber.map { $0.allSatisfy { $0.isNumber } }
        let lengthValidation = input.phoneNumber.map { $0.count >= 10 }
        let allValidation = Observable.combineLatest(numberValidation, lengthValidation).map { $0 && $1 }.asDriver(onErrorJustReturn: false)
        
        return Output(initialText: Observable.just("010"), allValidation: allValidation, nextButtonTapped: input.nextButtonTapped)
    }
}
