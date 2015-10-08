local gui = require("gui")

local defualt = gui.theme()

defualt:setPrimaryColors( "C5CAE9", "3F51B5", "303F9F" )
defualt:setSecondaryColors( "FFFFFF", "FF80AB", "F50057" )
defualt:setMainFont( "Noto/noto.ttf", "Noto/notoB.ttf", "Noto/notoI.ttf", "Noto/notoBI.ttf" )

return defualt
