import Foundation
import HandyOperators

struct AssetProperties: Identifiable, Equatable, Encodable {
	static let formatter = NumberFormatter() <- {
		$0.maximumFractionDigits = 2
	}
	
	let id = UUID()
	
	var idiom: Idiom
	var size: CGSize
	var scale: Scale
	var background: TemplatePNG?
	var mask: TemplatePNG?
	
	var filename: String {
		"\(idiom.rawValue)_\(sizeString)\(scale.suffix).png"
	}
	
	var widthString: String { Self.formatter.string(from: size.width as NSNumber)! }
	var heightString: String { Self.formatter.string(from: size.height as NSNumber)! }
	
	var sizeString: String {
		"\(widthString)x\(heightString)"
	}
	
	var pixelWidth: Int {
		Int(exactly: size.width * .init(scale.rawValue))!
	}
	
	var pixelHeight: Int {
		Int(exactly: size.height * .init(scale.rawValue))!
	}
	
	func encode(to encoder: Encoder) throws {
		let raw = RawImageAsset(filename: filename, idiom: idiom, scale: "\(scale.rawValue)x", size: sizeString)
		try encoder.singleValueContainer() <- { try $0.encode(raw) }
	}
	
	enum Scale: Int, Hashable {
		case single = 1
		case double
		case triple
		
		var suffix: String {
			switch self {
			case .single:
				return ""
			case let other:
				return "@\(other.rawValue)x"
			}
		}
	}
	
	enum Idiom: String, Hashable, Codable {
		case iPhone = "iphone"
		case iPad = "ipad"
		case iOSMarketing = "ios-marketing"
		case mac = "mac"
	}
	
	struct RawImageAsset: Codable {
		let filename: String
		let idiom: Idiom
		let scale: String
		let size: String
	}
}

struct TemplatePNG: Hashable {
	let url: URL
	
	init(name: String) {
		self.url = Bundle.main.url(forResource: name, withExtension: "png", subdirectory: "Templates")!
	}
	
	func load() -> CGImage {
		.loadFromPNG(at: url)!
	}
}

struct ImageSetContents: Encodable {
	var images: [AssetProperties]
	let info = Info()
	
	struct Info: Encodable {
		let version = 1
		let author = "xcode" // TODO: test if this has to be xcode
	}
}
