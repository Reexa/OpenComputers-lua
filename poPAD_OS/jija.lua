--класс
Person= {}
--тело класса
function Person:new(fName, lName)

    -- свойства
    local obj= {}
        obj.firstName = fName
        obj.lastName = lName

    -- метод
    function obj:getName()
        return self.firstName 
    end

    --чистая магия!
    setmetatable(obj, self)
    self.__index = self; return obj
end

--создаем экземпляр класса
vasya = Person:new("Вася", "валына")

--обращаемся к свойству
print(vasya.firstName)    --> результат: Вася

--обращаемся к методу
print(vasya:getName())  --> результат: Вася