ARKit-Zoetrope

https://github.com/Physicslibrary/ARKit-Zoetrope

MIT License

Copyright (c) 2019 Hartwell Fong

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.


Aug 29, 2019.
 
Explore a zoetrope with ARKit.

Hardware:
 
Tested on Apple 2018 9.7" iPad (A9 CPU or higher for ARKit) 
but should work on any iPad supporting ARKit (stereoscope, dependent on screen dimensions, is off).
 
Software:
 
Apple iOS Swift Playgrounds 3.0

ARKit and SceneKit (set up scene, read 3D files, attact a virtual camera for 
lefteye to ARKit iPad camera righteye to make a stereoscope, 6DOF tracking)
 
https://www.apple.com/ca/swift/playgrounds/
 
Tips:
 
"Run My Code" with "Enable Results" off to disable Swift Playgrounds logging every objects 
created during runtime (little boxes that appears on the right side when "Run My Code", 
useful for inspection and debugging but consume memory).

This playground doesn't look for a flat plane to put virtual objects on, 
instead the initial position of the iPad is the world origin when "Run My Code" is pressed.
 
All virtual objects are positioned and oriented according to this world origin 
(with righteye.debugOptions on, the world origin is an XYZ or RGB axis)
 
If frame rate <60Hz, hold iPad still, swipe up from bottom edge of screen for HOME screen 
(or press HOME button), return to Swift Playgrounds.
 
*/

import ARKit
import PlaygroundSupport

var righteye = ARSCNView()
righteye.scene = SCNScene()
righteye.scene.background.contents = UIColor.darkGray
righteye.automaticallyUpdatesLighting = false
righteye.autoenablesDefaultLighting = false
righteye.showsStatistics = true  // comment out to turn off

var lefteye = SCNView()
lefteye.scene = righteye.scene
lefteye.showsStatistics = true  // comment out to turn off

let config = ARWorldTrackingConfiguration()
righteye.session.run(config)

righteye.debugOptions = [
    //ARSCNDebugOptions.showFeaturePoints,
    //ARSCNDebugOptions.showWorldOrigin  // comment out to turn off
]

var box = SCNScene(named: "zoetrope.obj")!
let node = box.rootNode.childNodes[0]
node.position = SCNVector3(x: 0, y: 0, z: 0)
node.eulerAngles = SCNVector3(0, 0, 0)
node.scale = SCNVector3(1, 1, 1)
righteye.scene.rootNode.addChildNode(node)

node.geometry?.firstMaterial?.fillMode = .lines
node.geometry?.firstMaterial?.emission.contents = UIColor.orange
node.geometry?.firstMaterial?.isDoubleSided = true

 /*
 node.geometry?.firstMaterial?.emission.contents = UIImage(named: "zoetrope.jpg")
 node.geometry?.firstMaterial?.isDoubleSided = false
 */

var box2 = SCNScene(named: "cylinder.obj")!
let node2 = box2.rootNode.childNodes[0]
node2.position = SCNVector3(x: 0, y: 0, z: 0)
node2.eulerAngles = SCNVector3(0, 0, 0)
node2.scale = SCNVector3(1, 1, 1)
righteye.scene.rootNode.addChildNode(node2)

node2.geometry?.firstMaterial?.emission.contents = UIImage(named: "elephant.jpg")
node2.geometry?.firstMaterial?.isDoubleSided = true

let rotate = SCNAction.repeatForever(SCNAction.rotate(by: .pi, around: SCNVector3(0,1,0), duration: 0.1083))

// try duration 0.1081 or 0.1085 to see temporal aliasing
// node.runAction(rotate)
node2.runAction(rotate)

// hardwired for Owl Stereoscopic Viewer with a 9.7" iPad

var ipd = -0.06  // interpupillary distance (meter)
var cameraNode = SCNNode()  // make a camera for left eye
let camera = SCNCamera()
camera.xFov = 39  // camera.* depends on righteye.frame
camera.yFov = 50
camera.zFar = 1
camera.zNear = 0.001
cameraNode.camera = camera
cameraNode.position = SCNVector3(ipd,0,0)
righteye.pointOfView?.addChildNode(cameraNode)

lefteye.pointOfView = cameraNode

lefteye.isPlaying = true

var imageView = UIImageView()

lefteye.frame = CGRect(x: 0, y: 0, width: 344, height: 380)
imageView.addSubview(lefteye)

righteye.frame = CGRect(x: 344, y: 0, width: 344, height: 380)
imageView.addSubview(righteye)

PlaygroundPage.current.wantsFullScreenLiveView = true
PlaygroundPage.current.liveView = righteye

// in last line, change righteye to imageView for stereoscopic view
