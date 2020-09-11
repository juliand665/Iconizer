import CoreGraphics

extension CGContext {
	func scale(by scale: CGSize) {
		scaleBy(x: scale.width, y: scale.height)
	}
	
	func translate(by delta: CGVector) {
		translateBy(x: delta.dx, y: delta.dy)
	}
}

extension CGImage {
	var size: CGSize {
		CGSize(width: width, height: height)
	}
}
