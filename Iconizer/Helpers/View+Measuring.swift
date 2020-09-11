import SwiftUI

extension View {
	func measured(onChange: @escaping (CGSize) -> Void) -> some View {
		self
			.background(GeometryReader { proxy in
				Color.clear.preference(key: SizeKey.self, value: proxy.size)
			}.hidden())
			.onPreferenceChange(SizeKey.self) { onChange($0!) }
	}
}

private typealias SizeKey = SimplePreferenceKey<SizeKeyMarker, CGSize>
private enum SizeKeyMarker {}

struct SimplePreferenceKey<Marker, Value>: PreferenceKey {
	static var defaultValue: Value? { nil }
	
	static func reduce(value: inout Value?, nextValue: () -> Value?) {
		if value == nil {
			value = nextValue()
		}
	}
}
