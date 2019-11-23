Return-Path: <SRS0=HVYc=ZP=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 877DDC432C3
	for <linux-trace-devel@archiver.kernel.org>; Sat, 23 Nov 2019 08:47:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 52A3020719
	for <linux-trace-devel@archiver.kernel.org>; Sat, 23 Nov 2019 08:47:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726141AbfKWIrs (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Sat, 23 Nov 2019 03:47:48 -0500
Received: from snd00003.auone-net.jp ([111.86.247.3]:24482 "EHLO
        dmta0009-f.auone-net.jp" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725973AbfKWIrs (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Sat, 23 Nov 2019 03:47:48 -0500
X-Greylist: delayed 377 seconds by postgrey-1.27 at vger.kernel.org; Sat, 23 Nov 2019 03:47:48 EST
Received: from ppp.dion.ne.jp by dmta0005.auone-net.jp with ESMTP
          id <20191123084130027.IPKB.12758.ppp.dion.ne.jp@dmta0005.auone-net.jp>
          for <linux-trace-devel@vger.kernel.org>;
          Sat, 23 Nov 2019 17:41:30 +0900
Date:   Sat, 23 Nov 2019 17:41:29 +0900
From:   Kusanagi Kouichi <slash@ac.auone-net.jp>
To:     linux-trace-devel@vger.kernel.org
Subject: [PATCH] trace-cmd: Improve /proc/kallsyms parsing
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.12.2 (2019-09-21)
Message-Id: <20191123084130027.IPKB.12758.ppp.dion.ne.jp@dmta0005.auone-net.jp>
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

- Use the stricter format string.
- Avoid allocating memory.
- Check sscanf return value.

Signed-off-by: Kusanagi Kouichi <slash@ac.auone-net.jp>
---
 lib/trace-cmd/trace-util.c | 29 +++++++++++++++--------------
 1 file changed, 15 insertions(+), 14 deletions(-)

diff --git a/lib/trace-cmd/trace-util.c b/lib/trace-cmd/trace-util.c
index 8aa3b6c..ef8e4f7 100644
--- a/lib/trace-cmd/trace-util.c
+++ b/lib/trace-cmd/trace-util.c
@@ -80,39 +80,40 @@ void tracecmd_parse_proc_kallsyms(struct tep_handle *pevent,
 	char *func;
 	char *line;
 	char *next = NULL;
-	char *addr_str;
 	char *mod;
 	char ch;
 
 	line = strtok_r(file, "\n", &next);
 	while (line) {
+		int n, func_start, func_end = 0, mod_start, mod_end = 0;
+
 		mod = NULL;
 		errno = 0;
-		sscanf(line, "%ms %c %ms\t[%ms",
-			     &addr_str, &ch, &func, &mod);
+		n = sscanf(line, "%16llx %c %n%*s%n%*1[\t][%n%*s%n",
+			   &addr, &ch, &func_start, &func_end, &mod_start, &mod_end);
 		if (errno) {
-			free(addr_str);
-			free(func);
-			free(mod);
 			perror("sscanf");
 			return;
 		}
-		addr = strtoull(addr_str, NULL, 16);
-		free(addr_str);
 
-		/* truncate the extra ']' */
-		if (mod)
-			mod[strlen(mod) - 1] = 0;
+		if (n != 2 || !func_end)
+			return;
 
+		func = line + func_start;
 		/*
 		 * Hacks for
 		 *  - arm arch that adds a lot of bogus '$a' functions
 		 *  - x86-64 that reports per-cpu variable offsets as absolute
 		 */
-		if (func[0] != '$' && ch != 'A' && ch != 'a')
+		if (func[0] != '$' && ch != 'A' && ch != 'a') {
+			line[func_end] = 0;
+			if (mod_end) {
+				mod = line + mod_start;
+				/* truncate the extra ']' */
+				line[mod_end - 1] = 0;
+			}
 			tep_register_function(pevent, func, addr, mod);
-		free(func);
-		free(mod);
+		}
 
 		line = strtok_r(NULL, "\n", &next);
 	}
-- 
2.24.0

