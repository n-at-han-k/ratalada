{
  actionpack = {
    dependencies = ["actionview" "activesupport" "nokogiri" "rack" "rack-session" "rack-test" "rails-dom-testing" "rails-html-sanitizer" "useragent"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1l13fy0y55h5c5ccm7c94mwfhf6bk5xj83qv1d3izs288lavfk4p";
      type = "gem";
    };
    version = "8.1.3.1";
  };
  actionview = {
    dependencies = ["activesupport" "builder" "erubi" "rails-dom-testing" "rails-html-sanitizer"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1dng2b5bbjm4c1bcpak7q9w4zh71mz2nkknipszl6yy42j28p9id";
      type = "gem";
    };
    version = "8.1.3.1";
  };
  activemodel = {
    dependencies = ["activesupport"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "124gi0hlvkabkl5fzfn90ylj7gbyg22rv5208k8p3hxf5z705k4r";
      type = "gem";
    };
    version = "8.1.3.1";
  };
  activerecord = {
    dependencies = ["activemodel" "activesupport" "timeout"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0fs0q1c35k2bh079kj1xbx9pvqx7q2z4k9d32fqgcf29iz1bcbqa";
      type = "gem";
    };
    version = "8.1.3.1";
  };
  activesupport = {
    dependencies = ["base64" "bigdecimal" "concurrent-ruby" "connection_pool" "drb" "i18n" "json" "logger" "minitest" "securerandom" "tzinfo" "uri"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0xhkhdx8svhaf439y398yixik0snzarnnsy43688p92yy9jqfic5";
      type = "gem";
    };
    version = "8.1.3.1";
  };
  aes_key_wrap = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "19bn0y70qm6mfj4y1m0j3s8ggh6dvxwrwrj5vfamhdrpddsz8ddr";
      type = "gem";
    };
    version = "1.1.0";
  };
  async = {
    dependencies = ["console" "fiber-annotation" "io-event"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0ry2sxfmhgizfd41zmsy0z82hwiwmf6hgwv9dha3b9gc69s9z14m";
      type = "gem";
    };
    version = "2.45.1";
  };
  async-container = {
    dependencies = ["async"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "127wzwpm288qbraqpqv4ba1rr438hdxksiigc176h3c7a62rsivi";
      type = "gem";
    };
    version = "0.38.0";
  };
  async-http = {
    dependencies = ["async" "async-pool" "io-endpoint" "io-stream" "protocol-http" "protocol-http1" "protocol-http2" "protocol-url"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0hdwx3n4i7lg1djml0lhnrbrrrrj0brh9krkzbap4zcz85fkszhk";
      type = "gem";
    };
    version = "0.103.0";
  };
  async-http-cache = {
    dependencies = ["async-http"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1mnzzlq0bnya0hlzrz0bl66r7qw5a3173cjd1fsicbqqjgqd2f10";
      type = "gem";
    };
    version = "0.4.6";
  };
  async-pool = {
    dependencies = ["async"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "01l5yna12l7qcmwmr0mvkkj241qh0w9vzl1fmd6p1g94q0ylk02m";
      type = "gem";
    };
    version = "0.12.0";
  };
  async-service = {
    dependencies = ["async" "async-container" "string-format"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1ldnryz9f30ay63zlsfsc5dkwianf7ayq30m95jxzpcq51fdgnbi";
      type = "gem";
    };
    version = "0.25.0";
  };
  async-utilization = {
    dependencies = ["console"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "10arz5049914z7il2qqqi16wcn7039d8rkvhgz5wpv899rilghwn";
      type = "gem";
    };
    version = "0.5.0";
  };
  attr_required = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "16fbwr6nmsn97n0a6k1nwbpyz08zpinhd6g7196lz1syndbgrszh";
      type = "gem";
    };
    version = "1.0.2";
  };
  bake = {
    dependencies = ["bigdecimal" "samovar"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0scqyjxfk1jk1f8ssn19miqmskdv4zz3dg6y4y409p5d4rmdqyx4";
      type = "gem";
    };
    version = "0.25.0";
  };
  base64 = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0yx9yn47a8lkfcjmigk79fykxvr80r4m1i35q82sxzynpbm7lcr7";
      type = "gem";
    };
    version = "0.3.0";
  };
  bcrypt = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0clhya4p8lhjj7hp31inp321wgzb0b5wbwppmya5sw1dikl7400z";
      type = "gem";
    };
    version = "3.1.22";
  };
  bigdecimal = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1g9zi8c4i7g8zz0c3hxrw6mblrjvgn7akys60clb9si7c1k1gljk";
      type = "gem";
    };
    version = "4.1.2";
  };
  bindata = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0ycapmsvww0nbf50j0kag59np7xsg4n181rj3bm2d0wm5w4q9p3y";
      type = "gem";
    };
    version = "3.0.0";
  };
  builder = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0pw3r2lyagsxkm71bf44v5b74f7l9r7di22brbyji9fwz791hya9";
      type = "gem";
    };
    version = "3.3.0";
  };
  concurrent-ruby = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1qfi2ns3zwkgq616fc127xiqhan7g7m7gqpwriwcr34nds1vxwdj";
      type = "gem";
    };
    version = "1.3.8";
  };
  connection_pool = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "02ifws3c4x7b54fv17sm4cca18d2pfw1saxpdji2lbd1f6xgbzrk";
      type = "gem";
    };
    version = "3.0.2";
  };
  console = {
    dependencies = ["fiber-annotation" "fiber-local" "json"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1mzgyg46jxdyijmg6dkxjv3yqmaixr7mk66094w0cnjrqa3b54w0";
      type = "gem";
    };
    version = "1.37.0";
  };
  crass = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "15djj19ynz3sbw54fsf8n7y3sha8a333f2mgvjfwhr46jhcqg1ll";
      type = "gem";
    };
    version = "1.0.7";
  };
  date = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1h0db8r2v5llxdbzkzyllkfniqw9gm092qn7cbaib73v9lw0c3bm";
      type = "gem";
    };
    version = "3.5.1";
  };
  doorkeeper = {
    dependencies = ["railties"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "158dy953r9r2s6zppnc3yn02r3g3g56yzxyvilnpcl4p170x5c0r";
      type = "gem";
    };
    version = "5.9.6";
  };
  doorkeeper-openid_connect = {
    dependencies = ["doorkeeper" "jwt" "ostruct"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "00pv5v0zk2wxg2bh3zwwirmljqbyfypnk6ff2qmyzprg7rbyb0hk";
      type = "gem";
    };
    version = "1.10.5";
  };
  drb = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0wrkl7yiix268s2md1h6wh91311w95ikd8fy8m5gx589npyxc00b";
      type = "gem";
    };
    version = "2.2.3";
  };
  erb = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "14pfj6zn0p1hxj6s6s0r7d424wap8zl9zxf89nj79y8fbg16vjn5";
      type = "gem";
    };
    version = "6.0.7";
  };
  erubi = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1naaxsqkv5b3vklab5sbb9sdpszrjzlfsbqpy7ncbnw510xi10m0";
      type = "gem";
    };
    version = "1.13.1";
  };
  falcon = {
    dependencies = ["async" "async-container" "async-http" "async-http-cache" "async-service" "async-utilization" "localhost" "openssl" "protocol-http" "protocol-rack" "samovar"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1xzhpbbjjjqd6q7z7x8j5w5qxx6q6zhaly306y00mfd34fy61c69";
      type = "gem";
    };
    version = "0.57.0";
  };
  faraday = {
    dependencies = ["faraday-net_http" "json" "logger"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0y7j6yzv07zggic6g0p2v1ivnvkzsbqjnfdl4215qqb6cxz290hq";
      type = "gem";
    };
    version = "2.14.3";
  };
  faraday-follow_redirects = {
    dependencies = ["faraday"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1b8hgpci3wjm3rm41bzpasvsc5j253ljyg5rsajl62dkjk497pjw";
      type = "gem";
    };
    version = "0.5.0";
  };
  faraday-net_http = {
    dependencies = ["net-http"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "125m3qri52vwh5v9dhq0dkqxf8629cxrf99yyc01pva72wasyy0f";
      type = "gem";
    };
    version = "3.4.4";
  };
  fiber-annotation = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "00vcmynyvhny8n4p799rrhcx0m033hivy0s1gn30ix8rs7qsvgvs";
      type = "gem";
    };
    version = "0.2.0";
  };
  fiber-local = {
    dependencies = ["fiber-storage"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "01lz929qf3xa90vra1ai1kh059kf2c8xarfy6xbv1f8g457zk1f8";
      type = "gem";
    };
    version = "1.1.0";
  };
  fiber-storage = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1qa0j9qjwav9xb0n3isx0rbh0942xrfback392n6vs8bidnmp3pl";
      type = "gem";
    };
    version = "1.0.1";
  };
  hashie = {
    dependencies = ["logger"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0w1qrab701d3a63aj2qavwc2fpcqmkzzh1w2x93c88zkjqc4frn2";
      type = "gem";
    };
    version = "5.1.0";
  };
  i18n = {
    dependencies = ["concurrent-ruby"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1dfikmmd9dllirsfq0kjiyxpmlq0afkxm5sslsr97r9g85ifpy80";
      type = "gem";
    };
    version = "1.15.2";
  };
  io-console = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "026v93kja19bfslnwi9xfq2dj4r89kkwdprim4whjg6h3n4lz9zg";
      type = "gem";
    };
    version = "0.9.2";
  };
  io-endpoint = {
    dependencies = ["openssl"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1ajia4kwnma5i41mp2w4xvzwbhrc6fmivjdzj2j8nkjqrmmih3bj";
      type = "gem";
    };
    version = "0.18.0";
  };
  io-event = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1rlrxfc91d1pngp52xa8c8lfk407mrgqmx62kyzgkvb7mn4qy25k";
      type = "gem";
    };
    version = "1.21.1";
  };
  io-stream = {
    dependencies = ["openssl"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1kgim30xjghz4z6047nkc5sy8casmmlqvzqzfsycnv06l8zb3n87";
      type = "gem";
    };
    version = "0.14.0";
  };
  irb = {
    dependencies = ["pp" "prism" "rdoc" "reline"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1qs8a9vprg7s8krgq4s0pygr91hclqqyz98ik15p0m1sf2h5956y";
      type = "gem";
    };
    version = "1.18.0";
  };
  json = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0shwgjqbj856mb6m9kgkpy08nhym2gdvc2yaprlimfmky9y3n78z";
      type = "gem";
    };
    version = "2.21.2";
  };
  json-jwt = {
    dependencies = ["activesupport" "aes_key_wrap" "base64" "bindata" "faraday" "faraday-follow_redirects"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1jgivknk82sbcsqxpr96c9iqmp2wkhqpf38w9bby3s927qf7rqwp";
      type = "gem";
    };
    version = "1.17.2";
  };
  jwt = {
    dependencies = ["base64"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1mqps8z4ly74hpksfajcfamqk1wb79biy187pn10knmi6zzb26al";
      type = "gem";
    };
    version = "3.2.0";
  };
  localhost = {
    dependencies = ["bake"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0097kdsp2fwkps57f8ypc12dqzf4dg4glzn1i32ljjgnnhjshznz";
      type = "gem";
    };
    version = "1.8.0";
  };
  logger = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "00q2zznygpbls8asz5knjvvj2brr3ghmqxgr83xnrdj4rk3xwvhr";
      type = "gem";
    };
    version = "1.7.0";
  };
  loofah = {
    dependencies = ["crass" "nokogiri"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "062r891hxis58j5q735kk9sj5srxx0rv813f8m95bilsjm3gf1r0";
      type = "gem";
    };
    version = "2.25.2";
  };
  mail = {
    dependencies = ["logger" "mini_mime" "net-imap" "net-pop" "net-smtp"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1s30l5z7jkazgi4m6l6mh80rgsyhh2pp1pa5h70xclsj8z54wmq6";
      type = "gem";
    };
    version = "2.9.1";
  };
  mini_mime = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1vycif7pjzkr29mfk4dlqv3disc5dn0va04lkwajlpr1wkibg0c6";
      type = "gem";
    };
    version = "1.1.5";
  };
  mini_portile2 = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "12f2830x7pq3kj0v8nz0zjvaw02sv01bqs1zwdrc04704kwcgmqc";
      type = "gem";
    };
    version = "2.8.9";
  };
  minitest = {
    dependencies = ["drb" "prism"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1wfnqyfayx9n9j7x871v2ars4hjhfisi1dl24fa64ylq3mns6ghm";
      type = "gem";
    };
    version = "6.0.6";
  };
  net-http = {
    dependencies = ["uri"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "15k96fj6qwbaiv6g52l538ass95ds1qwgynqdridz29yqrkhpfi5";
      type = "gem";
    };
    version = "0.9.1";
  };
  net-imap = {
    dependencies = ["date" "net-protocol"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1px886qvws5zvqphy5cysj8vg01lym0w7vs9wq1h41pk1pjlxaln";
      type = "gem";
    };
    version = "0.6.6";
  };
  net-pop = {
    dependencies = ["net-protocol"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1wyz41jd4zpjn0v1xsf9j778qx1vfrl24yc20cpmph8k42c4x2w4";
      type = "gem";
    };
    version = "0.1.2";
  };
  net-protocol = {
    dependencies = ["timeout"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0wklahcafcib6jwrr3angj7zzcb9csq3c0xj3axldb8w9wyhqcds";
      type = "gem";
    };
    version = "0.3.0";
  };
  net-smtp = {
    dependencies = ["net-protocol"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0dh7nzjp0fiaqq1jz90nv4nxhc2w359d7c199gmzq965cfps15pd";
      type = "gem";
    };
    version = "0.5.1";
  };
  nokogiri = {
    dependencies = ["mini_portile2" "racc"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1d9safb4dly6qmc2g06444l0zifby52yy6j1a5fa1g4j3ihm3jah";
      type = "gem";
    };
    version = "1.19.4";
  };
  omniauth = {
    dependencies = ["hashie" "logger" "rack" "rack-protection"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0g3n12k5npmmgai2cs3snimy6r7h0bvalhjxv0fjxlphjq25p822";
      type = "gem";
    };
    version = "2.1.4";
  };
  omniauth_openid_connect = {
    dependencies = ["omniauth" "openid_connect"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "099xg7s6450wlfzs77mbdx78g3dp0glx5q6f44i78akf7283hbqz";
      type = "gem";
    };
    version = "0.8.0";
  };
  openid_connect = {
    dependencies = ["activemodel" "attr_required" "faraday" "faraday-follow_redirects" "json-jwt" "mail" "rack-oauth2" "swd" "tzinfo" "validate_url" "webfinger"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1i1rksidmf0aj0z6y89mhyp3fadf4xgpx0znwfc7g470vj7gz6k5";
      type = "gem";
    };
    version = "2.5.0";
  };
  openssl = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1hj7wwp4r3jhvnyd8ik85wbs25cq1w61r28pv6ddyn5fd0lasdqh";
      type = "gem";
    };
    version = "4.0.2";
  };
  ostruct = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "04nrir9wdpc4izqwqbysxyly8y7hsfr4fsv69rw91lfi9d5fv8lm";
      type = "gem";
    };
    version = "0.6.3";
  };
  pp = {
    dependencies = ["prettyprint"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0w5mha75hs8gdj75g8vl0sxpyp8rzvwq8a4jcmi4ah8cf370zjyz";
      type = "gem";
    };
    version = "0.6.4";
  };
  prettyprint = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "14zicq3plqi217w6xahv7b8f7aj5kpxv1j1w98344ix9h5ay3j9b";
      type = "gem";
    };
    version = "0.2.0";
  };
  prism = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "11ggfikcs1lv17nhmhqyyp6z8nq5pkfcj6a904047hljkxm0qlvv";
      type = "gem";
    };
    version = "1.9.0";
  };
  protocol-hpack = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "14ddqg5mcs9ysd1hdzkm5pwil0660vrxcxsn576s3387p0wa5v3g";
      type = "gem";
    };
    version = "1.5.1";
  };
  protocol-http = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1fnr9gql98zfqglxp5zn6r765msbrczv88byxvvw7w0bvzrpnmrq";
      type = "gem";
    };
    version = "0.71.0";
  };
  protocol-http1 = {
    dependencies = ["protocol-http"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "18qfic0k6w4bqw3n0w2hxprwi0562dns2ziydj4qm5182958fqwq";
      type = "gem";
    };
    version = "0.41.0";
  };
  protocol-http2 = {
    dependencies = ["protocol-hpack" "protocol-http"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "148nihcg3brk4iws06ir99jwq90hqa7zvsbh8r4c43m8rxfikimp";
      type = "gem";
    };
    version = "0.28.0";
  };
  protocol-rack = {
    dependencies = ["io-stream" "protocol-http" "rack"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1hwz5bb3wcx4lkprigsgfa4vqlx33jcxc01pc2d89ybyj92x518i";
      type = "gem";
    };
    version = "0.22.1";
  };
  protocol-url = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1mhf2nbc79ikirr9c9m3c9cspr30n8rr6w2bw0c6vd4l62c5avxi";
      type = "gem";
    };
    version = "0.18.0";
  };
  public_suffix = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "08znfv30pxmdkjyihvbjqbvv874dj3nybmmyscl958dy3f7v12qs";
      type = "gem";
    };
    version = "7.0.5";
  };
  racc = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0byn0c9nkahsl93y9ln5bysq4j31q8xkf2ws42swighxd4lnjzsa";
      type = "gem";
    };
    version = "1.8.1";
  };
  rack = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1dwgab330lsv4qppw3f52mc4ihr8lagxgll53mkmcdgr4hf3xqck";
      type = "gem";
    };
    version = "3.2.7";
  };
  rack-oauth2 = {
    dependencies = ["activesupport" "attr_required" "faraday" "faraday-follow_redirects" "json-jwt" "rack"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0cn6a9v8nry9fx4zrzp1xakfp2n5xv5075j90q56m20k7zvjrq23";
      type = "gem";
    };
    version = "2.3.0";
  };
  rack-protection = {
    dependencies = ["base64" "logger" "rack"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1b4bamcbpk29i7jvly3i7ayfj69yc1g03gm4s7jgamccvx12hvng";
      type = "gem";
    };
    version = "4.2.1";
  };
  rack-session = {
    dependencies = ["base64" "rack"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1s7zcxlmg88a6dam4aqbgk9xkpy6dkdfqmmcszkkliy3q3w38m2r";
      type = "gem";
    };
    version = "2.1.2";
  };
  rack-test = {
    dependencies = ["rack"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0qy4ylhcfdn65a5mz2hly7g9vl0g13p5a0rmm6sc0sih5ilkcnh0";
      type = "gem";
    };
    version = "2.2.0";
  };
  rackup = {
    dependencies = ["rack"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0s48d2a0z5f0cg4npvzznf933vipi6j7gmk16yc913kpadkw4ybc";
      type = "gem";
    };
    version = "2.3.1";
  };
  rails-dom-testing = {
    dependencies = ["activesupport" "minitest" "nokogiri"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "07awj8bp7jib54d0khqw391ryw8nphvqgw4bb12cl4drlx9pkk4a";
      type = "gem";
    };
    version = "2.3.0";
  };
  rails-html-sanitizer = {
    dependencies = ["loofah" "nokogiri"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1hi25xz5ijz3kjx4vsiywqbq05mlkas7di8pwc3p6mhyn34sg5z7";
      type = "gem";
    };
    version = "1.7.1";
  };
  railties = {
    dependencies = ["actionpack" "activesupport" "irb" "rackup" "rake" "thor" "tsort" "zeitwerk"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "11s4n3zqd7bry5ndraq02f641hskhmnfcza8lkzcw04sawra5213";
      type = "gem";
    };
    version = "8.1.3.1";
  };
  rake = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "009p524zl0p0kfa65nii8wdmaigkmawv9pbvlcffky7islmmp0nb";
      type = "gem";
    };
    version = "13.4.2";
  };
  ratalada = {
    dependencies = ["rack"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1p8al24h9jvm5fg904f2qac0mnkv82yw5qnkdjxcvg27vrrr3p8j";
      type = "gem";
    };
    version = "2.1.0";
  };
  rbs = {
    dependencies = ["logger" "prism" "tsort"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0x067q8cdam4kv5dc09iq2nzca8qm2kdl0dr22gc0ny0vj3bixsi";
      type = "gem";
    };
    version = "4.2.0";
  };
  rdoc = {
    dependencies = ["erb" "prism" "rbs" "tsort"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0sf4909q2mr9z0rpygv94z12b0yamg07gz8cba2mi5k3m448rgq3";
      type = "gem";
    };
    version = "8.0.0";
  };
  reline = {
    dependencies = ["io-console"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0gaq2lc463ap1srz7y5kh2p4dxazs7vjrpiby58d9yfvan72s0av";
      type = "gem";
    };
    version = "0.7.0";
  };
  samovar = {
    dependencies = ["console"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "15133m5jihv7pv00dcrg51yvrkw5qiw1dd0y6bq89046p0gc97wa";
      type = "gem";
    };
    version = "2.5.1";
  };
  securerandom = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1cd0iriqfsf1z91qg271sm88xjnfd92b832z49p1nd542ka96lfc";
      type = "gem";
    };
    version = "0.4.1";
  };
  sqlite3 = {
    dependencies = ["mini_portile2"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "13nh4kd96d28dv3habjv2fiap30ccb73lz8mqx5d0834jl3fcvwm";
      type = "gem";
    };
    version = "2.9.6";
  };
  string-format = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1xlsg0m748bcb4vgvmjxlfsif6nnl8pz6ja52c91y1kb24a1r65w";
      type = "gem";
    };
    version = "0.2.0";
  };
  swd = {
    dependencies = ["activesupport" "attr_required" "faraday" "faraday-follow_redirects"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0m86fzmwgw0vc8p6fwvnsdbldpgbqdz9cbp2zj9z06bc4jjf5nsc";
      type = "gem";
    };
    version = "2.0.3";
  };
  thor = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0wsy88vg2mazl039392hqrcwvs5nb9kq8jhhrrclir2px1gybag3";
      type = "gem";
    };
    version = "1.5.0";
  };
  timeout = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1jxcji88mh6xsqz0mfzwnxczpg7cyniph7wpavnavfz7lxl77xbq";
      type = "gem";
    };
    version = "0.6.1";
  };
  tsort = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "17q8h020dw73wjmql50lqw5ddsngg67jfw8ncjv476l5ys9sfl4n";
      type = "gem";
    };
    version = "0.2.0";
  };
  tzinfo = {
    dependencies = ["concurrent-ruby"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "16w2g84dzaf3z13gxyzlzbf748kylk5bdgg3n1ipvkvvqy685bwd";
      type = "gem";
    };
    version = "2.0.6";
  };
  uri = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1ijpbj7mdrq7rhpq2kb51yykhrs2s54wfs6sm9z3icgz4y6sb7rp";
      type = "gem";
    };
    version = "1.1.1";
  };
  useragent = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0i1q2xdjam4d7gwwc35lfnz0wyyzvnca0zslcfxm9fabml9n83kh";
      type = "gem";
    };
    version = "0.16.11";
  };
  validate_url = {
    dependencies = ["activemodel" "public_suffix"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0lblym140w5n88ijyfgcvkxvpfj8m6z00rxxf2ckmmhk0x61dzkj";
      type = "gem";
    };
    version = "1.0.15";
  };
  webfinger = {
    dependencies = ["activesupport" "faraday" "faraday-follow_redirects"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0p39802sfnm62r4x5hai8vn6d1wqbxsxnmbynsk8rcvzwyym4yjn";
      type = "gem";
    };
    version = "2.1.3";
  };
  zeitwerk = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1rcjpgyzmdxp8rdw466156fmr588k9q1wg8j42g0dkk7hid1519c";
      type = "gem";
    };
    version = "2.8.3";
  };
}
