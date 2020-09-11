import SwiftUI

struct IconSetPreview: View {
	let iconSet: IconSet?
	
	var body: some View {
		Group {
			if let iconSet = iconSet {
				ScrollView(.vertical) {
					VStack {
						ForEach(iconSet.assets, id: \.properties.id) { properties, image in
							VStack {
								Image(nsImage: NSImage(cgImage: image, size: .zero))
									.resizable()
									.aspectRatio(contentMode: .fit)
									.frame(maxWidth: properties.size.width, maxHeight: properties.size.height)
								
								Text(verbatim: "\(properties.idiom.rawValue), \(properties.userFacingSize)")
							}
						}
					}
					.animation(.easeInOut)
					.frame(maxWidth: .infinity)
					.padding()
				}
			} else {
				Text("Preview")
					.opacity(0.5)
					.frame(maxWidth: .infinity, maxHeight: .infinity)
			}
		}
		.background(Color(.textBackgroundColor))
		.frame(idealWidth: 200)
	}
}

private extension AssetProperties {
	var userFacingSize: String {
		"\(widthString)×\(heightString)\(scale.suffix)"
	}
}

struct IconSetPreview_Previews: PreviewProvider {
	static var previews: some View {
		IconSetPreview(iconSet: nil)
	}
}
