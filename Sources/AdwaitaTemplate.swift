// The Swift Programming Language
// https://docs.swift.org/swift-book

import Adwaita
import OpenGL.GL3
import CAdw

let width: Int32 = 640
let height: Int32 = 480

func checkCompileStatus(_ vs: UInt32) {
    let status = UnsafeMutablePointer<GLint>.allocate(capacity: 1)
    glGetShaderiv(vs, UInt32(GL_COMPILE_STATUS), status)
    if status.pointee == GL_FALSE {
        let buf = UnsafeMutablePointer<UInt8>.allocate(capacity: 1024)
        glGetShaderInfoLog(vs, 1024, nil, buf)
        // C.free(unsafe.Pointer(&buf))
        print(String.init(cString: buf))
        fatalError("vertex shader is not compiled")
    }
}

func validateProgram(_ program: UInt32) {

    // link status
    let status = UnsafeMutablePointer<GLint>.allocate(capacity: 1)
    glGetProgramiv(program, UInt32(GL_LINK_STATUS), status)
    if status.pointee == GL_FALSE {
        getProgramInfoLog(program)
        fatalError("program is not linked")
    }

    // validation
    glValidateProgram(program)
    checkError()
    glGetProgramiv(program, UInt32(GL_VALIDATE_STATUS), status)
    if status.pointee == GL_FALSE {
        getProgramInfoLog(program)
        fatalError("program is invalid")
    }
}


func getProgramInfoLog(_ program: UInt32) {
    let bytes = UnsafeMutablePointer<UInt8>.allocate(capacity: 1024)
    defer {
        bytes.deallocate()
    }
    // var buf = make([]byte, 1024)
    // bufArray := C.CBytes(buf)
    // glGetProgramInfoLog (GLuint program, GLsizei bufSize, GLsizei *length, GLchar *infoLog)
    glGetProgramInfoLog(program, 1024, nil, bytes)
    // C.free(unsafe.Pointer(&buf))
    print(String.init(cString: bytes))
}


func checkError() {
    let errno = glGetError()
    if errno != 0 {
        switch Int32(errno) {
        case GL_INVALID_VALUE:
            print("invalid value")
        case GL_INVALID_ENUM:
            print("invalid enum")
        case GL_INVALID_OPERATION:
            print("invalid operation")
        case GL_INVALID_FRAMEBUFFER_OPERATION:
            print("invalid framebuffer operation")
        case GL_OUT_OF_MEMORY:
            print("out of memory")
        /*case GL_STACK_UNDERFLOW:
            print("stack underflow")
        case GL_STACK_OVERFLOW:
            print("stack overflow")
         */
        default:
            print("unknown error")
        }
        fatalError("error occured")
    }
}

var vbo = UnsafeMutablePointer<UInt32>.allocate(capacity: 1)
var vao = UnsafeMutablePointer<UInt32>.allocate(capacity: 1)
var shaderProgramme: UInt32 = 0

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
                        .realize {
                            glEnable(UInt32(GL_DEPTH_TEST)) // enable depth-testing
                            glDepthFunc(UInt32(GL_LESS))    // depth-testing interprets a smaller value as "closer"

                            let points: [Float] = [
                                0.0, 0.5, 0.0,
                                0.5, -0.5, 0.0,
                                -0.5, -0.5, 0.0,
                            ]
                            
                            glGenBuffers(1, vbo)
                            glBindBuffer(UInt32(GL_ARRAY_BUFFER), vbo.pointee)
                            points.withUnsafeBytes() { (cArray: UnsafeRawBufferPointer) -> () in
                                glBufferData(UInt32(GL_ARRAY_BUFFER), points.count * MemoryLayout<Float>.stride , cArray.baseAddress, UInt32(GL_STATIC_DRAW))
                            }

                            glGenVertexArrays(1, vao)
                            glBindVertexArray(vao.pointee)
                            glEnableVertexAttribArray(0)
                            glBindBuffer(UInt32(GL_ARRAY_BUFFER), vbo.pointee)
                            glVertexAttribPointer(0, 3, UInt32(GL_FLOAT), UInt8(GL_FALSE), 0, nil)

                            let vertex_shader = """
                            #version 400
                            in vec3 vp;
                            void main() {
                              gl_Position = vec4(vp, 1.0);
                            }
                            """

                            let fragment_shader = """
                            #version 400
                            out vec4 frag_colour;
                            void main() {
                              frag_colour = vec4(0.5, 0.0, 0.5, 1.0);
                            }
                            """

                            let vs = glCreateShader(UInt32(GL_VERTEX_SHADER))
                            vertex_shader.withCString { str in
                                var strP = Optional<UnsafePointer<GLchar>>(str)
                                glShaderSource(vs, 1, &strP, nil)
                            }
                            // C.free(vs)
                            glCompileShader(vs)
                            checkCompileStatus(vs)

                            let fs = glCreateShader(UInt32(GL_FRAGMENT_SHADER))
                            fragment_shader.withCString { str in
                                var strP = Optional<UnsafePointer<GLchar>>(str)
                                glShaderSource(fs, 1, &strP, nil)
                            }
                            // C.free(fs)
                            glCompileShader(fs)
                            checkCompileStatus(vs)

                            shaderProgramme = glCreateProgram()
                            glAttachShader(shaderProgramme, fs)
                            glAttachShader(shaderProgramme, vs)
                            glLinkProgram(shaderProgramme)
                            // validateProgram(shaderProgramme)

                            glViewport(0, 0, width, height)
                        }
                        .render {
                            glClearColor (0.5, 0.5, 0, 1);
                            glClear(UInt32(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT));
                            
                            glUseProgram(shaderProgramme)
                            checkError()
                            

                            glBindVertexArray(vao.pointee)
                            glDrawArrays(UInt32(GL_TRIANGLES), 0, 3)

                        }
                }
                .topToolbar {
                    ToolbarView(app: app, window: window)
                }
        }
        .defaultSize(width: 450, height: 300)
    }

}
