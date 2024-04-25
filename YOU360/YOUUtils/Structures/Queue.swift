//
//  Queue.swift
//  YOUUtils
//
//  Created by Ihar Karunny on 4/25/24.
//

import Foundation

public final class Queue<T> {
    private var head: QueueNode<T>?
    private var rear: QueueNode<T>?
    private var currentNode: QueueNode<T>?
    
    private var looped = false
    
    private var muttable: Bool {
        return !looped
    }
    
    public init(item: T? = nil) {
        guard let item = item else { return }
        self.head = QueueNode<T>.init(item: item)
        currentNode = head
        rear = head
    }
    
    public func addToRear(item: T) {
        guard muttable else { return }
        let node = QueueNode<T>.init(item: item)
        
        if head == nil {
            head = node
            currentNode = node
            rear = node
        }
        else {
            rear?.next = node
            node.previous = rear
            rear = node
        }
    }
    
    /**
            Looped queue becomes immutable
     */
    public func loop() {
        looped = true
        rear?.next = head
        head?.previous = rear
    }
    
    public func removeAll() {
        rear?.next = nil
        head?.previous = nil
        head?.next = nil
        head = nil
        
        looped = false
    }
    
    public func forEach(_ block: ((T) -> Void)) {
        guard let headNode = head else { return }
        var node: QueueNode<T>? = headNode
        
        block(headNode.item)
        while node != nil && node !== rear {
            node = node?.next
            
            if let node = node {
                block(node.item)
            }
        }
    }
    
    public func next() -> T? {
        guard let node = currentNode?.next else { return nil }
        let item = node.item
        currentNode = node
        return item
    }
    
    public func previous() -> T? {
        guard let node = currentNode?.previous else { return nil }
        let item = node.item
        currentNode = node
        return item
    }
    
    public var currentItem: T? {
        return currentNode?.item
    }
}

final class QueueNode<T> {
    let item: T
    init(item: T) {
        self.item = item
    }
    
    weak var previous: QueueNode<T>?
    var next: QueueNode<T>?
}
