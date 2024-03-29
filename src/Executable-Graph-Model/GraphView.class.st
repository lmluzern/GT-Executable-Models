"
I build a view of a Graph and glue it to a GraphController.
I am a canvas and graph elements are added to me as children, e.g. GraphView>>#drawNodes:
I get invoked in Graph>>#gtElement:
"
Class {
	#name : #GraphView,
	#superclass : #BlElement,
	#category : #'Executable-Graph-Model'
}

{ #category : #ui }
GraphView >> addWeightTo: anEdgeElement with: weight [
	| edgeLable |
	edgeLable := (BlTextElement new
	text: weight asRopedText;
	background: Color white;
	padding: (BlInsets all: 5);
	constraintsDo: [ :c |
		c ignoreByLayout. 
		c ignored horizontal alignCenter.
		c ignored vertical alignCenter]).
	
	weight < 1 ifTrue: [ edgeLable visibility: BlVisibility hidden ].
	
	anEdgeElement addChild: edgeLable.
]

{ #category : #accessing }
GraphView >> allEdgeElements [
	^ self children select: [ :eachElement | eachElement graph isEdge ]
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
		^ node.
]

{ #category : #utilities }
GraphView >> borderRectangle [
	| node |
	node := BlElement new
		geometry: BlRectangle new;
		size: self defaultTransitionSize;
		border: (BlBorder paint: Color black width: self defaultWidth).
		^ node.
]

{ #category : #ui }
GraphView >> defaultCurvatureFraction [
	^ 0.3
]

{ #category : #ui }
GraphView >> defaultNodeSize [
	^ 50@50
]

{ #category : #'as yet unclassified' }
GraphView >> defaultTransitionSize [
	^ 15@60
]

{ #category : #ui }
GraphView >> defaultWidth [
	^ 2
]

{ #category : #ui }
GraphView >> directedCurvedEdge [
	| edge |
	edge := BlParabollaArcElement new
		zIndex: 1;
		curvatureFraction: 0;
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

{ #category : #ui }
GraphView >> edgeElementToAssociation: anEdgeElement [
		| fromNode toNode |
		fromNode := (anEdgeElement graph model fromElement) graph model.
		toNode := (anEdgeElement graph model toElement) graph model.
		
		^ (fromNode -> toNode)
]

{ #category : #'as yet unclassified' }
GraphView >> findEdgeElementFor: aGtGraphEdge [
	^ self children detect: [ :eachElement | eachElement graph model = aGtGraphEdge ]
]

{ #category : #'as yet unclassified' }
GraphView >> findNodeElementFor: aNode [
	^ self children detect: [ :eachElement | eachElement graph model = aNode ] ifNone: [  ]
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
	
	newWeight < 1
		ifTrue: [ textElement visibility: BlVisibility hidden ]
		ifFalse: [ textElement visibility: BlVisibility visible ]
]

{ #category : #ui }
GraphView >> viewFor: aGraph [
	| nodeList controller |
	nodeList := aGraph nodes copy.
	nodeList removeAll: aGraph transitions.
	nodeList removeAll: aGraph places.
	
	self constraintsDo: [ :c |
		c horizontal matchParent.
		c vertical matchParent ].
	
	self drawNodes: nodeList.
	self drawTransitions: aGraph transitions.
	self drawPlaces: aGraph places with: aGraph tokens. 
	
	controller:= GraphController new initializeModel: aGraph andView: self.
	aGraph addDependent: controller.
	
	self drawEdges: aGraph edges.
	
	self allEdgeElements do: [ :eachEdgeElement |
		| fromNode toNode |
		fromNode := (eachEdgeElement graph model fromElement) graph model.
		toNode := (eachEdgeElement graph model toElement) graph model.
		self addWeightTo: eachEdgeElement with: (aGraph weights at: (fromNode -> toNode)).
		
		eachEdgeElement curvatureFraction: (aGraph edgeCurvatures at: (fromNode -> toNode))
		].
	
	aGraph nodeLocations ifNotEmpty: [ 
		aGraph nodeLocations associations do: [ :nodeLocation |
			(self findNodeElementFor: nodeLocation key) relocate: nodeLocation value
			 ]
		 ].
	
	aGraph nodeSizes ifNotEmpty: [ 
		aGraph nodeSizes associations do: [ :nodeSize |
			(self findNodeElementFor: nodeSize key) size: nodeSize value
			 ]
		 ]
]
