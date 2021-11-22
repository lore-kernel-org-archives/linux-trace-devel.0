Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 91515C433F5
	for <linux-trace-devel@archiver.kernel.org>; Mon, 22 Nov 2021 23:50:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231976AbhKVXxR (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 22 Nov 2021 18:53:17 -0500
Received: from ex13-edg-ou-001.vmware.com ([208.91.0.189]:32631 "EHLO
        EX13-EDG-OU-001.vmware.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231950AbhKVXxQ (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 22 Nov 2021 18:53:16 -0500
Received: from sc9-mailhost1.vmware.com (10.113.161.71) by
 EX13-EDG-OU-001.vmware.com (10.113.208.155) with Microsoft SMTP Server id
 15.0.1156.6; Mon, 22 Nov 2021 15:50:07 -0800
Received: from vypre.local.home (unknown [10.21.245.36])
        by sc9-mailhost1.vmware.com (Postfix) with ESMTP id F1A3E20349;
        Mon, 22 Nov 2021 15:50:08 -0800 (PST)
From:   Steven Rostedt <rostedt@goodmis.org>
To:     <linux-trace-devel@vger.kernel.org>
CC:     "Steven Rostedt (VMware)" <rostedt@goodmis.org>
Subject: [PATCH 08/11] libtracefs/Documentation: Fix function-filter call to tracefs_list_free()
Date:   Mon, 22 Nov 2021 18:49:53 -0500
Message-ID: <20211122234956.788401-9-rostedt@goodmis.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211122234956.788401-1-rostedt@goodmis.org>
References: <20211122234956.788401-1-rostedt@goodmis.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
Received-SPF: None (EX13-EDG-OU-001.vmware.com: rostedt@goodmis.org does not
 designate permitted sender hosts)
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (VMware)" <rostedt@goodmis.org>

The function-filter man page example used tracefs_free_list() instead of
tracefs_list_free()

Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
---
 Documentation/libtracefs-function-filter.txt | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Documentation/libtracefs-function-filter.txt b/Documentation/libtracefs-function-filter.txt
index ac43d9b..23ba2b8 100644
--- a/Documentation/libtracefs-function-filter.txt
+++ b/Documentation/libtracefs-function-filter.txt
@@ -152,7 +152,7 @@ int main(int argc, char *argv[])
 	printf("Ignoring the following functions:\n");
 	for (i = 0; func_list[i]; i++)
 		printf("  %s\n", func_list[i]);
-	tracefs_free_list(func_list);
+	tracefs_list_free(func_list);
 
 	/* Do not trace any function with the word "lock" in it */
 	ret = tracefs_function_notrace(inst, "*lock*", NULL, TRACEFS_FL_RESET);
-- 
2.31.1

