local http = require "socket.http"
local socket = require "socket"
local ltn12 = require "ltn12"
local mime = require "mime"
local socket = require "socket"
local utf8 = require "utf8"

local utils = {}

function utils.request( url, method, timeout, data ) --shorten request version for a RESTful api utilizing json
	method       = method or 'GET'
	http.TIMEOUT = timeout or 0

	if string.upper(method) == "GET" then
		return http.request(url) 

	elseif string.upper(method) == "POST" then
		local t      = {}
		local source = ltn12.source.string(data)
		local sink   = ltn12.sink.table(t)
		assert(data,"You need data for a "..method)

		return http.request({
			url     = url,
			sink    = sink,
			method  = "POST",
			headers = { ["Content-Type"] = "application/json",
					   ["Content-Length"] = string.len(data)  },
			source  = source
		})
	
	elseif string.upper(method) == "DELETE" then
		local t    = {}
		local sink = ltn12.sink.table(t)

		return http.request({
			url     = url,
			sink    = sink,
			method  = "DELETE",
			headers = { ["Content-Type"] = "application/json",
					   ["Content-Length"] = string.len(data)  },
		})

	elseif string.upper(method)	== "PUT" then
		local t      = {}
		local source = ltn12.source.string(data)
		local sink   = ltn12.sink.table(t)
		assert(data,"You need data for a "..method)

		return http.request({
			url     = url,
			sink    = sink,
			method  = "PUT",
			headers = { ["Content-Type"] = "application/json",
					   ["Content-Length"] = string.len(data)  },
			source  = source
		})

	end

end

function utils.limitString(str, font, width, ellipses, cut )-- ellipses is a bool for "...", cut teels function it is after its first cut. internal use only
		if ellipses == true and cut then
			if font:getWidth(str.."...") < width  then
				return str.."..."
			else
				local byteoffset = utf8.offset(str, -1)
		        if byteoffset then
		            str = string.sub(str, 1, byteoffset - 1)
		        end
				return utils.limitString(str, font, width, true, true  )
			end
		else
			if font:getWidth(str) < width then
				return str
			else
				local byteoffset = utf8.offset(str, -1)
		        if byteoffset then
		            str = string.sub(str, 1, byteoffset - 1)
		        end
				return utils.limitString(str, font, width, ellipses, true )
			end
		end
end

function utils.makeTimeStamp(dateString)
	local pattern = "(%d+)%-(%d+)%-(%d+)%a(%d+)%:(%d+)%:([%d%.]+)([Z%p])(%d*)%:?(%d*)";
	local year, month, day, hour, minute, seconds, tzoffset, offsethour, offsetmin = dateString:match(pattern);
	local timestamp = os.time({year=year, month=month, day=day, hour=hour, min=minute, sec=seconds});
	local offset = 0;
	if (tzoffset) then
		if ((tzoffset == "+") or (tzoffset == "-")) then  -- we have a timezone!
			offset = offsethour * 60 + offsetmin;
			if (tzoffset == "-") then
			  offset = offset * -1;
			end
			timestamp = timestamp + offset;
		end
	end
	return timestamp;
end

function utils.modifyColor( color, mult) -- multiplies r,g,b by a mult
	return {color[1]*mult,color[2]*mult,color[3]*mult,color[4]}
end

function utils.hexToColor(hex)
	local color = tonumber(hex, 16)
	local t = {}
	while color > 0 do
	    table.insert(t, 1, color % 256)
	    color = math.floor(color / 256)
	end
	return t
end
return utils