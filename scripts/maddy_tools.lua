M = {}

function M.Run(command)
	local handel = io.popen(command)
	if handel ~= nil then
		local result = handel:read("*a")
		handel:close()
		return result
	end
end

function M.Split(inStr, sep, half)
	local defaultSep = "%s"
	if sep == nil then
		sep = defaultSep
	end
	local t = {}
	for str in string.gmatch(inStr, "([^" .. sep .. "]+)") do
		table.insert(t, str)
	end
	if #t == 2 and half then
		return t[1], t[2]
	else
		return t
	end
end

function M.TableInvert(t)
	local s = {}
	for k, v in pairs(t) do
		s[v] = k
	end
	return s
end

function M.TableDump(t)
	for k, v in pairs(t) do
		print(k, v)
	end
end

return M
