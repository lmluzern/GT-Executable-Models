Class {
	#name : #GraphPlace,
	#superclass : #Object,
	#instVars : [
		'announcer',
		'tokens'
	],
	#category : #'Executable-Graph-Model'
}

{ #category : #adding }
GraphPlace >> addToken: aToken [

	tokens add: aToken.
	self notifyTokenAdded: aToken
]

{ #category : #accessing }
GraphPlace >> announcer [
	^ announcer ifNil: [ announcer := Announcer new ]
]

{ #category : #initialization }
GraphPlace >> initialize [
	super initialize.
	
	tokens := OrderedCollection new
]

{ #category : #adding }
GraphPlace >> notifyTokenAdded: aToken [
	self announcer announce: (TokenAddedAnnouncement new token: aToken)
]
