Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3526FC4321E
	for <linux-trace-devel@archiver.kernel.org>; Wed, 23 Feb 2022 00:30:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235143AbiBWAap (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 22 Feb 2022 19:30:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35870 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234981AbiBWAam (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 22 Feb 2022 19:30:42 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 069BB5575A
        for <linux-trace-devel@vger.kernel.org>; Tue, 22 Feb 2022 16:30:16 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 958C561313
        for <linux-trace-devel@vger.kernel.org>; Wed, 23 Feb 2022 00:30:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 82DD4C36AE2;
        Wed, 23 Feb 2022 00:30:14 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.95)
        (envelope-from <rostedt@rostedt.homelinux.com>)
        id 1nMfXp-005bGN-Fq;
        Tue, 22 Feb 2022 19:30:13 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-trace-devel@vger.kernel.org
Cc:     "Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH 05/11] libtracefs: Hide tracefs_list_pop() and make it trace_list_pop()
Date:   Tue, 22 Feb 2022 19:30:06 -0500
Message-Id: <20220223003012.1334741-6-rostedt@goodmis.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220223003012.1334741-1-rostedt@goodmis.org>
References: <20220223003012.1334741-1-rostedt@goodmis.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (Google)" <rostedt@goodmis.org>

The tracefs_list_pop() is not ready to be exposed as an API. Make it
hidden and rename it to trace_list_pop().

Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
 include/tracefs-local.h |  1 +
 include/tracefs.h       |  1 -
 src/tracefs-hist.c      | 10 +++++-----
 src/tracefs-utils.c     |  6 +++---
 4 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/include/tracefs-local.h b/include/tracefs-local.h
index bf157e11aaea..926fd02c3d1e 100644
--- a/include/tracefs-local.h
+++ b/include/tracefs-local.h
@@ -71,6 +71,7 @@ struct tracefs_options_mask *
 enabled_opts_mask(struct tracefs_instance *instance);
 
 char **trace_list_create_empty(void);
+int trace_list_pop(char **list);
 
 char *append_string(char *str, const char *delim, const char *add);
 int trace_test_state(int state);
diff --git a/include/tracefs.h b/include/tracefs.h
index 1848ad0aa668..301f1b155ba1 100644
--- a/include/tracefs.h
+++ b/include/tracefs.h
@@ -75,7 +75,6 @@ int tracefs_error_clear(struct tracefs_instance *instance);
 void tracefs_list_free(char **list);
 char **tracefs_list_add(char **list, const char *string);
 int tracefs_list_size(char **list);
-int tracefs_list_pop(char **list);
 
 /**
  * tracefs_trace_on_get_fd - Get a file descriptor of "tracing_on" in given instance
diff --git a/src/tracefs-hist.c b/src/tracefs-hist.c
index aec61ad52e72..5a89be2876d2 100644
--- a/src/tracefs-hist.c
+++ b/src/tracefs-hist.c
@@ -1096,14 +1096,14 @@ static int add_synth_fields(struct tracefs_synth *synth,
 
 	ret = asprintf(&str, "$%s", name);
 	if (ret < 0) {
-		tracefs_list_pop(synth->synthetic_fields);
+		trace_list_pop(synth->synthetic_fields);
 		return -1;
 	}
 
 	list = tracefs_list_add(synth->synthetic_args, str);
 	free(str);
 	if (!list) {
-		tracefs_list_pop(synth->synthetic_fields);
+		trace_list_pop(synth->synthetic_fields);
 		return -1;
 	}
 
@@ -1156,7 +1156,7 @@ int tracefs_synth_add_match_field(struct tracefs_synth *synth,
 
 	list = tracefs_list_add(synth->end_keys, end_match_field);
 	if (!list) {
-		tracefs_list_pop(synth->start_keys);
+		trace_list_pop(synth->start_keys);
 		return -1;
 	}
 	synth->end_keys = list;
@@ -1176,8 +1176,8 @@ int tracefs_synth_add_match_field(struct tracefs_synth *synth,
 	return 0;
 
  pop_lists:
-	tracefs_list_pop(synth->start_keys);
-	tracefs_list_pop(synth->end_keys);
+	trace_list_pop(synth->start_keys);
+	trace_list_pop(synth->end_keys);
 	return -1;
 }
 
diff --git a/src/tracefs-utils.c b/src/tracefs-utils.c
index a502c2dec736..0ad9a35e7819 100644
--- a/src/tracefs-utils.c
+++ b/src/tracefs-utils.c
@@ -448,14 +448,14 @@ char **tracefs_list_add(char **list, const char *string)
 	return list;
 }
 
-/**
- * tracefs_list_pop - Removes the last string added
+/*
+ * trace_list_pop - Removes the last string added
  * @list: The list to remove the last event from
  *
  * Returns 0 on success, -1 on error.
  * Returns 1 if the list is empty or NULL.
  */
-int tracefs_list_pop(char **list)
+__hidden int trace_list_pop(char **list)
 {
 	unsigned long size;
 
-- 
2.34.1

