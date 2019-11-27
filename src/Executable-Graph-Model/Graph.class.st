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
		'nodeLocations',
		'nodeSizes'
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

{ #category : #'as yet unclassified' }
Graph >> diningPhilosophersExample [
<gtExample>
self nodes: #(1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20) asOrderedCollection.
self places: #(11 12 13 14 15 16 17 18 19 20) asOrderedCollection.
self transitions: #(1 2 3 4 5 6 7 8 9 10) asOrderedCollection.
self edges: {12->5. 12->1. 13->1. 13->2. 14->3. 14->2. 15->4. 15->3. 11->4. 11->5. 6->12. 6->13. 8->13. 8->14. 9->15. 9->14. 10->15. 10->11. 7->11. 7->12. 1->16. 16->6. 2->20. 20->8. 3->19. 19->9. 4->18. 18->10. 5->17. 17->7} asOrderedCollection.
self currentState: 0.
self weights: {(12->5)->1.(12->1)->1.(13->1)->1.(13->2)->1.(14->3)->1.(14->2)->1.(15->4)->1.(15->3)->1.(11->4)->1.(11->5)->1.(6->12)->1.(6->13)->1.(8->13)->1.(8->14)->1.(9->15)->1.(9->14)->1.(10->15)->1.(10->11)->1.(7->11)->1.(7->12)->1.(1->16)->1.(16->6)->1.(2->20)->1.(20->8)->1.(3->19)->1.(19->9)->1.(4->18)->1.(18->10)->1.(5->17)->1.(17->7)->1} asOrderedDictionary.
self tokens: { 11->1. 12->1. 13->1. 14->1. 15->1. 16->0. 17->0. 18->0. 19->0. 20->0} asOrderedDictionary.
self nodeLocations: { 1->(434.0@523.0). 2->(891.0@533.0). 3->(965.0@198.0). 4->(649.0@10.0). 5->(345.0@190.0). 6->(596.0@342.0). 7->(559.0@245.0). 8->(734.0@341.0). 9->(751.0@244.0). 10->(653.0@200.0). 11->(482.0@85.0). 12->(391.0@334.0). 13->(671.0@509.0). 14->(939.0@338.0). 15->(829.0@86.0). 16->(516.0@425.0). 17->(443.0@198.0). 18->(658.0@90.0). 19->(868.0@198.0). 20->(817.0@421.0)} asOrderedDictionary.
self nodeSizes: { 1->(60.0@15.0). 2->(60.0@15.0). 3->(60.0@15.0). 4->(60.0@15.0). 5->(60.0@15.0). 6->(60.0@15.0). 7->(60.0@15.0). 8->(60.0@15.0). 9->(60.0@15.0). 10->(60.0@15.0). 11->(50.0@50.0). 12->(50.0@50.0). 13->(50.0@50.0). 14->(50.0@50.0). 15->(50.0@50.0). 16->(50.0@50.0). 17->(50.0@50.0). 18->(50.0@50.0). 19->(50.0@50.0). 20->(50.0@50.0)} asOrderedDictionary.

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
	nodeSizes := OrderedDictionary new.
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
Graph >> nodeSizes [
	^ nodeSizes
]

{ #category : #accessing }
Graph >> nodeSizes: anObject [
	nodeSizes := anObject
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
self places: #(1 2 4) asOrderedCollection.
self transitions: #(3) asOrderedCollection.
self edges: {1->3. 2->3. 3->4} asOrderedCollection.
self currentState: 0.
self weights: {(1->3)->2.(2->3)->1.(3->4)->1} asOrderedDictionary.
self tokens: { 1->2. 2->2. 4->0} asOrderedDictionary.
self nodeLocations: { 1->(322.0@173.0). 2->(323.0@264.0). 3->(506.0@221.0). 4->(645.0@219.0)} asOrderedDictionary.


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
