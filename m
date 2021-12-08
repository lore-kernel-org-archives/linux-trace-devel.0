Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C0DF3C433EF
	for <linux-trace-devel@archiver.kernel.org>; Wed,  8 Dec 2021 14:34:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235209AbhLHOhm (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 8 Dec 2021 09:37:42 -0500
Received: from smtp1.axis.com ([195.60.68.17]:10127 "EHLO smtp1.axis.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231621AbhLHOhl (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 8 Dec 2021 09:37:41 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=axis.com; q=dns/txt; s=axis-central1; t=1638974050;
  x=1670510050;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=V1IRJDrb89QQNhM5uaiOIalHicu0tSd4JZjBrGugfto=;
  b=iaLu/LRpHkjofWDpbuHRiBJkN0RSngS8wGP05F27kjw8OnyqMn3tF0au
   oBaDzALnEMx7iw6c8BocP6x65G/Zd6Wr0wo1CczQBAcUxCm1fXR4UgdXS
   VPaqIQ9hekfCU1SH9hJiCrS2nrdmzMaTbBXJJBAxpb7jyXCX9WUTZLuWS
   zbbW9lhgyGetBSQZzkNEenejvtWYyEq1rXDwfmKVgCmabNSntuzO9UDWD
   FJHWP3WkU1YtyUPejKh6KLexu4341y6/7GV8yD8i8yIUCd/LfNMFh69oE
   mlVLewkw3uPmO8olThoUj5IKQgVfW42C2MX4AS3B3qQaeVQbujoT/0YpQ
   w==;
From:   Vincent Whitchurch <vincent.whitchurch@axis.com>
To:     <rostedt@goodmis.org>
CC:     <linux-trace-devel@vger.kernel.org>, <kernel@axis.com>,
        Vincent Whitchurch <vincent.whitchurch@axis.com>
Subject: [PATCH v2] trace-cmd report: Avoid crash on unknown event
Date:   Wed, 8 Dec 2021 15:34:02 +0100
Message-ID: <20211208143402.28076-1-vincent.whitchurch@axis.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Do not segfault if the event cannot be found for some reason and
tep_find_event_by_record() returns NULL.

With this patch:

 kworker/u8:0-7 [003] 1.245773: sched_stat_runtime: comm=kworker/u8:...
[UNKNOWN EVENT][UNKNOWN EVENT] (NULL):               [UNKNOWN EVENT]
 kworker/u8:0-7 [003] 1.245776: sched_switch: kworker/u8:0:7 [120] W...

Suggested-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
Signed-off-by: Vincent Whitchurch <vincent.whitchurch@axis.com>
---
 tracecmd/trace-read.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/tracecmd/trace-read.c b/tracecmd/trace-read.c
index 6f43c1d..df40b75 100644
--- a/tracecmd/trace-read.c
+++ b/tracecmd/trace-read.c
@@ -142,12 +142,13 @@ static struct trace_hash wakeup_hash;
 static void print_event_name(struct trace_seq *s, struct tep_event *event)
 {
 	static const char *spaces = "                    "; /* 20 spaces */
+	const char *name = event ? event->name : "(NULL)";
 	int len;
 
-	trace_seq_printf(s, " %s: ", event->name);
+	trace_seq_printf(s, " %s: ", name);
 
 	/* Space out the event names evenly. */
-	len = strlen(event->name);
+	len = strlen(name);
 	if (len < 20)
 		trace_seq_printf(s, "%.*s", 20 - len, spaces);
 }
-- 
2.20.1

