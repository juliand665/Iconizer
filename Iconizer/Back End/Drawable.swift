import Foundation
import CGeometry
import Bitmap

protocol Drawable {
	var previewImage: CGImage { get }
	
	func draw(in context: CGContext, within rect: CGRect)
}

struct PNG: Drawable {
	let image: CGImage
	
	var previewImage: CGImage { image }
	
	init?(at url: URL) {
		guard let image = CGImage.loadFromPNG(at: url) else { return nil }
		self.image = image
	}
	
	func draw(in context: CGContext, within rect: CGRect) {
		context.draw(image, in: rect)
	}
}

struct PDF: Drawable {
	let page: CGPDFPage
	let cropBox: CGRect
	let previewImage: CGImage
	
	init?(at url: URL) {
		guard let document = CGPDFDocument(url as CFURL) else { return nil }
		self.page = document.page(at: 1)!
		self.cropBox = page.getBoxRect(.cropBox)
		
		let preview = Bitmap(width: Int(cropBox.width), height: Int(cropBox.height))
		preview.withContext { [page] context in
			context.configureForDrawing()
			context.drawPDFPage(page)
		}
		previewImage = preview.cgImage()
	}
	
	func draw(in context: CGContext, within rect: CGRect) {
		// TODO: include crop box origin in translation
		context.translate(by: CGVector(rect.origin))
		context.scale(by: rect.size / cropBox.size)
		context.drawPDFPage(page)
	}
}
