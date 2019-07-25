#Adam Falcigno
#Summer 2019 Muffin project

#spacer from terminal
println("\n");



################################################################################
#FC

#Works fully 6/24/19 8:32AM (weird // fraction thing but it works nonetheless)
function FC(m, s)
    #default answer text to explain what I do here
    ansText = "FC(" * string(m) * ", " * string(s) * ") = "
    #take care of wacky cases
    if m < s
        return "MORON! m has to be greater than s"
    end
    if m % s == 0
        println(ansText * string(1))
        return 1
    end

    #do the calculations
    ceiling = m//Int64(s*ceil(2m/s))
    flr = 1-m//Int64(s*floor(2m/s))
    #determine minimum
    if flr > ceiling
        min = ceiling
    else
        min = flr
    end
    #max between min and 1/3
    if min > 1/3
        println(ansText * string(min))
        return min
    else
        println(ansText * string(1/3))
        return 1/3
    end
end





################################################################################
#VINT

function VHALF(m, s, alpha)
    #compute possible pieces per person
    V = 2m
    #some people will get sV number of pieces
    sV = ceil(V/s)
    smin1 = sV-1
    #compute how many of each pieces people are getting
    numGettingV = (V - smin1*s) / (sV - smin1)
    numGettingMin1 = s - numGettingV

    #if they get v+1 or v-2 pieces...
    higher = sV+1
    lower = smin1 - 1
    if m/s / higher > alpha || 1 - (m/s / lower) > alpha
        return println("Assumption of share of pieces does not work: alpha = " * string(alpha) * " is less than "
                        * string(m/s / higher) * " or " * string(1 - (m/s / lower)));
    end

    #determine if half method works
    y = m//s - (1- alpha)*Int64(lower)
    x = m//s - (Int64(sV)-1)*alpha
    #convert to 1/2 if needed
    if x > 0.4999 && x < 0.5001
        x = 1//2
    end
    if y > 0.4999 && y < 0.5001
        y = 1//2
    end
    #boundaries
    numInBottomBoundary = sV*numGettingV
    numInTopBoundary = smin1*numGettingMin1
    println("    " * string(numInBottomBoundary) * "                 " * string(numInTopBoundary))
    println("(---------)----------(---------)")
    println(string(alpha) * "   " * string(x) * "   " * string(y) * "   " * string(1-alpha))
end



################################################################################
#HALF

#I think this might be how to calculate alpha idk
function HALF(m, s)
    println("HALF(" * string(m) * ", " * string(s) * "):")
    if m % s == 0
        return 1
    end
    #compute possible pieces per person
    V = 2m
    #some people will get sV number of pieces
    sV = ceil(V/s)
    smin1 = sV-1
    #compute how many of each pieces people are getting
    numGettingV = (V - smin1*s) / (sV - smin1)
    numGettingMin1 = s - numGettingV

    #calculate the possible alphas
    y = 1 - (m//s - 1//2) // (Int64(smin1)-1)
    x = (m//s - 1//2) // (Int64(sV)-1)

    #use the bigger one
    if x > 1-y
        alpha = x
    else
        alpha = 1-y
    end

    VHALF(m, s, alpha)

    return alpha
end



################################################################################
#VINT

function VINT(m, s, alpha)
    #compute possible pieces per person
    V = 2m
    #some people will get sV number of pieces
    sV = ceil(V/s)
    smin1 = sV-1
    #compute how many of each pieces people are getting
    numGettingV = (V - smin1*s) / (sV - smin1)
    numGettingMin1 = s - numGettingV

    #if they get v+1 or v-2 pieces...
    higher = sV+1
    lower = smin1 - 1
    if m/s / higher > alpha || 1 - (m/s / lower) > alpha
        return println("Assumption of share of pieces does not work: alpha = " * string(alpha) * " is less than "
                        * string(m/s / higher) * " or " * string(1 - (m/s / lower)));
    end

    #calculate x and y
    y = m//s - (1- alpha)*Int64(lower)
    x = m//s - (Int64(sV)-1)*alpha
    #convert to 1/2 if needed
    if x > 0.4999 && x < 0.5001
        x = 1//2
    end
    if y > 0.4999 && y < 0.5001
        y = 1//2
    end
    #boundaries
    numInBottomBoundary = sV*numGettingV
    numInTopBoundary = smin1*numGettingMin1

    xBud = 1-x
    yBud = 1-y

    #determine the side that is being split
    if numInTopBoundary > numInBottomBoundary
        sBig = numInBottomBoundary
        sSmall = numInTopBoundary - numInBottomBoundary
        numSharesForMid = smin1

        #find the contradiction
        mid = 0
        while  mid <= numSharesForMid
            rightSide = numSharesForMid - mid

            #test if it's too big
            if mid * yBud + rightSide * (1-alpha) > m/s && mid * y + rightSide * xBud < m/s
                if mid * numGettingMin1 > sSmall
                    println("CONTRADICTION1: " * string(mid) * " * " * string(numGettingMin1) * " > " * string(sSmall))
                    println("                          " * string(mid) * "                   " * string(Int64(rightSide)))
                end
                if rightSide * numGettingMin1 > sBig
                    println("CONTRADICTION2: " * string(rightSide) * " * " * string(numGettingMin1) * " > " * string(sBig))
                    println("                          " * string(mid) * "                   " * string(Int64(rightSide)))
                end
            end
            mid += 1
        end


    elseif numInBottomBoundary > numInTopBoundary
        sBig = numInTopBoundary
        sSmall = numInBottomBoundary - numInTopBoundary
        numSharesForMid = sV

        #find the contradiction
        leftSide = 0
        while  leftSide <= numSharesForMid
            mid = numSharesForMid - leftSide

            #test if it's too big
            if leftSide * yBud + mid * x > m/s && leftSide * alpha + mid * xBud < m/s

                if leftSide * numGettingV > sBig
                    println("CONTRADICTION: " * string(leftSide) * " * " * string(numGettingV) * " > " * string(sBig))
                    println("     " * string(leftSide) * "                    " * string(Int64(mid)))
                end
                if mid * numGettingV > sSmall
                    println("CONTRADICTION: " * string(mid) * " * " * string(numGettingV) * " > " * string(sSmall))
                    println("     " * string(leftSide) * "                    " * string(Int64(mid)))
                end
            end
            leftSide += 1
        end
    end

    println("    " * string(sBig) * "                 " * string(sSmall) * "                 " * string(sBig))
    println("(---------)----------(---------)----------(---------)")
    print(string(alpha) * "   ")
    if x > xBud
        print(string(yBud) * "    " * string(xBud) * "     " * string(x) * "    " * string(y) * "    ")
    else
        print(string(x) * "    " * string(y) * "    " * string(yBud) * "    " * string(xBud) * "     ")
    end
    println(string(1-alpha))

end





################################################################################
#INT

function INT(m, s)
    if m % s == 0
        return 1
    end
    #compute possible pieces per person
    V = 2m
    #some people will get sV number of pieces
    sV = Int64(ceil(V/s))
    smin1 = sV-1
    #compute how many of each pieces people are getting
    numGettingV = (V - smin1*s) / (sV - smin1)
    numGettingMin1 = s - numGettingV

    if numGettingV * sV < numGettingMin1 * smin1
        a = numGettingV * sV
        b = numGettingMin1 * smin1
        ssV = smin1
    else
        a = numGettingMin1 * smin1
        b = numGettingV * sV
        ssV = sV
    end
    ssV += 1
    println(ssV)
    i = Int64(floor(a/numGettingMin1))+1
    println(i)
    ######## THIS MIGHT BE WRONG: sV - 1 isn't always v - 1, sometimes it might have to be smin1 - 1
    alpha1 = (m//s - ((  ssV - 1) - (i - 1)) * (1 - m//s)) // ((sV - 2) * ((  ssV - 1) - (i - 1)) + i - 1)

    j = Int64(floor((b - a) / numGettingMin1))+1
    println(j)
    alpha2 = (   m//s - (1 - m//s) * ((  ssV - 1) - (j - 1)) - m//s * (j - 1) + (j - 1) * (sV - 2)  )  //  (   ((  ssV - 1) - (j - 1)) * (sV - 1) + (j - 1) * (sV - 2)    )
    
    if alpha1 > alpha2
        alpha = alpha1
    else
        alpha = alpha2
    end
    if alpha > 0.5
        alpha = 1 - alpha
    end

    #VINT(m, s, alpha)

    println(alpha)
    return alpha
    #VINT(m, s, alpha)
    #y = m//s - (1- alpha)*Int64(smin1 - 1)
    #x = m//s - (Int64(sV)-1)*alpha
end



################################################################################
#=VMID

function VMID(m, s, alpha)
    #compute possible pieces per person
    V = 2m
    #some people will get sV number of pieces
    sV = ceil(V/s)
    smin1 = sV-1
    #compute how many of each pieces people are getting
    numGettingV = (V - smin1*s) / (sV - smin1)
    numGettingMin1 = s - numGettingV

    #if they get v+1 or v-2 pieces...
    higher = sV+1
    lower = smin1 - 1
    if m/s / higher > alpha || 1 - (m/s / lower) > alpha
        return println("Assumption of share of pieces does not work: alpha = " * string(alpha) * " is less than "
                        * string(m/s / higher) * " or " * string(1 - (m/s / lower)));
    end

    #calculate x and y
    y = m//s - (1- alpha)*Int64(lower)
    x = m//s - (Int64(sV)-1)*alpha
    #convert to 1/2 if needed
    if x > 0.4999 && x < 0.5001
        x = 1//2
    end
    if y > 0.4999 && y < 0.5001
        y = 1//2
    end
    #boundaries
    numInBottomBoundary = sV*numGettingV
    numInTopBoundary = smin1*numGettingMin1

    xBud = 1-x
    yBud = 1-y

    if x > xBud && (x + xBud) / 2 == 1/2

    elseif (y + yBud) / 2 == 1/2

    else
        println("Midpoint is not 1/2, MID does not work")
    end


    end


    println("    " * string(sBig) * "                 " * string(sSmall) * "                 " * string(sBig))
    println("(---------)----------(---------)----------(---------)")
    print(string(alpha) * "   ")
    if x > xBud
        print(string(yBud) * "    " * string(xBud) * "     " * string(x) * "    " * string(y) * "    ")
    else
        print(string(x) * "    " * string(y) * "    " * string(yBud) * "    " * string(xBud) * "     ")
    end
    println(string(1-alpha))
end=#

function f(m, s)
    functions = Float64[HALF(m, s), INT(m, s)]
    min = FC(m, s)
    i = 1
    while i <= length(functions)
        if functions[i] < min
            min = rationalize(functions[i])
        end
        i+=1
    end
    println("ANSWER: " * string(min))
    return min
end

#=FC
println(FC(3, 5))
println(FC(6, 6))
println(FC(12, 6))
println(FC(5, 3))
println(FC(6, 5))
=#

#=HALF
if HALF(11,5) != 13//30
    println("\nFAIL\n\n")
end
if HALF(45, 26) != 32//78
    println("\nFAIL\n\n")
end
if HALF(7, 6) != 1//3
    println("\nFAIL\n\n")
end
if HALF(69, 41) != 67//164
    println("\nFAIL\n\n")
end
if HALF(19, 11) != 9//22
    println("\nFAIL\n\n")
end
if HALF(13, 11) != 1//3
    println("\nFAIL\n\n")
end
if HALF(23, 13) != 11//26
    println("\nFAIL\n\n")
end
=#

#=VINT
VINT(24, 11, 19//44)
VINT(23, 13, 53//130)
VINT(19, 17, 1//3)
VINT(10, 9, 1//3)
VINT(17, 15, 7//20)
=#

#=INT
INT(24, 11)
INT(59, 14)
INT(17, 15)#don't work
INT(19, 17)#
INT(21, 17)#
INT(21, 19)
=#

#f
f(24, 11)
f(59, 14)
f(11, 5)
f(7, 6)
f(6, 6)
f(5, 3)

#

#spacer from terminal
println("\n");
