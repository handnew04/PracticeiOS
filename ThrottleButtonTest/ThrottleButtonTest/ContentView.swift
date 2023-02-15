//
//  ContentView.swift
//  ThrottleButtonTest
//
//  Created by yujung on 2023/02/09.
//

import SwiftUI
import Combine

struct ContentView: View {
  var body: some View {
      ThrottleButton(action: { print("Throttle button tapped") })
  }
}

struct ThrottleButton: View {
  @StateObject var throttleObject = ThrottleObject()
  private let action: () -> Void
  
  init(action: @escaping () -> Void) {
    self.action = action
  }
  
  var body: some View {
    Button(action: {
      print("tap tap tap")
      throttleObject.perform(action)
    }) {
      Text("쓰로틀 버튼!")
    }
  }
}

public final class ThrottleObject: ObservableObject {
  private let subject = PassthroughSubject<() -> Void, Never>()
  private let subscription: AnyCancellable
  
  init() {
    subscription = subject
      .throttle(for: .seconds(1), scheduler: DispatchQueue.main, latest: true)
      .sink {
        $0()
      }
  }
  
  func perform(_ action: @escaping () -> Void) {
    subject.send(action)
  }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
