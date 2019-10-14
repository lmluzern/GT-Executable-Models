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
		'selectedNode'
	],
	#category : #'Executable-Graph-Model'
}

{ #category : #'as yet unclassified' }
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
	
	"viewNodes
		do: [ :aNode | aNode when: BlClickEvent do: [ self onClick: aNode ] ]."
		
	view mondrian root when: BlMouseDownEvent do: [ :event |
		event secondaryButtonPressed ifTrue: [ self openSecondaryMenuWith: event localPosition ].].
]

{ #category : #initialization }
GraphController >> onClick: aNode [

]

{ #category : #'as yet unclassified' }
GraphController >> openPrimaryMenuWith: aNode [
	| menu |
	menu := MenuMorph new defaultTarget: self .
	menu add: 'Add edge from current selected node' selector: #addEdge: argument: aNode.

	menu popUpInWorld
]

{ #category : #'as yet unclassified' }
GraphController >> openSecondaryMenuWith: mousePosition [
	| menu |
	menu := MenuMorph new defaultTarget: self .
	menu add: 'Add new node' selector: #addNodeAt: argument: mousePosition.
	menu add: 'Executable FSA Model' selector: #addNodeAt: argument: mousePosition.
	menu add: 'Graph Editor' selector: #addNodeAt: argument: mousePosition.
	menu popUpInWorld
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
