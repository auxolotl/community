let
  committees = import ./committees.nix;
  sigs = import ./sigs.nix;
  users = import ./users.nix;
in
[
  {
    committee = committees.security;
    leaders = [
      users.c8h4
      users.dfh
      users.jakehamilton
    ];
    members = [
      users.axel
      users.codingpuffin
      users.isabel
      users.minion
    ];
  }
  {
    sig = sigs.documentation;
    leaders = [
      users.coded
      users.minion
    ];
    members = [
      users.axel
      users.isabel
      users.ircurry
      users."8bitbuddhist"
      users.trespaul
      users.imadnyc
      users.aprl
      users.dfh
      users.vera
      users.nova
      users.blue
      users.deivpaukst
      users.tau
      users.srestegosaurio
      users.jacab
      users.liketechnik
      users.angryant
      users.raf
    ];
  }
  {
    sig = sigs.rust;
    leaders = with users; [ ];
    members = with users; [
      aprl
      austreelis
      bbjubjub
      c8h4
      eri
      evanrichter
      jalil
      liketechnik
    ];
  }
]
