
###
> PACKAGE MANAGER
###

module.exports = class EventsPackageManager

	###
	> DOCPAD READY HANDLER
	###

	docpadReady:(opts)->
		{docpad} = opts

		###
		> ADD CUSTOM COLLECTIONS
		###

		docpad.setCollection "events", docpad.getCollection("documents").findAllLive({isEvent:true})

		###
		> ADD DEFAULT EVENT TYPES
		###
		@eventTypes =
			Event:
				eventAbsName:"starling.events.Event"
				types:[
					"added"
					"addedToStage"
					"cancel"
					"change"
					"close"
					"complete"
					"context3DCreate"
					"enterFrame"
					"flatten"
					"open"
					"removed"
					"removedFromStage"
					"removeFromJuggler"
					"resize"
					"rootCreated"
					"scroll"
					"select"
					"triggered"]

			TouchEvent:
				eventAbsName:"starling.events.TouchEvent"
				types:[
					"touch"]

			FeathersEventType:
				eventAbsName:"feathers.events.FeathersEventType"
				types:[
					"beginInteraction"
					"clear"
					"endInteraction"
					"enter"
					"error"
					"focusIn"
					"focusOut"
					"initialize"
					"rendererAdd"
					"rendererRemove"
					"resize"
					"scrollComplete"
					"transitionComplete"
					"transitionStart" ]

			DragDropEvent:
				eventAbsName:"feathers.events.DragDropEvent"
				types:[
					"dragComplete"
					"dragDrop"
					"dragEnter"
					"dragExit"
					"dragMove"
					"dragStart"]

		###
		> EXTEND DOCUMENT MODEL
		###

		{DocumentModel} = docpad
		eventTypes = @eventTypes
		plugin = @
		DocumentModel::getStaticNamesForEventClass = (eventDocument) ->
			if eventDocument.isEvent
				results = []
				event = eventTypes[ eventDocument.className ]
				for type in event.types
					results.push plugin.convertTypeToStaticPropertyName type
				return results
			else
				return []

		DocumentModel::getEventTypesForEventClass = (eventDocument) ->
			if eventDocument.isEvent
				results = []
				event = eventTypes[ eventDocument.className ]
				for type in event.types
					results.push type
				return results
			else
				return []

		DocumentModel::getEventImportsForTypes = (types) ->
			imports = {}
			for type in types
				for event of eventTypes
					for typ in eventTypes[event].types

						if typ == type
							imports[ eventTypes[event].eventAbsName ] = true
							break

			results = []
			results.push imp for imp of imports
			return results

		#Returns a list of static members for an event. e.g. Event.RESIZE
		DocumentModel::getStaticPropsForTypes = (types) ->
			names = []
			for type in types
				found = false
				for event of eventTypes
					for typ in eventTypes[event].types
						if typ == type
							found = true
							names.push event + "." + plugin.convertTypeToStaticPropertyName(type)
							break
					if found
						break

			return names

		DocumentModel::getEventHandlerNamesForTypes = (types) ->
			results = []
			for type in types
				results.push plugin.convertTypeEventHandlerName(type)

			return results

		DocumentModel::getEventClassNamesForTypes = (types) ->
			names = []
			for type in types
				found = false
				for event of eventTypes
					for typ in eventTypes[event].types
						if typ == type
							found = true
							names.push event
							break
					if found
						break

			return names

	###
	> CALLED FOR EACH PACKAGE ADDED
	###

	packageAdded:(pkgProps,classes)->
		if pkgProps.isEvent
			# add new event types.
			for cls in classes
				@eventTypes[cls.classProps.className] =
					eventAbsName: cls.classProps.classAbsName
					types: cls.classData.events.split(",")

	###
	> CONVERTS AN EVENT TYPE NAME TO STATIC PROPERTY NAME
	###

	convertTypeToStaticPropertyName:(type)->
		# cover some edge cases names that don't work with this..
		if type == "context3DCreate"
			return "CONTEXT3D_CREATE"

		propName = ""
		for char, i in type
			char = type.charAt(i)
			if /[A-Z]/.test char
				propName += "_" + char.toUpperCase()
			else
				propName += char.toUpperCase()

		return propName

	convertTypeEventHandlerName:(type)->
		return "on" + type.charAt(0).toUpperCase() + type.slice(1)










