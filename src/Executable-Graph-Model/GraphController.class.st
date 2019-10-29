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
			view drawEdges: 
			(graph addEdgeFrom: graph selectedNode to: node) asOrderedCollection.
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
	| newNode blNode |
	newNode := self graph addNode.
	self view drawNodes: newNode asOrderedCollection.
	blNode := (view mondrian root children last).
	blNode relocate: (mousePosition) - (view defaultNodeSize / 2).
	view mondrian root graph nodeAt: newNode put: blNode.
	
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

{ #category : #utilities }
GraphController >> deleteNode: aNode [
	graph debug: view mondrian root.	
	graph deleteNode: aNode graph model.
	view mondrian root removeChild: aNode.
	
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

{ #category : #'model interaction' }
GraphController >> openPrimaryMenuWith: aNode [
	| menu |
	menu := MenuMorph new defaultTarget: self .
	menu add: 'Add edge from current selected node' selector: #addEdge: argument: aNode.
	menu add: 'Set as initial state' selector: #setInitialState: argument: aNode.
	menu add: 'Delete node' selector: #deleteNode: argument: aNode.
	menu popUpInWorld
]

{ #category : #'model interaction' }
GraphController >> openSecondaryMenuWith: mousePosition [
	| menu |
	menu := MenuMorph new defaultTarget: self .
	menu add: 'Add new node' selector: #addNodeAt: argument: mousePosition.
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
