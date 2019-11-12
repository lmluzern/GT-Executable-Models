"
This class handles events/clicks etc.
"
Class {
	#name : #GraphController,
	#superclass : #Object,
	#instVars : [
		'graph',
		'view',
		'selectedNode',
		'controllerMode'
	],
	#category : #'Executable-Graph-Model'
}

{ #category : #'model interaction' }
GraphController >> addEdge: aNodeElement [
	| node |

	node := aNodeElement graph model.

	graph debug: view.

	(graph selectedNode > 0)
		ifTrue: [
			| anEdge |
			anEdge := graph addEdgeFrom: graph selectedNode to: node.
			
			view drawEdge: anEdge.
			
			graph selectedNode: 0.
			selectedNode background: Color white.
			]
		ifFalse: [
			graph selectedNode: node.
			aNodeElement background: Color blue.
			selectedNode := aNodeElement.
			].
]

{ #category : #adding }
GraphController >> addNodeAt: mousePosition [
	self view drawNodes: (self graph addNode) asOrderedCollection.
	self addNodeToMondrian: mousePosition
]

{ #category : #adding }
GraphController >> addNodeToMondrian: mousePosition [
	| blNode |

	blNode := (view children last).
	blNode relocate: (mousePosition) - (view defaultNodeSize / 2).

	^ blNode

]

{ #category : #adding }
GraphController >> addPlaceAt: mousePosition [
	self view drawPlaces: (self graph addPlace) asOrderedCollection with: self graph tokens.
	self addNodeToMondrian: mousePosition



]

{ #category : #adding }
GraphController >> addTokenAt: aNode [
	| node |
	node := aNode graph model.
	graph tokens at: node put: (graph tokens at: node) + 1.
	self updatePlaces
]

{ #category : #adding }
GraphController >> addTransitionAt: mousePosition [
	self view drawTransitions: (self graph addTransition) asOrderedCollection.
	self addNodeToMondrian: mousePosition

]

{ #category : #'model interaction' }
GraphController >> clearAllStates [
	view allNodeElements do: [ :eachNodeElement | eachNodeElement background: Color white ]
]

{ #category : #accessing }
GraphController >> controllerMode [
	^ controllerMode
]

{ #category : #accessing }
GraphController >> controllerMode: anObject [
	controllerMode := anObject
]

{ #category : #'view control' }
GraphController >> deadColor [
	^ Color red
]

{ #category : #'as yet unclassified' }
GraphController >> deleteEdge: anEdgeElement [
	| aGtGraphEdge |
	
	aGtGraphEdge := anEdgeElement graph model.
	
	graph deleteEdge: (aGtGraphEdge fromElement graph model -> aGtGraphEdge toElement graph model).
	
	aGtGraphEdge fromElement constraints graph removeConnectedEdge: aGtGraphEdge.
	aGtGraphEdge toElement constraints graph removeConnectedEdge: aGtGraphEdge.
	
	anEdgeElement removeFromParent.
]

{ #category : #utilities }
GraphController >> deleteNode: aNode [
	graph deleteNode: aNode graph model.
	view mondrian root removeChild: aNode.
	self updateEdges.
]

{ #category : #utilities }
GraphController >> fireTransition: aTransition [
	graph fireTransition: aTransition graph model.
	self updatePlaces.
]

{ #category : #accessing }
GraphController >> graph [
	^ graph
]

{ #category : #accessing }
GraphController >> graph: anObject [
	graph := anObject
]

{ #category : #initialization }
GraphController >> initializeModel: aGraph andView: aView [
	graph := aGraph.
	view := aView.
	controllerMode := 0.
		
	view when: BlMouseDownEvent do: [ :event |
		event secondaryButtonPressed ifTrue: [ self openSecondaryMenuWith: event localPosition ].].
]

{ #category : #'view control' }
GraphController >> liveColor [
	^ (Color green darker alpha: 1)
]

{ #category : #'model interaction' }
GraphController >> markSuccessorStates [
	| successors |
	successors := self graph successorOf: self graph currentState.
	view allNodeElements
		select: [ :node | successors includes: node graph model ]
		thenDo: [ :node | node background: Color blue ]
]

{ #category : #'model interaction' }
GraphController >> nodeColor [
	(self graph successorOf: self graph currentState) isEmpty
		ifTrue: [ ^self deadColor ]
		ifFalse: [ ^self liveColor ]
		
]

{ #category : #initialization }
GraphController >> onClick: aNodeElement [
	| node |
	node := aNodeElement graph model.
	((graph successorOf: graph currentState) includes: node)
		ifTrue: [ graph currentState: node.].
]

{ #category : #'as yet unclassified' }
GraphController >> openEdgeMenuFor: anEdge [
	| menu |
	menu := MenuMorph new defaultTarget: self .
	menu add: 'Delete edge' selector: #deleteEdge: argument: anEdge.
	menu popUpInWorld
]

{ #category : #'as yet unclassified' }
GraphController >> openNodeMenuFor: aNode [
	| menu node |
	node := aNode graph model.
	menu := MenuMorph new defaultTarget: self .
	menu add: 'Add edge from current selected node' selector: #addEdge: argument: aNode.
	menu add: 'Set as initial state' selector: #setInitialState: argument: aNode.
	menu add: 'Delete node' selector: #deleteNode: argument: aNode.
	(graph places includes: node) ifTrue:[
		menu add: 'Add token' selector: #addTokenAt: argument: aNode.
		].
	(graph isEnabled: node) ifTrue:[
		menu add: 'Fire transition' selector: #fireTransition: argument: aNode.
		].
	
	menu popUpInWorld
	
]

{ #category : #'model interaction' }
GraphController >> openPrimaryMenuWith: aGraphElement [
	(aGraphElement graph isNode)
		ifTrue: [ self openNodeMenuFor: aGraphElement ]
		ifFalse: [ self openEdgeMenuFor: aGraphElement ].
]

{ #category : #'model interaction' }
GraphController >> openSecondaryMenuWith: mousePosition [
	| menu |
	menu := MenuMorph new defaultTarget: self .
	menu add: 'Add new node' selector: #addNodeAt: argument: mousePosition.
	menu add: 'Add new transition' selector: #addTransitionAt: argument: mousePosition.
	menu add: 'Add new place' selector: #addPlaceAt: argument: mousePosition.
	controllerMode == 0 ifTrue: [ menu add: 'Switch to executable FSA Model' selector: #controllerMode: argument:1.].
	controllerMode == 1 ifTrue: [ menu add: 'Switch to Graph Editor' selector: #controllerMode: argument:0.].
	menu popUpInWorld
]

{ #category : #initialization }
GraphController >> setCurrentStateColor [
	| aCurrentStateNodeElement |

	aCurrentStateNodeElement := view findNodeElementFor: graph currentState.
	self clearAllStates.
	graph selectedNode: 0.

	aCurrentStateNodeElement background: self nodeColor
]

{ #category : #initialization }
GraphController >> setInitialState: aNode [
	graph currentState: aNode graph model.
	self setCurrentStateColor.
]

{ #category : #updating }
GraphController >> update: aGraph [
	self clearAllStates.
	self markSuccessorStates.
	self setCurrentStateColor.
]

{ #category : #'as yet unclassified' }
GraphController >> updateEdges [
	| edges |
	edges := view mondrian root children select: [ :element | element graph isEdge ].
	edges do: [ :edge | view mondrian root removeChild: edge ].
	
	view drawEdges: graph edges.
	
]

{ #category : #'as yet unclassified' }
GraphController >> updatePlaces [
	| places position node |
	places := view mondrian root children select: [ :element | (element graph isNode) and: (graph places includes: element graph model) ].
	places do: [ :place |
		position := place measuredBounds position.
		node := place graph model.
		view mondrian root removeChild: place .
		self view drawPlaces: node asOrderedCollection with: self graph tokens.
		self addNodeToMondrian: (position) + (view defaultNodeSize / 2).
		].
	
]

{ #category : #accessing }
GraphController >> view [
	^ view
]

{ #category : #accessing }
GraphController >> view: anObject [
	view := anObject
]
