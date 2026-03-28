def solve():
    T = int(input())
    results = []
    for _ in range(T):
        xp, yp, xn, yn, S = map(int, input().split())
        if S <= 1:
            results.append("NO")
            continue
        dx, dy = xp - xn, yp - yn
        if S == 2:
            cands = [
                ((-1,0),(1,1),(1,-1)),
                ((1,0),(-1,1),(-1,-1)),
                ((0,-1),(1,1),(-1,1)),
                ((0,1),(1,-1),(-1,-1)),
                ((-1,0),(0,-1),(2,1)),
                ((-1,0),(0,1),(2,-1)),
                ((1,0),(0,-1),(-2,1)),
                ((1,0),(0,1),(-2,-1)),
            ]
        else:
            cands = [
                ((-1,-1),(1,-1),(-1,S-1)),
                ((-1,1),(1,1),(-1,1-S)),
                ((-1,-1),(-1,1),(S-1,-1)),
                ((1,-1),(1,1),(1-S,-1)),
                ((-1,0),(0,-1),(2*S-2,1)),
                ((-1,0),(0,1),(2*S-2,-1)),
                ((1,0),(0,-1),(2-2*S,1)),
                ((1,0),(0,1),(2-2*S,-1)),
            ]
        found = False
        for a, b, c in cands:
            d1 = (b[0]-a[0])*(dy-a[1]) - (b[1]-a[1])*(dx-a[0])
            d2 = (c[0]-b[0])*(dy-b[1]) - (c[1]-b[1])*(dx-b[0])
            d3 = (a[0]-c[0])*(dy-c[1]) - (a[1]-c[1])*(dx-c[0])
            if (d1<0 or d2<0 or d3<0) and (d1>0 or d2>0 or d3>0):
                results.append("YES")
                results.append("{} {} {} {} {} {}".format(
                    a[0]+xn, a[1]+yn, b[0]+xn, b[1]+yn, c[0]+xn, c[1]+yn))
                found = True
                break
        if not found:
            results.append("NO")
    print('\n'.join(results))

solve()
