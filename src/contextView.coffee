
###
> PACKAGE MANAGER
###

module.exports = class ContextViewPackageManager

	###
	> DOCPAD READY HANDLER
	###

	docpadReady:(opts)->
		{docpad} = opts

		###
		> ADD CUSTOM COLLECTIONS
		###

		docpad.setCollection "contextView", docpad.getCollection("documents").findAllLive({isContextView:true})


	###
	> CALLED FOR EACH PACKAGE ADDED
	###

	packageAdded:(pkgProps,classes)->
		c = classes




