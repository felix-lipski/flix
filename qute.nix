palette: with palette; {
  enable = true;
  settings = {
    tabs.position = "left";
    colors = {
      tabs = {
        even = {bg = black; fg = grey;};
        odd = {bg = black; fg = grey;};
        selected.even = {bg = white; fg = black;};
        selected.odd = {bg = white; fg = black;};
        bar.bg = black;
        indicator = { stop = green; start = blue; error = red; };
      };
      downloads = {
        bar.bg = black;
        error.bg = red;
        stop.bg = green;
        start.bg = yellow;
      };
      statusbar = {
        caret   = { fg = white; bg = cyan;  };
        insert  = { fg = white; bg = green; };
        normal  = { fg = white; bg = black; };
        command = { fg = yellow; bg = black; };
        url.success = { http.fg = blue; https.fg = green; };
      };
      completion = {
        category = { bg = black; fg = white; border = { top = white; bottom = white; }; };
        item.selected = { bg = white; fg = black; match.fg = green; border = { top = white; bottom = white; }; };
        match.fg = green;
        even.bg = black;
        odd.bg = black;
        fg = [white white blue];
      };
      webpage.darkmode.enabled = true;
      messages = {
        error   = { fg = black;  bg = red;   border = red; };
        info    = { fg = blue;   bg = black; border = blue; };
        warning = { fg = yellow; bg = black; border = yellow; };
      };
    };
    fonts = let 
      bold = "bold 14px 'terminus'"; 
    in {
      tabs.selected = bold;
      tabs.unselected = bold;
      downloads = bold;
      statusbar = bold;
      completion.category = bold;
      completion.entry = bold;
      messages.info = bold;
      messages.error = bold;
      messages.warning = bold;
    };
  };
  searchEngines = {
    g = "https://github.com/felix-lipski/{}";
    y = "https://www.youtube.com/results?search_query={}";
    n = "https://search.nixos.org/packages?channel=unstable&from=0&size=50&sort=relevance&type=packages&query={}";
    w = "https://en.wikipedia.org/wiki/Special:Search?search={}&go=Go&ns0=1";
    aw = "https://wiki.archlinux.org/?search={}";
    nw = "https://nixos.wiki/index.php?search={}";
    google = "https://www.google.com/search?hl=en&q={}";
  };
}
