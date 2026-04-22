-- 
--  This is file `arabic-math.lua',
--  generated with the docstrip utility.
-- 
--  The original source files were:
-- 
--  arabic-math.dtx  (with options: `luamodule')
--  
--  See the aforementioned source file(s) for copyright and licensing information.
--  
arabicmath        = arabicmath or { }

arabicmath.module = {
    name        = "arabic-math",
    version     = 0.2,
    date        = "2018/06/06",
    description = "Arabic math support for LuaTeX",
    author      = "Khaled Hosny",
    copyright   = "Khaled Hosny",
    license     = "CC0",
}

if not modules then modules = { } end modules['arabic-math'] = arabicmath.module

local accentid = node.id("accent")
local mlistid  = node.id("sub_mlist")

local accentattr = luatexbase.new_attribute("accent")
local function new_dir_node(dir)
    local n
    if node.subtype("dir") then
        n = node.new("whatsit", "dir")
    else
        n = node.new("dir")
    end
    n.dir = dir
    return n
end
local function process_math_accents(head)
    if tex.mathdir == "TRT" then
        for n in node.traverse(head) do
            if node.has_attribute(n, accentattr) then
                local accent = n.next
                if accent and node.has_attribute(accent, accentattr) then
                    head = node.insert_before(head, n, new_dir_node("+TLT"))
                    while accent and node.has_attribute(accent, accentattr) do
                        accent = accent.next
                    end
                    head = node.insert_after(head, accent, new_dir_node("-TLT"))
                end
            end
            if n.head then
                n.head = process_math_accents(n.head)
            end
        end
    end
    return head
end
local function process_sub_mlist(n, func)
     if n and n.id == mlistid then
         func(n.head)
     end
end
function prepare_math_accents(head)
    if tex.mathdir == "TRT" then
        for n in node.traverse(head) do
            process_sub_mlist(n.nucleus, prepare_math_accents)
            process_sub_mlist(n.sup, prepare_math_accents)
            process_sub_mlist(n.sub, prepare_math_accents)
            process_sub_mlist(n.degree, prepare_math_accents)
            process_sub_mlist(n.num, prepare_math_accents)
            process_sub_mlist(n.denom, prepare_math_accents)
            if n.id == accentid then
                if n.accent then
                    node.set_attribute(n.accent, accentattr, 1)
                end
                if n.bot_accent then
                    node.set_attribute(n.bot_accent, accentattr, 1)
                end
            end
        end
    end
    return head
end

-- Check if a character is a digit (Western 0-9 or Eastern Arabic ٠-٩) or a decimal separator
local function is_digit_char(char)
    if not char then return false end
    -- Western digits: 0-9 (U+0030 to U+0039)
    if char >= 0x30 and char <= 0x39 then
        return true
    end
    -- Eastern Arabic-Indic digits: ٠-٩ (U+0660 to U+0669)
    if char >= 0x0660 and char <= 0x0669 then
        return true
    end
    -- Arabic decimal separator: ٫ (U+066B)
    if char == 0x066B then
        return true
    end
    return false
end

-- Protect digit sequences from RTL reversal
local function protect_digit_sequences(head)
    if tex.mathdir ~= "TRT" then
        return head
    end
    
    local glyphid = node.id("glyph")
    local current = head
    
    while current do
        -- Check if this is a glyph node with a digit character
        if current.id == glyphid and is_digit_char(current.char) then
            local first_digit = current
            local last_digit = current
            
            -- Find consecutive digit nodes
            local next_node = current.next
            while next_node and next_node.id == glyphid and is_digit_char(next_node.char) do
                last_digit = next_node
                next_node = next_node.next
            end
            
            -- If we have at least one digit, wrap the sequence in TLT direction nodes
            if first_digit == last_digit or last_digit ~= first_digit then
                -- Insert +TLT before first digit
                head = node.insert_before(head, first_digit, new_dir_node("+TLT"))
                -- Insert -TLT after last digit
                head = node.insert_after(head, last_digit, new_dir_node("-TLT"))
                -- Move current to after the closing direction node
                current = last_digit.next
            end
        end
        
        -- Recursively process sublists
        if current and current.head then
            current.head = protect_digit_sequences(current.head)
        end
        
        if current then
            current = current.next
        end
    end
    
    return head
end

local function handle_math(head, ...)
    head = prepare_math_accents(head)
    head = node.mlist_to_hlist(head, ...)
    head = protect_digit_sequences(head)
    head = process_math_accents(head)
    return head
end
local function registercallback()
    luatexbase.add_to_callback("mlist_to_hlist", handle_math, "arabic-math (math)", 1)
end
local letters = {
    "alef", "beh", "jeem", "dal", "heh", "waw", "zain", "hah", "tah", "yeh",
    "kaf", "lam", "meem", "noon", "seen", "ain", "feh", "sad", "qaf", "reh",
    "sheen", "teh", "theh", "khah", "thal", "dad", "zah", "ghain",
    "dotlessbeh", "dotlessnoon", "dotlessfeh", "dotlessqaf",
}

local ranges = {
    [""] =0x1EE00, -- Isolated
    ["i"]=0x1EE20, -- Initial
    ["t"]=0x1EE40, -- Tailed
    ["s"]=0x1EE60, -- Stretched
    ["l"]=0x1EE80, -- Looped
    ["d"]=0x1EEA0, -- Double-struck
}

local function definechars()
    for suffix, start in next, ranges do
        for index, name in next, letters do
            local cmd = string.format('\\Umathchardef\\%s%s="7 "0 "%X', name, suffix, start + index - 1)
            tex.print(cmd)
        end
    end
end

function arabicmath.init()
    definechars()
    registercallback()
end
-- 
--  End of File `arabic-math.lua'.
