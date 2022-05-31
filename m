Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2B7F1C433EF
	for <linux-trace-devel@archiver.kernel.org>; Tue, 31 May 2022 21:24:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346814AbiEaVYo (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 31 May 2022 17:24:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51138 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242150AbiEaVYo (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 31 May 2022 17:24:44 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B1E59A9A8
        for <linux-trace-devel@vger.kernel.org>; Tue, 31 May 2022 14:24:43 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id BB6F9B816CB
        for <linux-trace-devel@vger.kernel.org>; Tue, 31 May 2022 21:24:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A2AB6C385A9;
        Tue, 31 May 2022 21:24:39 +0000 (UTC)
Date:   Tue, 31 May 2022 17:24:35 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Cc:     hws@denx.de
Subject: [PATCH] libtracefs: Allow for the same event to be start and end in
 tracefs_sql()
Message-ID: <20220531172435.2a51eff3@rorschach.local.home>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (Google)" <rostedt@goodmis.org>

When creating a synthetic event that is based off of the same event with
two different fields, it should still work. But the assumption was that
every field that has a label will have the same label, which is not
true.

For example, to create an event that measures the time a task is
blocked, it needs to start and end on the same event (sched_switch), but
just use different fields.

  sqlhist -n blocked 'SELECT end.next_pid AS pid,end.next_comm AS comm,(end.TIMESTAMP_USECS - start.TIMESTAMP_USECS) AS lat
      FROM sched_switch AS start JOIN sched_switch AS end ON start.prev_pid = end.next_pid WHERE start.prev_state = 2'

But this gave the following error:

   Failed creating synthetic event!: Success
   SELECT end.next_pid AS pid,end.next_comm AS comm,(end.TIMESTAMP_USECS - start.TIMESTAMP_USECS) AS lat FROM sched_switch AS start JOIN sched_switch AS end ON start.prev_pid = end.next_pid WHERE start.prev_state = 2
       ^
   ERROR: 'end.next_pid'
   'start.prev_pid' and 'end.next_pid' must be a field for each event: 'sched_switch' and 'sched_switch'

Because the end sched_switch would already have the label "start" and it
would not create one for "end" making the "end" not resolve correctly.

Now it gives the correct answer:

  echo 's:blocked pid_t next_pid; char next_comm[16]; u64 lat;' >> /sys/kernel/tracing/dynamic_events
  echo 'hist:keys=prev_pid:__arg_21065_1=next_pid,__arg_21065_2=next_comm,__arg_21065_3=common_timestamp.usecs if prev_state == 2' >> /sys/kernel/tracing/events/sched/sched_switch/trigger
  echo 'hist:keys=next_pid:next_pid=$__arg_21065_1,next_comm=$__arg_21065_2,lat=common_timestamp.usecs-$__arg_21065_3:onmatch(sched.sched_switch).trace(blocked,$next_pid,$next_comm,$lat)' >> /sys/kernel/tracing/events/sched/sched_switch/trigger

Fixes: 25446407 ("libtracefs: Added new API tracefs_sql()")
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
 src/tracefs-sqlhist.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/src/tracefs-sqlhist.c b/src/tracefs-sqlhist.c
index 9811362..cee037b 100644
--- a/src/tracefs-sqlhist.c
+++ b/src/tracefs-sqlhist.c
@@ -285,6 +285,8 @@ static struct expr *find_field(struct sqlhist_bison *sb,
 		if (!strcmp(field->raw, raw)) {
 			if (label && !field->label)
 				field->label = label;
+			if (label && strcmp(label, field->label) != 0)
+				continue;
 			return expr;
 		}
 
-- 
2.35.1

