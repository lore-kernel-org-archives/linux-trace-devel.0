Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 69CA9C636C8
	for <linux-trace-devel@archiver.kernel.org>; Thu, 22 Jul 2021 03:39:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3EC2361287
	for <linux-trace-devel@archiver.kernel.org>; Thu, 22 Jul 2021 03:39:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230026AbhGVC67 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 21 Jul 2021 22:58:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:52582 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229900AbhGVC67 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 21 Jul 2021 22:58:59 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F0EDC610CC;
        Thu, 22 Jul 2021 03:39:34 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.94.2)
        (envelope-from <rostedt@rostedt.homelinux.com>)
        id 1m6PYb-001Xmo-NW; Wed, 21 Jul 2021 23:39:33 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-trace-devel@vger.kernel.org
Cc:     Tom Zanussi <zanussi@kernel.org>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Namhyung Kim <namhyung@kernel.org>,
        "Steven Rostedt (VMware)" <rostedt@goodmis.org>
Subject: [PATCH 3/4] libtracefs: Add TRACEFS_TIMESTAMP and TRACEFS_TIMESTAMP_USECS to synth
Date:   Wed, 21 Jul 2021 23:39:16 -0400
Message-Id: <20210722033917.367982-4-rostedt@goodmis.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210722033917.367982-1-rostedt@goodmis.org>
References: <20210722033917.367982-1-rostedt@goodmis.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (VMware)" <rostedt@goodmis.org>

Add the fields of TRACEFS_TIMESTAMP and TRACEFS_TIMESTAMP_USECS that can
be used to calculate the timestamps between the events for the synthetic
event creation.

Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
---
 include/tracefs.h  |  3 +++
 src/tracefs-hist.c | 50 ++++++++++++++++++++++++++++++++++------------
 2 files changed, 40 insertions(+), 13 deletions(-)

diff --git a/include/tracefs.h b/include/tracefs.h
index 226ddff17f2f..f4cd1cbefdbb 100644
--- a/include/tracefs.h
+++ b/include/tracefs.h
@@ -324,6 +324,9 @@ enum tracefs_synth_compare {
 	TRACEFS_COMPARE_AND,
 };
 
+#define TRACEFS_TIMESTAMP "common_timestamp"
+#define TRACEFS_TIMESTAMP_USECS "common_timestamp.usecs"
+
 struct tracefs_synth *tracefs_synth_init(struct tep_handle *tep,
 					 const char *name,
 					 const char *start_system,
diff --git a/src/tracefs-hist.c b/src/tracefs-hist.c
index 77aff4e9d8e4..62eff6baa044 100644
--- a/src/tracefs-hist.c
+++ b/src/tracefs-hist.c
@@ -563,6 +563,18 @@ struct tracefs_synth {
 	int			arg_cnt;
 };
 
+static const struct tep_format_field common_timestamp = {
+	.type			= "u64",
+	.name			= "common_timestamp",
+	.size			= 8,
+};
+
+static const struct tep_format_field common_timestamp_usecs = {
+	.type			= "u64",
+	.name			= "common_timestamp.usecs",
+	.size			= 8,
+};
+
 void tracefs_synth_free(struct tracefs_synth *synth)
 {
 	if (!synth)
@@ -583,21 +595,33 @@ void tracefs_synth_free(struct tracefs_synth *synth)
 	free(synth);
 }
 
+static const struct tep_format_field *get_event_field(struct tep_event *event,
+					 const char *field_name)
+{
+	if (!strcmp(field_name, TRACEFS_TIMESTAMP))
+		return &common_timestamp;
+
+	if (!strcmp(field_name, TRACEFS_TIMESTAMP_USECS))
+		return &common_timestamp_usecs;
+
+	return tep_find_any_field(event, field_name);
+}
+
 static bool verify_event_fields(struct tep_event *start_event,
 				struct tep_event *end_event,
 				const char *start_field_name,
 				const char *end_field_name,
-				struct tep_format_field **ptr_start_field)
+				const struct tep_format_field **ptr_start_field)
 {
-	struct tep_format_field *start_field;
-	struct tep_format_field *end_field;
+	const struct tep_format_field *start_field;
+	const struct tep_format_field *end_field;
 
-	start_field = tep_find_any_field(start_event, start_field_name);
+	start_field = get_event_field(start_event, start_field_name);
 	if (!start_field)
 		goto nodev;
 
 	if (end_event) {
-		end_field = tep_find_any_field(end_event, end_field_name);
+		end_field = get_event_field(end_event, end_field_name);
 		if (!start_field)
 			goto nodev;
 
@@ -644,7 +668,7 @@ static char *append_string(char *str, const char *space, const char *add)
 	return str;
 }
 
-static char *add_synth_field(struct tep_format_field *field,
+static char *add_synth_field(const struct tep_format_field *field,
 			     const char *name)
 {
 	const char *type;
@@ -829,7 +853,7 @@ struct tracefs_synth *tracefs_synth_init(struct tep_handle *tep,
 }
 
 static int add_synth_fields(struct tracefs_synth *synth,
-			    struct tep_format_field *field,
+			    const struct tep_format_field *field,
 			    const char *name)
 {
 	char **list;
@@ -886,7 +910,7 @@ int tracefs_synth_add_match_field(struct tracefs_synth *synth,
 				  const char *start_match_field,
 				  const char *end_match_field)
 {
-	struct tep_format_field *key_field;
+	const struct tep_format_field *key_field;
 	char **list;
 	int ret;
 
@@ -976,7 +1000,7 @@ int tracefs_synth_add_compare_field(struct tracefs_synth *synth,
 				    const char *end_compare_field,
 				    enum tracefs_synth_calc calc)
 {
-	struct tep_format_field *start_field;
+	const struct tep_format_field *start_field;
 	char *start_arg;
 	char *compare;
 	int ret;
@@ -1061,7 +1085,7 @@ int tracefs_synth_add_start_field(struct tracefs_synth *synth,
 				  const char *name,
 				  const char *start_field)
 {
-	struct tep_format_field *field;
+	const struct tep_format_field *field;
 	char *start_arg;
 	int ret;
 
@@ -1115,7 +1139,7 @@ int tracefs_synth_add_end_field(struct tracefs_synth *synth,
 				const char *name,
 				const char *end_field)
 {
-	struct tep_format_field *field;
+	const struct tep_format_field *field;
 	int ret;
 
 	if (!synth || !end_field) {
@@ -1236,7 +1260,7 @@ int tracefs_synth_add_start_filter(struct tracefs_synth *synth,
 				   const char *val,
 				   bool neg, bool or)
 {
-	struct tep_format_field *start_field;
+	const struct tep_format_field *start_field;
 	bool is_string;
 
 	if (!field || !val)
@@ -1265,7 +1289,7 @@ int tracefs_synth_add_end_filter(struct tracefs_synth *synth,
 				 const char *val,
 				 bool neg, bool or)
 {
-	struct tep_format_field *end_field;
+	const struct tep_format_field *end_field;
 	bool is_string;
 
 	if (!field || !val)
-- 
2.30.2

