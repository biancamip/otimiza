## companhia siderurgica jerico

using JuMP
using GLPK
using Formatting

model = Model();
set_optimizer(model, GLPK.Optimizer);

custo_kg_aco = 3;
custo_kg_sucata = 6;

@variable(model, kg_aco >= 0);
@variable(model, kg_sucata >= 0);

@objective(model, Min, custo_kg_aco * kg_aco + custo_kg_sucata * kg_sucata);
@constraint(model, (kg_aco + kg_sucata) >= 5);

limite_aco = 4;
limite_sucata = 7;
@constraint(model, kg_aco <= limite_aco);
@constraint(model, kg_sucata <= limite_sucata);

tempo_proc_aco = 3;
tempo_proc_sucata = 2;
@constraint(model, kg_sucata <= 7 * kg_aco / 8);
@constraint(model, (kg_aco * tempo_proc_aco + kg_sucata * tempo_proc_sucata) <= 18);

println(model);
optimize!(model);
printfmt("\n Custo total: {:.2f}", objective_value(model));
printfmt("\n Kg aco: {:.2f}", value(kg_aco));
printfmt("\n Kg sucata: {:.2f}", value(kg_sucata));