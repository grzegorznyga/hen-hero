-- config.lua
--letterbox,zoomEven, zoomStretch

application =
{
	content =
	{
		width = 768,
        height = 1024,
        scale = "letterbox",
		fps = 60,
		imageSuffix = {				
		    ["@2x"] = 2 		-- ipad retina  	2048 x 1536
			},
	},
}

