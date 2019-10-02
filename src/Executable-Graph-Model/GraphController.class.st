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
		'mondrianRoot'
	],
	#category : #'Executable-Graph-Model'
}

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
	mondrianRoot := view mondrian root.
	viewNodes := mondrianRoot children select: [ :each | each graph isNode ].
]

{ #category : #initialization }
GraphController >> onClick: aNode [
	| node |
	
	self graph addNode.
	
	node := aNode graph model.
	((graph successorOf: graph currentState) includes: node)
		ifTrue: [ graph currentState: node.].
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
