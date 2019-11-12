"
This class visualizes graphs.
"
Class {
	#name : #GraphView,
	#superclass : #BlElement,
	#instVars : [
		'controller'
	],
	#category : #'Executable-Graph-Model'
}

{ #category : #accessing }
GraphView >> addEventsToNode: aNode [
	aNode
		addEventHandlerOn: BlClickEvent do: [ :event |
			event primaryButtonPressed ifTrue: [ 
				controller controllerMode == 0
					ifTrue: [ controller openPrimaryMenuWith: aNode ]
					ifFalse: [ controller onClick: aNode ]]].
	
]

{ #category : #accessing }
GraphView >> allNodeElements [
	^ self children select: [ :eachElement | eachElement graph isNode ]
]

{ #category : #utilities }
GraphView >> borderCircle [
	| node |
	node := BlElement new
		border: (BlBorder paint: Color black width: 1);
		geometry: BlCircle new;
		size: self defaultNodeSize;
		layout: GtGraphCirclePackLayout new.
		self addEventsToNode: node.
		^ node.
]

{ #category : #utilities }
GraphView >> borderCircleWithLabel: aString [
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

{ #category : #utilities }
GraphView >> borderRectangle [
	| node |
	node := BlElement new
		geometry: BlRectangle new;
		size: self defaultTransitionSize;
		border: (BlBorder paint: Color black).
		self addEventsToNode: node.
		^ node.
]

{ #category : #'as yet unclassified' }
GraphView >> convertToTransition: aNode [
	aNode
		geometry: BlRectangle new;
		size: self defaultTransitionSize;
		removeChildren.
]

{ #category : #ui }
GraphView >> defaultNodeSize [
	^ 20@20
]

{ #category : #'as yet unclassified' }
GraphView >> defaultTransitionSize [
	^ 20@30
]

{ #category : #ui }
GraphView >> directedCurvedEdge [
	| edge |
	edge := BlLineElement new
		zIndex: 1;
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
GraphView >> drawEdge: anEdge [
	| aFromNodeElement aToNodeElement |
	
	aFromNodeElement := self findNodeElementFor: anEdge key.
	aToNodeElement := self findNodeElementFor: anEdge value.

	self drawEdge: anEdge from: aFromNodeElement to: aToNodeElement
]

{ #category : #ui }
GraphView >> drawEdge: anEdge from: aFromNodeElement to: aToNodeElement [
	| anEdgeElement aGtGraphEdge |

	"GraphEdge know two node elements that it connects"
	aGtGraphEdge := aFromNodeElement graph connectTo: aToNodeElement.

	anEdgeElement := self directedCurvedEdge.
	anEdgeElement graph beEdge.
	anEdgeElement graph model: aGtGraphEdge.

	anEdgeElement fromAnchor: (BlNearestPositionEllipseAnchor
		referenceElement: aFromNodeElement
		relatedTo: aToNodeElement).
	anEdgeElement toAnchor: (BlNearestPositionEllipseAnchor
		referenceElement: aToNodeElement
		relatedTo: aFromNodeElement).

	self addChild: anEdgeElement
]

{ #category : #ui }
GraphView >> drawEdges: edgeList [
	edgeList do: [ :eachEdge | self drawEdge: eachEdge ]
]

{ #category : #ui }
GraphView >> drawNodes: nodeList [

	self addChildren: (nodeList collect: [ :eachNode |
		| aNodeElement |
		aNodeElement := self borderCircleWithLabel: eachNode asString.
		aNodeElement graph beNode; model: eachNode.
		aNodeElement addEventHandler: BlPullHandler new.
		aNodeElement ])
]

{ #category : #ui }
GraphView >> drawPlaces: nodeList [
	
	self addChildren: (nodeList collect: [ :eachNode |
		| aNodeElement |
		aNodeElement := self borderCircle.
		aNodeElement graph beNode; model: eachNode.
		aNodeElement addEventHandler: BlPullHandler new.
		aNodeElement ])
]

{ #category : #ui }
GraphView >> drawPlaces: nodeList with: tokenList [
	
	self addChildren: (nodeList collect: [ :eachNode |
		| aNodeElement |
		aNodeElement := self borderCircle.
		aNodeElement graph beNode; model: eachNode.
		aNodeElement addEventHandler: BlPullHandler new.
		aNodeElement ])
	
	"mondrian nodes
	shape: [ :x | 
		node := BlElement new 
		geometry: BlCircle new;
		border: (BlBorder paint: Color black);
		size: self defaultNodeSize;"
		"background: Color paleOrange;"
		"constraintsDo: [ :c | c padding: (BlInsets all: 10)].
		self addEventsToNode: node.
		node];
		with: nodeList
		forEach: [ :each |
			mondrian nodes 
			shape: [ :x | BlElement new
				border: (BlBorder paint: Color black);
				geometry: BlCircle new;
				size: 3@3];
			with: (1 to: (tokenList at: each)).
			mondrian layout circle radius: 4 ]."
		
]

{ #category : #ui }
GraphView >> drawTransitions: nodeList [

	self addChildren: (nodeList collect: [ :eachNode |
		| aNodeElement |
		aNodeElement := self borderRectangle.
		aNodeElement graph beNode; model: eachNode.
		aNodeElement addEventHandler: BlPullHandler new.
		aNodeElement ])
]

{ #category : #'as yet unclassified' }
GraphView >> findEdgeElementFor: aGtGraphEdge [
	^ self children detect: [ :eachElement | eachElement graph model = aGtGraphEdge ]
]

{ #category : #'as yet unclassified' }
GraphView >> findNodeElementFor: aNode [
	^ self children detect: [ :eachElement | eachElement graph model = aNode ]
]

{ #category : #ui }
GraphView >> viewFor: aGraph [
	self constraintsDo: [ :c |
		c horizontal matchParent.
		c vertical matchParent ].

	self drawNodes: aGraph nodes.
	
	"TODO"
	controller := GraphController new initializeModel: aGraph andView: self.
	
	aGraph addDependent: controller.
	self drawEdges: aGraph edges.
]
