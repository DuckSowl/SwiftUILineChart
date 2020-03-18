//
//  StackView.swift
//  
//
//  Created by Anton Tolstov on 18.03.2020.
//

import SwiftUI

struct StackView<Data: RandomAccessCollection, Content: View, Separator: View>: View
where Data.Element : Hashable {
    var data: Data
    var content: (Data.Element) -> Content
    var separator: () -> Separator
    var orientation: Orientation
    
    var body: some View {
        getStack() {
            ForEach.init(self.data, id: \.self) { element in
                ZStack(alignment: .topLeading) {
                    self.content(element)
                    
                    self.getStack() {
                        self.separator()
                        
                        Spacer()
                    }
                }
            }
            self.separator()
        }
    }
    
    private func getStack<Content: View>(@ViewBuilder content: @escaping () -> Content) -> some View {
        Group {
            if orientation == .horizontal {
                HStack(alignment: .top, content: content)
            } else {
                VStack(alignment: .leading, content: content)
            }
        }
    }
}

enum Orientation {
    case horizontal
    case vertical
}
