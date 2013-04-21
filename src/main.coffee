
###
> PACKAGE MANAGER
###

module.exports = class MainPackageManager

	###
	> DOCPAD READY HANDLER
	###

	docpadReady:(opts)->
		{docpad} = opts

		###
		> ADD CUSTOM COLLECTIONS
		###

		#docpad.setCollection "models", docpad.getCollection("documents").findAllLive({isModel:true})



	###
	> CALLED FOR EACH PACKAGE ADDED
	###

	packageAdded:(pkgProps,classes)->
		c = classes




