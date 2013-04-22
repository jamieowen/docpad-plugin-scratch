
###
> PACKAGE MANAGER
###

module.exports = class MediatorsPackageManager

	###
	> DOCPAD READY HANDLER
	###

	docpadReady:(opts)->
		{docpad} = opts

		###
		> ADD CUSTOM COLLECTIONS
		###

		docpad.setCollection "mediators", docpad.getCollection("documents").findAllLive({isMediator:true})


	###
	> CALLED FOR EACH PACKAGE ADDED
	###

	packageAdded:(pkgProps,classes)->
		if pkgProps.isMediator
			# split string into array for all class handlers
			for cls in classes
				cls.classData.handlers = cls.classData.handlers.split(",")





