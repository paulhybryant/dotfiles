# vim: filetype=zsh sw=2 ts=2 sts=2 et tw=80 foldlevel=0 nospell

autoload -Uz up-line-or-beginning-search                                        # Put cursor at end of line when using Up for command history
autoload -Uz down-line-or-beginning-search                                      # Put cursor at end of line when using Down for command history

# TODO(me): Bind C-Left and C-Right as HOME / END
bindkey '^[OD' beginning-of-line                                                # Set left arrow as HOME
bindkey '^[OC' end-of-line                                                      # Set right arrow as END
bindkey -s 'OM' ''                                                          # Let enter in numeric keypad work as newline (return)
bindkey -r '^S'                                                                 # By default <C-S> is bind to self-insert, which presents vim from getting the combination.
bindkey '^R' history-incremental-pattern-search-backward                        # Search history backward incrementally
bindkey '^[[A' up-line-or-beginning-search                                      # Up
bindkey '^[[B' down-line-or-beginning-search                                    # Down
# bindkey '^I' expand-or-complete-prefix
# bindkey '^[[3~' delete-char
bindkey '\C-n' menu-complete
bindkey '\C-p' reverse-menu-complete
