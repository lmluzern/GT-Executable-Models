"
This class handles events/clicks etc.
"
Class {
	#name : #GraphController,
	#superclass : #Object,
	#instVars : [
		'graph',
		'view',
		'viewNodes',
		'selectedNode',
		'controllerMode'
	],
	#category : #'Executable-Graph-Model'
}

{ #category : #'model interaction' }
GraphController >> addEdge: aNode [
	| node |
	node := aNode graph model.
	graph debug: view mondrian.
	(graph selectedNode > 0)
		ifTrue: [
			"view drawEdges:" 
			graph addEdgeFrom: graph selectedNode to: node.
			self updateEdges.
			graph selectedNode: 0.
			selectedNode background: Color white.
			]
		ifFalse: [
			graph selectedNode: node.
			aNode background: Color blue.
			selectedNode := aNode.
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
	blNode := (view mondrian root children last).
	blNode relocate: (mousePosition) - (view defaultNodeSize / 2).
	view mondrian root graph nodeAt: blNode graph model put: blNode.
	^blNode

]

{ #category : #adding }
GraphController >> addPlaceAt: mousePosition [
	self view drawPlaces: (self graph addPlace) asOrderedCollection.
	self addNodeToMondrian: mousePosition



]

{ #category : #adding }
GraphController >> addTransitionAt: mousePosition [
	self view drawTransitions: (self graph addTransition) asOrderedCollection.
	self addNodeToMondrian: mousePosition

]

{ #category : #'model interaction' }
GraphController >> clearAllStates [
	viewNodes do: [ :node | node background: Color white ]
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
GraphController >> deleteEdge: anEdge [
	graph deleteEdge: (anEdge fromAnchor referenceElement graph model -> anEdge toAnchor referenceElement graph model).
	self updateEdges.
]

{ #category : #utilities }
GraphController >> deleteNode: aNode [
	graph deleteNode: aNode graph model.
	view mondrian root removeChild: aNode.
	self updateEdges.
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
	viewNodes := view mondrian root children select: [ :each | each graph isNode ].
	
	"viewNodes
		do: [ :aNode | aNode when: BlClickEvent do: [ self onClick: aNode ] ]."
		
	view mondrian root when: BlMouseDownEvent do: [ :event |
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
	(viewNodes select: [ :node | successors includes: node graph model ])  do:
		[ :node | node background: Color blue ]
]

{ #category : #'model interaction' }
GraphController >> nodeColor [
	(self graph successorOf: self graph currentState) isEmpty
		ifTrue: [ ^self deadColor ]
		ifFalse: [ ^self liveColor ]
		
]

{ #category : #initialization }
GraphController >> onClick: aNode [
	| node |
	node := aNode graph model.
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
	| menu |
	menu := MenuMorph new defaultTarget: self .
	menu add: 'Add edge from current selected node' selector: #addEdge: argument: aNode.
	menu add: 'Set as initial state' selector: #setInitialState: argument: aNode.
	menu add: 'Delete node' selector: #deleteNode: argument: aNode.
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
	viewNodes := view mondrian root children select: [ :each | each graph isNode ].
	self clearAllStates.
	graph selectedNode: 0.
	(viewNodes detect:
		[ :node | node graph model = graph currentState ]) background: self nodeColor.
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

{ #category : #accessing }
GraphController >> view [
	^ view
]

{ #category : #accessing }
GraphController >> view: anObject [
	view := anObject
]

{ #category : #accessing }
GraphController >> viewNodes [
	^ viewNodes
]

{ #category : #accessing }
GraphController >> viewNodes: anObject [
	viewNodes := anObject
]
