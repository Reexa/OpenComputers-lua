local shell         = require("shell")
local filesystem    = require("filesystem")
Parser = {}

Parser.getWordsInStringArray = function(string, separator, stop)
    local word          = ""
    local words_array   = {}
    for i in string:gmatch"." do

        if i ~= separator then
            if i ~= ' ' and i ~= '\t' and i ~= '\n' and i ~= '\r' then
                word = word..i
            end
        else
            table.insert(words_array, word)
            word = ""
        end

    end
    return words_array
end

Parser.getWordsInTable = function(array, separator)
    local word          = ""
    local words_array   = {}
    for _, ii in pairs(array) do
        for i in ii:gmatch"." do
            if i ~= separator then
                if i ~= ' ' and i ~= '\t' and i ~= '\n' and i ~= '\r' then
                    word = word..i
                end
            else
            end
        end
        if word ~= "" and word ~= nil then table.insert(words_array, word) end
        word = ""
    end
    return words_array
end

Parser.getStringArrayInBlock = function(arr, block_start, block_end)
    local str       = ""
    local to_read   = false
    local str_out   = {}
    if arr == nil then
        error("[!] Get nil string on parser input")
    end

    if block_start == nil or block_end == nil then
        error("[!] nil block symbol on parser input")
    end

    for i in arr:gmatch"." do   -- посимвольный перебор строки
        if i == block_end then
            to_read = false
        end
        if to_read and i ~= nil and i ~= '\t' and i ~= '\r' and i ~= '\n' and i ~= ' ' and i ~= ',' then
            str = str..i
        end
        if i == block_start then
            to_read = true
        end
        if i == ',' then
            table.insert(str_out, str)
            str = ""
        end
    end
    table.insert(str_out, str)
    return str_out
end

return Parser