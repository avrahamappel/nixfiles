{
  # Rustfmt config file
  xdg.configFile."rustfmt/rustfmt.toml".text = /* toml */ ''
    # blank_lines_lower_bound = 1        https://github.com/rust-lang/rustfmt/issues/3382
    # empty_item_single_line = false     https://github.com/rust-lang/rustfmt/issues/3356
    # format_macro_matchers = true       https://github.com/rust-lang/rustfmt/issues/3354
    # format_strings - true              https://github.com/rust-lang/rustfmt/issues/3353
    match_block_trailing_comma = true    
    # imports_granularity = "Crate"      https://github.com/rust-lang/rustfmt/issues/4991
    merge_imports = true # Remove when `imports_granularity` stablizes
    # group_imports = "StdExternalCrate" https://github.com/rust-lang/rustfmt/issues/5083
    # trailing_semicolon = false         https://github.com/rust-lang/rustfmt/issues/3378
    use_field_init_shorthand = true
    wrap_comments = true
  '';
}
