import SwiftUI

struct ShimmeringView<Content: View>: View {
  private let content: () -> Content
  private let configuration: ShimmerConfiguration
  @State
  private var startPoint: UnitPoint
  @State
  private var endPoint: UnitPoint
  
  init(
    configuration: ShimmerConfiguration,
    @ViewBuilder content: @escaping () -> Content
  ) {
    self.configuration = configuration
    self.content = content
    self.startPoint = configuration.initialLocation.start
    self.endPoint = configuration.initialLocation.end
  }
  
  var body: some View {
    content()
      .overlay {
        LinearGradient(
          gradient: configuration.gradient,
          startPoint: startPoint,
          endPoint: endPoint
        )
        .opacity(configuration.opacity)
        .blendMode(.screen)
        .onAppear {
          withAnimation(
            Animation
              .linear(duration: configuration.duration)
              .repeatForever(autoreverses: false)
          ) {
            startPoint = configuration.finalLocation.start
            endPoint = configuration.finalLocation.end
          }
        }
      }
  }
}

public struct ShimmerModifier: ViewModifier {
  public let configuration: ShimmerConfiguration
  
  public func body(content: Content) -> some View {
    ShimmeringView(configuration: configuration) { content }
  }
}

extension View {
  @ViewBuilder
  public func shimmer(
    configuration: ShimmerConfiguration = .default(),
    isActive: Bool
  ) -> some View {
    if isActive {
      modifier(ShimmerModifier(configuration: configuration))
    }
    else {
      self
    }
  }
}

public struct ShimmerConfiguration {
  public init(
    gradient: Gradient,
    duration: TimeInterval,
    opacity: Double,
    initialLocation: Self.Location,
    finalLocation: Self.Location
  ) {
    self.gradient = gradient
    self.duration = duration
    self.opacity = opacity
    self.initialLocation = initialLocation
    self.finalLocation = finalLocation
  }
  
  public let gradient: Gradient
  public let duration: TimeInterval
  public let opacity: Double
  public let initialLocation: Self.Location
  public let finalLocation: Self.Location
}

extension ShimmerConfiguration {
  public struct Location: Equatable {
    public init(
      start: UnitPoint,
      end: UnitPoint
    ) {
      self.start = start
      self.end = end
    }
    
    public var start: UnitPoint
    public var end: UnitPoint
  }
}

extension ShimmerConfiguration {
  public static func `default`(
    gradient: Gradient = .shimmering,
    duration: TimeInterval = 1.5,
    opacity: Double = 0.2,
    initialLocation: Location = .init(start: UnitPoint(x: -3, y: -1), end: .leading),
    finalLocation: Location = .init(start: .trailing, end: UnitPoint(x: 4, y: 1))
  ) -> ShimmerConfiguration {
    ShimmerConfiguration(
      gradient: gradient,
      duration: duration,
      opacity: opacity,
      initialLocation: initialLocation,
      finalLocation: finalLocation
    )
  }
}

extension Gradient {
  public static var shimmering: Self {
    .init(stops: [
      .init(color: .black, location: 0),
      .init(color: .white, location: 0.4),
      .init(color: .white, location: 0.6),
      .init(color: .black, location: 1),
    ])
  }
}
