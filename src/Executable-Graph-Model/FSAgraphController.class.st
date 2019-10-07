"
This class handles events/clicks especially for FSA Models.
"
Class {
	#name : #FSAgraphController,
	#superclass : #GraphController,
	#category : #'Executable-Graph-Model'
}

{ #category : #'as yet unclassified' }
FSAgraphController >> clearAllStates [
	viewNodes do: [ :node | node background: Color white ]
]

{ #category : #'view control' }
FSAgraphController >> deadColor [
	^ Color red
]

{ #category : #'accessing colors' }
FSAgraphController >> edgeColor [
	(self graph successorOf: self graph currentState) isEmpty
		ifTrue: [ ^self deadColor ]
		ifFalse: [ ^self liveColor ]
		
]

{ #category : #initialization }
FSAgraphController >> initializeModel: aGraph andView: aView [
	super initializeModel: aGraph andView: aView.
	self update: aGraph.
]

{ #category : #'view control' }
FSAgraphController >> liveColor [
	^ (Color green darker alpha: 1)
]

{ #category : #'as yet unclassified' }
FSAgraphController >> markSuccessorStates [
	| successors |
	successors := self graph successorOf: self graph currentState.
	(viewNodes select: [ :node | successors includes: node graph model ])  do:
		[ :node | node background: Color blue ]

]

{ #category : #initialization }
FSAgraphController >> onClick: aNode [
	| node |
	node := aNode graph model.
	((graph successorOf: graph currentState) includes: node)
		ifTrue: [ graph currentState: node.].
]

{ #category : #initialization }
FSAgraphController >> setCurrentStateColor [
	(viewNodes detect:
		[ :node | node graph model = graph currentState ]) background: self edgeColor
]

{ #category : #updating }
FSAgraphController >> update: aGraph [
	self clearAllStates.
	self markSuccessorStates.
	self setCurrentStateColor.
]
