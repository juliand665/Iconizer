import SwiftUI

struct IconCustomization: View {
	@Binding var settings: IconSettings
	
	var body: some View {
		group(label: "macOS") {
			Toggle("Include macOS icons", isOn: $settings.includeMac)
			Toggle("Automatically apply macOS Big Sur style", isOn: $settings.stylizeMac)
		}
		
		group(label: "iOS") {
			Toggle("Include iPhone icons", isOn: $settings.includeiPhone)
			Toggle("Include iPad icons", isOn: $settings.includeiPad)
			Toggle("Include iOS Marketing icons", isOn: $settings.includeiOSMarketing)
		}
	}
	
	func group<V: View>(label: String, @ViewBuilder content: () -> V) -> some View {
		GroupBox(label: Text(label)) {
			VStack(alignment: .leading) {
				content()
			}
			.frame(maxWidth: .infinity, alignment: .leading)
			.padding(6)
		}
	}
}

struct IconCustomization_Previews: PreviewProvider {
	static var previews: some View {
		VStack {
			IconCustomization(settings: .constant(IconSettings()))
		}
		.padding()
	}
}
