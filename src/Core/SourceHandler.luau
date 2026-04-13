local SourceHandler = {}

function SourceHandler:BuildLCS(linesA, linesB)
	local m = #linesA
	local n = #linesB
	local dp = {}

	for i = 0, m do
		dp[i] = {}
		for j = 0, n do
			dp[i][j] = 0
		end
	end

	for i = 1, m do
		for j = 1, n do
			if linesA[i] == linesB[j] then
				dp[i][j] = dp[i-1][j-1] + 1
			else
				dp[i][j] = math.max(dp[i-1][j], dp[i][j-1])
			end
		end
	end

	return dp
end

function SourceHandler:Backtrack(dp, linesA, linesB, i, j, result)
	if i > 0 and j > 0 and linesA[i] == linesB[j] then
		self:Backtrack(dp, linesA, linesB, i-1, j-1, result)
		table.insert(result, {
			Type = "equal",
			Source = linesA[i],
			Line = i,
		})
	elseif j > 0 and (i == 0 or dp[i][j-1] >= dp[i-1][j]) then
		self:Backtrack(dp, linesA, linesB, i, j-1, result)
		table.insert(result, {
			Type = "added",
			Source = linesB[j],
			Line = i,
		})
	elseif i > 0 and (j == 0 or dp[i][j-1] < dp[i-1][j]) then
		self:Backtrack(dp, linesA, linesB, i-1, j, result)
		table.insert(result, {
			Type = "removed",
			Source = linesA[i],
			Line = i,
		})
	end
end

function SourceHandler:GetLines(source: string): {string}
	local lines = {}
	source = source:gsub("\r\n", "\n")
	for line in source:gmatch("([^\n]*)\n?") do
		table.insert(lines, line)
	end

	if lines[#lines] == "" then
		table.remove(lines, #lines)
	end

	return lines
end

function SourceHandler:Compare(sourceA: string, sourceB: string)
	local linesA = self:GetLines(sourceA)
	local linesB = self:GetLines(sourceB)

	local dp = self:BuildLCS(linesA, linesB)

	local result = {}
	self:Backtrack(dp, linesA, linesB, #linesA, #linesB, result)

	return result
end

return SourceHandler