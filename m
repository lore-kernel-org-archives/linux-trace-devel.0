Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 34C0CC433FE
	for <linux-trace-devel@archiver.kernel.org>; Wed, 10 Nov 2021 23:25:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1851161267
	for <linux-trace-devel@archiver.kernel.org>; Wed, 10 Nov 2021 23:25:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234161AbhKJX21 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 10 Nov 2021 18:28:27 -0500
Received: from ex13-edg-ou-002.vmware.com ([208.91.0.190]:34883 "EHLO
        EX13-EDG-OU-002.vmware.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233965AbhKJX21 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 10 Nov 2021 18:28:27 -0500
X-Greylist: delayed 903 seconds by postgrey-1.27 at vger.kernel.org; Wed, 10 Nov 2021 18:28:26 EST
Received: from sc9-mailhost3.vmware.com (10.113.161.73) by
 EX13-EDG-OU-002.vmware.com (10.113.208.156) with Microsoft SMTP Server id
 15.0.1156.6; Wed, 10 Nov 2021 15:10:30 -0800
Received: from vypre.local.home (unknown [10.21.244.28])
        by sc9-mailhost3.vmware.com (Postfix) with ESMTP id 24C7E2056D;
        Wed, 10 Nov 2021 15:10:35 -0800 (PST)
From:   Steven Rostedt <rostedt@goodmis.org>
To:     <linux-trace-devel@vger.kernel.org>
CC:     "Steven Rostedt (VMware)" <rostedt@goodmis.org>
Subject: [PATCH 1/2] tracefs Documentation: Fix tracefs_hist_add_sort_key() example
Date:   Wed, 10 Nov 2021 18:10:24 -0500
Message-ID: <20211110231025.1131051-2-rostedt@goodmis.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211110231025.1131051-1-rostedt@goodmis.org>
References: <20211110231025.1131051-1-rostedt@goodmis.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
Received-SPF: None (EX13-EDG-OU-002.vmware.com: rostedt@goodmis.org does not
 designate permitted sender hosts)
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (VMware)" <rostedt@goodmis.org>

The tracefs_hist_add_sort_key() example in the man page had the old usage
of variable args. Update it to use the new "one at a time" version.

Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
---
 Documentation/libtracefs-hist.txt | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/Documentation/libtracefs-hist.txt b/Documentation/libtracefs-hist.txt
index 0139ba8..cc82286 100644
--- a/Documentation/libtracefs-hist.txt
+++ b/Documentation/libtracefs-hist.txt
@@ -282,7 +282,8 @@ int main (int argc, char **argv, char **env)
 	}
 
 	ret = tracefs_hist_add_value(hist, "bytes_alloc");
-	ret |= tracefs_hist_add_sort_key(hist, "bytes_req", "bytes_alloc", NULL);
+	ret |= tracefs_hist_add_sort_key(hist, "bytes_req");
+	ret |= tracefs_hist_add_sort_key(hist, "bytes_alloc");
 
 	ret |= tracefs_hist_sort_key_direction(hist, "bytes_alloc",
 					       TRACEFS_HIST_SORT_DESCENDING);
-- 
2.31.1

