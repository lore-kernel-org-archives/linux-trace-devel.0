Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 811E0C4338F
	for <linux-trace-devel@archiver.kernel.org>; Thu, 12 Aug 2021 00:55:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 612EC6105A
	for <linux-trace-devel@archiver.kernel.org>; Thu, 12 Aug 2021 00:55:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233209AbhHLA4N (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 11 Aug 2021 20:56:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:35972 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233085AbhHLA4N (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 11 Aug 2021 20:56:13 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 592A46104F;
        Thu, 12 Aug 2021 00:55:49 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.94.2)
        (envelope-from <rostedt@rostedt.homelinux.com>)
        id 1mDz0e-003oyX-3I; Wed, 11 Aug 2021 20:55:48 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-trace-devel@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, Tom Zanussi <zanussi@kernel.org>,
        Daniel Bristot de Oliveira <bristot@redhat.com>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        "Steven Rostedt (VMware)" <rostedt@goodmis.org>
Subject: [PATCH 2/2] libtracefs: Have end event variables not be the end event field name
Date:   Wed, 11 Aug 2021 20:55:46 -0400
Message-Id: <20210812005546.910833-3-rostedt@goodmis.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210812005546.910833-1-rostedt@goodmis.org>
References: <20210812005546.910833-1-rostedt@goodmis.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (VMware)" <rostedt@goodmis.org>

Currently we have:

 # sqlhist -n wakeup 'select end.next_pid, (end.TIMESTAMP - start.TIMESTAMP) as lat
   from sched_waking as start join sched_switch as end on start.pid = end.next_pid'

produces:

 echo 'wakeup s32 next_pid; u64 lat;' > /sys/kernel/tracing/synthetic_events
 echo 'hist:keys=pid:__arg_18871_1=common_timestamp' > /sys/kernel/tracing/events/sched/sched_waking/trigger
 echo 'hist:keys=next_pid:next_pid=next_pid,lat=common_timestamp-$__arg_18871_1:onmatch(sched.sched_waking).trace(wakeup,$next_pid,$lat)' > /sys/kernel/tracing/events/sched/sched_switch/trigger

The issue is that we have "next_pid=next_pid" where if we want to change
the above to use the "save" action:

 hist:keys=next_pid:next_pid=next_pid,lat=common_timestamp-$__arg_18871_1:onmax($lat).save(next_pid)

It fails with:

   hist:sched:sched_switch: error: Couldn't find field
    Command: hist:keys=next_pid:next_pid=next_pid,lat=common_timestamp-$__arg_18871_1:onmax($lat).save(next_pid)
                                                                       ^

But by having the end vars be unique, then the above "save" works.

Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
---
 src/tracefs-hist.c | 22 +++++++++++++---------
 1 file changed, 13 insertions(+), 9 deletions(-)

diff --git a/src/tracefs-hist.c b/src/tracefs-hist.c
index 8783ef4364bd..1e6bde7880f2 100644
--- a/src/tracefs-hist.c
+++ b/src/tracefs-hist.c
@@ -851,16 +851,19 @@ struct tracefs_synth *tracefs_synth_init(struct tep_handle *tep,
 
 static int add_synth_fields(struct tracefs_synth *synth,
 			    const struct tep_format_field *field,
-			    const char *name)
+			    const char *name, const char *var)
 {
 	char **list;
 	char *str;
 	int ret;
 
-	str = add_synth_field(field, name);
+	str = add_synth_field(field, name ? : field->name);
 	if (!str)
 		return -1;
 
+	if (!name)
+		name = var;
+
 	list = tracefs_list_add(synth->synthetic_fields, str);
 	free(str);
 	if (!list)
@@ -942,7 +945,7 @@ int tracefs_synth_add_match_field(struct tracefs_synth *synth,
 	if (ret < 0)
 		goto pop_lists;
 
-	ret = add_synth_fields(synth, key_field, name);
+	ret = add_synth_fields(synth, key_field, name, NULL);
 	if (ret < 0)
 		goto pop_lists;
 
@@ -1061,7 +1064,7 @@ int tracefs_synth_add_compare_field(struct tracefs_synth *synth,
 	if (ret < 0)
 		goto out_free;
 
-	ret = add_synth_fields(synth, start_field, name);
+	ret = add_synth_fields(synth, start_field, name, NULL);
 	if (ret < 0)
 		goto out_free;
 
@@ -1106,7 +1109,7 @@ __hidden int synth_add_start_field(struct tracefs_synth *synth,
 	if (ret)
 		goto out_free;
 
-	ret = add_synth_fields(synth, field, name);
+	ret = add_synth_fields(synth, field, name, NULL);
 	if (ret)
 		goto out_free;
 
@@ -1178,6 +1181,7 @@ int tracefs_synth_add_end_field(struct tracefs_synth *synth,
 				const char *name)
 {
 	const struct tep_format_field *field;
+	char *tmp_var = NULL;
 	int ret;
 
 	if (!synth || !end_field) {
@@ -1186,17 +1190,17 @@ int tracefs_synth_add_end_field(struct tracefs_synth *synth,
 	}
 
 	if (!name)
-		name = end_field;
+		tmp_var = new_arg(synth);
 
 	if (!trace_verify_event_field(synth->end_event, end_field, &field))
 		return -1;
 
-	ret = add_var(&synth->end_vars, name, end_field, false);
+	ret = add_var(&synth->end_vars, name ? : tmp_var, end_field, false);
 	if (ret)
 		goto out;
 
-	ret = add_synth_fields(synth, field, name);
-
+	ret = add_synth_fields(synth, field, name, tmp_var);
+	free(tmp_var);
  out:
 	return ret;
 }
-- 
2.30.2

