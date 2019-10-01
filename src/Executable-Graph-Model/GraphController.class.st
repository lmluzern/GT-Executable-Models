"
This class handles events/clicks etc.
"
Class {
	#name : #GraphController,
	#superclass : #Object,
	#instVars : [
		'graph',
		'view',
		'viewNodes'
	],
	#category : #'Executable-Graph-Model'
}

{ #category : #'as yet unclassified' }
GraphController >> clearAllStates [
	viewNodes do: [ :node | node background: Color white ]
]

{ #category : #'view control' }
GraphController >> deadColor [
	^ Color red
]

{ #category : #'accessing colors' }
GraphController >> edgeColor [
	(self graph successorOf: self graph currentState) isEmpty
		ifTrue: [ ^self deadColor ]
		ifFalse: [ ^self liveColor ]
		
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
	viewNodes := view children select: [ :each | each graph isNode ].
	viewNodes
		do: [ :aNode | aNode when: BlClickEvent do: [ self onClick: aNode ] ].
	"self setCurrentStateColor."
	self update: aGraph.
]

{ #category : #'view control' }
GraphController >> liveColor [
	^ (Color green darker alpha: 1)
]

{ #category : #'as yet unclassified' }
GraphController >> markSuccessorStates [
	| successors |
	successors := self graph successorOf: self graph currentState.
	(viewNodes select: [ :node | successors includes: node graph model ])  do:
		[ :node | node background: Color blue ]

]

{ #category : #initialization }
GraphController >> onClick: aNode [
	| node |
	node := aNode graph model.
	((graph successorOf: graph currentState) includes: node)
		ifTrue: [ graph currentState: node.].
]

{ #category : #initialization }
GraphController >> setCurrentStateColor [
	(viewNodes detect:
		[ :node | node graph model = graph currentState ]) background: self edgeColor
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
