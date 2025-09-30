# Log Parsing

In this exercise we will parse a log searching for insights. The goal is to
apply what we learned during the course and apply it to a real-World scenario.

## HTTP logs

Open the `assets/orfeo-doc.log` file and read the first 10 lines:

```
$ head orfeo-doc.log
20.194.1.3 - - [29/Sep/2025:23:56:45 +0000] "GET /HPC/python-environment/ HTTP/2.0" 200 37262 "-" "Mozilla/5.0 AppleWebKit/537.36 (KHTML, like Gecko); compatible; ChatGPT-User/1.0; +https://openai.com/bot" 
4.227.36.85 - - [29/Sep/2025:23:57:34 +0000] "GET /robots.txt HTTP/2.0" 404 153 "-" "Mozilla/5.0 AppleWebKit/537.36 (KHTML, like Gecko; compatible; GPTBot/1.2; +https://openai.com/gptbot)" 
172.182.213.201 - - [29/Sep/2025:23:57:35 +0000] "GET /HPC/python-environment/ HTTP/2.0" 200 37262 "-" "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36; compatible; OAI-SearchBot/1.0; +https://openai.com/searchbot" 
4.227.36.85 - - [29/Sep/2025:23:57:35 +0000] "GET /robots.txt HTTP/1.1" 308 164 "-" "Mozilla/5.0 AppleWebKit/537.36 (KHTML, like Gecko; compatible; GPTBot/1.2; +https://openai.com/gptbot)" 
4.227.36.85 - - [29/Sep/2025:23:57:36 +0000] "GET /robots.txt HTTP/2.0" 404 153 "http://orfeo-doc.areasciencepark.it/robots.txt" "Mozilla/5.0 AppleWebKit/537.36 (KHTML, like Gecko; compatible; GPTBot/1.2; +https://openai.com/gptbot)" 
20.171.207.56 - - [29/Sep/2025:23:57:39 +0000] "GET /HPC/python-environment/ HTTP/1.1" 308 164 "-" "Mozilla/5.0 AppleWebKit/537.36 (KHTML, like Gecko; compatible; GPTBot/1.2; +https://openai.com/gptbot)" 
4.227.36.85 - - [29/Sep/2025:23:57:39 +0000] "GET /robots.txt HTTP/2.0" 404 153 "-" "Mozilla/5.0 AppleWebKit/537.36 (KHTML, like Gecko; compatible; GPTBot/1.2; +https://openai.com/gptbot)" 
20.171.207.56 - - [29/Sep/2025:23:57:40 +0000] "GET /HPC/python-environment HTTP/2.0" 301 169 "-" "Mozilla/5.0 AppleWebKit/537.36 (KHTML, like Gecko; compatible; GPTBot/1.2; +https://openai.com/gptbot)" 
20.171.207.56 - - [29/Sep/2025:23:57:40 +0000] "GET /HPC/python-environment/ HTTP/1.1" 308 164 "-" "Mozilla/5.0 AppleWebKit/537.36 (KHTML, like Gecko; compatible; GPTBot/1.2; +https://openai.com/gptbot)" 
20.171.207.56 - - [29/Sep/2025:23:57:40 +0000] "GET /HPC/python-environment HTTP/2.0" 301 169 "-" "Mozilla/5.0 AppleWebKit/537.36 (KHTML, like Gecko; compatible; GPTBot/1.2; +https://openai.com/gptbot)" 
```

As you can see the lines follow a common scheme:
- An IP address
- Two `-` signs separated by a single space.
- A date and time enclosed in square brackets (`[]`).
- A substring enclosed in double quotes (`"`).
- Two numbers.
- Another substring (that can be either `"-"` or a URL).
- A final substring.

This is a common pattern in HTTP logs. You have the IP address of the
requester, an optional user (if the request is authenticated), an optional
realm (only when the user field is present), the timestamp, the request itself
(method, URI, protocol), the HTTP return code, the size of the document
returned, the referrer (if present) and finally the user agent.

First let's see what are the most common user agents sorted in descending order:

```
$ grep -Eo '"[^"]+"$' orfeo-doc.log | sort | uniq -c | sort -nr
     25 "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36; compatible; OAI-SearchBot/1.0; +https://openai.com/searchbot"
     15 "Mozilla/5.0 AppleWebKit/537.36 (KHTML, like Gecko; compatible; GPTBot/1.2; +https://openai.com/gptbot)"
     11 "Mozilla/5.0 (compatible; SemrushBot/7~bl; +http://www.semrush.com/bot.html)"
      7 "Mozilla/5.0 AppleWebKit/537.36 (KHTML, like Gecko); compatible; ChatGPT-User/1.0; +https://openai.com/bot"
      3 "Mozilla/5.0 AppleWebKit/537.36 (KHTML, like Gecko; compatible; PerplexityBot/1.0; +https://perplexity.ai/perplexitybot)"
      2 "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36"
      2 "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/104.0.5112.81 Safari/537.36"
      1 "Mozilla/5.0 (X11; Linux x86_64; rv:135.0) Gecko/20100101 Firefox/135.0"
      1 "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/121.0.0.0 Safari/537.36"
      1 "Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:139.0) Gecko/20100101 Firefox/139.0"
      1 "Mozilla/5.0 (Linux; Android 7.0;) AppleWebKit/537.36 (KHTML, like Gecko) Mobile Safari/537.36 (compatible; PetalBot;+https://webmaster.petalsearch.com/site/petalbot)"
      1 "Mozilla/5.0 (compatible; YandexBot/3.0; +http://yandex.com/bots)"
      1 "Googlebot-Image/1.0"
      1 "facebookexternalhit/1.1 (+http://www.facebook.com/externalhit_uatext.php)"
```

Unsurprisingly most of the requests come from bots. Let's check what IP addresses OpenAI uses:

```
$ fgrep openai.com orfeo-doc.log | egrep -o '^([0-9]{1,3}\.){3}[0-9]{1,3}' | sort | uniq -c
      2 104.210.140.128
      1 104.210.140.129
      1 104.210.140.130
      3 104.210.140.131
      1 104.210.140.133
      2 104.210.140.134
      4 104.210.140.135
      1 104.210.140.137
      2 104.210.140.140
      3 104.210.140.141
      1 104.210.140.143
      1 172.182.213.201
      1 172.203.190.132
      2 172.203.190.139
      1 172.204.16.67
      1 172.213.21.122
      1 172.213.21.151
     11 20.171.207.56
      1 20.194.1.3
      1 23.98.142.189
      1 40.84.221.236
      4 4.227.36.85
      1 52.159.249.102
```

Now something trickier, let's see what are the most requested URIs:

```
$ fgrep openai.com orfeo-doc.log | cut -d '"' -f2 | sed -r 's/[A-Z]+ (.*) HTTP\/[.0-9]+/\1/' | sort | uniq -c | sort -nr
     28 /robots.txt
      8 /HPC/python-environment/
      5 /HPC/python-environment
      4 /HPC/SLURM-basics/
      1 /examples/STREAM/
      1 /examples/MPI-communication/
```

## SSH logs

Now let's examine `assets/ssh.log`:

```
$ head ssh.log
Sep 29 06:05:49 login01.hpc.rd.areasciencepark.it sshd-session[1544792]: Connection closed by 45.79.172.21 port 6058 [preauth]
Sep 29 06:05:49 login01.hpc.rd.areasciencepark.it sshd-session[1544804]: Connection closed by 45.79.172.21 port 6072 [preauth]
Sep 29 06:05:50 login01.hpc.rd.areasciencepark.it sshd-session[1544808]: Connection closed by 45.79.172.21 port 6088 [preauth]
Sep 29 06:06:40 login01.hpc.rd.areasciencepark.it sshd-session[1545462]: Invalid user adi from 34.91.0.68 port 40616
Sep 29 06:06:40 login01.hpc.rd.areasciencepark.it sshd-session[1545462]: Received disconnect from 34.91.0.68 port 40616:11: Bye Bye [preauth]
Sep 29 06:06:40 login01.hpc.rd.areasciencepark.it sshd-session[1545462]: Disconnected from invalid user adi 34.91.0.68 port 40616 [preauth]
Sep 29 06:08:14 login01.hpc.rd.areasciencepark.it sshd-session[1546714]: Invalid user carlo from 222.255.214.140 port 54000
Sep 29 06:08:14 login01.hpc.rd.areasciencepark.it sshd-session[1546714]: Received disconnect from 222.255.214.140 port 54000:11: Bye Bye [preauth]
Sep 29 06:08:14 login01.hpc.rd.areasciencepark.it sshd-session[1546714]: Disconnected from invalid user carlo 222.255.214.140 port 54000 [preauth]
Sep 29 06:12:36 login01.hpc.rd.areasciencepark.it sshd-session[1550231]: Invalid user pula from 181.116.220.24 port 46421
```

Write a one-liner that filters all the lines containing `invalid user` (case
insensitive), extracts the IP address and prints out the top ten most frequent
IP addresses.
