function theta = rotate_p(mp,rp)

xy_vec = rp(1,[1,2]) - mp;

x1 = xy_vec(1,1);
y1 = xy_vec(1,2);
theta = atan(x1/y1);
theta = rad2deg(theta);
end