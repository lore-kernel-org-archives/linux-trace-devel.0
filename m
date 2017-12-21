Return-Path: linux-trace-devel-owner@vger.kernel.org
Received: from mail-wr0-f195.google.com ([209.85.128.195]:43400 "EHLO
        mail-wr0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750757AbdLUPZv (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 21 Dec 2017 10:25:51 -0500
From: "Vladislav Valtchev (VMware)" <vladislav.valtchev@gmail.com>
To: rostedt@goodmis.org
Cc: y.karadz@gmail.com, linux-trace-devel@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        "Vladislav Valtchev (VMware)" <vladislav.valtchev@gmail.com>
Subject: [PATCH v2 2/3] trace-cmd: Remove the die() call from read_proc()
Date: Thu, 21 Dec 2017 17:25:19 +0200
Message-Id: <20171221152520.25867-3-vladislav.valtchev@gmail.com>
In-Reply-To: <20171221152520.25867-1-vladislav.valtchev@gmail.com>
References: <20171221152520.25867-1-vladislav.valtchev@gmail.com>
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>

As trace-stack.c's read_proc() function is going to be used by trace-cmd stat,
we don't want it to make the program die in case something went wrong.
Therefore, this simple patch makes read_proc() to just return -1 in case the
proc file was empty or read() failed with an error, instead of using die().

Signed-off-by: Vladislav Valtchev (VMware) <vladislav.valtchev@gmail.com>
---
 trace-stack.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/trace-stack.c b/trace-stack.c
index c1058ca..d55d994 100644
--- a/trace-stack.c
+++ b/trace-stack.c
@@ -79,9 +79,9 @@ static int read_proc(int *status)
 
 	n = read(fd, buf, sizeof(buf));
 
-	/* We assume that the file is never empty we got no errors. */
+	/* The file was empty or read() failed with an error. */
 	if (n <= 0)
-		die("error reading %s", PROC_FILE);
+		return -1;
 
 	/* Does this file have more than 63 characters?? */
 	if (n >= sizeof(buf))
-- 
2.14.1
