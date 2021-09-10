Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4EED6C433F5
	for <linux-trace-devel@archiver.kernel.org>; Fri, 10 Sep 2021 16:39:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3848C611CC
	for <linux-trace-devel@archiver.kernel.org>; Fri, 10 Sep 2021 16:39:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230154AbhIJQkY (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 10 Sep 2021 12:40:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58388 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230272AbhIJQkW (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 10 Sep 2021 12:40:22 -0400
Received: from mail-ej1-x635.google.com (mail-ej1-x635.google.com [IPv6:2a00:1450:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1AD9AC061766
        for <linux-trace-devel@vger.kernel.org>; Fri, 10 Sep 2021 09:39:11 -0700 (PDT)
Received: by mail-ej1-x635.google.com with SMTP id a25so5442892ejv.6
        for <linux-trace-devel@vger.kernel.org>; Fri, 10 Sep 2021 09:39:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=iFxkFKimb4SYn9oH9t3gLTUmDTFC+h81zIObZUcChf4=;
        b=U+uHDJP8dKe+8rm1gSxYu8Xf+Qf813L2EGy8Tzkan+KDL5MqkrNO36z9AUCcz0pLrd
         x75nC9S0uneo37ytEchonDlAe/bxMm2rJU5IGPcw5Pur7vvfVe+ahFmXBF6Tw02izUNp
         STbJPDl/Xl2UFHQnpsZBQ2/rrerem37GtYjQdUgLi4iqGJhjffTL51AFE2ChDx4h2J6o
         eYcitIGgp4aiwYeClEpNrZJdNZCQtPRiAFgD2v3pBVceHuL5rXXVNdtklQV5w3DttQjE
         HyMaro82nsI345mNeeMn6mTQhI/P18KfG/pLbdB3GWiZqHJeAaKfWSqUtdsQVjuuM1G1
         Oyyg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=iFxkFKimb4SYn9oH9t3gLTUmDTFC+h81zIObZUcChf4=;
        b=ik/cZpoknBzOPMp2uhT+36SjxJFKU5cbEuyHP7Y7Sq9MBP6lWUv+kJY9dN+zALB1Wq
         LynZhJ6QA0kRZaUdpMBn3SJUIWl1i/7NCROy3UZN1lsPcEDpMvN07bdV5FwHiClPxrjr
         j6YBifd26gm/VpZMx3TeH81lJ4xPF4w8KDrDAl5dJm1Ev7ys4VjPHY1RUfGJh7LGJ68Q
         LrsXDDDhdvrNFt9soiOeXDEJQoOUM7NGFFqQEXfY5s+Q9dsnoRFFGpPdn1MgDmUA1qoq
         V9/gvhOjhnbTmy3ewBeSW90/MqFOo3vG5dGle74b9+WLKRT04zlqn0wUQTY5SG5eJWTf
         zRqw==
X-Gm-Message-State: AOAM533D3qzrFusxtr8pCs5+qad/q30Yt9HTrilOyBccHPuxRSt7ufFZ
        WMWXUmXuWu1CxPKiq8W8qsw=
X-Google-Smtp-Source: ABdhPJw/q0Wtv6OHoc6C+egXPa7VMW0NBXot/doSPAned3Y4jzcCxQZJC1iv/dcCzcJDnunNN0G7Hg==
X-Received: by 2002:a17:906:9747:: with SMTP id o7mr10267400ejy.486.1631291949663;
        Fri, 10 Sep 2021 09:39:09 -0700 (PDT)
Received: from crow.. ([95.87.199.93])
        by smtp.gmail.com with ESMTPSA id g9sm3095290edk.54.2021.09.10.09.39.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Sep 2021 09:39:09 -0700 (PDT)
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org,
        "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Subject: [RFC PATCH 4/4] libtracefs: Remove tracefs_hist_add_key()
Date:   Fri, 10 Sep 2021 19:38:57 +0300
Message-Id: <20210910163857.324696-5-y.karadz@gmail.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210910163857.324696-1-y.karadz@gmail.com>
References: <20210910163857.324696-1-y.karadz@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Since we have appropriate constructor for N-dimensional histograms,
this method is no longer needed.

Signed-off-by: Yordan Karadzhov (VMware) <y.karadz@gmail.com>
---
 Documentation/libtracefs-hist-cont.txt |   8 +-
 Documentation/libtracefs-hist.txt      |   8 +-
 include/tracefs.h                      |   2 -
 src/tracefs-hist.c                     | 110 +++++++++++--------------
 4 files changed, 58 insertions(+), 70 deletions(-)

diff --git a/Documentation/libtracefs-hist-cont.txt b/Documentation/libtracefs-hist-cont.txt
index 1b0153c..d584b46 100644
--- a/Documentation/libtracefs-hist-cont.txt
+++ b/Documentation/libtracefs-hist-cont.txt
@@ -82,15 +82,15 @@ int main (int argc, char **argv, char **env)
 		exit(-1);
 	}
 
-	hist = tracefs_hist_alloc(instance, "kmem", "kmalloc",
-				  "call_site", TRACEFS_HIST_KEY_SYM);
+	hist = tracefs_hist2d_alloc(instance, "kmem", "kmalloc",
+				    "call_site", TRACEFS_HIST_KEY_SYM,
+				    "bytes_req", 0);
 	if (!hist) {
 		fprintf(stderr, "Failed hist create\n");
 		exit(-1);
 	}
 
-	ret = tracefs_hist_add_key(hist, "bytes_req", 0);
-	ret |= tracefs_hist_add_value(hist, "bytes_alloc");
+	ret = tracefs_hist_add_value(hist, "bytes_alloc");
 	ret |= tracefs_hist_add_sort_key(hist, "bytes_req", "bytes_alloc", NULL);
 
 	ret |= tracefs_hist_sort_key_direction(hist, "bytes_alloc",
diff --git a/Documentation/libtracefs-hist.txt b/Documentation/libtracefs-hist.txt
index 0254c5f..692f488 100644
--- a/Documentation/libtracefs-hist.txt
+++ b/Documentation/libtracefs-hist.txt
@@ -186,15 +186,15 @@ int main (int argc, char **argv, char **env)
 		exit(-1);
 	}
 
-	hist = tracefs_hist_alloc(instance, "kmem", "kmalloc",
-				  "call_site", TRACEFS_HIST_KEY_SYM);
+	hist = tracefs_hist2d_alloc(instance, "kmem", "kmalloc",
+				    "call_site", TRACEFS_HIST_KEY_SYM,
+				    "bytes_req", 0);
 	if (!hist) {
 		fprintf(stderr, "Failed hist create\n");
 		exit(-1);
 	}
 
-	ret = tracefs_hist_add_key(hist, "bytes_req", 0);
-	ret |= tracefs_hist_add_value(hist, "bytes_alloc");
+	ret = tracefs_hist_add_value(hist, "bytes_alloc");
 	ret |= tracefs_hist_add_sort_key(hist, "bytes_req", "bytes_alloc", NULL);
 
 	ret |= tracefs_hist_sort_key_direction(hist, "bytes_alloc",
diff --git a/include/tracefs.h b/include/tracefs.h
index 255be9b..5c193a2 100644
--- a/include/tracefs.h
+++ b/include/tracefs.h
@@ -303,8 +303,6 @@ const char *tracefs_get_hist_name(struct tracefs_hist *hist);
 const char *tracefs_get_hist_event(struct tracefs_hist *hist);
 const char *tracefs_get_hist_system(struct tracefs_hist *hist);
 struct tracefs_instance *tracefs_get_hist_instance(struct tracefs_hist *hist);
-int tracefs_hist_add_key(struct tracefs_hist *hist, const char *key,
-			 enum tracefs_hist_key_type type);
 int tracefs_hist_add_value(struct tracefs_hist *hist, const char *value);
 int tracefs_hist_add_sort_key(struct tracefs_hist *hist,
 			      char *sort_key);
diff --git a/src/tracefs-hist.c b/src/tracefs-hist.c
index 175b627..b71b0e3 100644
--- a/src/tracefs-hist.c
+++ b/src/tracefs-hist.c
@@ -217,6 +217,55 @@ tracefs_hist2d_alloc(struct tracefs_instance * instance,
 	return tracefs_hist_alloc(instance, system, event, axis);
 }
 
+static int add_hist_key(struct tracefs_hist *hist, const char *key,
+			 enum tracefs_hist_key_type type)
+{
+	bool use_key = false;
+	char *key_type = NULL;
+	char **new_list;
+	int ret;
+
+	switch (type) {
+	case TRACEFS_HIST_KEY_NORMAL:
+		use_key = true;
+		ret = 0;
+		break;
+	case TRACEFS_HIST_KEY_HEX:
+		ret = asprintf(&key_type, "%s.hex", key);
+		break;
+	case TRACEFS_HIST_KEY_SYM:
+		ret = asprintf(&key_type, "%s.sym", key);
+		break;
+	case TRACEFS_HIST_KEY_SYM_OFFSET:
+		ret = asprintf(&key_type, "%s.sym-offset", key);
+		break;
+	case TRACEFS_HIST_KEY_SYSCALL:
+		ret = asprintf(&key_type, "%s.syscall", key);
+		break;
+	case TRACEFS_HIST_KEY_EXECNAME:
+		ret = asprintf(&key_type, "%s.execname", key);
+		break;
+	case TRACEFS_HIST_KEY_LOG:
+		ret = asprintf(&key_type, "%s.log2", key);
+		break;
+	case TRACEFS_HIST_KEY_USECS:
+		ret = asprintf(&key_type, "%s.usecs", key);
+		break;
+	}
+
+	if (ret < 0)
+		return -1;
+
+	new_list = tracefs_list_add(hist->keys, use_key ? key : key_type);
+	free(key_type);
+	if (!new_list)
+		return -1;
+
+	hist->keys = new_list;
+
+	return 0;
+}
+
 /**
  * tracefs_hist_alloc - Initialize N-dimensional histogram
  * @instance: The instance the histogram will be in (NULL for toplevel)
@@ -262,7 +311,7 @@ tracefs_hist_alloc(struct tracefs_instance * instance,
 		goto fail;
 
 	for (; axes && axes->key; axes++)
-		if (tracefs_hist_add_key(hist, axes->key, axes->type) < 0)
+		if (add_hist_key(hist, axes->key, axes->type) < 0)
 			goto fail;
 
 	return hist;
@@ -272,65 +321,6 @@ tracefs_hist_alloc(struct tracefs_instance * instance,
 	return NULL;
 }
 
-/**
- * tracefs_hist_add_key - add to a key to a histogram
- * @hist: The histogram to add the key to.
- * @key: The name of the key field.
- * @type: The type of the key format.
- *
- * This adds a secondary or tertiary key to the histogram.
- *
- * Returns 0 on success, -1 on error.
- */
-int tracefs_hist_add_key(struct tracefs_hist *hist, const char *key,
-			 enum tracefs_hist_key_type type)
-{
-	bool use_key = false;
-	char *key_type = NULL;
-	char **new_list;
-	int ret;
-
-	switch (type) {
-	case TRACEFS_HIST_KEY_NORMAL:
-		use_key = true;
-		ret = 0;
-		break;
-	case TRACEFS_HIST_KEY_HEX:
-		ret = asprintf(&key_type, "%s.hex", key);
-		break;
-	case TRACEFS_HIST_KEY_SYM:
-		ret = asprintf(&key_type, "%s.sym", key);
-		break;
-	case TRACEFS_HIST_KEY_SYM_OFFSET:
-		ret = asprintf(&key_type, "%s.sym-offset", key);
-		break;
-	case TRACEFS_HIST_KEY_SYSCALL:
-		ret = asprintf(&key_type, "%s.syscall", key);
-		break;
-	case TRACEFS_HIST_KEY_EXECNAME:
-		ret = asprintf(&key_type, "%s.execname", key);
-		break;
-	case TRACEFS_HIST_KEY_LOG:
-		ret = asprintf(&key_type, "%s.log2", key);
-		break;
-	case TRACEFS_HIST_KEY_USECS:
-		ret = asprintf(&key_type, "%s.usecs", key);
-		break;
-	}
-
-	if (ret < 0)
-		return -1;
-
-	new_list = tracefs_list_add(hist->keys, use_key ? key : key_type);
-	free(key_type);
-	if (!new_list)
-		return -1;
-
-	hist->keys = new_list;
-
-	return 0;
-}
-
 /**
  * tracefs_hist_add_value - add to a value to a histogram
  * @hist: The histogram to add the value to.
-- 
2.30.2

