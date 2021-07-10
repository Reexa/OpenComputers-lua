--
-- Created by IntelliJ IDEA.
-- User: 1337
-- Date: 3/10/2021
-- Time: 9:51 PM
-- To change this template use File | Settings | File Templates.
--

Container = {_ELEMENT_COUNTER = 1
    --контейнер для элементов интерфейса (окнах)
    --содержит базовую и дополнительную информацию об элементов
    --базовая -> позиция(X,Y), размер(Width, Height), isVisible(1 or 0)
    --дополнительная -> (пользовательское)
}
Container["id"] ={_ELEMENT_COUNTER = 1}

--------------------------------------FUNCTION----------------------------------------
function Container:addElement(element, callback)
    for k, v in pairs(element) do

    print(k..'\t'..tostring(v))

    end

    if element == nil then
        print("ERROR: gived a void element on input at function")

    elseif element["Xpos"] == nil then
        print("ERROR: a nil X pos in element")

    elseif element["Ypos"] == nil then
        print("ERROR: a nil X pos in element")

    elseif element["Width"] == nil then
        print("ERROR: a nil width value in element")

    elseif element["Height"] == nil then
        print("ERROR: a nil height value in element")

    elseif element["isVisible"] == nil then
        print("ERROR: a nil visible flag in element")

    else
        element["callback"] = callback
        table.insert(Container, element)

        local newID = (math.random(0, 0xFF))

        if type(Container["id"]) == table then

            for k,v in pairs(Container["id"]) do

                if Container["id"][k] == newID then

                    newID = (math.random(0, 0xFFFFFF))

                end
            end
        end
        Container._ELEMENT_COUNTER = Container._ELEMENT_COUNTER+1

        table.insert(Container["id"], {value = newID, reference = Container._ELEMENT_COUNTER})

        Container["id"]._ELEMENT_COUNTER = Container["id"]._ELEMENT_COUNTER+1

        return Container["id"]._ELEMENT_COUNTER-1

    end
end
--------------------------------------------------------------------------------------

--------------------------------------FUNCTION----------------------------------------
function Container:removeElement(element)
    table.remove()
    --TODO
end
--------------------------------------------------------------------------------------

--------------------------------------FUNCTION----------------------------------------
--возвращает массив всех кликабельных зон и из коллбэков
function Container:getElements()
    local counter = Container["id"]._ELEMENT_COUNTER
    local returnable = {}
    for element in Container do
        -- ...каждый элемент в контейнере

    end
    --TODO
end
--------------------------------------------------------------------------------------

return Container