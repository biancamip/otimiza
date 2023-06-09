## problema manufatura peça mil

using JuMP
using GLPK
using Formatting

m = Model();
set_optimizer(m, GLPK.Optimizer);

fabricas = collect(1:3);
atacadistas = collect(1:5);

lucro_fabricas = [0.5, 1.5, 0.7];
capacidade_fabricas = [4500, 9000, 11250]; ## Ci
demanda_por_atacadista = [2700, 2700, 9000, 4500, 3600]; ## dj
custo_transporte_fabrica_atacadista = [ ## cij
    [0.05 0.07 0.11 0.15 0.16];
    [0.08 0.06 0.10 0.12 0.15];
    [0.10 0.09 0.09 0.10 0.16]
];

@variable(m, qtd_prod_por_fabrica[f in fabricas] >= 0);  ## xi
@variable(m, qtd_transp_fabrica_atacadista[f in fabricas, a in atacadistas] >= 0); ## yij

@objective(m, Max,
    sum(qtd_prod_por_fabrica[f] * lucro_fabricas[f] for f in fabricas)
    - sum(qtd_transp_fabrica_atacadista[f, a] * custo_transporte_fabrica_atacadista[f, a] for f in fabricas, a in atacadistas));

@constraint(m, [a in atacadistas], sum(qtd_transp_fabrica_atacadista[f, a] for f in fabricas) == demanda_por_atacadista[a]); ## restrição (2):

@constraint(m, [f in fabricas], sum(qtd_transp_fabrica_atacadista[f, a] for a in atacadistas) <= capacidade_fabricas[f]); ## restrição (3):
## nota: poderíamos usar qtd_prod_por_fabrica[f] aqui, no lugar de sum(qtd_transp_fabrica_atacadista[f, a] for a in atacadistas)?
## já que a restrição 4 garante que esses valores devem ser iguais?

@constraint(m, [f in fabricas], qtd_prod_por_fabrica[f] == sum(qtd_transp_fabrica_atacadista[f, a] for a in atacadistas)); ## restrição (4):

# println(m)
optimize!(m)
printfmt("\nLucro máximo: {:.2f}", objective_value(m))
for f in fabricas
    printfmt("\n\n----Fabrica {}", f);
    printfmt("\nQuantidade total produzida: {} unidades", value(qtd_prod_por_fabrica[f]));

    for a in atacadistas
        printfmt("\n transportado para atacadista {}: {} unidades", a, value(qtd_transp_fabrica_atacadista[f, a]));
    end
end
