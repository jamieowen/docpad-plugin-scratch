module.exports = class PackageBuilder
	constructor:()->
		@packageList = []
		@currentPackage = null

	pushPackage: (name)->
		console.log "push package"

	popPackage: ()->
		console.log "pop package"

	pushConfig: ()->
		console.log "push config"

	popConfig: ()->
		console.log "pop config"

	addModel: (cls, fields )->
		console.log "add"

	addEvent: (cls, events )->
		console.log "add"

	addCommand: (cls, name )->
		console.log "add"

	addView: (cls, events, controls )->
		console.log "add"

	addMediator: (cls, view, handlers, dataBindings )->
		console.log "add"

	addMain: (cls) ->
		console.log "add"

	addContextConfig: (cls) ->
		console.log "add"

	addContextView: (cls, events, controls) ->
		console.log "add"
