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
	fromNode > 0
		ifTrue: [
			graph addEdgeFrom: fromNode to: node.
			fromNode:=0.
			selectedNode background: Color white.
			]
		ifFalse: [
			fromNode := node.
			aNode background: Color blue.
			selectedNode := aNode.
			].
]

{ #category : #'as yet unclassified' }
GraphModelerController >> onDoubleClick: anObject [
	| newNode |
	newNode = self graph addNode.
]
