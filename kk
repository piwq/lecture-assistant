import sys
input = sys.stdin.readline

def main():
    N = int(input())

    rank = [1] * (N + 1)
    sub  = [0] * (N + 1)
    depth_abs = [0] * (N + 1)
    uf = list(range(N + 1))

    def find(v):
        while uf[v] != v:
            uf[v] = uf[uf[v]]
            v = uf[v]
        return v

    best_rank_val  = 1;  best_rank_node  = N
    best_sub_val   = 0;  best_sub_node   = N

    out = []

    for _ in range(N - 1):
        A, B = map(int, input().split())

        R = find(B)

        depth_abs[A] = depth_abs[B] + 1

        new_rank = depth_abs[B] + 1 + rank[A]
        if new_rank > rank[R]:
            rank[R] = new_rank

        sub[R] += sub[A] + 1

        uf[A] = R

        if rank[R] > best_rank_val or (rank[R] == best_rank_val and R > best_rank_node):
            best_rank_val = rank[R];  best_rank_node = R

        if sub[R] > best_sub_val or (sub[R] == best_sub_val and R > best_sub_node):
            best_sub_val = sub[R];  best_sub_node = R

        out.append(f"{best_rank_node} {best_rank_val} {best_sub_node} {best_sub_val}")

    print('\n'.join(out))

main()
