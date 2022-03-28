Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A4FD1C433EF
	for <linux-trace-devel@archiver.kernel.org>; Mon, 28 Mar 2022 22:32:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229883AbiC1WeM (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 28 Mar 2022 18:34:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44550 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229821AbiC1WeM (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 28 Mar 2022 18:34:12 -0400
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 2721B1EEC1;
        Mon, 28 Mar 2022 15:32:30 -0700 (PDT)
Received: from localhost.localdomain (c-73-140-2-214.hsd1.wa.comcast.net [73.140.2.214])
        by linux.microsoft.com (Postfix) with ESMTPSA id 74AE320DEDC7;
        Mon, 28 Mar 2022 15:32:29 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 74AE320DEDC7
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
        s=default; t=1648506749;
        bh=rDdctiN4V0lx1299/QwvJZQHMCgA3eqz5OdsVHshV3A=;
        h=From:To:Cc:Subject:Date:From;
        b=no0jLGqXvSCYHNPwS+X5/XjzHfK//pe7YH5TVjkYTM4ffpGo4o6lSjiIzUJ0imfg2
         +55ZaTt4FR6G/BFbRh4rmhle9oEaDjP+Kl3DJxRRXCUQTvEBv7Ym56ltaLvVo/vSss
         EDSSRSVuhfLMy/kQ4kSrQBvPjlzcciwibjGZ3Trc=
From:   Beau Belgrave <beaub@linux.microsoft.com>
To:     rostedt@goodmis.org, mhiramat@kernel.org
Cc:     mathieu.desnoyers@efficios.com, linux-trace-devel@vger.kernel.org,
        linux-kernel@vger.kernel.org, beaub@linux.microsoft.com
Subject: [PATCH] tracing/user_events: Hold event_mutex during dyn_event_add
Date:   Mon, 28 Mar 2022 15:32:25 -0700
Message-Id: <20220328223225.1992-1-beaub@linux.microsoft.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Make sure the event_mutex is properly held during dyn_event_add call.
This is required when adding dynamic events.

Reported-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Signed-off-by: Beau Belgrave <beaub@linux.microsoft.com>
---
 kernel/trace/trace_events_user.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/kernel/trace/trace_events_user.c b/kernel/trace/trace_events_user.c
index 8b3d241a31c2..61d78d64bdf0 100644
--- a/kernel/trace/trace_events_user.c
+++ b/kernel/trace/trace_events_user.c
@@ -1165,11 +1165,11 @@ static int user_event_parse(char *name, char *args, char *flags,
 #endif
 
 	mutex_lock(&event_mutex);
+
 	ret = user_event_trace_register(user);
-	mutex_unlock(&event_mutex);
 
 	if (ret)
-		goto put_user;
+		goto put_user_lock;
 
 	user->index = index;
 
@@ -1181,8 +1181,12 @@ static int user_event_parse(char *name, char *args, char *flags,
 	set_bit(user->index, page_bitmap);
 	hash_add(register_table, &user->node, key);
 
+	mutex_unlock(&event_mutex);
+
 	*newuser = user;
 	return 0;
+put_user_lock:
+	mutex_unlock(&event_mutex);
 put_user:
 	user_event_destroy_fields(user);
 	user_event_destroy_validators(user);

base-commit: c87857e214862a125208a4b1a510839d0c5a1bd4
-- 
2.25.1

