import Collections
import Observation
import SwiftUI

@Observable
class PanelsModel {
    var panels: OrderedDictionary<String, Panel> = [:]
}

public struct Panel {
    public var id: String
    public var label: String
    public var body: AnyView

    public init<V>(id: String, label: String, @ViewBuilder body: () -> V) where V: View {
        self.id = id
        self.label = label
        self.body = AnyView(body())
    }
}

extension Panel: Identifiable {
}

extension Panel: Equatable {
    public static func == (lhs: Panel, rhs: Panel) -> Bool {
        lhs.id == rhs.id && lhs.label == rhs.label
    }
}

struct PanelModifier: ViewModifier {
    @Environment(PanelsModel.self)
    var panelsModel

    var panel: Panel

    init<V>(id: String, label: String, @ViewBuilder body: () -> V) where V: View {
        self.panel = Panel(id: id, label: label, body: body)
    }

    func body(content: Content) -> some View {
        content
            .onChange(of: panel, initial: true) {
                panelsModel.panels[panel.id] = panel
            }
            .onDisappear {
                panelsModel.panels[panel.id] = nil
            }
    }
}

public extension View {
    func panel(id: String, label: String, @ViewBuilder body: () -> some View) -> some View {
        self.modifier(PanelModifier(id: id, label: label, body: body))
    }
}

struct PanelsHostModifier: ViewModifier {
    @State
    var panelsModel = PanelsModel()

    func body(content: Content) -> some View {
        content
            .environment(panelsModel)
    }
}

public extension View {
    func panelsHost() -> some View {
        self.modifier(PanelsHostModifier())
    }
}

public struct Panels <Content>: View where Content: View {
    @Environment(PanelsModel.self)
    var panelsModel

    var content: (Panel) -> Content

    public init(@ViewBuilder content: @escaping (Panel) -> Content) {
        self.content = content
    }

    public var body: some View {
        ForEach(panelsModel.panels.values.reversed()) { panel in
            content(panel).id(panel.id)
        }
    }
}

public extension Panels where Content == AnyView {
    init() {
        self.content = \.body
    }
}

#Preview {
    VStack {
        Text("Hello world")
            .panel(id: "1", label: "Panel #1") { Text("Panel #1")}
        Text("Hello world")
            .panel(id: "2", label: "Panel #2") { Text("Panel #2")}
        Text("Hello world")
            .panel(id: "3", label: "Panel #3") { Text("Panel #3")}
    }
    .inspector(isPresented: .constant(true), content: {
        Form {
            Panels { panel in
                DisclosureGroup(panel.label) {
                    panel.body
                }
            }
        }
    })
    .panelsHost()
}
