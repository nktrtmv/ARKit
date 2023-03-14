import UIKit
import SceneKit
import ARKit
class ViewController: UIViewController, ARSCNViewDelegate {
    @IBOutlet var sceneView: ARSCNView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Установка делегата для ARSCNView
        sceneView.delegate = self
        // Отображение статистики FPS и времени рендеринга
        sceneView.showsStatistics = true
        // Создание сцены
        let scene = SCNScene()
        // Создание геометрии куба
        let cube = SCNBox(width: 0.1, height: 0.1, length: 0.1, chamferRadius: 0)
        // Создание материала для куба
        let material = SCNMaterial()
        material.diffuse.contents = UIColor.red
        // Назначение материала для куба
        cube.materials = [material]
        // Создание узла для куба
        let cubeNode = SCNNode(geometry: cube)
        // Установка позиции узла
        cubeNode.position = SCNVector3(0, 0, -0.2)
        // Добавление узла к сцене
        scene.rootNode.addChildNode(cubeNode)
        // Назначение сцены для ARSCNView
        sceneView.scene = scene
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Создание конфигурации ARSession
        let configuration = ARWorldTrackingConfiguration()
        // Запуск ARSession
        sceneView.session.run(configuration)
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        // Остановка ARSession
        sceneView.session.pause()
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        // Проверка, что добавленный якорь является якорем плоскости
        guard let planeAnchor = anchor as? ARPlaneAnchor else { return }
        // Создание геометрии плоскости
        let plane = SCNPlane(width: CGFloat(planeAnchor.extent.x), height: CGFloat(planeAnchor.extent.z))
        // Создание материала для плоскости
        let material = SCNMaterial()
        material.diffuse.contents = UIColor.white.withAlphaComponent(0.5)
        // Назначение материала для плоскости
        plane.materials = [material]
        // Создание узла для плоскости
        let planeNode = SCNNode(geometry: plane)
        // Установка позиции узла
        planeNode.position = SCNVector3(planeAnchor.center.x, 0, planeAnchor.center.z)
        // Поворот узла на 90 градусов по оси X
        planeNode.transform = SCNMatrix4MakeRotation(-Float.pi / 2, 1, 0, 0)
        // Добавление узла к сцене
        node.addChildNode(planeNode)
    }
}
