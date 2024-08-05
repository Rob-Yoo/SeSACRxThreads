//
//  PasswordViewModel.swift
//  SeSACRxThreads
//
//  Created by Jinyoung Yoo on 8/5/24.
//

import Foundation
import RxSwift
import RxCocoa

final class PasswordViewModel {
    
    struct Input {
        let passwordText: ControlProperty<String>
        let nextButtonTapped: ControlEvent<Void>
    }
    
    struct Output {
        let validation: SharedSequence<DriverSharingStrategy, Bool>
        let nextButtonTapped: ControlEvent<Void>
    }
    
    func tranform(input: Input) -> Output {
        let validation = input.passwordText.map { $0.count >= 8 }.asDriver(onErrorJustReturn: false)
        
        return Output(validation: validation, nextButtonTapped: input.nextButtonTapped)
    }
}
