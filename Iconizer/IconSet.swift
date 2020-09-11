import Foundation
import Bitmap
import HandyOperators
import CGeometry

struct IconSet {
	let manifest: ImageSetContents
	let assets: [(properties: AssetProperties, image: CGImage)]
	
	init(from iconArtwork: Drawable, properties: [AssetProperties]) {
		self.manifest = ImageSetContents(images: properties)
		self.assets = properties.map {
			($0, createIcon(from: iconArtwork, with: $0))
		}
	}
	
	func makeExportedFolder() -> FileWrapper {
		let files = [String: FileWrapper](
			uniqueKeysWithValues: assets.map { properties, image in
				let iconData = image.encoded()
				return (
					properties.filename,
					FileWrapper(regularFileWithContents: iconData)
				)
			}
		)
		
		let encodedManifest = try! encoder.encode(manifest)
		let manifestFile = FileWrapper(regularFileWithContents: encodedManifest)
		
		
		return FileWrapper(directoryWithFileWrappers: files <- {
			$0["Contents.json"] = manifestFile
		}) <- {
			$0.preferredFilename = "AppIcon.appiconset"
		}
	}
}

private let encoder = JSONEncoder() <- {
	$0.outputFormatting = .prettyPrinted
}

func createIcon(from iconArtwork: Drawable, with properties: AssetProperties) -> CGImage {
	let mask = properties.mask?.load()
	let bitmap = properties.background.map { Bitmap(from: $0.load()) }
		?? Bitmap(width: properties.pixelWidth, height: properties.pixelHeight)
	
	bitmap.withContext { context in
		context.configureForDrawing()
		
		let artworkSize = mask?.size ?? bitmap.size
		print("artwork size: \(artworkSize)") // TODO: somehow report this back to the user?
		let center = CGPoint(bitmap.size / 2)
		let artworkRect = CGRect(center: center, size: artworkSize)
		
		if let mask = mask {
			context.clip(to: artworkRect, mask: mask)
		}
		iconArtwork.draw(in: context, within: artworkRect)
	}
	
	return bitmap.cgImage()
}

extension CGContext {
	func configureForDrawing() {
		// make bitmaps in pdfs render with interpolation, and probably generally looks better
		interpolationQuality = .high
	}
}
