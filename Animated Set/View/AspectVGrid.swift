//
//  AspectVGrid.swift
//  Set
//
//  Created by CS193p instructor on 4/24/23.
//

import SwiftUI

struct AspectVGrid<Item: Identifiable, ItemView: View>: View {
    let items: [Item]
    var aspectRatio: CGFloat = 1.0
    var minimumGridItemWidth: CGFloat?
    let content: (Item) -> ItemView
    
    init(_ items: [Item], aspectRatio: CGFloat, minimumGridItemWidth: CGFloat? = nil, @ViewBuilder content: @escaping (Item) -> ItemView) {
        self.items = items
        self.aspectRatio = aspectRatio
        self.minimumGridItemWidth = minimumGridItemWidth
        self.content = content
    }
    
    var body: some View {
        GeometryReader { geometry in
            let gridItemSize = gridItemWidth(
                count: items.count,
                size: geometry.size,
                atAspectRatio: aspectRatio
            )
            ScrollView {
                LazyVGrid(columns: [GridItem(.adaptive(minimum: gridItemSize), spacing: 0)], spacing: 0) {
                    ForEach(items) { item in
                        content(item)
                            .aspectRatio(aspectRatio, contentMode: .fit)
                    }
                }
            }
        }
    }
    
    private func gridItemWidth(count: Int, size: CGSize, atAspectRatio aspectRatio: CGFloat) -> CGFloat {
        let widthThatFits = gridItemWidthThatFits(
            count: items.count,
            size: size,
            atAspectRatio: aspectRatio
        )
        if let minimumGridItemWidth = minimumGridItemWidth, minimumGridItemWidth > widthThatFits {
            return minimumGridItemWidth
        }
        return widthThatFits
    }

    private func gridItemWidthThatFits(
        count: Int,
        size: CGSize,
        atAspectRatio aspectRatio: CGFloat) -> CGFloat {
        let count = CGFloat(count)
        var columnCount = 1.0
        repeat {
            let width = size.width / columnCount
            let height = width / aspectRatio
            
            let rowCount = (count / columnCount).rounded(.up)
            if rowCount * height < size.height {
                return (size.width / columnCount).rounded(.down)
            }
            columnCount += 1
        } while columnCount < count
        return min(size.width / count, size.height * aspectRatio).rounded(.down)
    }
}

