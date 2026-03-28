import sys

def main():
    data = sys.stdin.buffer.read().split()
    idx = 0
    N = int(data[idx]); idx += 1

    rank = [1] * (N + 1)      # ранг поддерева (актуален для корней)
    sub  = [0] * (N + 1)      # кол-во подчинённых (актуален для корней)
    depth_abs = [0] * (N + 1) # глубина от корня своего дерева
    uf = list(range(N + 1))   # union-find

    def find(v):
        while uf[v] != v:
            uf[v] = uf[uf[v]]  # сжатие пути (two-step)
            v = uf[v]
        return v

    # Изначально все узлы — корни: ранг=1, подчинённых=0, макс. номер=N
    best_rank_val  = 1;  best_rank_node  = N
    best_sub_val   = 0;  best_sub_node   = N

    out = []

    for _ in range(N - 1):
        A = int(data[idx]); idx += 1
        B = int(data[idx]); idx += 1

        R = find(B)

        # Глубина A в новом дереве фиксируется навсегда
        depth_abs[A] = depth_abs[B] + 1

        # Обновляем ранг корня R
        new_rank = depth_abs[B] + 1 + rank[A]
        if new_rank > rank[R]:
            rank[R] = new_rank

        # Обновляем подчинённых корня R
        sub[R] += sub[A] + 1

        # A больше не корень
        uf[A] = R

        # Обновляем лучших
        if rank[R] > best_rank_val or (rank[R] == best_rank_val and R > best_rank_node):
            best_rank_val = rank[R];  best_rank_node = R

        if sub[R] > best_sub_val or (sub[R] == best_sub_val and R > best_sub_node):
            best_sub_val = sub[R];  best_sub_node = R

        out.append(f"{best_rank_node} {best_rank_val} {best_sub_node} {best_sub_val}")

    sys.stdout.write('\n'.join(out) + '\n')

main()
