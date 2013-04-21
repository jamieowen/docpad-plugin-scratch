
###
> PACKAGE MANAGER
###

module.exports = class UIControlsPackageManager

	###
	> DOCPAD READY HANDLER
	###

	docpadReady:(opts)->
		{docpad} = opts

		###
		> ADD CUSTOM COLLECTIONS
		###

		docpad.setCollection "controls", docpad.getCollection("documents").findAllLive({isControl:true})


	###
	> CALLED FOR EACH PACKAGE ADDED
	###

	packageAdded:(pkgProps,classes)->
		c = classes




