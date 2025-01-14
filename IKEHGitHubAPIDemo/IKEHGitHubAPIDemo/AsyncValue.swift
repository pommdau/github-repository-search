//
//  AsyncValue.swift
//  IKEHGitHubAPIDemo
//
//  Created by HIROKI IKEUCHI on 2025/01/14.
//
//  Refs: [非同期処理をラクにする！SwiftUIでの設計パターンの紹介](https://zenn.dev/timetree/articles/97ad70c4611894)

enum AsyncValue<Item, E: Error> {
    case initial /// 読み込み開始前
    case loading(Item?) /// 読み込み中 or リフレッシュ中
    case loaded(Item) /// 読み込み成功
    case error(E, Item?) ///エラー
}
