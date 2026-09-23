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
  ast = {
    groups = ["default" "development"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "10yknjyn0728gjn6b5syynvrvrwm66bhssbxq8mkhshxghaiailm";
      type = "gem";
    };
    version = "2.4.3";
  };
  async = {
    dependencies = ["console" "fiber-annotation" "io-event"];
    groups = ["default" "development"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1cprvia1j7ggdp6cdl81p2biv6glkadzs461iv2prclz046wx6q7";
      type = "gem";
    };
    version = "2.44.1";
  };
  async-container = {
    dependencies = ["async"];
    groups = ["default" "development"];
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
    groups = ["default" "development"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1d6mxr6122jkcvfbmqhaddk1hllmpma0d5bz27b35zf0yd5s4p23";
      type = "gem";
    };
    version = "0.101.0";
  };
  async-http-cache = {
    dependencies = ["async-http"];
    groups = ["default" "development"];
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
    groups = ["default" "development"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1vg3lwb3yhq0rad3dm00vp35vrahkbxgl4kx3d2rqkdh09xs2hqa";
      type = "gem";
    };
    version = "0.11.2";
  };
  async-service = {
    dependencies = ["async" "async-container" "string-format"];
    groups = ["default" "development"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1ldnryz9f30ay63zlsfsc5dkwianf7ayq30m95jxzpcq51fdgnbi";
      type = "gem";
    };
    version = "0.25.0";
  };
  async-smtp = {
    dependencies = ["async" "gem_kit" "io-endpoint" "io-stream" "protocol-smtp"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "01byh9xaljf7yy45n3gimybjwaqq4552xrl59j5rjhbwidawp4v8";
      type = "gem";
    };
    version = "0.1.0";
  };
  async-utilization = {
    dependencies = ["console"];
    groups = ["default" "development"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "10arz5049914z7il2qqqi16wcn7039d8rkvhgz5wpv899rilghwn";
      type = "gem";
    };
    version = "0.5.0";
  };
  bake = {
    dependencies = ["bigdecimal" "samovar"];
    groups = ["default" "development"];
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
  bigdecimal = {
    groups = ["default" "development"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1g9zi8c4i7g8zz0c3hxrw6mblrjvgn7akys60clb9si7c1k1gljk";
      type = "gem";
    };
    version = "4.1.2";
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
    groups = ["default" "development"];
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
  csv = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0mj4kq4wwpc7c8ll52q30hsir1jrcd5kq7yb8lyz0rksa1z1x9mb";
      type = "gem";
    };
    version = "3.3.6";
  };
  diff-lcs = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0qlrj2qyysc9avzlr4zs1py3x684hqm61n4czrsk1pyllz5x5q4s";
      type = "gem";
    };
    version = "1.6.2";
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
  dry-cli = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0x6qlxk6zp3jw748k6x3zkpywx9yjyagdyinb9qai2khdjvmn0dq";
      type = "gem";
    };
    version = "1.4.1";
  };
  dry-configurable = {
    dependencies = ["dry-core" "zeitwerk"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1kkk3fs22ndslgihxwm6rwr0y03rvccljmhz6vpm65q87iginpg3";
      type = "gem";
    };
    version = "1.4.0";
  };
  dry-core = {
    dependencies = ["concurrent-ruby" "logger" "zeitwerk"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "18cn9s2p7cbgacy0z41h3sf9jvl75vjfmvj774apyffzi3dagi8c";
      type = "gem";
    };
    version = "1.2.0";
  };
  dry-inflector = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1k1dd35sqqqg2abd2g2w78m94pa3mcwvmrsjbkr3hxpn0jxw5c3z";
      type = "gem";
    };
    version = "1.3.1";
  };
  dry-logic = {
    dependencies = ["bigdecimal" "concurrent-ruby" "dry-core" "zeitwerk"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "18nf8mbnhgvkw34drj7nmvpx2afmyl2nyzncn3wl3z4h1yyfsvys";
      type = "gem";
    };
    version = "1.6.0";
  };
  dry-types = {
    dependencies = ["bigdecimal" "concurrent-ruby" "dry-core" "dry-inflector" "dry-logic" "zeitwerk"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0y7icwaa26ycikz6h97gwd1hji3r280n4yr2kmn5sfgqp76yxsxs";
      type = "gem";
    };
    version = "1.9.1";
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
    groups = ["development"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1xzhpbbjjjqd6q7z7x8j5w5qxx6q6zhaly306y00mfd34fy61c69";
      type = "gem";
    };
    version = "0.57.0";
  };
  fiber-annotation = {
    groups = ["default" "development"];
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
    groups = ["default" "development"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "01lz929qf3xa90vra1ai1kh059kf2c8xarfy6xbv1f8g457zk1f8";
      type = "gem";
    };
    version = "1.1.0";
  };
  fiber-storage = {
    groups = ["default" "development"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1qa0j9qjwav9xb0n3isx0rbh0942xrfback392n6vs8bidnmp3pl";
      type = "gem";
    };
    version = "1.0.1";
  };
  gem_kit = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0dx9w041lqzr4jd0m9as0v5v6n3fj2hcg74p2gyswr2y2a6zc5v9";
      type = "gem";
    };
    version = "0.2.0";
  };
  gem_kit-release = {
    dependencies = ["gem_kit" "thor"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1cnl3p4y9jfag8q908ih28q3hll21b3ban5j004cra7l58hg3rrq";
      type = "gem";
    };
    version = "0.3.2";
  };
  grape = {
    dependencies = ["activesupport" "dry-configurable" "dry-types" "mustermann-grape" "rack" "zeitwerk"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "150vvdrvrxbpc7xwl0jlwr5m2hir6w51yy73lbfa9r84b7sp5024";
      type = "gem";
    };
    version = "3.2.1";
  };
  hanami-api = {
    dependencies = ["hanami-router"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1gg3ygjbnmdnzksrm3m8xs5p5g194bnq9bxcbcmx48ld4h4v8wq2";
      type = "gem";
    };
    version = "0.3.0";
  };
  hanami-router = {
    dependencies = ["csv" "mustermann" "mustermann-contrib" "rack"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "07z3i8xjpi7vn0517kw82a3szcncbqvkzsigpl1mgpjip1f6dcw1";
      type = "gem";
    };
    version = "2.3.1";
  };
  hansi = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1nq59071hmkymrf17fw50by3qplxmzrhxz4hfqx2lsgi57bxy9vy";
      type = "gem";
    };
    version = "0.2.1";
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
  inertia_rails = {
    dependencies = ["railties"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1cdphyvic78b1rk3s7f4j67ccwlnl3w6390zhg91a827vqh03hir";
      type = "gem";
    };
    version = "3.22.0";
  };
  io-console = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1p8000b68iw14byanj6d8w9kfj3vgj7bxda8aj5bgbxhc6a08mgm";
      type = "gem";
    };
    version = "0.9.3";
  };
  io-endpoint = {
    dependencies = ["openssl"];
    groups = ["default" "development"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1ajia4kwnma5i41mp2w4xvzwbhrc6fmivjdzj2j8nkjqrmmih3bj";
      type = "gem";
    };
    version = "0.18.0";
  };
  io-event = {
    groups = ["default" "development"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1lms71bkfbx663lhac44cz8fsn8zhfzz90kz0kr99s50qnvsjs5i";
      type = "gem";
    };
    version = "1.19.5";
  };
  io-stream = {
    dependencies = ["openssl"];
    groups = ["default" "development"];
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
    groups = ["default" "development"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0shwgjqbj856mb6m9kgkpy08nhym2gdvc2yaprlimfmky9y3n78z";
      type = "gem";
    };
    version = "2.21.2";
  };
  language_server-protocol = {
    groups = ["default" "development"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1w5p8c2145lmqzr25bxh4ikzjm6k8y1k5lriqqdpw9pq730w1wjy";
      type = "gem";
    };
    version = "3.17.0.6";
  };
  lefthook = {
    groups = ["development"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0r8vwq96i3wfsb3c2q0qjl3nssadwmlrgavf06wfi2d6isyhd76c";
      type = "gem";
    };
    version = "2.1.10";
  };
  lint_roller = {
    groups = ["default" "development"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "11yc0d84hsnlvx8cpk4cbj6a4dz9pk0r1k29p0n1fz9acddq831c";
      type = "gem";
    };
    version = "1.1.0";
  };
  localhost = {
    dependencies = ["bake"];
    groups = ["default" "development"];
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
    groups = ["development"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1mbpz92ml19rcxxfjrj91gmkif9khb1xpzyw38f81rvglgw1ffrd";
      type = "gem";
    };
    version = "5.27.0";
  };
  mustermann = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "163i29mdcr1h0nximk3d51a1fgp7vz3sfasn8p1rjm2d4g3p0qac";
      type = "gem";
    };
    version = "3.1.1";
  };
  mustermann-contrib = {
    dependencies = ["hansi" "mustermann"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "07d8hadc7n2phlmc3n3zk42fbpyraxlzl8a7apkj50k6f57z5v63";
      type = "gem";
    };
    version = "3.1.1";
  };
  mustermann-grape = {
    dependencies = ["mustermann"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1iaqlj7kjm5dd207gxcwi3nsjs616yqc08y0whfg1j04c2c8l9cd";
      type = "gem";
    };
    version = "1.1.0";
  };
  mutex_m = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0l875dw0lk7b2ywa54l0wjcggs94vb7gs8khfw9li75n2sn09jyg";
      type = "gem";
    };
    version = "0.3.0";
  };
  nio4r = {
    groups = ["default" "development"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "18fwy5yqnvgixq3cn0h63lm8jaxsjjxkmj8rhiv8wpzv9271d43c";
      type = "gem";
    };
    version = "2.7.5";
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
  openssl = {
    groups = ["default" "development"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1hj7wwp4r3jhvnyd8ik85wbs25cq1w61r28pv6ddyn5fd0lasdqh";
      type = "gem";
    };
    version = "4.0.2";
  };
  parallel = {
    groups = ["default" "development"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0mlkn1vhh9lr7vljibpgspwsswk7mzm8nw6bbr616c9fbj35hlmk";
      type = "gem";
    };
    version = "2.1.0";
  };
  parser = {
    dependencies = ["ast" "racc"];
    groups = ["default" "development"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0a4q5h2hcihk79dbr20scgkm56l79qp7fsvfvkxlv8nmapvxg9i1";
      type = "gem";
    };
    version = "3.3.12.0";
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
    groups = ["default" "development"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "11ggfikcs1lv17nhmhqyyp6z8nq5pkfcj6a904047hljkxm0qlvv";
      type = "gem";
    };
    version = "1.9.0";
  };
  protocol-hpack = {
    groups = ["default" "development"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "14ddqg5mcs9ysd1hdzkm5pwil0660vrxcxsn576s3387p0wa5v3g";
      type = "gem";
    };
    version = "1.5.1";
  };
  protocol-http = {
    groups = ["default" "development"];
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
    groups = ["default" "development"];
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
    groups = ["default" "development"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1piy395lxlbwzy16p5idlq9qj2qpxaa007h5971i4xc766mcymql";
      type = "gem";
    };
    version = "0.26.2";
  };
  protocol-rack = {
    dependencies = ["io-stream" "protocol-http" "rack"];
    groups = ["default" "development"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1hwz5bb3wcx4lkprigsgfa4vqlx33jcxc01pc2d89ybyj92x518i";
      type = "gem";
    };
    version = "0.22.1";
  };
  protocol-smtp = {
    dependencies = ["gem_kit"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1snln067w1q2895cls7xk74md3m7y918g009mxggjqna6x3yccng";
      type = "gem";
    };
    version = "0.1.0";
  };
  protocol-url = {
    groups = ["default" "development"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1mhf2nbc79ikirr9c9m3c9cspr30n8rr6w2bw0c6vd4l62c5avxi";
      type = "gem";
    };
    version = "0.18.0";
  };
  puma = {
    dependencies = ["nio4r"];
    groups = ["development"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1yw6nvkvddriacmva8hm0za0961d6j96dm7zm6748rmyzcfqgvf8";
      type = "gem";
    };
    version = "8.0.2";
  };
  racc = {
    groups = ["default" "development"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0byn0c9nkahsl93y9ln5bysq4j31q8xkf2ws42swighxd4lnjzsa";
      type = "gem";
    };
    version = "1.8.1";
  };
  rack = {
    groups = ["default" "development"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1dwgab330lsv4qppw3f52mc4ihr8lagxgll53mkmcdgr4hf3xqck";
      type = "gem";
    };
    version = "3.2.7";
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
  rack-proxy = {
    dependencies = ["rack"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0x723aalhz38zpwsh766vdxv1mqq14hkbi5ps7g2533j91mabbz7";
      type = "gem";
    };
    version = "2.0.1";
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
  rainbow = {
    groups = ["default" "development"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0smwg4mii0fm38pyb5fddbmrdpifwv22zv3d3px2xx497am93503";
      type = "gem";
    };
    version = "3.1.1";
  };
  rake = {
    groups = ["development"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "009p524zl0p0kfa65nii8wdmaigkmawv9pbvlcffky7islmmp0nb";
      type = "gem";
    };
    version = "13.4.2";
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
  regexp_parser = {
    groups = ["default" "development"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1fwfw26a32rps78920nn29shqg2zmqv72i89j1fap41isshida9m";
      type = "gem";
    };
    version = "2.12.0";
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
  roda = {
    dependencies = ["rack"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "01kwqzqg0ypcjh0nf0z8xhdfsb65iz4iv6jq23n3gl7wy6hcfh5z";
      type = "gem";
    };
    version = "3.107.0";
  };
  rspec = {
    dependencies = ["rspec-core" "rspec-expectations" "rspec-mocks"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "11q5hagj6vr694innqj4r45jrm8qcwvkxjnphqgyd66piah88qi0";
      type = "gem";
    };
    version = "3.13.2";
  };
  rspec-core = {
    dependencies = ["rspec-support"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0bcbh9yv6cs6pv299zs4bvalr8yxa51kcdd1pjl60yv625j3r0m8";
      type = "gem";
    };
    version = "3.13.6";
  };
  rspec-expectations = {
    dependencies = ["diff-lcs" "rspec-support"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0dl8npj0jfpy31bxi6syc7jymyd861q277sfr6jawq2hv6hx791k";
      type = "gem";
    };
    version = "3.13.5";
  };
  rspec-mocks = {
    dependencies = ["diff-lcs" "rspec-support"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0iqxmw0knjiz5nf6pgr8ihs6cjzh89f0ppj3fqiz8cvms79x6sh8";
      type = "gem";
    };
    version = "3.13.8";
  };
  rspec-support = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0z64h5rznm2zv21vjdjshz4v0h7bxvg02yc6g7yzxakj11byah06";
      type = "gem";
    };
    version = "3.13.7";
  };
  rubocop = {
    dependencies = ["json" "language_server-protocol" "lint_roller" "parallel" "parser" "rainbow" "regexp_parser" "rubocop-ast" "ruby-progressbar" "unicode-display_width"];
    groups = ["development"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1gwvjfd3zh40dhggh3p99h62b4v8nl5dqgma9pmmz5fdj0f2bvwd";
      type = "gem";
    };
    version = "1.88.2";
  };
  rubocop-ast = {
    dependencies = ["parser" "prism"];
    groups = ["default" "development"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1nw84xk6vc2ls8sxqvyhxs2agh4l0jrws85d4bi3x0501lq8ijmr";
      type = "gem";
    };
    version = "1.50.0";
  };
  ruby-progressbar = {
    groups = ["default" "development"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0cwvyb7j47m7wihpfaq7rc47zwwx9k4v7iqd9s1xch5nm53rrz40";
      type = "gem";
    };
    version = "1.13.0";
  };
  samovar = {
    dependencies = ["console"];
    groups = ["default" "development"];
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
  sinatra = {
    dependencies = ["logger" "mustermann" "rack" "rack-protection" "rack-session" "tilt"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "103h6wjpcqp3i034hi44za2v365yz7qk9s5df8lmasq43nqvkbmp";
      type = "gem";
    };
    version = "4.2.1";
  };
  string-format = {
    groups = ["default" "development"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1xlsg0m748bcb4vgvmjxlfsif6nnl8pz6ja52c91y1kb24a1r65w";
      type = "gem";
    };
    version = "0.2.0";
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
  tilt = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "19d3k8ym9bj9j98zmc0pbjnwqdg4mqabnh8hm7lrdfhb5383amys";
      type = "gem";
    };
    version = "2.9.0";
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
  unicode-display_width = {
    dependencies = ["unicode-emoji"];
    groups = ["default" "development"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0hiwhnqpq271xqari6mg996fgjps42sffm9cpk6ljn8sd2srdp8c";
      type = "gem";
    };
    version = "3.2.0";
  };
  unicode-emoji = {
    groups = ["default" "development"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "03zqn207zypycbz5m9mn7ym763wgpk7hcqbkpx02wrbm1wank7ji";
      type = "gem";
    };
    version = "4.2.0";
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
  vite_ruby = {
    dependencies = ["dry-cli" "logger" "mutex_m" "rack-proxy" "zeitwerk"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "17p4vmjawciz1s3vg397zjvw4flxw37q48dhc1ihn75k3jz95vp9";
      type = "gem";
    };
    version = "3.10.5";
  };
  webrick = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0ca1hr2rxrfw7s613rp4r4bxb454i3ylzniv9b9gxpklqigs3d5y";
      type = "gem";
    };
    version = "1.9.2";
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
