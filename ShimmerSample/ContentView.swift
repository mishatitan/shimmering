import SwiftUI

struct ContentView: View {
  
  @State
  var isLoading: Bool = true
  
  var body: some View {
    VStack(spacing: 20) {
      ScrollView(.horizontal, showsIndicators: false) {
        HStack {
          ForEach(0...10, id: \.self) { _ in
            RowItemView(isLoading: isLoading)
              .frame(height: 120)
          }
        }
        .padding()
        .redacted(reason: isLoading ? .placeholder : [])
      }
      
      Button("Change view status") {
        isLoading.toggle()
      }
    }
  }
}

private struct RowItemView: View {
  var isLoading: Bool
  
  var body: some View {
    VStack(alignment: .leading, spacing: 4) {
      Image(systemName: "globe")
        .resizable()
        .frame(width: 100, height: 100)
        .cornerRadius(6)
        .shimmer(isActive: isLoading)
      Text("Sample")
        .shimmer(isActive: isLoading)
    }
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView()
  }
}
