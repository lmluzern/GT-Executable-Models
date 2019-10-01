"
This class visualizes graphs.
"
Class {
	#name : #GraphViewBuilder,
	#superclass : #Object,
	#category : #'Executable-Graph-Model'
}

{ #category : #utilities }
GraphViewBuilder >> borderCircleWithLabel: aString [
	^ BlElement new
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
				yourself);
		yourself
]

{ #category : #ui }
GraphViewBuilder >> defaultNodeSize [
	^ 20@20
]

{ #category : #ui }
GraphViewBuilder >> directedCurvedEdge [
	^ BlParabollaArcElement new
		zIndex: 1;
		curvatureFraction: 0.2;
		border: (BlBorder paint: Color gray width: 2);
		toHead:
			(BlArrowheadSimpleArrow new
				border:
					(BlBorder builder
						paint: Color gray;
						width: 2;
						build))
]

{ #category : #ui }
GraphViewBuilder >> viewFor: aGraph [

	| mondrian controller |
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
	controller := GraphController new initializeModel: aGraph andView: mondrian root.
	aGraph addDependent: controller.
	^ mondrian
]

{ #category : #ui }
GraphViewBuilder >> viewFor: aGraph with: aMondrian [

	| controller |
	aMondrian nodes
		shape: [ :x | self borderCircleWithLabel: x asString ];
		with: aGraph nodes.
	aMondrian edges
		shape: [ :edge | self directedCurvedEdge ];
		fromNearestTightCircle;
		toNearestTightCircle;
		connectToAll: [:x | (aGraph edges select: [ :each | each key = x ]) collect:
			[ :each | each value] ].
	aMondrian layout circle.
	controller := GraphController new initializeModel: aGraph andView: aMondrian root.
	aGraph addDependent: controller.
	^ aMondrian
]
