// The Swift Programming Language
// https://docs.swift.org/swift-book

import Adwaita
import OpenGL.GL3


@main
struct AdwaitaTemplate: App {

    let id = "io.github.AparokshaUI.AdwaitaTemplate"
    var app: GTUIApp!

    var scene: Scene {
        Window(id: "main") { window in
            Overlay()
                .overlay {
                    Text("hud1")
                        .halign(Alignment.center)
                        .valign(Alignment.center)
                        .css { ".hud { background: transparent; }"}
                        .style("hud")
                    Text("hud2")
                        .halign(Alignment.start)
                        .valign(Alignment.start)
                        .css { ".hud { background: transparent; }"}
                        .style("hud")
                }
                .child {
                    // Text(Loc.helloWorld)
                    GLArea()
                        .render {
                            glClearColor (0.5, 0.5, 0, 1);
                            glClear(UInt32(GL_COLOR_BUFFER_BIT));
                        }
                }
                .topToolbar {
                    ToolbarView(app: app, window: window)
                }
        }
        .defaultSize(width: 450, height: 300)
    }

}
