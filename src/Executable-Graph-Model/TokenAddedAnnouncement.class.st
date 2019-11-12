Class {
	#name : #TokenAddedAnnouncement,
	#superclass : #Announcement,
	#instVars : [
		'token'
	],
	#category : #'Executable-Graph-Model'
}

{ #category : #accessing }
TokenAddedAnnouncement >> token [
	^ token
]

{ #category : #accessing }
TokenAddedAnnouncement >> token: anObject [
	token := anObject
]
