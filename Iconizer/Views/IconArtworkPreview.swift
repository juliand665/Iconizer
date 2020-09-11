import SwiftUI
import CGeometry

struct IconArtworkPreview: View {
	@Binding var iconArtwork: Drawable?
	@State var iconPreviewSize = CGSize.one * 320 // for preview
	@State var isTargetedForIconDrop = false
	
	let handleDrop: ([NSItemProvider]) -> Bool
	
	var body: some View {
		//let radius = 0.2 * iconPreviewSize.min
		let radius: CGFloat = 4
		let padding: CGFloat = 1
		ZStack {
			RoundedRectangle(cornerRadius: radius + padding, style: .continuous)
				.fill(Color(.separatorColor))
			
			Group {
				if let iconArtwork = iconArtwork {
					Image(nsImage: NSImage(cgImage: iconArtwork.previewImage, size: .zero))
						.resizable()
				} else {
					VStack(spacing: 8) {
						Text("Drop Icon Artwork Here")
							.font(.title3)
							.fontWeight(.medium)
						Text("supported formats:\nPNG, PDF")
					}
					.multilineTextAlignment(.center)
					.opacity(0.5)
					.padding()
					.frame(maxWidth: .infinity, maxHeight: .infinity)
					.background(Color(.textBackgroundColor))
				}
				
				if isTargetedForIconDrop {
					RoundedRectangle(cornerRadius: radius, style: .continuous)
						.strokeBorder(Color(.controlAccentColor).opacity(0.5), lineWidth: 8)
				}
			}
			.measured { iconPreviewSize = $0 }
			.mask(RoundedRectangle(cornerRadius: radius, style: .continuous))
			.padding(padding)
			.onDrop(of: [.fileURL, .png, .pdf], isTargeted: $isTargetedForIconDrop, perform: handleDrop)
		}
		.aspectRatio(1, contentMode: .fit)
		.frame(minWidth: 300, idealWidth: 512 + padding, minHeight: 300, idealHeight: 512 + padding)
	}
}

struct IconArtworkPreview_Previews: PreviewProvider {
	static var previews: some View {
		Group {
			IconArtworkPreview(iconArtwork: .constant(nil), handleDrop: { _ in true })
			IconArtworkPreview(iconArtwork: .constant(nil), isTargetedForIconDrop: true, handleDrop: { _ in true })
		}
		.padding()
		.previewLayout(.sizeThatFits)
	}
}
