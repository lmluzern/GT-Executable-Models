"
This class handles events/clicks especially for the interactive graph modeler.
"
Class {
	#name : #GraphModelerController,
	#superclass : #GraphController,
	#instVars : [
		'selectedNode',
		'fromNode'
	],
	#category : #'Executable-Graph-Model'
}

{ #category : #initialization }
GraphModelerController >> initializeModel: aGraph andView: aView [
	super initializeModel: aGraph andView: aView.
	fromNode := 0.
	mondrianRoot when: BlDoubleClickEvent do: [ self onDoubleClick: view ].
]

{ #category : #initialization }
GraphModelerController >> onClick: aNode [
	| node |
	node := aNode graph model.
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
	super initializeModel: graph andView: view.
	
]
