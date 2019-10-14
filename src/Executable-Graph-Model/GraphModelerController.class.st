"
This class handles events/clicks especially for the interactive graph modeler.
"
Class {
	#name : #GraphModelerController,
	#superclass : #GraphController,
	#category : #'Executable-Graph-Model'
}

{ #category : #initialization }
GraphModelerController >> initializeModel: aGraph andView: aView [
	super initializeModel: aGraph andView: aView.
	graph currentState: 0.
	view mondrian root when: BlMouseDownEvent do: [ :event |
		event secondaryButtonPressed ifTrue: [ self openMenuWith: event localPosition ].
 ].
]

{ #category : #initialization }
GraphModelerController >> onClick: aNode [
	| node |
	node := aNode graph model.
	graph debug: view mondrian.
	(graph currentState > 0)
		ifTrue: [
			view drawEdges: 
			(graph addEdgeFrom: graph currentState to: node) asOrderedCollection.
			graph currentState: 0.
			selectedNode background: Color white.
			]
		ifFalse: [
			graph currentState: node.
			aNode background: Color blue.
			selectedNode := aNode.
			].
]

{ #category : #'as yet unclassified' }
GraphModelerController >> onDoubleClick: anObject [
	| newNode |
	newNode := self graph addNode.
	self view drawNodes: newNode asOrderedCollection.
	view mondrian root graph nodeAt: newNode put: (view mondrian root children last).
	
]

{ #category : #'as yet unclassified' }
GraphModelerController >> onDoubleClick: anObject with: mousePosition [
	| newNode blNode |
	newNode := self graph addNode.
	self view drawNodes: newNode asOrderedCollection.
	blNode := (view mondrian root children last).
	blNode relocate: (mousePosition) - (view defaultNodeSize / 2).
	view mondrian root graph nodeAt: newNode put: blNode.
	
]

{ #category : #'as yet unclassified' }
GraphModelerController >> onDoubleClickAt: mousePosition [
	| newNode blNode |
	newNode := self graph addNode.
	self view drawNodes: newNode asOrderedCollection.
	blNode := (view mondrian root children last).
	blNode relocate: (mousePosition) - (view defaultNodeSize / 2).
	view mondrian root graph nodeAt: newNode put: blNode.
	
]

{ #category : #'as yet unclassified' }
GraphModelerController >> openMenuWith: mousePosition [
	| menu |
	menu := MenuMorph new defaultTarget: self .
	menu add: 'Add new node' selector: #onDoubleClickAt: argument: mousePosition.
	menu add: 'Executable FSA Model' selector: #onDoubleClickAt: argument: mousePosition.
	menu add: 'Graph Editor' selector: #onDoubleClickAt: argument: mousePosition.
	menu popUpInWorld
]
