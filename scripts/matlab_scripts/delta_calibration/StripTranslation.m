function stripped = StripTranslation(tf, u)
  r_aa = tf(1:3);
  t = tf(4:6);
  tf
  u
  t_part = dot(t, u')/norm(u) * u'
  t
  tf
  stripped = t - t_part'
  stripped = [r_aa stripped 0 0]
end