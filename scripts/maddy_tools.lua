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
		t[#t + 1] = str
	end
	if #t == 2 and half then
		return t[1], t[2]
	else
		return t
	end
end

function M.Split2(inStr, sep, half)
	local defaultSep = "%s"
	if sep == nil then
		sep = defaultSep
	end
	local t = {}
	for str in (inStr .. sep):gmatch("(.-)(" .. sep .. ")") do
		t[#t + 1] = str
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

function M.TableDumpR(tab, depth)
	if depth == nil then
		depth = 1
	end

	for k, v in pairs(tab) do
		if type(v) ~= "table" then
			print(string.rep("\t", depth - 1), k, v)
		else
			print(string.rep("\t", depth - 1), k, "󱞣 ")
			M.TableDumpR(v, depth + 1)
		end
	end
end

function M.Includes(word, list)
	for _, v in pairs(list) do
		if word == v then
			return true
		end
	end
	return false
end

--function Array(...)
--	local t = {}
--	for x in ... do
--		t[#t + 1] = x
--	end
--	return t
--end

--function M.Split2(str, sep)
--	local psep = sep:gsub("[%(%)%.%%%+%-%*%?%[%]%^%$]", "%%%1")
--	return Array((str .. sep):gmatch("(.-)(" .. psep .. ")"))
--end

return M
