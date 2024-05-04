let
  users = import ../users.nix;

  # This is how many contact points a user should have
  # besides GitHub
  requiredContactPoints = 1;

  # attrset -> attrset
  # We remove the GitHub attribute from all users, as we don't consider it
  # as a point of contact
  removeGH = userInfo: builtins.removeAttrs userInfo [ "github" ];

  # attrset -> int
  # Count the number of attributes in a set
  # This is how we count the points of contact
  attrsLength = attrs: builtins.length (builtins.attrValues attrs);

  # attrset -> bool
  # Check to see if a set of user information attributes has the
  # number of contact points we require
  hasEnoughContacts = userInfo: attrsLength (removeGH userInfo) >= requiredContactPoints;

  # attrset -> attrset
  # This will check the contacts for a user and throw an evaluation
  # error if they don't meet our number of required contacts
  checkContact =
    userName: userInfo:
    if (!(hasEnoughContacts userInfo)) then
      throw "${userName} has less than ${toString requiredContactPoints} contact point(s)!"
    else
      userInfo;

  # This will run our contact check on each user
  checkContacts = builtins.mapAttrs checkContact users;

  # string -> string
  # This will evaluate our checks and display the message you give it if all goes well
  evalContactsThen = builtins.deepSeq checkContacts;
in
evalContactsThen "All users have at least ${toString requiredContactPoints} contact point(s)!"
