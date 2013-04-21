
###
> PACKAGE MANAGER
###

module.exports = class ViewsPackageManager

	###
	> DOCPAD READY HANDLER
	###

	docpadReady:(opts)->
		{docpad} = opts

		###
		> ADD CUSTOM COLLECTIONS
		###

		docpad.setCollection "views", docpad.getCollection("documents").findAllLive({isView:true})


	###
	> CALLED FOR EACH PACKAGE ADDED
	###

	packageAdded:(pkgProps,classes)->
		c = classes




