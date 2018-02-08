function sem = stderror(x,dim)

sem= std(x,[],dim) / sqrt(size(x,dim));
end
