defmodule ExfileSwiftTest do
  # Requires real Swift server. :(
  use Exfile.BackendTest, {
    ExfileSwift,
    auth_url: "https://auth.example.com/",
    username: "valid_username",
    password: "valid_password",
    container: "TST"
  }
end
