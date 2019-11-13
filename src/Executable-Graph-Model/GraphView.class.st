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

{ #category : #ui }
GraphView >> addWeightTo: anEdgeElement with: weight [
	
	anEdgeElement addChild:
		(BlTextElement new
			text: weight asRopedText;
			constraintsDo: [ :c | 
				c frame horizontal alignCenter.
				c frame vertical alignCenter]).
]

{ #category : #accessing }
GraphView >> allNodeElements [
	^ self children select: [ :eachElement | eachElement graph isNode ]
]

{ #category : #utilities }
GraphView >> borderCircle [
	| node |
	node := BlElement new
		border: (BlBorder paint: Color black width: self defaultWidth);
		geometry: BlCircle new;
		size: self defaultNodeSize;
		layout: GtGraphCirclePackLayout new.
		"layout: BlFrameLayout new."
		self addEventsToNode: node.
		^ node.
]

{ #category : #utilities }
GraphView >> borderCircleWithLabel: aString [
	| node |
	node := BlElement new
		layout: BlFrameLayout new;
		border: (BlBorder paint: Color black width: self defaultWidth);
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
		border: (BlBorder paint: Color black width: self defaultWidth).
		self addEventsToNode: node.
		^ node.
]

{ #category : #ui }
GraphView >> defaultNodeSize [
	^ 50@50
]

{ #category : #'as yet unclassified' }
GraphView >> defaultTransitionSize [
	^ 35@50
]

{ #category : #ui }
GraphView >> defaultWidth [
	^ 2
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
		border: (BlBorder paint: Color black width: self defaultWidth);
		toHead:
			(BlArrowheadSimpleArrow new
				border:
					(BlBorder builder
						paint: Color black;
						width: self defaultWidth;
						build)).
		
		^edge
]

{ #category : #ui }
GraphView >> drawEdge: anEdge [
	| aFromNodeElement aToNodeElement |
	
	aFromNodeElement := self findNodeElementFor: anEdge key.
	aToNodeElement := self findNodeElementFor: anEdge value.

	^ self drawEdge: anEdge from: aFromNodeElement to: aToNodeElement
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

	self addChild: anEdgeElement.
	
	^ anEdgeElement
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
GraphView >> drawPlaces: nodeList with: tokenList [
	
	self addChildren: (nodeList collect: [ :eachNode |
		| aNodeElement |
		aNodeElement := self borderCircle.
		aNodeElement graph beNode; model: eachNode.
		aNodeElement addEventHandler: BlPullHandler new.
		self updateTokens: (tokenList at: eachNode)  at: aNodeElement.
		aNodeElement ])
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
GraphView >> updateTokens: numberOfTokens at: aNodeElement [
	aNodeElement removeChildren.
	aNodeElement layout: GtGraphCirclePackLayout new.
	numberOfTokens timesRepeat: [
		| token |
		token := BlElement new.
		token border: (BlBorder paint: Color black width: 1).
		token geometry: BlCircle new.
		token margin: (BlInsets all: 3).
		token background: Color black.
		token size: 7@7.
		aNodeElement addChild: token ].
]

{ #category : #ui }
GraphView >> updateWeightOf: anEdgeElement with: newWeight [
	| textElement |
	textElement := anEdgeElement children detect: [ :eachElement | eachElement class = BlTextElement ].
	textElement text: newWeight asRopedText.
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
