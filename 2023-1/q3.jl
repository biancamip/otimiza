## problema drinque ideal

using JuMP
using GLPK
using Formatting

model = Model();
set_optimizer(model, GLPK.Optimizer);

n = 5;
ingredientes = collect(1:n);
custo_ings = 100 * rand(n);
acidez_ings = rand(n);
docura_ings = rand(n);
teor_alcool_ings = rand(n);
preferidos = [2 4];

@variable(model, qtd_total);
@variable(model, qtd_ingrediente[i in ingredientes]);

@objective(model, Min, sum(qtd_ingrediente[i] * custo_ings[i] for i in ingredientes));

@constraint(model, qtd_total == 1);
@constraint(model, qtd_total == sum(qtd_ingrediente[i] for i in ingredientes));
