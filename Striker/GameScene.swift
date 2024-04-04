//
//  GameScene.swift
//  Striker
//
//  Created by Oleg Yakushin on 4/3/24.
//

import Foundation
import SpriteKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    let bulletCategory: UInt32 = 0x1 << 0
    let enemyCategory: UInt32 = 0x1 << 1
    let playerCategory: UInt32 = 0x1 << 2
    let enemyBulletCategory: UInt32 = 0x1 << 3
    var playerShip: SKSpriteNode!
    var playerBullets: [SKSpriteNode] = []
    var enemyShips: [SKSpriteNode] = []
    var lastUpdateTime: TimeInterval = 0
    var deltaTime: TimeInterval = 0
    let bulletSpeed: CGFloat = 500
    let enemySpeed: CGFloat = 100
    let fireRate: TimeInterval = 0.5
    let enemyFireRate: TimeInterval = 10
    let touchMoveInterval: TimeInterval = 0.001
    var playerShipTouch: UITouch?
    var score = 0
    var hp = 0
    var canFire: Bool = true
    let enemyTextures = ["enemyOne", "enemyTwo", "enemyThree", "enemyFour"]
    var gameManager: GameManager
    init(size: CGSize, gameManager: GameManager) {
          self.gameManager = gameManager
          super.init(size: size)
      }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func didMove(to view: SKView) {
        self.backgroundColor = .clear
        physicsWorld.gravity = CGVector(dx: 0, dy: 0)
        physicsWorld.contactDelegate = self
        physicsWorld.gravity = CGVector(dx: 0, dy: 0)
           physicsWorld.contactDelegate = self
        _ = gameManager.game!.currentHp
        let playerShipTexture = SKTexture(imageNamed: "playerShipImage")
           playerShip = SKSpriteNode(texture: playerShipTexture, size: CGSize(width: 156 * sizeScreen(), height: 156 * sizeScreen()))
           playerShip.size = CGSize(width: 50 * sizeScreen(), height: 50 * sizeScreen())
           playerShip.position = CGPoint(x: frame.midX, y: frame.minY + playerShip.size.height/2)
           addChild(playerShip)
           playerShip.physicsBody = SKPhysicsBody(rectangleOf: playerShip.size)
           playerShip.physicsBody?.categoryBitMask = playerCategory
           playerShip.physicsBody?.contactTestBitMask = enemyBulletCategory
           playerShip.physicsBody?.isDynamic = false
       
        
        let spawnEnemies = SKAction.sequence([SKAction.run(spawnEnemy), SKAction.wait(forDuration: 3.0)])
        run(SKAction.repeatForever(spawnEnemies))
        
        let fireBullets = SKAction.sequence([SKAction.run(shoot), SKAction.wait(forDuration: fireRate)])
        run(SKAction.repeatForever(fireBullets))
    }
    
    override func update(_ currentTime: TimeInterval) {
        for enemyShip in enemyShips {
            if enemyShip.position.y <= enemyShip.size.height/2 {
                if let index = enemyShips.firstIndex(of: enemyShip) {
                    enemyShips.remove(at: index)
                }
                enemyShip.removeFromParent()
                gameManager.game?.endGame = true
            }
        }
    }

    
    func spawnEnemy() {
        let randomEnemyTexture = enemyTextures.randomElement()!
        let enemyShip = SKSpriteNode(imageNamed: randomEnemyTexture)
        enemyShip.size = CGSize(width: 50 * sizeScreen(), height: 50 * sizeScreen())
        enemyShip.position = CGPoint(x: CGFloat.random(in: frame.minX...frame.maxX), y: frame.maxY)
        addChild(enemyShip)
        enemyShips.append(enemyShip)
        enemyShip.physicsBody = SKPhysicsBody(rectangleOf: enemyShip.size)
        enemyShip.physicsBody?.categoryBitMask = enemyCategory
        enemyShip.physicsBody?.contactTestBitMask = bulletCategory
        enemyShip.physicsBody?.isDynamic = true
        let moveAction = SKAction.moveBy(x: 0, y: -frame.height, duration: TimeInterval(frame.height / enemySpeed))
        enemyShip.run(moveAction) {
            enemyShip.removeFromParent()
            if let index = self.enemyShips.firstIndex(of: enemyShip) {
                self.enemyShips.remove(at: index)
            }
        }
        enemyShip.zRotation = CGFloat.pi
        let randomDelay = TimeInterval(arc4random_uniform(1000)) / 1000.0
           DispatchQueue.main.asyncAfter(deadline: .now() + randomDelay) {
               self.enemyShoot(from: enemyShip)
           }
    }


    func enemyShoot(from enemyShip: SKSpriteNode) {
        let bullet = SKSpriteNode(imageNamed: "shootEnemy")
        bullet.size = CGSize(width: 10 * sizeScreen(), height: 18 * sizeScreen())
        bullet.position = CGPoint(x: enemyShip.position.x, y: enemyShip.position.y - enemyShip.size.height / 2)
        addChild(bullet)
        bullet.physicsBody = SKPhysicsBody(rectangleOf: bullet.size)
        bullet.physicsBody?.categoryBitMask = enemyBulletCategory
        bullet.physicsBody?.contactTestBitMask = playerCategory
        bullet.physicsBody?.isDynamic = true
        let moveAction = SKAction.moveBy(x: 0, y: -frame.height, duration: TimeInterval(frame.height / bulletSpeed))
        bullet.run(SKAction.sequence([moveAction, .removeFromParent()]))
    }



    func shoot() {
        guard canFire else { return }
        
        let bullet = SKSpriteNode(imageNamed: "shoot")
        bullet.size = CGSize(width: 10 * sizeScreen(), height: 18 * sizeScreen())
        bullet.position = CGPoint(x: playerShip.position.x, y: playerShip.position.y + playerShip.size.height / 2)
        addChild(bullet)
        playerBullets.append(bullet)
    
        bullet.physicsBody = SKPhysicsBody(rectangleOf: bullet.size)
        bullet.physicsBody?.categoryBitMask = bulletCategory
        bullet.physicsBody?.contactTestBitMask = enemyCategory
        bullet.physicsBody?.isDynamic = true
        
        let moveAction = SKAction.moveBy(x: 0, y: frame.height, duration: TimeInterval(frame.height / bulletSpeed))
        bullet.run(moveAction) {
            bullet.removeFromParent()
            if let index = self.playerBullets.firstIndex(of: bullet) {
                self.playerBullets.remove(at: index)
            }
        }
    }
    func removeShip(_ ship: SKNode) {
        ship.enumerateChildNodes(withName: "enemyFire") { (node, stop) in
            node.removeFromParent()
        }
        ship.removeFromParent()
        if let index = enemyShips.firstIndex(of: ship as! SKSpriteNode) {
            enemyShips.remove(at: index)
        }
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        var firstBody: SKPhysicsBody
        var secondBody: SKPhysicsBody
        
        if contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask {
            firstBody = contact.bodyA
            secondBody = contact.bodyB
        } else {
            firstBody = contact.bodyB
            secondBody = contact.bodyA
        }
        
        if firstBody.categoryBitMask == bulletCategory && secondBody.categoryBitMask == enemyCategory {
            // Обработка столкновения пули с врагом
            if let bullet = firstBody.node as? SKSpriteNode {
                bullet.removeFromParent()
                if let index = playerBullets.firstIndex(of: bullet) {
                    playerBullets.remove(at: index)
                }
            }
            
            if let enemyShip = secondBody.node as? SKSpriteNode {
                enemyShip.enumerateChildNodes(withName: "enemyFire") { (node, stop) in
                    node.removeFromParent()
                }
                if gameManager.game!.difficulty == 0 {
                    score += 1
                } else if gameManager.game!.difficulty == 1 {
                    score += 2
                } else if gameManager.game!.difficulty == 2 {
                    score += 3
                }
                gameManager.updateCurrenrScore(score: score)
                gameManager.updateTotal()
                removeShip(enemyShip)
            }
        }
        
        
        if firstBody.categoryBitMask == playerCategory && secondBody.categoryBitMask == enemyBulletCategory {
          
            print("contact")
            if let playerShip = firstBody.node as? SKSpriteNode {
              
                if let enemyBullet = secondBody.node as? SKSpriteNode {
                    enemyBullet.removeFromParent()
                }
                gameManager.updateCurrenrHp(HP: -5)
                gameManager.damageTaken()
                if gameManager.game!.currentHp <= 0 {
                    gameManager.game?.endGame = true
                }
            }
        }

    }

    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
            let touchLocation = touch.location(in: self)
            if playerShip.frame.contains(touchLocation) {
                playerShipTouch = touch
            }
    }

         
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first, let playerShipTouch = playerShipTouch, CACurrentMediaTime() - lastUpdateTime > touchMoveInterval else { return }
        lastUpdateTime = CACurrentMediaTime()
        
        let touchLocation = touch.location(in: self)
        if touch == playerShipTouch {
            playerShip.position.x = touchLocation.x
        }
    }
}
