function [t_err, r_err] = genTestPartialCal(N,angle,noise)
clc;
A = RandomTransform6D(3.14159, .5)';
A = [0 0 1.5 0 0 0 0 0];
%N = 10;
max_delta_angle = angle / 180 * pi;
max_delta_translation = 0.2;
noise_angular = (1.0 *noise) / 180 * pi;
noise_translation = 0.01 * noise;

A1 = [];
A1I = [];
A2 = [];
A2I = [];
A1T = [];
A2T = [];
U1t = [];
U2t = [];
uz = [0 0 1];
ux = [1 0 0];
uy = [0 1 0];
u0 = [0 0 0];
for i=1:N
  a1x = RandomXRotationAA(max_delta_angle)';
  a1y = RandomYRotationAA(max_delta_angle)';
  a1z = RandomZRotationAA(max_delta_angle)';
  
  a1x2 = RandomXRotationAA(max_delta_angle)';
  a1y2 = RandomYRotationAA(max_delta_angle)';
  a1z2 = RandomZRotationAA(max_delta_angle)';
  
  a2x = A1toA2(A', a1x');
  a2y = A1toA2(A', a1y');
  a2z = A1toA2(A', a1z');
  
  a2x2 = A1toA2(A', a1x2');
  a2y2 = A1toA2(A', a1y2');
  a2z2 = A1toA2(A', a1z2');
  
  a1x2 = StripRotation(a1x2, ux);
  a1y2 = StripRotation(a1y2, ux);
  a1z2 = StripRotation(a1z2, uz);
  a2x2 = StripRotation(a2x2, ux);
  a2y2 = StripRotation(a2y2, ux);
  a2z2 = StripRotation(a2z2, uz);
  
  A1 = [A1; a1x];
  A1 = [A1; a1y];
  A1 = [A1; a1z];
%   A1 = [A1; a1x2];
%   A1 = [A1; a1y2];
%   A1 = [A1; a1z2];
  
  A2 = [A2; a2x];
  A2 = [A2; a2y];
  A2 = [A2; a2z];
%   A2 = [A2; a1x2];
%   A2 = [A2; a1y2];
%   A2 = [A2; a1z2];
  
  U1t = [U1t ; u0];
  U1t = [U1t ; u0];
  U1t = [U1t ; u0];
%   U1t = [U1t ; ux];
%   U1t = [U1t ; ux];
%   U1t = [U1t ; uz];
  
  U2t = [U2t ; u0];
  U2t = [U2t ; u0];
  U2t = [U2t ; u0];
%   U2t = [U2t ; ux];
%   U2t = [U2t ; ux];
%   U2t = [U2t ; uz];
  %A2(end,:) = AddNoiseToTransform6D(A2(end,:)', noise_angular, noise_translation)';
end

% ===========================================
% Test Calibration Math with generated data.
C0 = [A1 A2];
Ut = [U1t U2t];
dlmwrite('generated_deltas.txt', C0, ' ');
dlmwrite('generated_uncertaintiest.txt', Ut, ' ');
size(C0);
A_cal = calibrate_data(C0)
A
q = aa2quat(A');
fprintf('\n %f degrees about [%f %f %f]\n\n',...
        180 / pi * 2.0 * acos(q(1)),...
        q(2:4) / norm(q(2:4)));
% Compute angular error
error_aa = rotm2aa(inv(aa2rotm(A(1:3)')) * aa2rotm(A_cal(1:3)'))
% [thetax, thetay, thetaz] = rotm2eulerangles(inv(aa2rotm(A(1:3)')))
% [thetaxt, thetayt, thetazt] = rotm2eulerangles(aa2rotm(A_cal(1:3)'))
r_err = norm(error_aa) / pi * 180

% Compute translation error
t_err = norm(A(4:6) - A_cal(4:6))
