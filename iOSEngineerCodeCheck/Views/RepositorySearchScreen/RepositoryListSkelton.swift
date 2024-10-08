//
//  RepositoryListSkelton.swift
//  iOSEngineerCodeCheck
//
//  Created by HIROKI IKEUCHI on 2024/09/30.
//  Copyright © 2024 YUMEMI Inc. All rights reserved.
//

import SwiftUI

struct RepositoryListSkelton: View {
    var body: some View {
        List {
            ForEach(0..<10) { _ in
                RepositoryCellSkelton()
            }
        }
    }
}

#Preview {
    RepositoryListSkelton()
}
