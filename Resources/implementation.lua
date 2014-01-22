function addFunc(a, b)
	return a + b
end

function multiplayMatrix(a, b, c)
	local sum = 0
	local n = 1
	for i = 1, 4 do
		while n <= 4 do
			for j = 1, 4 do
				sum = sum + a[i][j] * b[j][n]
			end
			c[i][n] = sum
			n = n + 1
			sum = 0
		end
		n = 1
	end
end