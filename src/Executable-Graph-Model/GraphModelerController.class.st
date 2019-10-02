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
	mondrianRoot when: BlDoubleClickEvent do: [ self onDoubleClick: view ].
]

{ #category : #'as yet unclassified' }
GraphModelerController >> onDoubleClick: anObject [
	self graph addNode.
]
