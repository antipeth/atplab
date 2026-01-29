_: {
  services.readeck = {
    enable = true;
    environmentFile = /run/secret; # Include 	READECK_SECRET_KEY=some-long-and-strong-key
    settings = {
      main = {
        log_level = "INFO";
        data_directory = "data";
      };
      server = {
        host = "127.0.0.1";
        port = 8000;
        base_url = "https://readeck.0pt.dpdns.org";
      };
      database.source = "sqlite3:data/db.sqlite3";
    };
  };
}
