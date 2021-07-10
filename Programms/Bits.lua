BitOps = {}
function BitOps:bit(p)
    return 2 ^ (p - 1)  -- 1-based indexing
  end

  function BitOps:hasbit(x, p)
    return x % (p + p) >= p
  end

  function BitOps:setbit(x, p)
    return BitOps:hasbit(x, p) and x or x + p
  end

  function BitOps:clearbit(x, p)
    return BitOps:hasbit(x, p) and x - p or x
  end
return BitOps
