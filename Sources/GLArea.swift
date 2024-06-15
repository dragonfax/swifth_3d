//
//  GLArea.swift
//  Adwaita
//
//  Created by auto-generation on 09.06.24.
//

import CAdw
import LevenshteinTransformations
import Adwaita


/// `GtkGLArea` is a widget that allows drawing with OpenGL.
///
/// ![An example GtkGLArea](glarea.png)
///
/// `GtkGLArea` sets up its own [class@Gdk.GLContext], and creates a custom
/// GL framebuffer that the widget will do GL rendering onto. It also ensures
/// that this framebuffer is the default GL rendering target when rendering.
/// The completed rendering is integrated into the larger GTK scene graph as
/// a texture.
///
/// In order to draw, you have to connect to the [signal@Gtk.GLArea::render]
/// signal, or subclass `GtkGLArea` and override the GtkGLAreaClass.render
/// virtual function.
///
/// The `GtkGLArea` widget ensures that the `GdkGLContext` is associated with
/// the widget's drawing area, and it is kept updated when the size and
/// position of the drawing area changes.
///
/// ## Drawing with GtkGLArea
///
/// The simplest way to draw using OpenGL commands in a `GtkGLArea` is to
/// create a widget instance and connect to the [signal@Gtk.GLArea::render] signal:
///
/// The `render()` function will be called when the `GtkGLArea` is ready
/// for you to draw its content:
///
/// The initial contents of the framebuffer are transparent.
///
/// ```c
/// static gboolean
/// render (GtkGLArea *area, GdkGLContext *context)
/// {
/// // inside this function it's safe to use GL; the given
/// // GdkGLContext has been made current to the drawable
/// // surface used by the `GtkGLArea` and the viewport has
/// // already been set to be the size of the allocation
///
/// // we can start by clearing the buffer
/// glClearColor (0, 0, 0, 0);
/// glClear (GL_COLOR_BUFFER_BIT);
///
/// // draw your object
/// // draw_an_object ();
///
/// // we completed our drawing; the draw commands will be
/// // flushed at the end of the signal emission chain, and
/// // the buffers will be drawn on the window
/// return TRUE;
/// }
///
/// void setup_glarea (void)
/// {
/// // create a GtkGLArea instance
/// GtkWidget *gl_area = gtk_gl_area_new ();
///
/// // connect to the "render" signal
/// g_signal_connect (gl_area, "render", G_CALLBACK (render), NULL);
/// }
/// ```
///
/// If you need to initialize OpenGL state, e.g. buffer objects or
/// shaders, you should use the [signal@Gtk.Widget::realize] signal;
/// you can use the [signal@Gtk.Widget::unrealize] signal to clean up.
/// Since the `GdkGLContext` creation and initialization may fail, you
/// will need to check for errors, using [method@Gtk.GLArea.get_error].
///
/// An example of how to safely initialize the GL state is:
///
/// ```c
/// static void
/// on_realize (GtkGLarea *area)
/// {
/// // We need to make the context current if we want to
/// // call GL API
/// gtk_gl_area_make_current (area);
///
/// // If there were errors during the initialization or
/// // when trying to make the context current, this
/// // function will return a GError for you to catch
/// if (gtk_gl_area_get_error (area) != NULL)
/// return;
///
/// // You can also use gtk_gl_area_set_error() in order
/// // to show eventual initialization errors on the
/// // GtkGLArea widget itself
/// GError *internal_error = NULL;
/// init_buffer_objects (&error);
/// if (error != NULL)
/// {
/// gtk_gl_area_set_error (area, error);
/// g_error_free (error);
/// return;
/// }
///
/// init_shaders (&error);
/// if (error != NULL)
/// {
/// gtk_gl_area_set_error (area, error);
/// g_error_free (error);
/// return;
/// }
/// }
/// ```
///
/// If you need to change the options for creating the `GdkGLContext`
/// you should use the [signal@Gtk.GLArea::create-context] signal.
public struct GLArea: Widget {

    /// Additional update functions for type extensions.
    var updateFunctions: [(ViewStorage, [(View) -> View], Bool) -> Void] = []
    /// Additional appear functions for type extensions.
    var appearFunctions: [(ViewStorage, [(View) -> View]) -> Void] = []

    /// The accessible role of the given `GtkAccessible` implementation.
    ///
    /// The accessible role cannot be changed once set.
    var accessibleRole: String?
    /// The API currently in use.
    var api: String?
    /// If set to %TRUE the ::render signal will be emitted every time
    /// the widget draws.
    ///
    /// This is the default and is useful if drawing the widget is faster.
    ///
    /// If set to %FALSE the data from previous rendering is kept around and will
    /// be used for drawing the widget the next time, unless the window is resized.
    /// In order to force a rendering [method@Gtk.GLArea.queue_render] must be called.
    /// This mode is useful when the scene changes seldom, but takes a long time
    /// to redraw.
    var autoRender: Bool?
    /// The `GdkGLContext` used by the `GtkGLArea` widget.
    ///
    /// The `GtkGLArea` widget is responsible for creating the `GdkGLContext`
    /// instance. If you need to render with other kinds of buffers (stencil,
    /// depth, etc), use render buffers.
    var context: String?
    /// If set to %TRUE the widget will allocate and enable a depth buffer for the
    /// target framebuffer.
    ///
    /// Setting this property will enable GL's depth testing as a side effect. If
    /// you don't need depth testing, you should call `glDisable(GL_DEPTH_TEST)`
    /// in your `GtkGLArea::render` handler.
    var hasDepthBuffer: Bool?
    /// If set to %TRUE the widget will allocate and enable a stencil buffer for the
    /// target framebuffer.
    var hasStencilBuffer: Bool?
    /// If set to %TRUE the widget will try to create a `GdkGLContext` using
    /// OpenGL ES instead of OpenGL.
    var useEs: Bool?
    /// Emitted when the widget is being realized.
    ///
    /// This allows you to override how the GL context is created.
    /// This is useful when you want to reuse an existing GL context,
    /// or if you want to try creating different kinds of GL options.
    ///
    /// If context creation fails then the signal handler can use
    /// [method@Gtk.GLArea.set_error] to register a more detailed error
    /// of how the construction failed.
    var createContext: (() -> Void)?
    var realize: (() -> Void)?
    /// Emitted every time the contents of the `GtkGLArea` should be redrawn.
    ///
    /// The @context is bound to the @area prior to emitting this function,
    /// and the buffers are painted to the window once the emission terminates.
    var render: (() -> Void)?
    /// Emitted once when the widget is realized, and then each time the widget
    /// is changed while realized.
    ///
    /// This is useful in order to keep GL state up to date with the widget size,
    /// like for instance camera properties which may depend on the width/height
    /// ratio.
    ///
    /// The GL context for the area is guaranteed to be current when this signal
    /// is emitted.
    ///
    /// The default handler sets up the GL viewport.
    var resize: (() -> Void)?
    /// The application.
    var app: GTUIApp?
    /// The window.
    var window: GTUIApplicationWindow?

    /// Initialize `GLArea`.
    public init() {
    }

    /// Get the widget's view storage.
    /// - Parameter modifiers: The view modifiers.
    /// - Returns: The view storage.
    public func container(modifiers: [(View) -> View]) -> ViewStorage {
        let storage = ViewStorage(gtk_gl_area_new()?.opaque())
        for function in appearFunctions {
            function(storage, modifiers)
        }
        update(storage, modifiers: modifiers, updateProperties: true)

        return storage
    }

    /// Update the widget's view storage.
    /// - Parameters:
    ///     - storage: The view storage.
    ///     - modifiers: The view modifiers.
    ///     - updateProperties: Whether to update the view's properties.
    public func update(_ storage: ViewStorage, modifiers: [(View) -> View], updateProperties: Bool) {
        if let realize {
            storage.connectSignal(name: "realize", argCount: 0) {
                realize()
            }
        }
        if let createContext {
            storage.connectSignal(name: "create-context", argCount: 0) {
                createContext()
            }
        }
        if let render {
            storage.connectSignal(name: "render", argCount: 1) {
                render()
            }
        }
        if let resize {
            storage.connectSignal(name: "resize", argCount: 2) {
                resize()
            }
        }
        storage.modify { widget in

            if let autoRender, updateProperties {
                gtk_gl_area_set_auto_render(widget?.cast(), autoRender.cBool)
            }
            if let hasDepthBuffer, updateProperties {
                gtk_gl_area_set_has_depth_buffer(widget?.cast(), hasDepthBuffer.cBool)
            }
            if let hasStencilBuffer, updateProperties {
                gtk_gl_area_set_has_stencil_buffer(widget?.cast(), hasStencilBuffer.cBool)
            }
            if let useEs, updateProperties {
                gtk_gl_area_set_use_es(widget?.cast(), useEs.cBool)
            }


        }
        for function in updateFunctions {
            function(storage, modifiers, updateProperties)
        }
    }

    /// The accessible role of the given `GtkAccessible` implementation.
    ///
    /// The accessible role cannot be changed once set.
    public func accessibleRole(_ accessibleRole: String?) -> Self {
        var newSelf = self
        newSelf.accessibleRole = accessibleRole
        
        return newSelf
    }

    /// The API currently in use.
    public func api(_ api: String?) -> Self {
        var newSelf = self
        newSelf.api = api
        
        return newSelf
    }

    /// If set to %TRUE the ::render signal will be emitted every time
    /// the widget draws.
    ///
    /// This is the default and is useful if drawing the widget is faster.
    ///
    /// If set to %FALSE the data from previous rendering is kept around and will
    /// be used for drawing the widget the next time, unless the window is resized.
    /// In order to force a rendering [method@Gtk.GLArea.queue_render] must be called.
    /// This mode is useful when the scene changes seldom, but takes a long time
    /// to redraw.
    public func autoRender(_ autoRender: Bool? = true) -> Self {
        var newSelf = self
        newSelf.autoRender = autoRender
        
        return newSelf
    }

    /// The `GdkGLContext` used by the `GtkGLArea` widget.
    ///
    /// The `GtkGLArea` widget is responsible for creating the `GdkGLContext`
    /// instance. If you need to render with other kinds of buffers (stencil,
    /// depth, etc), use render buffers.
    public func context(_ context: String?) -> Self {
        var newSelf = self
        newSelf.context = context
        
        return newSelf
    }

    /// If set to %TRUE the widget will allocate and enable a depth buffer for the
    /// target framebuffer.
    ///
    /// Setting this property will enable GL's depth testing as a side effect. If
    /// you don't need depth testing, you should call `glDisable(GL_DEPTH_TEST)`
    /// in your `GtkGLArea::render` handler.
    public func hasDepthBuffer(_ hasDepthBuffer: Bool? = true) -> Self {
        var newSelf = self
        newSelf.hasDepthBuffer = hasDepthBuffer
        
        return newSelf
    }

    /// If set to %TRUE the widget will allocate and enable a stencil buffer for the
    /// target framebuffer.
    public func hasStencilBuffer(_ hasStencilBuffer: Bool? = true) -> Self {
        var newSelf = self
        newSelf.hasStencilBuffer = hasStencilBuffer
        
        return newSelf
    }

    /// If set to %TRUE the widget will try to create a `GdkGLContext` using
    /// OpenGL ES instead of OpenGL.
    public func useEs(_ useEs: Bool? = true) -> Self {
        var newSelf = self
        newSelf.useEs = useEs
        
        return newSelf
    }

    /// Emitted when the widget is being realized.
    ///
    /// This allows you to override how the GL context is created.
    /// This is useful when you want to reuse an existing GL context,
    /// or if you want to try creating different kinds of GL options.
    ///
    /// If context creation fails then the signal handler can use
    /// [method@Gtk.GLArea.set_error] to register a more detailed error
    /// of how the construction failed.
    public func createContext(_ createContext: @escaping () -> Void) -> Self {
        var newSelf = self
        newSelf.createContext = createContext
        return newSelf
    }
    
    public func realize(_ realize: @escaping () -> Void) -> Self {
        var newSelf = self
        newSelf.realize = realize
        return newSelf
    }

    /// Emitted every time the contents of the `GtkGLArea` should be redrawn.
    ///
    /// The @context is bound to the @area prior to emitting this function,
    /// and the buffers are painted to the window once the emission terminates.
    public func render(_ render: @escaping () -> Void) -> Self {
        var newSelf = self
        newSelf.render = render
        return newSelf
    }

    /// Emitted once when the widget is realized, and then each time the widget
    /// is changed while realized.
    ///
    /// This is useful in order to keep GL state up to date with the widget size,
    /// like for instance camera properties which may depend on the width/height
    /// ratio.
    ///
    /// The GL context for the area is guaranteed to be current when this signal
    /// is emitted.
    ///
    /// The default handler sets up the GL viewport.
    public func resize(_ resize: @escaping () -> Void) -> Self {
        var newSelf = self
        newSelf.resize = resize
        return newSelf
    }

}
