import Foundation
import UserDefault

final class IconManager: ObservableObject {
	@UserDefault("iconSettings") static private var storedSettings: IconSettings?
	
	@Published var artwork: Drawable? {
		didSet { generateAssets() }
	}
	@Published var settings = storedSettings ?? IconSettings() {
		didSet {
			Self.storedSettings = settings
			generateAssets()
		}
	}
	@Published var iconSet: IconSet?
	
	func generateAssets() {
		guard let artwork = artwork else {
			iconSet = nil
			return
		}
		
		DispatchQueue.global(qos: .userInitiated).async { [settings] in
			let iconSet = IconSet(from: artwork, properties: settings.selectedAssets)
			DispatchQueue.main.async {
				self.iconSet = iconSet
			}
		} 
	}
}

extension IconSettings: DefaultsValueConvertible {}
