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
	
	graph debug: aNodeElement graph.
	
	(graph selectedNode > 0)
		ifTrue: [
			| anEdge |
			anEdge := graph addEdgeFrom: graph selectedNode to: node.
			
			anEdge ~= 0 ifTrue: [
				| anEdgeElement |
				anEdgeElement := view drawEdge: anEdge.
				((graph places includes: node) or: (graph transitions includes: node)) ifTrue: [
					view addWeightTo: anEdgeElement with: (graph weights at: anEdge) ]
				 ].
			
			graph selectedNode: 0.
			selectedNode background: Color white.
			self update: graph.
			]
		ifFalse: [
			graph selectedNode: node.
			aNodeElement background: Color blue.
			selectedNode := aNodeElement.
			].
]

{ #category : #'api - adding' }
GraphController >> addNodeAt: mousePosition [
	self view drawNodes: (self graph addNode) asOrderedCollection.
	self relocateLastNode: mousePosition
]

{ #category : #'api - adding' }
GraphController >> addPlaceAt: mousePosition [
	self view drawPlaces: (self graph addPlace) asOrderedCollection with: self graph tokens.
	self relocateLastNode: mousePosition



]

{ #category : #'api - adding' }
GraphController >> addTransitionAt: mousePosition [
	self view drawTransitions: (self graph addTransition) asOrderedCollection.
	self relocateLastNode: mousePosition

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

{ #category : #'api - deleting' }
GraphController >> deleteEdge: anEdgeElement [
	| aGtGraphEdge |
	
	aGtGraphEdge := anEdgeElement graph model.
	
	graph deleteEdge: (aGtGraphEdge fromElement graph model -> aGtGraphEdge toElement graph model).
	
	aGtGraphEdge fromElement constraints graph removeConnectedEdge: aGtGraphEdge.
	aGtGraphEdge toElement constraints graph removeConnectedEdge: aGtGraphEdge.
	
	anEdgeElement removeFromParent
]

{ #category : #'api - deleting' }
GraphController >> deleteNode: aNodeElement [
	"I also delete all connected edges of the given node element"
	graph deleteNode: aNodeElement graph model.
	
	aNodeElement graph connectedEdges
		do: [ :eachGtGraphEdge | self deleteEdge: (view findEdgeElementFor: eachGtGraphEdge) ].
	
	aNodeElement removeFromParent
]

{ #category : #utilities }
GraphController >> fireTransition: aTransition [
	| node |
	node := aTransition graph model.
	
	graph fireTransition: node.
	
	(graph predecessorOf: node) do:
		[ :eachPredecessor |
		self view updateTokens: (graph tokens at: eachPredecessor) at: (self view findNodeElementFor: eachPredecessor) ].
	
	(graph successorOf: node) do:
		[ :eachSuccessor |
		self view updateTokens: (graph tokens at: eachSuccessor) at: (self view findNodeElementFor: eachSuccessor) ]
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
	
	self update: graph.
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
		thenDo: [ :node | node background: Color orange ]
]

{ #category : #'model interaction' }
GraphController >> markTransitions [
	| transitions |
	transitions := self graph transitions.
	
	view allNodeElements
		select: [ :node | transitions includes: node graph model ]
		thenDo: [ :node |
			(graph isEnabled: node graph model)
				ifTrue: [ node background: Color green ]
				ifFalse: [ node background: Color white ]
			 ]
]

{ #category : #'model interaction' }
GraphController >> nodeColor [
	(self graph successorOf: self graph currentState) isEmpty
		ifTrue: [ ^self deadColor ]
		ifFalse: [ ^self liveColor ]
		
]

{ #category : #gui }
GraphController >> onClick: aNodeElement [
	| node |
	node := aNodeElement graph model.
	((graph successorOf: graph currentState) includes: node)
		ifTrue: [ graph currentState: node.].
]

{ #category : #gui }
GraphController >> openEdgeMenuFor: anEdge [
	| menu |
	menu := MenuMorph new defaultTarget: self .
	menu add: 'Delete edge' selector: #deleteEdge: argument: anEdge.
	menu add: 'Set weight' selector: #setWeightOf: argument: anEdge.
	menu popUpInWorld
]

{ #category : #gui }
GraphController >> openNodeMenuFor: aNode [
	| menu node |
	node := aNode graph model.
	menu := MenuMorph new defaultTarget: self .
	menu add: 'Add edge from current selected node' selector: #addEdge: argument: aNode.
	menu add: 'Set as initial state' selector: #setInitialState: argument: aNode.
	menu add: 'Delete node' selector: #deleteNode: argument: aNode.
	(graph places includes: node) ifTrue:[
		menu add: 'Set number of tokens' selector: #setNumberOfTokensAt: argument: aNode.
		].
	(graph isEnabled: node) ifTrue:[
		menu add: 'Fire transition' selector: #fireTransition: argument: aNode.
		].
	
	menu popUpInWorld
	
]

{ #category : #gui }
GraphController >> openPrimaryMenuWith: aGraphElement [
	(aGraphElement graph isNode)
		ifTrue: [ self openNodeMenuFor: aGraphElement ]
		ifFalse: [ self openEdgeMenuFor: aGraphElement ].
]

{ #category : #gui }
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

{ #category : #'api - adding' }
GraphController >> relocateLastNode: mousePosition [
	| blNode |

	blNode := (view children last).
	blNode relocate: (mousePosition) - (view defaultNodeSize / 2).

	^ blNode

]

{ #category : #'model interaction' }
GraphController >> setCurrentStateColor [
	| aCurrentStateNodeElement |

	aCurrentStateNodeElement := view findNodeElementFor: graph currentState.
	aCurrentStateNodeElement ifNotNil: [
		aCurrentStateNodeElement background: self nodeColor
	 ]
]

{ #category : #'model interaction' }
GraphController >> setInitialState: aNode [
	graph currentState: aNode graph model.
]

{ #category : #'api - adding' }
GraphController >> setNumberOfTokensAt: aNode [
	| node numberOfTokens|
	node := aNode graph model.
	
	numberOfTokens := (UIManager default request: 'Set number of tokens:') asInteger.
	numberOfTokens ifNotNil: [ 
		self view updateTokens: (graph tokens at: node put: numberOfTokens ) at: aNode
		]
]

{ #category : #'api - adding' }
GraphController >> setWeightOf: anEdgeElement [
	| fromNode toNode newWeight |
	fromNode := (anEdgeElement graph model fromElement) graph model.
	toNode := (anEdgeElement graph model toElement) graph model.
	
	graph weights at: (fromNode->toNode) ifPresent: [
		newWeight := (UIManager default request: 'Set new weight:') asInteger.
		newWeight ifNotNil: [ 
			graph weights at: (fromNode->toNode) put: newWeight.
			view updateWeightOf: anEdgeElement with: (graph weights at: (fromNode->toNode))
			 ]
		].

	self graph debug: anEdgeElement.

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
