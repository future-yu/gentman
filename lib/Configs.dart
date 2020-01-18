import 'dart:io';

class Config{
  static final  ex_remote_url= "https://exhentai.org/";
  static final e_remote_url="https://e-hentai.org/";
  static final service = "http://127.0.0.1:9001";
  static final nhentai_url  = "https://nhentai.net";
  static final sites={
    "0": "https://exhentai.org/",
    "1": "https://e-hentai.org/",
    "2": "https://nhentai.net",
    "3": "http://127.0.0.1:9001",
  };
  static final cookies = [
    Cookie("igneous", "823a80955"),
    Cookie("ipb_member_id", "3495927"),
    Cookie("ipb_pass_hash", "24aab63fc4577147b9883472a9db83b2"),
    Cookie("sk", "qrle2ilitrd9pwfdugecs9raq5sr")
  ];
  static final login_url= "https://forums.e-hentai.org/index.php?act=Login&CODE=01";
  static final Headers = {
    HttpHeaders.acceptHeader:
        "text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.9",
    HttpHeaders.acceptLanguageHeader: 'zh',
    HttpHeaders.contentTypeHeader: "text/html; charset=UTF-8",
    HttpHeaders.acceptEncodingHeader: 'gzip, deflate, br',
    HttpHeaders.userAgentHeader:
        'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_2) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/79.0.3945.88 Safari/537.36',
  };
}
