def solve():
    T = int(input())
    for _ in range(T):
        N, K = map(int, input().split())
        
        divs = []
        i = 1
        while i * i <= N:
            if N % i == 0:
                divs.append(i)
                if i != N // i:
                    divs.append(N // i)
            i += 1
        divs.sort()
        
        G = {}
        for d in divs:
            reachable = set()
            j = 1
            while j * j <= d:
                if d % j == 0:
                    for f in (j, d // j):
                        if 2 <= f <= K:
                            if f % 2 == 0:
                                reachable.add(0)
                            else:
                                reachable.add(G[d // f])
                j += 1
            mex = 0
            while mex in reachable:
                mex += 1
            G[d] = mex
        
        print("Geralt" if G[N] != 0 else "Vesemir")

solve()
