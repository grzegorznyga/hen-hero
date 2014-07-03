local M = {}

local helpers = require("scripts.helpers")

M.newText = function (sheet, prefix)        

        local imageGroup = display.newGroup()
        imageGroup.letterMargin = 0
        imageGroup.widthFix = 0

        function imageGroup:print(text)
                
                text = tostring(text)
                imageGroup.widthFix = 0

                --wyczysc grupe
                 while self.numChildren > 0 do
                        self:remove(self.numChildren)                        
                end

                --drukuj litery pojedynczo
                local leftMargin = 0        
                for c in text:gmatch"." do

                     local bText = sheet:newImage(prefix..c..".png")
                     bText.x = leftMargin
                     self:insert(bText)

                     --dodaj margin dla nastepnej cyfry
                     local index = sheet:index(prefix..c..".png")
                     leftMargin = leftMargin + sheet.options.frames[index].width + imageGroup.letterMargin

                     imageGroup.widthFix = imageGroup.widthFix + sheet.options.frames[index].width
                end
                
        end

        function imageGroup:printRight(text)
                
                text = tostring(text)
                imageGroup.widthFix = 0
                local x = self.x

                --wyczysc grupe
                 while self.numChildren > 0 do
                        self:remove(self.numChildren)                        
                end

                --drukuj litery pojedynczo
                local leftMargin = 0   
                
   
                for c in text:gmatch"." do

                     local bText = sheet:newImage(prefix..c..".png")
                     bText.x = leftMargin
                     self:insert(bText)

                     --dodaj margin dla nastepnej cyfry
                     local index = sheet:index(prefix..c..".png")
                     leftMargin = leftMargin + sheet.options.frames[index].width + imageGroup.letterMargin
                     
                     imageGroup.widthFix = imageGroup.widthFix + sheet.options.frames[index].width
                end

                imageGroup.xReference = imageGroup.widthFix
                self.x = x
        end

        function imageGroup:printCenter(text)
                
                text = tostring(text)
                imageGroup.widthFix = 0
                local x = self.x

                --wyczysc grupe
                 while self.numChildren > 0 do
                        self:remove(self.numChildren)                        
                end

                --drukuj litery pojedynczo
                local leftMargin = 0   
                
   
                for c in text:gmatch"." do

                     local bText = sheet:newImage(prefix..c..".png")
                     bText.x = leftMargin
                     self:insert(bText)

                     --dodaj margin dla nastepnej cyfry
                     local index = sheet:index(prefix..c..".png")
                     leftMargin = leftMargin + sheet.options.frames[index].width + imageGroup.letterMargin
                     
                     imageGroup.widthFix = imageGroup.widthFix + sheet.options.frames[index].width
                end

                imageGroup.xReference = imageGroup.widthFix/2
                self.x = x
        end

        return imageGroup        
end

return M
