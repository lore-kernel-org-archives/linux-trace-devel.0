Return-Path: <SRS0=R/5S=OM=vger.kernel.org=linux-trace-devel-owner@goodmis.org>
Received: from mail-wr1-f68.google.com ([209.85.221.68]:37435 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725874AbeLCJT6 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 3 Dec 2018 04:19:58 -0500
Received: by mail-wr1-f68.google.com with SMTP id j10so11277566wru.4
        for <linux-trace-devel@vger.kernel.org>; Mon, 03 Dec 2018 01:19:46 -0800 (PST)
From: Slavomir Kaslev <kaslevs@vmware.com>
To: rostedt@goodmis.org
Cc: linux-trace-devel@vger.kernel.org, ykaradzhov@vmware.com
Subject: [PATCH] trace-cmd: Fix make clean error
Date: Mon,  3 Dec 2018 11:19:36 +0200
Message-Id: <20181203091936.2881-1-kaslevs@vmware.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>

Fix make clean failing when cmake hasn't generated Makefile for KernelShark:

    $ make clean
    # ...
    make -C /home/kaslevs/src/trace-cmd/kernel-shark-qt/build clean
    make[1]: *** No rule to make target 'clean'.  Stop.
    make: *** [Makefile:365: clean] Error 2

Signed-off-by: Slavomir Kaslev <kaslevs@vmware.com>
---
 Makefile | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/Makefile b/Makefile
index 7ee9e0d..562afd1 100644
--- a/Makefile
+++ b/Makefile
@@ -361,11 +361,11 @@ clean:
 	$(RM) tags TAGS cscope*
 	$(MAKE) -C $(src)/lib/traceevent clean
 	$(MAKE) -C $(src)/lib/trace-cmd clean
-	$(MAKE) -C $(src)/kernel-shark clean
-	$(MAKE) -C $(kshark-dir)/build clean
 	$(MAKE) -C $(src)/plugins clean
 	$(MAKE) -C $(src)/python clean
 	$(MAKE) -C $(src)/tracecmd clean
+	$(MAKE) -C $(src)/kernel-shark clean
+	if [ -f $(kshark-dir)/build/Makefile ]; then $(MAKE) -C $(kshark-dir)/build clean; fi
 
 
 ##### PYTHON STUFF #####
-- 
2.19.1
