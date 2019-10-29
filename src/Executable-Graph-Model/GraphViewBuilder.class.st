"
This class visualizes graphs.
"
Class {
	#name : #GraphViewBuilder,
	#superclass : #Object,
	#instVars : [
		'mondrian'
	],
	#classVars : [
		'controller'
	],
	#category : #'Executable-Graph-Model'
}

{ #category : #utilities }
GraphViewBuilder >> borderCircleWithLabel: aString [
	| node |
	node := BlElement new
		layout: BlFrameLayout new;
		border: (BlBorder paint: Color black);
		geometry: BlCircle new;
		size: self defaultNodeSize;
		addEventHandlerOn: BlClickEvent do: [ :event |
			event primaryButtonPressed ifTrue: [ 
				controller controllerMode == 0
					ifTrue: [ controller openPrimaryMenuWith: node ]
					ifFalse: [ controller onClick: node ]]];
		addChild:
			(BlTextElement new
				text: aString asRopedText;
				constraintsDo: [ :c | 
					c frame horizontal alignCenter.
					c frame vertical alignCenter ];
				yourself).
		^ node.
]

{ #category : #ui }
GraphViewBuilder >> defaultNodeSize [
	^ 20@20
]

{ #category : #ui }
GraphViewBuilder >> directedCurvedEdge [
	| edge |
	edge := BlParabollaArcElement new
		zIndex: 1;
		curvatureFraction: 0.0;
		addEventHandlerOn: BlClickEvent do: [ :event |
			event primaryButtonPressed ifTrue: [ 
				controller controllerMode == 0
					ifTrue: [ controller openPrimaryMenuWith: edge ]]];
		border: (BlBorder paint: Color black width: 2);
		toHead:
			(BlArrowheadSimpleArrow new
				border:
					(BlBorder builder
						paint: Color black;
						width: 2;
						build)).
		^edge
]

{ #category : #ui }
GraphViewBuilder >> drawEdges: edgeList [
	mondrian edges
	shape: [ :edge | self directedCurvedEdge ];
	fromNearestTightCircle;
	toNearestTightCircle;
	connectToAll: [:x | (edgeList select: [ :each | each key = x ]) collect:
			[ :each | each value] ].
]

{ #category : #ui }
GraphViewBuilder >> drawNodes: nodeList [
	mondrian nodes
	shape: [ :x | self borderCircleWithLabel: x asString ];
	with: nodeList.
]

{ #category : #accessing }
GraphViewBuilder >> mondrian [
	^ mondrian
]

{ #category : #accessing }
GraphViewBuilder >> mondrian: anObject [
	mondrian := anObject
]

{ #category : #ui }
GraphViewBuilder >> viewFor: aGraph [

	"| mondrian controller |
	mondrian := GtMondrian new.
	mondrian nodes
		shape: [ :x | self borderCircleWithLabel: x asString ];
		with: aGraph nodes.
	mondrian edges
		shape: [ :edge | self directedCurvedEdge ];
		fromNearestTightCircle;
		toNearestTightCircle;
		connectToAll: [:x | (aGraph edges select: [ :each | each key = x ]) collect:
			[ :each | each value] ].
	mondrian layout circle.
	controller := FSAgraphController new initializeModel: aGraph andView: mondrian root.
	aGraph addDependent: controller.
	^ mondrian"
]

{ #category : #ui }
GraphViewBuilder >> viewFor: aGraph with: aMondrian [
	mondrian := aMondrian.
	self drawNodes: aGraph nodes.
	controller := GraphController new initializeModel: aGraph andView: self.
	aGraph addDependent: controller.
	self drawEdges: aGraph edges.
	aMondrian layout circle.

	^ aMondrian
]
