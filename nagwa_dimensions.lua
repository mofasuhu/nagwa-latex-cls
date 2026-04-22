-- Global table to accumulate entries across multiple calls within the same run
nagwa_dimension_cache = nagwa_dimension_cache or {}
-- Global buffer to store sub-parts for the current question
nagwa_subparts_buffer = nagwa_subparts_buffer or {}

function write_question_dimensions(page_height_sp, text_height_sp, content_height_sp, text_width_sp, lmargin_sp, bmargin_sp, tmargin_sp, pagewidth_sp, question_id, prefix, pagenumber)
    -- Try to load a JSON library
    local json = nil
    pcall(function() json = require("json") end)
    if not json then
        pcall(function() json = require("dkjson") end)
    end
    
    -- Fallback serializer
    if not json then
        json = {}
        json.encode = function(val)
            local function serialize(o)
                if type(o) == "number" then return tostring(o)
                elseif type(o) == "string" then return string.format("%q", o)
                elseif type(o) == "boolean" then return tostring(o)
                elseif type(o) == "table" then
                    local parts = {}
                    if o[1] then -- Array check
                        table.insert(parts, "[")
                        for i, v in ipairs(o) do
                            if i > 1 then table.insert(parts, ", ") end
                            table.insert(parts, serialize(v))
                        end
                        table.insert(parts, "]")
                    else
                        table.insert(parts, "{")
                        local first = true
                        for k, v in pairs(o) do
                            if type(k) == "string" then
                                if not first then table.insert(parts, ", ") end
                                first = false
                                table.insert(parts, string.format("%q: %s", k, serialize(v)))
                            end
                        end
                        table.insert(parts, "}")
                    end
                    return table.concat(parts)
                else return "null" end
            end
            return serialize(val)
        end
        json.decode = function(s) return {} end
    end

    local pageheight_pt = page_height_sp / 65536
    local textheight_pt = text_height_sp / 65536
    local textwidth_pt = text_width_sp / 65536
    local lmargin_pt = (lmargin_sp or 0) / 65536
    local bmargin_pt = (bmargin_sp or 0) / 65536
    local tmargin_pt = (tmargin_sp or 0) / 65536
    local pagewidth_pt = (pagewidth_sp or 0) / 65536
    
    -- Infer vertical gap based on prefix
    local vgap_pt = 0
    if prefix and string.match(prefix, "^part") then
        vgap_pt = 10
    end

    -- If this is a sub-part, just buffer it
    if prefix and prefix ~= "" then
        nagwa_subparts_buffer[question_id] = nagwa_subparts_buffer[question_id] or {}
        table.insert(nagwa_subparts_buffer[question_id], {
            prefix = prefix,
            h = textheight_pt,
            w = textwidth_pt,
            l = lmargin_pt,
            gap = vgap_pt
        })
        return
    end

    -- If this is the main question call
    local diff = pageheight_pt - textheight_pt
    -- Top-Down Coordinates:
    local X0 = lmargin_pt
    local Y0 = tmargin_pt
    local X1 = X0 + textwidth_pt
    local Y1 = Y0 + textheight_pt

    local data = {}
    
    -- 1. Add Main Entry
    table.insert(data, {
        question_id = question_id,
        pagenumber = pagenumber or "1",
        pagewidth_pt = pagewidth_pt,
        pageheight_pt = pageheight_pt,
        textheight_pt = textheight_pt,
        textwidth_pt = textwidth_pt,
        pageheight_pt_textheight_pt_diff = diff,
        X0 = X0,
        Y0 = Y0,
        X1 = X1,
        Y1 = Y1
    })

    -- 2. Add Sub-parts with Top-Down coordinate calculation
    local current_Y0 = Y0 -- Start at the top of the text block
    local sub_records = nagwa_subparts_buffer[question_id] or {}
    for _, sub in ipairs(sub_records) do
        local h = sub.h
        local gap = sub.gap or 0
        
        -- Apply gap before starting this part
        local s_y0 = current_Y0 + gap
        local s_y1 = s_y0 + h -- Increasing Y downwards
        
        local p = sub.prefix
        local sub_entry = {
            question_id = question_id,
            [p .. "_textheight_pt"] = h,
            [p .. "_textwidth_pt"] = sub.w,
            [p .. "__X0"] = sub.l,
            [p .. "__Y0"] = s_y0,
            [p .. "__X1"] = sub.l + sub.w,
            [p .. "__Y1"] = s_y1
        }
        table.insert(data, sub_entry)
        current_Y0 = s_y1 -- Next part starts where this one ends
    end
    nagwa_subparts_buffer[question_id] = nil -- Clear buffer

    -- Write to file
    local json_file = question_id .. "/" .. question_id .. "-dimensions.json"
    os.execute("mkdir -p " .. question_id)
    local file = io.open(json_file, "w")
    if file then
        file:write(json.encode(data))
        file:close()
    end
end
