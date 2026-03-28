from collections import deque
from heapq import heappush, heappop

def solve():
    N, M, X = map(int, input().split())
    NM = N * M
    permits = list(map(int, input().split()))
    s = []
    for i in range(N):
        s.append(list(map(int, input().split())))
    c = []
    for i in range(N):
        c.append(list(map(int, input().split())))

    white_cells = []
    black_cells = []
    black_id = {}
    for i in range(N):
        for j in range(M):
            if (i + j) % 2 == 0:
                white_cells.append((i, j))
            else:
                black_id[(i, j)] = len(black_cells)
                black_cells.append((i, j))

    W = len(white_cells)
    B = len(black_cells)
    SRC = 0
    SNK = 1
    NODES = 2 + W + B
    graph = [[] for _ in range(NODES)]

    def add_edge(u, v, cap, cost):
        graph[u].append([v, cap, cost, len(graph[v])])
        graph[v].append([u, 0, -cost, len(graph[u]) - 1])

    estate_info = []
    wh_info = []
    bh_info = []

    for idx in range(W):
        add_edge(SRC, 2 + idx, 1, 0)

    for idx, (bi, bj) in enumerate(black_cells):
        hp = s[bi][bj] ** 2 - c[bi][bj]
        eidx = len(graph[SRC])
        add_edge(SRC, 2 + W + idx, 1, -hp)
        bh_info.append((SRC, eidx, bi, bj))

    for idx, (wi, wj) in enumerate(white_cells):
        hp = s[wi][wj] ** 2 - c[wi][wj]
        u = 2 + idx
        eidx = len(graph[u])
        add_edge(u, SNK, 1, -hp)
        wh_info.append((u, eidx, wi, wj))

    for idx in range(B):
        add_edge(2 + W + idx, SNK, 1, 0)

    dirs = [(0, 1), (0, -1), (1, 0), (-1, 0)]
    for w_idx, (wi, wj) in enumerate(white_cells):
        for di, dj in dirs:
            ni, nj = wi + di, wj + dj
            if (ni, nj) in black_id:
                b_idx = black_id[(ni, nj)]
                ep = (s[wi][wj] + s[ni][nj]) ** 2 - c[wi][wj] - c[ni][nj] - X
                u = 2 + w_idx
                eidx = len(graph[u])
                add_edge(u, 2 + W + b_idx, 1, -ep)
                estate_info.append((u, eidx, wi, wj, ni, nj))

    INF = float('inf')
    h = [INF] * NODES
    h[SRC] = 0
    in_q = [False] * NODES
    q = deque([SRC])
    in_q[SRC] = True
    while q:
        u = q.popleft()
        in_q[u] = False
        for v, cap, cost, _ in graph[u]:
            if cap > 0 and h[u] + cost < h[v]:
                h[v] = h[u] + cost
                if not in_q[v]:
                    q.append(v)
                    in_q[v] = True

    total_profit = 0
    for k in range(NM):
        dist = [INF] * NODES
        prev = [(-1, -1)] * NODES
        dist[SRC] = 0
        pq = [(0, SRC)]
        while pq:
            d, u = heappop(pq)
            if d > dist[u]:
                continue
            for idx, (v, cap, cost, _) in enumerate(graph[u]):
                if cap > 0 and h[v] < INF:
                    nd = dist[u] + cost + h[u] - h[v]
                    if nd < dist[v]:
                        dist[v] = nd
                        prev[v] = (u, idx)
                        heappush(pq, (nd, v))
        if dist[SNK] >= INF:
            break
        actual_cost = dist[SNK] + h[SNK] - h[SRC]
        gross_profit = -actual_cost
        if gross_profit <= permits[k]:
            break
        for v in range(NODES):
            if dist[v] < INF:
                h[v] += dist[v]
        v = SNK
        while v != SRC:
            u, eidx = prev[v]
            graph[u][eidx][1] -= 1
            rev = graph[u][eidx][3]
            graph[v][rev][1] += 1
            v = u
        total_profit += gross_profit - permits[k]

    result = []
    for u, eidx, wi, wj, bi, bj in estate_info:
        if graph[u][eidx][1] == 0:
            result.append("2 {} {} {} {}".format(wi+1, wj+1, bi+1, bj+1))
    for u, eidx, wi, wj in wh_info:
        if graph[u][eidx][1] == 0:
            result.append("1 {} {}".format(wi+1, wj+1))
    for u, eidx, bi, bj in bh_info:
        if graph[u][eidx][1] == 0:
            result.append("1 {} {}".format(bi+1, bj+1))

    out = ["{} {}".format(total_profit, len(result))]
    out.extend(result)
    print('\n'.join(out))

solve()
