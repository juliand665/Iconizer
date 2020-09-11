import SwiftUI

struct ContentView: View {
	@Environment(\.importFiles) var importFiles
	@Environment(\.exportFiles) var exportFiles
	
	@ObservedObject var iconManager = IconManager()
	@State var loadingError: LoadingError?
	
	var body: some View {
		HSplitView {
			VStack(spacing: 8) {
				VStack {
					IconArtworkPreview(iconArtwork: $iconManager.artwork, handleDrop: getDroppedIconArtwork(from:))
					
					Button("Open File", action: openIconArtwork)
				}
				
				Spacer()
				
				IconCustomization(settings: $iconManager.settings)
				
				Spacer()
				
				Button("Export Icon Set", action: exportIconSet)
					.disabled(iconManager.iconSet == nil)
			}
			.padding()
			
			IconSetPreview(iconSet: iconManager.iconSet)
		}
		.alert(item: $loadingError) { $0.makeAlert() }
	}
	
	func getDroppedIconArtwork(from providers: [NSItemProvider]) -> Bool {
		guard providers.count == 1 else {
			loadingError = .init(description: "Too many files dropped—expecting only one.")
			return false
		}
		let provider = providers.first!
		
		_ = provider.loadObject(ofClass: URL.self) { url, error in
			loadIconArtwork(at: url!)
		}
		
		return true
	}
	
	func openIconArtwork() {
		importFiles(singleOfType: [.pdf, .png]) { result in
			guard let result = result else { return } // canceled
			loadIconArtwork(at: try! result.get())
		}
	}
	
	func loadIconArtwork(at url: URL) {
		print("importing from \(url)")
		DispatchQueue.global(qos: .userInitiated).async {
			guard let iconArtwork: Drawable = PNG(at: url) ?? PDF(at: url) else {
				loadingError = .init(description: "Unsupported artwork format: \(url.lastPathComponent)")
				iconManager.artwork = nil
				return
			}
			
			DispatchQueue.main.async {
				iconManager.artwork = iconArtwork
			}
		}
	}
	
	func exportIconSet() {
		let output = iconManager.iconSet!.makeExportedFolder()
		exportFiles(output, contentType: .directory) { result in
			guard let result = result else { return } // canceled
			let url = try! result.get()
			print("exported to \(url)")
		}
	}
}

struct LoadingError: Identifiable {
	let id = UUID()
	
	let description: String
	
	func makeAlert() -> Alert {
		Alert(
			title: Text("Could not load icon artwork!"),
			message: Text(description)
		)
	}
}

struct ContentView_Previews: PreviewProvider {
	static var previews: some View {
		Group {
			ContentView().preferredColorScheme(.light)
			ContentView().preferredColorScheme(.dark)
		}
		.previewLayout(.sizeThatFits)
	}
}
