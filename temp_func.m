function [x] = temp_func(T_out)

if T_out < -4
  x = 36.44-0.64*T_out;
elseif T_out >= -4 && T_out <= 4
  x = 39;
elseif T_out > 4 && T_out <= 21
  x = 43.26 - 1.06*T_out;
else
  x = 0;
end