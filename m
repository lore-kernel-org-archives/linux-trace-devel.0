Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B1B63C43216
	for <linux-trace-devel@archiver.kernel.org>; Tue, 10 Aug 2021 20:48:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8D8CE610FC
	for <linux-trace-devel@archiver.kernel.org>; Tue, 10 Aug 2021 20:48:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230181AbhHJUst (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 10 Aug 2021 16:48:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:44258 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231338AbhHJUsr (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 10 Aug 2021 16:48:47 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4A8D361077;
        Tue, 10 Aug 2021 20:48:25 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.94.2)
        (envelope-from <rostedt@rostedt.homelinux.com>)
        id 1mDYfg-003hA9-4u; Tue, 10 Aug 2021 16:48:24 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-trace-devel@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, Tom Zanussi <zanussi@kernel.org>,
        Daniel Bristot de Oliveira <bristot@redhat.com>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Namhyung Kim <namhyung@kernel.org>,
        linux-rt-users <linux-rt-users@vger.kernel.org>,
        Clark Williams <williams@redhat.com>,
        "Steven Rostedt (VMware)" <rostedt@goodmis.org>
Subject: [PATCH 3/9] libtracefs: Change hist_data_key type to flags
Date:   Tue, 10 Aug 2021 16:48:12 -0400
Message-Id: <20210810204818.880714-4-rostedt@goodmis.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210810204818.880714-1-rostedt@goodmis.org>
References: <20210810204818.880714-1-rostedt@goodmis.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (VMware)" <rostedt@goodmis.org>

As the tracefs_hist_bucket_key will be exposed to users of the library,
have the type be flags, where it can be modified in the future, and not
break backward compatibility.

Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
---
 src/tracefs-hist-data.c | 41 +++++++++++++++++++++--------------------
 1 file changed, 21 insertions(+), 20 deletions(-)

diff --git a/src/tracefs-hist-data.c b/src/tracefs-hist-data.c
index 6ec262e8b180..c7e110559ee8 100644
--- a/src/tracefs-hist-data.c
+++ b/src/tracefs-hist-data.c
@@ -113,10 +113,10 @@ static char *name_token(enum yytokentype type)
 	return NULL;
 }
 
-enum tracefs_bucket_key_type {
-	TRACEFS_BUCKET_KEY_UNDEF,
-	TRACEFS_BUCKET_KEY_SINGLE,
-	TRACEFS_BUCKET_KEY_RANGE,
+enum tracefs_bucket_key_flags {
+	TRACEFS_BUCKET_KEY_FL_UNDEF	= (1 << 29),
+	TRACEFS_BUCKET_KEY_FL_SINGLE	= (1 << 30),
+	TRACEFS_BUCKET_KEY_FL_RANGE	= (1 << 31),
 };
 
 struct tracefs_hist_bucket_key_single {
@@ -131,7 +131,7 @@ struct tracefs_hist_bucket_key_range {
 
 struct tracefs_hist_bucket_key {
 	struct tracefs_hist_bucket_key	*next;
-	enum tracefs_bucket_key_type	type;
+	unsigned int			flags;
 	union {
 		struct tracefs_hist_bucket_key_single	single;
 		struct tracefs_hist_bucket_key_range	range;
@@ -210,6 +210,8 @@ static int start_new_row(struct tracefs_hist_data *hdata)
 		return -1;
 	}
 
+	key->flags = TRACEFS_BUCKET_KEY_FL_UNDEF;
+
 	bucket->keys = key;
 	bucket->next_key = &key->next;
 
@@ -233,6 +235,8 @@ static int start_new_key(struct tracefs_hist_data *hdata)
 		return -1;
 	}
 
+	key->flags = TRACEFS_BUCKET_KEY_FL_UNDEF;
+
 	*bucket->next_key = key;
 	bucket->next_key = &key->next;
 
@@ -385,12 +389,13 @@ static int __do_key_val(struct tracefs_hist_data *hdata,
 	bucket = container_of(hdata->next_bucket, struct tracefs_hist_bucket, next);
 
 	key = container_of(bucket->next_key, struct tracefs_hist_bucket_key, next);
-	if (!key->type)
-		key->type = TRACEFS_BUCKET_KEY_SINGLE;
-
-	if (key->type != TRACEFS_BUCKET_KEY_SINGLE)
+	if (!(key->flags &
+	      (TRACEFS_BUCKET_KEY_FL_UNDEF | TRACEFS_BUCKET_KEY_FL_SINGLE)))
 		return -1;
 
+	key->flags &= ~TRACEFS_BUCKET_KEY_FL_UNDEF;
+	key->flags |= TRACEFS_BUCKET_KEY_FL_SINGLE;
+
 	k = &key->single;
 
 	len = strlen(text);
@@ -455,7 +460,7 @@ static int do_key_raw(struct tracefs_hist_data *hdata, char *text)
 	bucket = container_of(hdata->next_bucket, struct tracefs_hist_bucket, next);
 
 	key = container_of(bucket->next_key, struct tracefs_hist_bucket_key, next);
-	if (key->type != TRACEFS_BUCKET_KEY_SINGLE)
+	if (!(key->flags & TRACEFS_BUCKET_KEY_FL_SINGLE))
 		return -1;
 
 	k = &key->single;
@@ -487,12 +492,13 @@ static int do_key_range(struct tracefs_hist_data *hdata, long long start,
 
 	key = container_of(bucket->next_key, struct tracefs_hist_bucket_key, next);
 
-	if (!key->type)
-		key->type = TRACEFS_BUCKET_KEY_RANGE;
-
-	if (key->type != TRACEFS_BUCKET_KEY_RANGE)
+	if (!(key->flags &
+	      (TRACEFS_BUCKET_KEY_FL_UNDEF | TRACEFS_BUCKET_KEY_FL_RANGE)))
 		return -1;
 
+	key->flags &= ~TRACEFS_BUCKET_KEY_FL_UNDEF;
+	key->flags |= TRACEFS_BUCKET_KEY_FL_RANGE;
+
 	k = &key->range;
 
 	k->start = start;
@@ -698,13 +704,8 @@ void tracefs_hist_data_free(struct tracefs_hist_data *hdata)
 		hdata->buckets = bucket->next;
 		while ((key = bucket->keys)) {
 			bucket->keys = key->next;
-			switch (key->type) {
-			case TRACEFS_BUCKET_KEY_SINGLE:
+			if (key->flags & TRACEFS_BUCKET_KEY_FL_SINGLE)
 				free(key->single.sym);
-				break;
-			default:
-				break;
-			}
 			free(key);
 		}
 		while ((val = bucket->vals)) {
-- 
2.30.2

