## manufatura peça mil

using JuMP
using GLPK
using Formatting

m = Model();
set_optimizer(m, GLPK.Optimizer);

fabricas = collect(1:3);
atacadistas = collect(1:5);

lucro_por_fabrica = [0.5, 1.5, 0.7];
capacidade_por_fabrica = [4500, 9000, 11250];
demanda_por_atacadista = [2700, 2700, 9000, 4500, 3600];
custo_transporte_fabrica_atacadista = [
    [0.05 0.07 0.11 0.15 0.16];
    [0.08 0.06 0.10 0.12 0.15];
    [0.10 0.09 0.09 0.10 0.16]
];

@variable(m, qtd_prod_por_fabrica[f in fabricas]);
@variable(m, qtd_transporte_fabrica_atacadista[f in fabricas, a in atacadistas]);

@objective(m, Max, sum(qtd_prod_por_fabrica[f] * lucro_por_fabrica[f] for f in fabricas)
                    - sum(qtd_transporte_fabrica_atacadista[f, a] * custo_transporte_fabrica_atacadista[f, a] for f in fabricas, a in atacadistas));

println(m)
optimize!(m)