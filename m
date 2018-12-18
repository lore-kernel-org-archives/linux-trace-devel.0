Return-Path: <SRS0=lLmH=O3=vger.kernel.org=linux-trace-devel-owner@goodmis.org>
Received: from mail-wr1-f68.google.com ([209.85.221.68]:38247 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726446AbeLRKjc (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 18 Dec 2018 05:39:32 -0500
Received: by mail-wr1-f68.google.com with SMTP id v13so15341191wrw.5
        for <linux-trace-devel@vger.kernel.org>; Tue, 18 Dec 2018 02:39:30 -0800 (PST)
From: Tzvetomir Stoyanov <tstoyanov@vmware.com>
To: rostedt@goodmis.org
Cc: linux-trace-devel@vger.kernel.org
Subject: [PATCH] trace-cmd: fix deletion of histogram triggers
Date: Tue, 18 Dec 2018 12:39:28 +0200
Message-Id: <20181218103928.18345-1-tstoyanov@vmware.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>

This patch fixes the clear_trigger() function to delete
configured histograms. Unlike other triggers, histograms
must be deleted specifying the whole trigger string.

Signed-off-by: Tzvetomir Stoyanov <tstoyanov@vmware.com>
---
 tracecmd/trace-record.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tracecmd/trace-record.c b/tracecmd/trace-record.c
index a9bcd8d..37a2d1d 100644
--- a/tracecmd/trace-record.c
+++ b/tracecmd/trace-record.c
@@ -1680,7 +1680,7 @@ static void clear_trigger(const char *file)
 	 * to the file for each trigger.
 	 */
 	do {
-		len = find_trigger(file, trigger+1, BUFSIZ-1, 1);
+		len = find_trigger(file, trigger+1, BUFSIZ-1, 3);
 		if (len)
 			write_trigger(file, trigger);
 	} while (len);
-- 
2.19.2
