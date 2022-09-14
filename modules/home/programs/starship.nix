{
  programs.starship.settings = {
    format = ''
      $directory$username$hostname$cmd_duration$jobs$fill$git_state$nix_shell
      $character
    '';

    directory = {
      truncation_symbol = "…/";
    };
    username.format = "[$user]($style)";
    hostname.format = "@[$hostname]($style) ";
    cmd_duration = {
      format = "[$duration]($style) ";
      show_milliseconds = true;
      min_time = 1000;
      show_notifications = true;
      min_time_to_notify = 60000;
    };
    jobs = {
      format = "$symbol[$number]($style) ";
      symbol = "+";
    };

    fill.symbol = " ";

    git_state = {
      format = " [$state( $progress_current/$progress_total)]($style)";
    };
    nix_shell = {
      format = '' [$symbol$state( \($name\))]($style)'';
    };
  };
}
