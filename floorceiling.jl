function floorCeiling(m,s)
    bottom = s * (floor(2 * m/s))
    bottom2 = s * (ceil(2 * m/s))
    println("Hello")
    answer = max(1/3, min(m/bottom, 1 - m/bottom2))
    return answer
end