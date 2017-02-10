function R = RandomXRotationAA(max_angle)
	axis = [1; 0; 0];
	axis = axis / norm(axis);
	angle = (2.0 * rand(1,1) - 1.0) * max_angle;
	R = axis * angle;
    R = [R; 0; 0; 0; 0 ; 0];
end