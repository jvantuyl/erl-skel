{application,
  skel,
  [
    {description, "Skeleton App"},
    {vsn, "0.1"},
    {modules,[skel_app,skel_sup]},
    {registered, [skel_sup]},
    {applications, [kernel, stdlib, sasl]},
    {mod, {skel_app,[]}},
    {env, []}
 ]
}.
