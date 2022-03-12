Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 023FFC433EF
	for <linux-trace-devel@archiver.kernel.org>; Sat, 12 Mar 2022 01:01:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229808AbiCLBCx (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 11 Mar 2022 20:02:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48228 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229637AbiCLBCw (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 11 Mar 2022 20:02:52 -0500
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 2171B1E5028
        for <linux-trace-devel@vger.kernel.org>; Fri, 11 Mar 2022 17:01:48 -0800 (PST)
Received: from localhost.localdomain (c-73-140-2-214.hsd1.wa.comcast.net [73.140.2.214])
        by linux.microsoft.com (Postfix) with ESMTPSA id A45FF20B7178;
        Fri, 11 Mar 2022 17:01:47 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com A45FF20B7178
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
        s=default; t=1647046907;
        bh=2E+o0MmvfRD0N/Oi1whtsVf2wmIEE3tS9ctJJHsO6qU=;
        h=From:To:Cc:Subject:Date:From;
        b=Lt++efqAMYOxnhNZ0kppyBf//p7jIyto1yT6Q51AvYQC/pTxX1F86LHMSr0jELUOu
         y+PI1P7mNKbIMvGprjpd0/xLBmymjhRMIJIbGEp09nccA00W00xVileFhpkbwiexyx
         rITR42RRbGYliopg6XuDLSXSaLxQk1+Y5SIuVQTw=
From:   Beau Belgrave <beaub@linux.microsoft.com>
To:     rostedt@goodmis.org, mhiramat@kernel.org
Cc:     linux-trace-devel@vger.kernel.org, beaub@linux.microsoft.com
Subject: [RFC PATCH] tracing/user_events: Limit showing event names to CAP_SYS_ADMIN users
Date:   Fri, 11 Mar 2022 17:01:40 -0800
Message-Id: <20220312010140.1880-1-beaub@linux.microsoft.com>
X-Mailer: git-send-email 2.17.1
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Show actual names only to CAP_SYS_ADMIN capable users.

When user_events are configured to have broader write access than
default, this allows seeing names of events from other containers, etc.
Limit who can see the actual names to prevent event squatting or
information leakage.

Signed-off-by: Beau Belgrave <beaub@linux.microsoft.com>
---
 kernel/trace/trace_events_user.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/kernel/trace/trace_events_user.c b/kernel/trace/trace_events_user.c
index 2b5e9fdb63a0..fb9fb2071173 100644
--- a/kernel/trace/trace_events_user.c
+++ b/kernel/trace/trace_events_user.c
@@ -1480,6 +1480,9 @@ static int user_seq_show(struct seq_file *m, void *p)
 	struct user_event *user;
 	char status;
 	int i, active = 0, busy = 0, flags;
+	bool show_names;
+
+	show_names = capable(CAP_SYS_ADMIN);
 
 	mutex_lock(&reg_mutex);
 
@@ -1487,7 +1490,10 @@ static int user_seq_show(struct seq_file *m, void *p)
 		status = register_page_data[user->index];
 		flags = user->flags;
 
-		seq_printf(m, "%d:%s", user->index, EVENT_NAME(user));
+		if (show_names)
+			seq_printf(m, "%d:%s", user->index, EVENT_NAME(user));
+		else
+			seq_printf(m, "%d:<hidden>", user->index);
 
 		if (flags != 0 || status != 0)
 			seq_puts(m, " #");

base-commit: 864ea0e10cc90416a01b46f0d47a6f26dc020820
-- 
2.17.1

