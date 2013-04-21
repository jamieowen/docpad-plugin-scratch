
###
> PACKAGE MANAGER
###

module.exports = class ContextConfigPackageManager

	###
	> DOCPAD READY HANDLER
	###

	docpadReady:(opts)->
		{docpad} = opts

		###
		> ADD CUSTOM COLLECTIONS
		###

		docpad.setCollection "contextConfig", docpad.getCollection("documents").findAllLive({isContextConfig:true})


	###
	> CALLED FOR EACH PACKAGE ADDED
	###

	packageAdded:(pkgProps,classes)->
		c = classes




