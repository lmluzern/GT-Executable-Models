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

{ #category : #accessing }
GraphViewBuilder >> addEventsToNode: aNode [
	aNode
		addEventHandlerOn: BlDragEndEvent do: [ controller updateEdges ];
		addEventHandlerOn: BlClickEvent do: [ :event |
			event primaryButtonPressed ifTrue: [ 
				controller controllerMode == 0
					ifTrue: [ controller openPrimaryMenuWith: aNode ]
					ifFalse: [ controller onClick: aNode ]]].
	
]

{ #category : #utilities }
GraphViewBuilder >> borderCircleWithLabel: aString [
	| node |
	node := BlElement new
		layout: BlFrameLayout new;
		border: (BlBorder paint: Color black);
		geometry: BlCircle new;
		size: self defaultNodeSize;
		addChild:
			(BlTextElement new
				text: aString asRopedText;
				constraintsDo: [ :c | 
					c frame horizontal alignCenter.
					c frame vertical alignCenter ];
				yourself).
		self addEventsToNode: node.
		^ node.
]

{ #category : #'as yet unclassified' }
GraphViewBuilder >> convertToTransition: aNode [
	aNode
		geometry: BlRectangle new;
		size: self defaultTransitionSize;
		removeChildren.
]

{ #category : #ui }
GraphViewBuilder >> defaultNodeSize [
	^ 20@20
]

{ #category : #'as yet unclassified' }
GraphViewBuilder >> defaultTransitionSize [
	^ 15@20
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
		border: (BlBorder paint: Color black width: 1);
		toHead:
			(BlArrowheadSimpleArrow new
				border:
					(BlBorder builder
						paint: Color black;
						width: 1;
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

{ #category : #ui }
GraphViewBuilder >> drawPlaces: nodeList [
	| node |
	mondrian nodes
	shape: [ :x | 
		node := BlElement new 
		geometry: BlCircle new;
		border: (BlBorder paint: Color black);
		"background: Color paleOrange;"
		constraintsDo: [ :c | c padding: (BlInsets all: 10)].
		self addEventsToNode: node.
		node];
		with: nodeList
		forEach: [ :each |
			mondrian nodes 
			shape: [ :x | BlElement new
				border: (BlBorder paint: Color black);
				geometry: BlCircle new;
				size: 4@4];
			with: (10 * each to: (10 * each + 2)).
			mondrian layout circle radius: 10 ].
		
]

{ #category : #ui }
GraphViewBuilder >> drawTransitions: nodeList [
	| node |
	mondrian nodes
	shape: [ :x | 
		node := BlElement new 
		geometry: BlRectangle new;
		size: self defaultTransitionSize;
		border: (BlBorder paint: Color black).
		self addEventsToNode: node.
		node];
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
