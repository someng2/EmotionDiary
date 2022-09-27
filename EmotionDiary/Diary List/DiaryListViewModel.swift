//
//  DiaryListViewModel.swift
//  EmotionDiary
//
//  Created by 백소망 on 2022/09/26.
//

import Foundation
import Combine

final class DiaryListViewModel: ObservableObject {
    
    // 날짜 형식 -> Dictionary
    // ex) "2022-01" : [MoodDiary]
    
    let storage: MoodDiaryStorage
    
    @Published var list: [MoodDiary] = []
    @Published var dic: [String: [MoodDiary]] = [:]
    
    var subscriptions = Set<AnyCancellable>()
    
    // 데이터 파일에서 일기 리스트 가져오기
    // list에 해당 일기 객체들 세팅
    
    init(storage: MoodDiaryStorage) {
        self.storage = storage
        bind()
//        self.dic = Dictionary(grouping: self.list, by: { $0.monthlyIdentifier })
    }
    
    // 날짜 정렬
    var keys: [String] {
        return dic.keys.sorted { $0 < $1 }
    }
    
    private func bind() {
        $list.sink { items in
            print("---> List Changed: \(items)")
            self.dic = Dictionary(grouping: items, by: { $0.monthlyIdentifier })
            self.persist(items: items)
        }.store(in: &subscriptions)
    }
    
    func persist(items: [MoodDiary]) {
        guard items.isEmpty == false else { return }
        self.storage.persist(items)
    }
    
    func fetch() {
        self.list = storage.fetch()
    }
}
