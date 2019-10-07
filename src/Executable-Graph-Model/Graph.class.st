"
Data Object which represents a graph
"
Class {
	#name : #Graph,
	#superclass : #Object,
	#instVars : [
		'nodes',
		'edges',
		'currentState'
	],
	#category : #'Executable-Graph-Model'
}

{ #category : #tests }
Graph class >> eg10nodes [
	^ self new nodes: (0 to: 10);
		edges:
			((0 to: 10)
				flatCollect: [ :x | 
					{(x -> (x * 3 \\ 10)).
					(x -> (x // 2))} ]) asOrderedCollection;
		currentState: 10
]

{ #category : #adding }
Graph >> addEdgeFrom: nodeA to: nodeB [
	^ self edges add: (nodeA->nodeB)
]

{ #category : #adding }
Graph >> addNode [
	| newNode |
	newNode := self nodes last + 1.
	self nodes add: newNode.
	^newNode
]

{ #category : #accessing }
Graph >> currentState [
	^ currentState
]

{ #category : #accessing }
Graph >> currentState: anObject [
	currentState := anObject.
	self changed.
]

{ #category : #accessing }
Graph >> edges [
	^ edges
]

{ #category : #accessing }
Graph >> edges: anObject [
	edges := anObject
]

{ #category : #ui }
Graph >> gtElement: aView [
	<gtView>
	^ aView mondrian
		title: 'View';
		painting: [ :aMondrian | GraphViewBuilder new viewFor: self with: aMondrian ]
]

{ #category : #initialization }
Graph >> initialize [
	nodes:= Set new.
	edges:= Set new.
]

{ #category : #accessing }
Graph >> nodes [
	^ nodes
]

{ #category : #accessing }
Graph >> nodes: obj [
	nodes := obj.
]

{ #category : #'as yet unclassified' }
Graph >> predecessorOf: aNode [
"test"
	^(self edges select: [ :edge | edge value = aNode ]) collect: [ :edge | edge key ]


]

{ #category : #'as yet unclassified' }
Graph >> successorOf: aNode [
	^(self edges select: [ :edge | edge key = aNode ]) collect: [ :edge | edge value ]
]

{ #category : #'building - graph' }
Graph >> view [
	^ GraphViewBuilder new viewFor: self.
]
