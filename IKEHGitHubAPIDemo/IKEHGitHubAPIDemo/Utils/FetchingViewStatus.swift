//
//  FetchingViewStatus.swift
//  IKEHGitHubAPIDemo
//
//  Created by HIROKI IKEUCHI on 2025/02/02.
//

import Foundation

enum FetchingViewStatus: Equatable {
    case initial /// 読み込み開始前
    case loading /// 読み込み中 or リフレッシュ中
    case loaded /// 読み込み成功
    case loadingMore ///追加読み込み中
    case error ///エラー
}
