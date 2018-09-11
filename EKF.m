function xhatOut = EKF(pinput)
%������������ �� ��������� ������� ���� ��������, ����� �� ��������
%��� ����������� � ��������� �� ������ start ���� callback �������
%initialize.m
%global P xhat
%xhat = [1.25; 0.81; 1.35];
%     P = diag([0.02 0.02 0]);
H = [0 1 0];
global xhat
global P
%������������� �� ������������ ���� ��������
global Ks Ysx GAMAin MUmax T0 
%������ ��������� �� ��������� �� ��������� ����� � ������������
gamaSmeasured = pinput(1);
Q = pinput(2);
%
gamaX = xhat(1);
gamaS = xhat(2);
Volume = xhat(3);
%����������� �� ����������
   a11 = ( MUmax * gamaS ) / (Ks + gamaS) - Q / Volume;
   a12 = ( MUmax * gamaX  * ( Ks + gamaS) ) / ((Ks + gamaS)^2);
   a13 = ( Q * gamaX ) / Volume;
   a21 = - (MUmax * gamaS) / ( Ysx * ( Ks + gamaS ) );
   a22 = - (MUmax * gamaX * Ks) /((Ks + gamaS)^2) - Q / Volume;
   a23 = (Q * (GAMAin - gamaS)) / (Volume^2);
   a31 = 0;
   a32 = 0;
   a33 = 0;
   F=[a11 a12 a13;
      a21 a22 a23;
      a31 a32 a33;
      ];

% ���������� �� ��������� F
F = eye(3) + T0*F;
%����������� ������� �� ��������
Deta = T0^2*diag([0.001 0.001 0]);
%��������� �� ������������� ���
Dceta = 0.0025;

% 1. ������������ �� ������� �� ����������� � ��������������� �������

Ppredicted = F*P*F' + Deta;

Mu = (MUmax*gamaS)/(Ks+gamaS);
X = Mu*gamaX-Q/Volume*gamaX;
S = -1/Ysx*Mu*gamaX+Q/Volume*(GAMAin-gamaS);
Fpredicted =xhat+0.0056*[X S Q]';

% 2. ����������� �� ����������� �� ������
Kekf = Ppredicted*H'*inv(H*Ppredicted*H'+Dceta);

% 3. ����������� �� ������� �� �����������
xhat = Fpredicted+Kekf*(gamaSmeasured-H*Fpredicted);

% 4. ���������� �� ��������������� �������
P = (eye(3) - Kekf*H)*Ppredicted;
%��������� �� ��������
xhatOut = xhat;
