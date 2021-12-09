Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CE219C433F5
	for <linux-trace-devel@archiver.kernel.org>; Thu,  9 Dec 2021 10:45:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235460AbhLIKtN (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 9 Dec 2021 05:49:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38156 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235093AbhLIKtM (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 9 Dec 2021 05:49:12 -0500
Received: from mail-ed1-x533.google.com (mail-ed1-x533.google.com [IPv6:2a00:1450:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F1BC5C061746
        for <linux-trace-devel@vger.kernel.org>; Thu,  9 Dec 2021 02:45:38 -0800 (PST)
Received: by mail-ed1-x533.google.com with SMTP id x15so18266575edv.1
        for <linux-trace-devel@vger.kernel.org>; Thu, 09 Dec 2021 02:45:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=QzS8vOyXWJzFWBS4PCLUgQGIyY8AbUe+m5SwEq1hAKw=;
        b=OKttwZd9KhZz0/KqxPIj9JodFjfdX7cb5YpC4bQDx1OYaZ92oUqLD36xzVgymd5DhJ
         AeBkvsd0uIuzTNlA6qq6Io2CyIuEsi8fJZlsg1hYG8ZrU4g7RZKsjVBqBtJyKX1jJui3
         or80ZKTBY6XTlAuYh6iX8uBHbT+c8qIF8Iy8cReGUOCK5kTfyNAIAnR+WHf1lmZ4oI4o
         EIWvimZGR8SGLHiOBQZMMmPvRqQR1HVTcr6ADgcUKt5jtAVlzbQxvt6ICQb/ZE2ccW2V
         l7zY3C3XHR/U0oubp6oS61hDOl+Qwx9JdHdOhgvzYzTrsohckE+ISvqdVskbTVg5/Y1J
         ZhUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=QzS8vOyXWJzFWBS4PCLUgQGIyY8AbUe+m5SwEq1hAKw=;
        b=w6dKj99ApfjYSvgMGCFDf9TEpmS2YPT08VYyEFq+RzbBWDYub4gXXxhJDgclB5yVsg
         2yZxtjrfqbOrHoatMp0krsbfd34LrsOPDFjT1p7gURJE6cdS0LZzgDgDP+M5zj2jDTcB
         Ypiz7Y3dQgA/XWIAx3OhwljUalHJo8pa7M6ArIvr4hVA8jBdh+0Ne8wvMnD76isFlm06
         bUqT9gSdEsNfOuSkxnjOnXQT/LJFxDen8ZzGGhyCO24hmmEOEyBw7zKpeJs2znhQpNLT
         4ix9VZq/mF7v+5CfMlrkZ0Fm43U3dnZjwE+B1aq4VfWovjfOsWxf1pUIkPueanIzjp5r
         gvHw==
X-Gm-Message-State: AOAM531b6N5zh0FxYZbEUHZkoBr1sGvp+fNan01xGgBWth0q6qxa+ENX
        LJCFvrplkJL+UVDAlYmeKddbQYEjYrg=
X-Google-Smtp-Source: ABdhPJwgcPW1jBMoONkn00xusCNCeScedKAklQ0ZHN0BI3P6dKIYY6QdvJ6tP1xkoPPAEbDKvZl7Pw==
X-Received: by 2002:a05:6402:1a4f:: with SMTP id bf15mr28151261edb.260.1639046737566;
        Thu, 09 Dec 2021 02:45:37 -0800 (PST)
Received: from crow.. ([95.87.219.163])
        by smtp.gmail.com with ESMTPSA id b7sm3778545edd.26.2021.12.09.02.45.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Dec 2021 02:45:37 -0800 (PST)
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
To:     rostedt@goodmis.org, linux-trace-devel@vger.kernel.org
Cc:     "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Subject: [PATCH v2 2/3] libtracefs: Add new API for getting synth event name
Date:   Thu,  9 Dec 2021 12:45:23 +0200
Message-Id: <20211209104524.5354-3-y.karadz@gmail.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20211209104524.5354-1-y.karadz@gmail.com>
References: <20211209104524.5354-1-y.karadz@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

We add:
const char *tracefs_synth_get_name(struct tracefs_synth *)

The new API can be valuable in a number of different scenarios.
For example, when the user works with multiple synth events and
wants to print an adequate error message in a case of a failure.

Signed-off-by: Yordan Karadzhov (VMware) <y.karadz@gmail.com>
---
 Documentation/libtracefs-synth2.txt | 14 +++++++++++---
 include/tracefs.h                   |  1 +
 src/tracefs-hist.c                  | 11 +++++++++++
 3 files changed, 23 insertions(+), 3 deletions(-)

diff --git a/Documentation/libtracefs-synth2.txt b/Documentation/libtracefs-synth2.txt
index 1cb07c8..569819a 100644
--- a/Documentation/libtracefs-synth2.txt
+++ b/Documentation/libtracefs-synth2.txt
@@ -3,8 +3,9 @@ libtracefs(3)
 
 NAME
 ----
-tracefs_synth_create, tracefs_synth_destroy, tracefs_synth_echo_cmd,tracefs_synth_complete,
-tracefs_synth_get_start_hist,tracefs_synth_trace,tracefs_synth_snapshot - Creation of synthetic events
+tracefs_synth_create, tracefs_synth_destroy, tracefs_synth_echo_cmd, tracefs_synth_complete,
+tracefs_synth_get_start_hist, tracefs_synth_trace, tracefs_synth_snapshot,
+tracefs_synth_get_name - Creation of synthetic events
 
 SYNOPSIS
 --------
@@ -25,6 +26,7 @@ int tracefs_synth_snapshot(struct tracefs_synth pass:[*]synth,
 int tracefs_synth_save(struct tracefs_synth pass:[*]synth,
 		       enum tracefs_synth_handler type, const char pass:[*]var,
 		       char pass:[**]save_fields);
+const char *tracefs_synth_get_name(struct tracefs_synth pass:[*]synth);
 --
 
 DESCRIPTION
@@ -87,9 +89,15 @@ then saven the given _save_fields_ list. The fields will be stored in the histog
 "hist" file of the event that can be retrieved with *tracefs_event_file_read*(3).
 _var_ changes. _var_ must be one of the _name_ elements used in *tracefs_synth_add_end_field*(3).
 
+*tracefs_synth_get_name*() returns the name of the synthetic event or NULL on error.
+The returned string belongs to the synth event object and is freed with the event
+by *tracefs_synth_free*().
+
 RETURN VALUE
 ------------
-Returns zero on success or -1 on error.
+*tracefs_synth_get_name*() returns a string owned by the synth event object.
+
+All other functions return zero on success or -1 on error.
 
 ERRORS
 ------
diff --git a/include/tracefs.h b/include/tracefs.h
index b874d3f..967690f 100644
--- a/include/tracefs.h
+++ b/include/tracefs.h
@@ -502,6 +502,7 @@ enum tracefs_synth_handler {
 	TRACEFS_SYNTH_HANDLE_CHANGE,
 };
 
+const char *tracefs_synth_get_name(struct tracefs_synth *synth);
 struct tracefs_synth *tracefs_synth_alloc(struct tep_handle *tep,
 					  const char *name,
 					  const char *start_system,
diff --git a/src/tracefs-hist.c b/src/tracefs-hist.c
index 59ac5e4..6051ecc 100644
--- a/src/tracefs-hist.c
+++ b/src/tracefs-hist.c
@@ -702,6 +702,17 @@ struct tracefs_synth {
 	int			arg_cnt;
 };
 
+ /*
+ * tracefs_synth_get_name - get the name of the synthetic event
+ * @synth: The synthetic event to get the name for
+ *
+ * Returns name string owned by @synth on success, or NULL on error.
+ */
+const char *tracefs_synth_get_name(struct tracefs_synth *synth)
+{
+	return synth ? synth->name : NULL;
+}
+
 static void action_free(struct action *action)
 {
 	free(action->handle_field);
-- 
2.32.0

