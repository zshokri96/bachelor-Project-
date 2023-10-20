function z = g(model,t,j)
    u = model.u(j);
    d = model.d(j);
    tp = model.tp(j);
	ep = model.ep(j);
    z = tp * max(0,(t + u) - d) + ep * max (0, d-(t+u));
end