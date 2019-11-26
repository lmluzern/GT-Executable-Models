"
I represent the logic of different graph models (e.g. Finite State Automaton). Further the interactive graph editor is based on me.

To create your own graph and add semantic to the given graph, run:

	Graph new

Switch to the _GT tab, where you can create a graph and add semantics (right & left click).
"
Class {
	#name : #Graph,
	#superclass : #Object,
	#instVars : [
		'nodes',
		'edges',
		'places',
		'weights',
		'transitions',
		'tokens',
		'currentState',
		'selectedNode',
		'debug',
		'nodeLocations'
	],
	#category : #'Executable-Graph-Model'
}

{ #category : #tests }
Graph class >> eg10nodes [
	<gtExample>
	^ self new nodes: (0 to: 10) asOrderedCollection;
		edges:
			((0 to: 10)
				flatCollect: [ :x | 
					{(x -> (x * 3 \\ 10)).
					(x -> (x // 2))} ]) asOrderedCollection;
		currentState: 10
]

{ #category : #tests }
Graph class >> egEmptyEditor [
	<gtExample>
	^ self new
]

{ #category : #adding }
Graph >> addEdgeFrom: nodeA to: nodeB [
	(edges includes: (nodeA->nodeB)) ifTrue: [ ^ 0 ].
	(((transitions includes: nodeA) and: (places includes: nodeB)) or:
		((places includes: nodeA) and: (transitions includes: nodeB))) ifTrue: [
			self weights at: (nodeA->nodeB) put: 1.
			^ self edges add: (nodeA->nodeB) ].
	(((transitions includes: nodeA) or: (places includes: nodeB)) or: ((places includes: nodeA) or: (transitions includes: nodeB))) ifTrue: [ ^ 0].
	self weights at: (nodeA->nodeB) put: 0.
	^ self edges add: (nodeA->nodeB)
]

{ #category : #adding }
Graph >> addNode [
	| newNode |
	nodes isEmpty
		ifTrue: [ newNode := 1 ]
		ifFalse: [ newNode := nodes last + 1 ].
	self nodes add: newNode.
	^ newNode
]

{ #category : #adding }
Graph >> addPlace [
	| newPlace |
	newPlace := self addNode.
	places add: newPlace.
	tokens at: newPlace put: 0.
	^ newPlace
]

{ #category : #adding }
Graph >> addTransition [
	| newTransition |
	newTransition:= self addNode.
	transitions add: newTransition.
	^ newTransition
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
Graph >> debug [
	^ debug
]

{ #category : #accessing }
Graph >> debug: anObject [
	debug := anObject
]

{ #category : #'as yet unclassified' }
Graph >> deleteConnectedEdgesOf: aNode [
	(edges select: [ :edge | edge value = aNode or: edge key = aNode]) do: [ :edge | edges remove: edge].
]

{ #category : #'as yet unclassified' }
Graph >> deleteEdge: anEdge [
	edges remove: anEdge ifAbsent: [ ].
	weights removeKey: anEdge ifAbsent: [ ]
]

{ #category : #utilities }
Graph >> deleteNode: aNode [
	nodes remove: aNode.
	(transitions includes: aNode) ifTrue: [ transitions remove: aNode ].
	(places includes: aNode) ifTrue: [ places remove: aNode ].
	(tokens includesKey: aNode) ifTrue: [ tokens removeKey: aNode ].
	self deleteConnectedEdgesOf: aNode.
]

{ #category : #accessing }
Graph >> edges [
	^ edges
]

{ #category : #accessing }
Graph >> edges: anObject [
	edges := anObject
]

{ #category : #'public interface' }
Graph >> fireTransition: aTransition [
	(self predecessorOf: aTransition) do: [ :place | tokens at: place put: (tokens at: place) - (weights at: (place->aTransition)) ].
	(self successorOf: aTransition) do: [ :place | tokens at: place put: (tokens at: place) + (weights at: (aTransition->place)) ].


]

{ #category : #'as yet unclassified' }
Graph >> fsaExample [
	<gtExample>
	6 timesRepeat: [ self addNode ].
	self addEdgeFrom: 1 to: 2.
	self addEdgeFrom: 1 to: 3.
	self addEdgeFrom: 2 to: 5.
	self addEdgeFrom: 2 to: 4.
	self addEdgeFrom: 3 to: 5.
	self addEdgeFrom: 3 to: 4.
	self addEdgeFrom: 5 to: 6.
	self addEdgeFrom: 4 to: 6.
	self currentState: 1.
	^ self
]

{ #category : #ui }
Graph >> gtElement: aView [
	<gtView>

	^ aView explicit
		title: 'View';
		stencil: [ GraphView new viewFor: self ]
]

{ #category : #initialization }
Graph >> initialize [
	nodes:= OrderedCollection new.
	edges:= OrderedCollection new.
	places := OrderedCollection new.
	transitions := OrderedCollection new.
	tokens := OrderedDictionary new.
	weights := OrderedDictionary new.
	nodeLocations := OrderedDictionary new.
	currentState := 0.
	selectedNode := 0.
	debug := 0.
]

{ #category : #'public interface' }
Graph >> isEnabled: aTransition [
	(transitions includes: aTransition) ifFalse: [ ^false ].
	((self predecessorOf: aTransition) isEmpty or: (self successorOf: aTransition) isEmpty) ifTrue: [ ^false ].
	(((self predecessorOf: aTransition) select: [ :place | (tokens at: place) < (weights at: (place->aTransition))]) isNotEmpty) ifTrue: [^false].
	^true


]

{ #category : #accessing }
Graph >> nodeLocations [
	^ nodeLocations
]

{ #category : #accessing }
Graph >> nodeLocations: anObject [
	nodeLocations := anObject
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
Graph >> petriNetExample [
	<gtExample>	
	self addPlace.
	self addTransition.
	self addPlace.
	self addTransition.
	
	self tokens at: 1 put: 3.
	
	self addEdgeFrom: 1 to: 2.
	self addEdgeFrom: 2 to: 3.
	self addEdgeFrom: 3 to: 4. 
	self addEdgeFrom: 4 to: 1. 
	^ self
]

{ #category : #accessing }
Graph >> places [
	^ places
]

{ #category : #accessing }
Graph >> places: anObject [
	places := anObject
]

{ #category : #'public interface' }
Graph >> predecessorOf: aNode [
"test"
	^(self edges select: [ :edge | edge value = aNode ]) collect: [ :edge | edge key ]


]

{ #category : #accessing }
Graph >> selectedNode [
	^ selectedNode
]

{ #category : #accessing }
Graph >> selectedNode: anObject [
	selectedNode := anObject
]

{ #category : #'public interface' }
Graph >> successorOf: aNode [
	^(self edges select: [ :edge | edge key = aNode ]) collect: [ :edge | edge value ]
]

{ #category : #tests }
Graph >> test [
<gtExample>
self nodes: #(1 2 3 4) asOrderedCollection.
self places: #(3 4) asOrderedCollection.
self transitions: #(1 2) asOrderedCollection.
self edges: {3->1. 1->4. 4->2. 2->3} asOrderedCollection.
self currentState: 0.
self weights: {(3->1)->2.(1->4)->1.(4->2)->1.(2->3)->1} asOrderedDictionary.
self tokens: { 3->3. 4->0} asOrderedDictionary.
self nodeLocations: { 1->(228.0@14.0). 2->(228.0@85.0). 3->(102.0@49.0). 4->(337.0@48.0)} asOrderedDictionary.


]

{ #category : #accessing }
Graph >> tokens [
	^ tokens
]

{ #category : #accessing }
Graph >> tokens: anObject [
	tokens := anObject
]

{ #category : #accessing }
Graph >> transitions [
	^ transitions
]

{ #category : #accessing }
Graph >> transitions: anObject [
	transitions := anObject
]

{ #category : #'building - graph' }
Graph >> view [
	^ GraphView new viewFor: self.
]

{ #category : #accessing }
Graph >> weights [
	^ weights
]

{ #category : #accessing }
Graph >> weights: anObject [
	weights := anObject
]
