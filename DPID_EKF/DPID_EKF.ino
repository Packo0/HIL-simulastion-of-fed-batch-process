//sample time
float ts = 0.0056;
float q = 0;


//Kalman filter
float gama_x_past = 1.25;
float gama_s_past = 0.81;
float volume_past = 1.35;
float P[3][3] = {{0.02, 0, 0}, {0, 0.02, 0}, {0, 0, 0}};
float p_predicted[3][3] =  {{0, 0, 0}, {0, 0, 0}, {0, 0, 0}};
float result_matrix[3][3] =  {{0, 0, 0}, {0, 0, 0}, {0, 0, 0}};

//plant
float mu_max = 0.55;
float ks = 0.012;
float y_sx = 0.5;
float gama_in = 100.0;


float set_point = 0.1;
float gama_s_measured;
float v = 0.0;
float q_old = 0;
float pv_old = 0;

//pid
float ui_old = 0;
float ud_old = 0;

union SerialFloat {
  char arr[4];
  float number;
};

union SerialFloat data;

void setup() {
  // open a serial connection
  Serial.begin(9600);
}

void loop() {
  //on every byte read the byte and put it in arr
  for (int i = 0; i <= 3; i++) {
    if (Serial.available() > 0) {
      data.arr[i] = Serial.read();
    }
  }

  // take data from union as float
  gama_s_measured = data.number;

  if (isnan(gama_s_measured)) {
    gama_s_measured = 0.0;
  }

  extended_kalman_filter(q_old, gama_s_measured);

  float uff = feed_forward_component (gama_x_past, gama_s_past, volume_past);
  float ufb = pid_component (set_point, gama_s_past);

  v = uff + ufb;

  q = saturation(v);

  //  if (isnan(q)) {
  //    q = q_old;
  //  }



  Serial.write((unsigned char*)(&q), 4);
  q_old = q;

  delay(100);
}

void extended_kalman_filter (float q, float gama_s_measured) {
  float f11, f12, f13, f21, f22, f23, f31, f32, f33;
  float F[3][3], Ft[3][3], temp_k_ekf[3][3] = {{0, 0, 0}, {0, 0, 0}, {0, 0, 0}};
  float d_ceta = 0.001 * ts * ts; //3.1360E-008;
  float d_eta = 0.0025;
  float mu;
  float gama_x_pred, gama_s_pred;
  float f_predicted1, f_predicted2, f_predicted3;
  float k_ekf1, k_ekf2, k_ekf3;
  float x_hat1, x_hat2, x_hat3;

  f11 = (mu_max * gama_s_past) / (ks + gama_s_past) - q / volume_past;
  f12 = (mu_max * gama_x_past * ks) / ((ks + gama_s_past) * (ks + gama_s_past));
  f13 = (q * gama_x_past) / (volume_past * volume_past);

  f21 = -(mu_max * gama_s_past) / (y_sx * (ks + gama_s_past));
  f22 = -(mu_max * gama_x_past * ks) / (y_sx * (ks + gama_s_past) * (ks + gama_s_past)) - q / volume_past;
  f23 = -(q * (gama_in - gama_s_past)) / (volume_past * volume_past);

  f31 = 0; f32 = 0; f33 = 0;

  F[0][0] = 1 + ts * f11;
  F[0][1] = ts * f12;
  F[0][2] = ts * f13;
  F[1][0] = ts * f21;
  F[1][1] = 1 + ts * f22;
  F[1][2] = ts * f23;
  F[2][0] = ts * f31;
  F[2][1] = ts * f32;
  F[2][2] = 1 + ts * f33;
  //F'
  Ft[0][0] = 1 + ts * f11;
  Ft[0][1] = ts * f21;
  Ft[0][2] = ts * f31;
  Ft[1][0] = ts * f12;
  Ft[1][1] = 1 + ts * f22;
  Ft[1][2] = ts * f32;
  Ft[2][0] = ts * f13;
  Ft[2][1] = ts * f23;
  Ft[2][2] = 1 + ts * f33;

  //using temp global matrix called result_matrix to multiply and then reset temp matrix values
  matrix_multiply(F, P);
  matrix_multiply(result_matrix, Ft);

  for (int i = 0; i < 3; i++) {
    for (int j = 0; j < 3; j++) {
      p_predicted[i][j] = result_matrix[i][j];
    }
  }

  p_predicted[0][0] = p_predicted[0][0] + d_ceta;
  p_predicted[1][1] = p_predicted[1][1] + d_ceta;
  p_predicted[2][2] = p_predicted[2][2] + d_ceta;

  //-predicted state
  mu = (mu_max * gama_s_past) / (ks + gama_s_past);
  gama_x_pred = mu * gama_x_past - (q / volume_past) * gama_x_past;
  gama_s_pred = -(1 / y_sx) * mu * gama_x_past + (q / volume_past) * (gama_in - gama_s_past);

  f_predicted1 = gama_x_past + ts * gama_x_pred;
  f_predicted2 = gama_s_past + ts * gama_s_pred;
  f_predicted3 = volume_past + ts * q;

  //2. Compute Kalman Gain
  k_ekf1 = p_predicted[0][1] * 1 / (p_predicted[1][1] + d_eta);
  k_ekf2 = p_predicted[1][1] * 1 / (p_predicted[1][1] + d_eta);
  k_ekf3 = p_predicted[2][1] * 1 / (p_predicted[1][1] + d_eta);

  //3.Compute Estimate
  x_hat1 = f_predicted1 + k_ekf1 * (gama_s_measured - f_predicted2);
  x_hat2 = f_predicted2 + k_ekf2 * (gama_s_measured - f_predicted2);
  x_hat3 = f_predicted3 + k_ekf3 * (gama_s_measured - f_predicted2);

  //4.Compute error covariance
  temp_k_ekf[0][0] = 1;
  temp_k_ekf[0][1] = -k_ekf1;
  temp_k_ekf[1][1] = 1 - k_ekf2;
  temp_k_ekf[2][1] = -k_ekf3;
  temp_k_ekf[2][2] = 1;

  matrix_multiply(temp_k_ekf, p_predicted);

  for (int i = 0; i < 3; i++) {
    for (int j = 0; j < 3; j++) {
      P[i][j] = result_matrix[i][j];
    }
  }

  //output
  gama_x_past = x_hat1;
  gama_s_past = x_hat2;
  volume_past = x_hat3;
}

float feed_forward_component (float gama_x, float gama_s, float volume) {
  float result = 0, mu;

  mu = (mu_max * gama_s) / (ks + gama_s);

  result = (volume * mu * gama_x) / (y_sx * (gama_in - gama_s));

  return result;
}

float pid_component (float set_point, float pv) {
  // pid regulator koefficients
  float bi1 = 0.0655;
  float ad = 0.9948;
  float bd = 0.3125;
  float c = 0.7181;
  float b = 0.2352;

//genetic algorithm optimization
  float kp = 0.6502;
  float ti = 0.0556;
  float pd = 0.5184;
//optimization by fminserach
//  float kp = 1.0703;
//  float ti = 0.0242;
//  float pd = 0.4397;

  float up, ui, ud;

  //pid term
  float ufb = 0;

  float error = set_point - pv;

  //p term
  up = kp * (b * set_point - pv);

  //I term
  if (v >= 0) {
    ui = ui_old + bi1 * error;
  } else {
    ui = 0.0;
  }

  //d term
  ud = ad * ud_old + bd * (c * (set_point - set_point) - (pv - pv_old)); //D Term

  ui_old = ui;
  ud_old = ud;
  pv_old = pv;
  ufb = up + ui + ud;
  return ufb;
}

float saturation (float control) {
  float result = 0;
  if (control < 0) {
    result = 0;
  } else if (control > 1) {
    result = 1;
  } else {
    result = control;
  }
  return result;
}

void matrix_multiply (float left[3][3], float right[3][3]) {
  for (int row = 0; row < 3; row++) {
    for (int col = 0; col < 3; col++) {
      result_matrix[col][row] = 0;
      for (int i = 0; i < 3; i++) {
        result_matrix[col][row] += left[i][row] * right[col][i];
      }
    }
  }
}






