"
This class handles events/clicks especially for the interactive graph modeler.
"
Class {
	#name : #GraphModelerController,
	#superclass : #GraphController,
	#instVars : [
		'selectedNode'
	],
	#category : #'Executable-Graph-Model'
}

{ #category : #initialization }
GraphModelerController >> initializeModel: aGraph andView: aView [
	super initializeModel: aGraph andView: aView.
	graph currentState: 0.
	view mondrian root when: BlDoubleClickEvent do: [ self onDoubleClick: view ].
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
