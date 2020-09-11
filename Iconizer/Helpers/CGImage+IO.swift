import Foundation
import UniformTypeIdentifiers
import SwiftCF

extension CGImage {
	static func loadFromPNG(at url: URL) -> CGImage? {
		guard let provider = CGDataProvider(url: url as CFURL) else { return nil }
		return CGImage(
			pngDataProviderSource: provider,
			decode: nil,
			shouldInterpolate: true, // this actually effects how the image ends up being drawn
			intent: .defaultIntent
		)
	}
	
	func encoded() -> Data {
		let outputData = CFMutableData.create()
		let destination = CGImageDestination.create(data: outputData, type: UTType.png.identifier as CFString, count: 1)!
		destination.addImage(self)
		let wasSuccessful = destination.finalize()
		assert(wasSuccessful)
		return outputData as Data
	}
}
