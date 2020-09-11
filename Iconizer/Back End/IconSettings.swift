import Foundation
import HandyOperators
import CGeometry

struct IconSettings: Hashable, Codable {
	var includeMac = true
	var stylizeMac = true
	
	var includeiPhone = true
	var includeiPad = true
	var includeiOSMarketing = true
	
	@ArrayBuilder<AssetProperties>
	var selectedAssets: [AssetProperties] {
		if includeMac {
			stylizeMac ? .macMasked : .mac
		}
		
		if includeiPhone { .iPhone }
		if includeiPad { .iPad }
		if includeiOSMarketing { .iOSMarketing }
	}
}

extension Array where Element == AssetProperties {
	private typealias Scale = AssetProperties.Scale
	
	static let mac = properties(
		idiom: .mac,
		lengths: [16, 32, 128, 256, 512],
		scales: [.single, .double]
	)
	
	static let macMasked = mac.map { properties -> AssetProperties in
		assert(properties.pixelWidth == properties.pixelHeight)
		let length = properties.pixelWidth
		return properties <- {
			$0.background = .init(name: "\(length)s")
			$0.mask = .init(name: "\(length)")
		}
	}
	
	static let iPhone = properties(
		idiom: .iPhone,
		lengths: [20, 29, 40, 60],
		scales: [.double, .triple]
	)
	
	static let iPad = properties(
		idiom: .iPad,
		lengths: [20, 29, 40, 76],
		scales: [.single, .double]
	) + [AssetProperties(idiom: .iPad, size: 83.5 * .one, scale: .double)]
	
	static let iOSMarketing = [AssetProperties(idiom: .iOSMarketing, size: 1024 * .one, scale: .single)]
	
	static let iOS = iPhone + iPad + iOSMarketing
	
	private static func properties(idiom: AssetProperties.Idiom, lengths: [Int], scales: [Scale]) -> [AssetProperties] {
		lengths.flatMap { length in
			scales.map { scale in
				AssetProperties(
					idiom: idiom,
					size: CGFloat(length) * .one,
					scale: scale
				)
			}
		}
	}
}
