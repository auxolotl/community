let
  lib = (import <nixpkgs> {}).lib;

  inherit (lib.lists) length any;
  inherit (lib.attrsets) filterAttrs attrValues mapAttrs;

  users = import ./users.nix;

  # we remove the GitHub attribute from all users, this is beacuse we don't
  # consider GitHub to be a point of contact for the user.
  removeGh = user: filterAttrs (n: _: n != "github") user;

  # convert the user attribute set to a list of values
  userAttrs = user: attrValues (removeGh user);

  # we now create an error if the user attribute set is empty
  error = user: (length (userAttrs user)) == 0;

  # we iterate over all users and create a new attribute for each user
  # the attribute will be wether there is an error with the user or not
  iterUsers = users: mapAttrs (_: data: error data) users;

  # test all values in the list are false
  # if any are true this means that there was an error
  testAllFalse = arr: any (x: x) arr;

  # if we have any errors in the users, we will return an error
  errors = testAllFalse (attrValues (iterUsers users));

  # invert argument for readability
  pass = !errors;
in
  assert pass; "PASS"
