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
	viewNodes := view mondrian root children select: [ :each | each graph isNode ].
	viewNodes
		do: [ :aNode | aNode when: BlClickEvent do: [ self onClick: aNode ] ].
]

{ #category : #initialization }
GraphController >> onClick: aNode [

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
