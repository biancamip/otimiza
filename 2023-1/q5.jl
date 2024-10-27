## problema polícia cidade limpa

using JuMP
using GLPK
using Formatting

model = Model();
set_optimizer(model, GLPK.Optimizer);

periodos = collect(1:6);
@variable(model, x[p in periodos] >= 0); # x[p] = quantidade de policiais que começam a trabalhar no periodo p

minimo_por_periodo = [22, 55, 88, 110, 44, 33];
@objective(model, Min, sum(x[p] for p in periodos));
@constraint(model, [p in periodos], (x[p] + x[p === 1 ? 6 : (p-1)]) >= minimo_por_periodo[p])

println(model)
optimize!(model)
printfmt("\nTotal de policiais: {:.2f}", objective_value(model))
label_periodos = ["2-6", "6-10", "10-14", "14-18", "18-22", "22-2"];
for p in periodos
    printfmt("\nPeriodo {} ({}): {} policiais trabalhando", p, label_periodos[p], value(x[p] + x[p === 1 ? 6 : (p-1)]));
end
