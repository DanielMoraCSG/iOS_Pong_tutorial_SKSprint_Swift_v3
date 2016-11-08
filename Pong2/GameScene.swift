//
//  GameScene.swift
//  Pong2
//
//  Created by daniel on 08/11/16.
//  Copyright © 2016 CS Group. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    var ball = SKSpriteNode()
    var enemy = SKSpriteNode()
    var main = SKSpriteNode()
    
    var topLabel = SKLabelNode()
    var btnLabel = SKLabelNode()
    
    var score = [Int]()
    
    override func didMove(to view: SKView) {
        //MARK: Se inicializa la funcion
        // Esto se realiza debido a que la funcion update maneja las intancias
        // a funciones que fueron inializadas, de forma que cuando update la llama
        // no existe porque no fue inicializada nunca ocacionando el error de "index out of range"
        startGame()
        
        topLabel = self.childNode(withName: "topLabel") as! SKLabelNode
        btnLabel = self.childNode(withName: "btnLabel") as! SKLabelNode
        
        
        ball = self.childNode(withName: "ball") as! SKSpriteNode
        enemy = self.childNode(withName: "enemy") as! SKSpriteNode
        main = self.childNode(withName: "main") as! SKSpriteNode
        
        
        //MARK: Se inicializa los valores de dispersion con dx y dy
        ball.physicsBody?.applyImpulse(CGVector(dx: 20, dy: 20))
        
        let border = SKPhysicsBody(edgeLoopFrom: self.frame)
        
        //MARK: Friccion sobre bordes
        // No se agrega friccion ni afeccion al elemento cuando toca alguna de las esquinas
        border.friction = 0
        //MARK: Restitucion sobre golpe
        // Se restituye el valor de golpe haciendo que no se devilite la 
        // reaccion contra el golpe de las esquinas
        // 1 el valor por default que se agrega al la velocidad de contacto
        border.restitution = 1
        
        //MARK: Se relaciona el borde con el objeto "Ball"
        // Al aplicar se esto la pelota chocará con los bordes de la pantalla del dispositivo
        self.physicsBody = border
        
    }
    
    func startGame(){
        score = [0,0]
        topLabel.text = "\(score[1])"
        btnLabel.text = "\(score[0])"
    }
    
    func addScore(playerWhoWon: SKSpriteNode){
        ball.position = CGPoint(x: 0, y: 0)
        ball.physicsBody?.velocity = CGVector(dx:0 ,dy:0)
        
        if playerWhoWon == main {
            score[0] += 1
            ball.physicsBody?.applyImpulse(CGVector(dx: 20, dy: 20))
        }else if playerWhoWon == enemy {
            score[1] += 1
            ball.physicsBody?.applyImpulse(CGVector(dx: -20, dy: -20))
        }
        topLabel.text = "\(score[1])"
        btnLabel.text = "\(score[0])"
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches{
            let location = touch.location(in: self)
        
            main.run(SKAction.moveTo(x: location.x, duration: 0.2))
        }
    }
    
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches{
            let location = touch.location(in: self)
            
            main.run(SKAction.moveTo(x: location.x, duration: 0.2))
        }
    }
    
    //MARK: Esta funcion es llamada solo cuando se ejecuta correctamente la vista de Frames en el dispositivo de manera que si se ponen funciones poliformicas estas se desencadenan aquí
    override func update(_ currentTime: TimeInterval) {
        enemy.run(SKAction.moveTo(x: ball.position.x, duration: 1.0))
        
        if(ball.position.y <= main.position.y - 70){
            addScore(playerWhoWon: enemy)
        }else if(ball.position.y >= enemy.position.y + 70){
            addScore(playerWhoWon: main)
        }
    }
}
