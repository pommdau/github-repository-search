////
////  AsyncValue.swift
////  GitHubRepositorySearch
////
////  Created by HIROKI IKEUCHI on 2025/05/08.
////
//
//import Foundation
//
///// 非同期処理の状態を含む型を定義
///// - SeeAlso: [非同期処理をラクにする！SwiftUIでの設計パターンの紹介](https://zenn.dev/timetree/articles/97ad70c4611894)
//enum AsyncValue<T: Equatable, E: Error> {
//    case initial /// 読み込み開始前
//    case loading(T?) /// 読み込み中 or リフレッシュ中
//    case loaded(T) /// 読み込み成功
//    case error(E, T?) /// エラー
//}
