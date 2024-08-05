//
//  BirthdayViewModel.swift
//  SeSACRxThreads
//
//  Created by Jinyoung Yoo on 8/5/24.
//

import Foundation
import RxSwift
import RxCocoa

final class BirthdayViewModel {
    
    private let disposeBag = DisposeBag()
    
    struct Input {
        let birthday: ControlProperty<Date>
        let nextButton: ControlEvent<Void>
    }
    
    struct Output {
        let year: BehaviorRelay<Int>
        let month: BehaviorRelay<Int>
        let day: BehaviorRelay<Int>
        let ageValid:  SharedSequence<DriverSharingStrategy, Bool>
        let nextButton: ControlEvent<Void>
    }
    
    func transform(input: Input) -> Output {
        let current = Calendar.current.dateComponents([.year, .month, .day], from: .now)
        let year = BehaviorRelay(value: current.year!)
        let month = BehaviorRelay(value: current.month!)
        let day = BehaviorRelay(value: current.day!)
        let age = BehaviorRelay(value: 0)
        let ageValid = age.map { $0 >= 17 }.asDriver(onErrorJustReturn: false)
        
        input.birthday
            .bind(with: self) { owner, date in
                let dateComponents = Calendar.current.dateComponents([.year, .month, .day], from: date)
                
                age.accept(current.year! - dateComponents.year!)
                year.accept(dateComponents.year!)
                month.accept(dateComponents.month!)
                day.accept(dateComponents.day!)
            }
            .disposed(by: disposeBag)
        
        return Output(year: year, month: month, day: day, ageValid: ageValid, nextButton: input.nextButton)
    }
}
