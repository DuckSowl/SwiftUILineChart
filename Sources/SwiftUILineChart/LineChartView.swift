//
//  LineChartView.swift
//
//
//  Created by Anton Tolstov on 18.03.2020.
//

import SwiftUI

public struct LineChartView: View {
    public var values: [Double]
    public var horizontalTicks: [String]
    public var verticalTicks: [String]
    public var style: LineChartStyle
    
    public init(values: [Double], horizontalTicks: [String],
                verticalTicks: [String], style: LineChartStyle) {
        self.values = values
        self.horizontalTicks = horizontalTicks
        self.verticalTicks = verticalTicks
        self.style = style
    }
    
    public var body: some View {
        HStack(spacing: 0) {
            VStack(spacing: 0) {
                ZStack(alignment: .leading) {
                    GeometryReader { geometry in
                        self.gridView(.vertical)
                        self.gridView(.horizontal)
                        
                        self.closedPath(in: geometry.size)
                            .fill(LinearGradient(gradient: self.style.gradient,
                                                 startPoint: .top,
                                                 endPoint: .bottom))
                        
                        self.path(in: geometry.size)
                            .stroke(self.style.lineColor,
                                    style: StrokeStyle(lineWidth: 2,
                                                       lineJoin: .round))
                    }
                }
                
                self.separatorView(.vertical)
                
                self.ticksView(.horizontal)
                    .frame(height: 30)
            }
            
            VStack {
                self.ticksView(.vertical)
                    .fixedSize(horizontal: true, vertical: false)
                Spacer(minLength: 30)
            }
        }
    }
    
    private func separatorView(_ orientation: Orientation) -> some View {
        Group {
            if self.style.drawGrid || self.style.drawTicks {
                self.style.gridColor.frame(width: orientation == .horizontal ? 1 : .none,
                                           height: orientation == .vertical ? 1 : .none)
            } else {
                EmptyView()
            }
        }
    }
    
    private func gridView(_ orientation: Orientation) -> some View {
        StackView(data: orientation == .horizontal ? horizontalTicks
            : verticalTicks,
                  content: { _ in EmptyView() },
                  separator: { self.separatorView(orientation) },
                  orientation: orientation)
    }
    
    private func ticksView(_ orientation: Orientation) -> some View {
        Group {
            if self.style.drawTicks {
                StackView(data: ticks(for: orientation),
                          content: {
                            Text($0)
                                .font(.system(size: 16, weight: .semibold))
                                .foregroundColor(.white)
                                .padding(4)
                },
                          separator: { self.separatorView(orientation) },
                          orientation: orientation)
            } else {
                EmptyView()
            }
        }
    }
    
    private func ticks(for orientation: Orientation) -> [String] {
        return orientation == .horizontal ? horizontalTicks : verticalTicks
    }
    
    private func path(in size: CGSize) -> Path {
        var path = Path()
        
        if values.isEmpty { return path }
        
        let minValue = values.min()!
        let maxValue = values.max()!
        let deltaValue = maxValue - minValue
        
        var previousPosition = CGPoint(x: 0,
                                       y: size.height - (size.height / CGFloat(deltaValue)) * CGFloat(values[0] - minValue))
        
        path.move(to: previousPosition)
        
        for value in values[1...].enumerated() {
            let nextPosition = CGPoint(x: (size.width / CGFloat(values.count - 1)) * CGFloat(value.offset + 1),
                                       y: size.height - (size.height / CGFloat(deltaValue)) * CGFloat(value.element - minValue))
            
            let control = CGPoint(x: CGFloat.random(in: previousPosition.x..<nextPosition.x),
                                  y: (previousPosition.y + nextPosition.y) / 2)
            
            path.addQuadCurve(to: nextPosition,
                              control: control)
            
            previousPosition = nextPosition
        }
        
        return path
    }
    
    private func closedPath(in size: CGSize) -> Path {
        var path = self.path(in: size)
        
        path.addLine(to: CGPoint(x: size.width, y: size.height))
        path.addLine(to: CGPoint(x: 0, y: size.height))
        path.closeSubpath()
        
        return path
    }
}

public struct LineChartStyle {
    public var drawTicks: Bool = true
    public var drawGrid: Bool = true
    public var gridColor: Color = Color.gray.opacity(0.3)
    public var lineColor: Color = .white
    public var gradient: Gradient = Gradient(colors: [])
    
    public init(drawTicks: Bool = true, drawGrid: Bool = true,
                gridColor: Color = Color.gray.opacity(0.3),
                lineColor: Color = .white,
                gradient: Gradient = Gradient(colors: [])) {
        
        self.drawTicks = drawTicks
        self.drawGrid = drawGrid
        self.gridColor = gridColor
        self.lineColor = lineColor
        self.gradient = gradient
    
    public static let red = LineChartStyle(lineColor: .red,
                                    gradient: Gradient(colors: [
                                        Color.red.opacity(0.5),
                                        Color.red.opacity(0.1)
                                    ]))
    
    public static let green = LineChartStyle(lineColor: .green,
                                      gradient: Gradient(colors: [
                                        Color.green.opacity(0.5),
                                        Color.green.opacity(0.1)
                                      ]))
    
    public static let redOutline = LineChartStyle(drawTicks: false,
                                           drawGrid: false,
                                           lineColor: .red,
                                           gradient: Gradient(colors: [
                                            Color.red.opacity(0.5),
                                            Color.red.opacity(0.1)
                                           ]))
    
    public static let greenOutline = LineChartStyle(drawTicks: false,
                                             drawGrid: false,
                                             lineColor: .green,
                                             gradient: Gradient(colors: [
                                                Color.green.opacity(0.5),
                                                Color.green.opacity(0.1)
                                             ]))
}
