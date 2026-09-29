# More exercises

If you encounter any problem or doubts (even if you are attempting the more difficult variants) please do not hesitate to reach out.

## Exercise 1: Parsing a log file

Take a look at the attached file `deepseek.log`.
Here is an excerpt
```
2026-09-27T17:41:52.911167085+02:00 (APIServer pid=1) INFO:     10.128.6.50:42218 - "GET /health HTTP/1.1" 200 OK      
2026-09-27T17:41:57.911517071+02:00 (APIServer pid=1) INFO:     10.128.6.50:56256 - "GET /health HTTP/1.1" 200 OK      
2026-09-27T17:41:58.445380621+02:00 (APIServer pid=1) INFO:     172.26.86.51:38684 - "POST /v1/chat/completions HTTP/1.1" 200 OK      
2026-09-27T17:41:58.946667903+02:00 (APIServer pid=1) INFO 09-27 15:41:58 [loggers.py:310] Engine 000: Avg prompt throughput: 9.5 tokens/s, Avg generation throughput: 2.0 tokens/s, Running: 0 reqs, Waiting: 0    reqs, GPU KV cache usage: 0.0%, Prefix cache hit rate: 0.0%                 
2026-09-27T17:41:59.191048002+02:00 (APIServer pid=1) INFO:     172.26.86.51:38694 - "GET /metrics HTTP/1.1" 200 OK      
2026-09-27T17:42:02.909664159+02:00 (APIServer pid=1) INFO:     10.128.6.50:56266 - "GET /health HTTP/1.1" 200 OK
```

Using `awk`, write a script to only print the values of "prompt throughput".

Tip: write a loop over fields where you check if the word "prompt" comes out, then select ... fields after that.

### Added difficulty

Count how many times the /health endpoint was interrogated.

### Added difficulty+

Compute the average prompt and generation throughput and print them.
