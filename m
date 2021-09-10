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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3980BC4332F
	for <linux-trace-devel@archiver.kernel.org>; Fri, 10 Sep 2021 16:39:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 21B7B61208
	for <linux-trace-devel@archiver.kernel.org>; Fri, 10 Sep 2021 16:39:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229944AbhIJQkZ (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 10 Sep 2021 12:40:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58380 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230146AbhIJQkT (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 10 Sep 2021 12:40:19 -0400
Received: from mail-ej1-x630.google.com (mail-ej1-x630.google.com [IPv6:2a00:1450:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 918D4C06175F
        for <linux-trace-devel@vger.kernel.org>; Fri, 10 Sep 2021 09:39:08 -0700 (PDT)
Received: by mail-ej1-x630.google.com with SMTP id t19so5417871ejr.8
        for <linux-trace-devel@vger.kernel.org>; Fri, 10 Sep 2021 09:39:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=f/b6pGCLNFVwuIGlaak6s3O+ozWULqNfRRPxAC7QgTE=;
        b=LxVjiyOowRgcNTsBiUuecSRugEE8+a/fzEbV3nuE9GTrWxP63P7NBeIPnmuk36H17k
         5WX/3HHuPOEsk+W50bKVxoXu2hYNeyk3A6MrzN8jssdsnYCk/cjhGwzizvxxtDzHmpuA
         Z/M7sK90gbrk2EI1DlM1/u+F9W2YKeZA7hGNLrt7e64VJRkjgzp278NGYNFLTgoUe/qS
         Wmtl9+auKb1QskqhcaCGaVe8h/tcuJSCRPgFatTps0lcivq5NG0QxdIZGAYPZutp1mwe
         fAQZsNxcuM5CT0cYiJyZoqdu9iWCqRfoGrsaXfaaB1kEXh2bxYnFx8WvTKtef2GUaqVH
         eOOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=f/b6pGCLNFVwuIGlaak6s3O+ozWULqNfRRPxAC7QgTE=;
        b=jhKCa9DHVh0b8NMvRp0GI56vdYsYnCHw0q0NkQoGdu+omqobuUpLNZXAqDmgsPyVBm
         bT9gGbYH8zlkhyXQ6z9f5EUZRnlB8HCuV9g1GUMVXjGvdH2YTnY+HzmGx9G7f2BLjE/d
         xvmXPDDfOdfkTxFv8hP+Xj8jJp0cbIIDc5aKEdZLtEsuri7Ad0XoG38hPM9oDMZ7UkeX
         RvNrW7Pm0pzEkw6PtfYQ/EaGaRKqEl9Ij+3R4BB9zvJ5zqp/JCd4N+RvB0wS2GjNtFgj
         D66O8gX6e9VY2uGo40hrh/UPeAGtJiiIkpqEbDnZCOzshnyf0zaC+YqOu9mYTXpYSx6Y
         6Kmw==
X-Gm-Message-State: AOAM532cf2wHWovPFo3ZleGz/+5tShZw4Wf3iPCws6LtNH3/BKhFuazk
        iodV/Rw4v8oUe36kC+Y/+SiR01FHJys=
X-Google-Smtp-Source: ABdhPJwloF8OUqinJJWc/WPYuNdoS0q6K9AAU+fxtotlQK29WaE9Ip57YVIUTQUTWHQhGL0wHLmaZA==
X-Received: by 2002:a17:906:686:: with SMTP id u6mr9968653ejb.569.1631291947157;
        Fri, 10 Sep 2021 09:39:07 -0700 (PDT)
Received: from crow.. ([95.87.199.93])
        by smtp.gmail.com with ESMTPSA id g9sm3095290edk.54.2021.09.10.09.39.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Sep 2021 09:39:06 -0700 (PDT)
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org,
        "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Subject: [RFC PATCH 1/4] libtracefs: Add new constructors for histograms
Date:   Fri, 10 Sep 2021 19:38:54 +0300
Message-Id: <20210910163857.324696-2-y.karadz@gmail.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210910163857.324696-1-y.karadz@gmail.com>
References: <20210910163857.324696-1-y.karadz@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

The current way to create an N-dimensional histogram is bit
counterintuitive. We first have to call tracefs_hist_alloc()
which is essentially a constructor of 1d histogram. Then we
have to call tracefs_hist_add_key() N-1 times in order to
increase the dimentions of the histogram. Here we transform
tracefs_hist_alloc() into a constructor of N-dimensional
histogram and we also add 2 helper constructors for 1d and
2d histograms.

Signed-off-by: Yordan Karadzhov (VMware) <y.karadz@gmail.com>
---
 include/tracefs.h  | 17 +++++++++-
 src/tracefs-hist.c | 82 ++++++++++++++++++++++++++++++++++++++--------
 2 files changed, 85 insertions(+), 14 deletions(-)

diff --git a/include/tracefs.h b/include/tracefs.h
index b4aa75d..64fbb3f 100644
--- a/include/tracefs.h
+++ b/include/tracefs.h
@@ -280,10 +280,25 @@ enum tracefs_hist_sort_direction {
 struct tracefs_hist;
 
 void tracefs_hist_free(struct tracefs_hist *hist);
+struct tracefs_hist *
+tracefs_hist1d_alloc(struct tracefs_instance * instance,
+		     const char *system, const char *event,
+		     const char *key, enum tracefs_hist_key_type type);
+struct tracefs_hist *
+tracefs_hist2d_alloc(struct tracefs_instance * instance,
+		     const char *system, const char *event,
+		     const char *key1, enum tracefs_hist_key_type type1,
+		     const char *key2, enum tracefs_hist_key_type type2);
+
+struct tracefs_hist_axis {
+	const char *key;
+	enum tracefs_hist_key_type type;
+};
+
 struct tracefs_hist *
 tracefs_hist_alloc(struct tracefs_instance * instance,
 		   const char *system, const char *event,
-		   const char *key, enum tracefs_hist_key_type type);
+		   struct tracefs_hist_axis *axes);
 int tracefs_hist_add_key(struct tracefs_hist *hist, const char *key,
 			 enum tracefs_hist_key_type type);
 int tracefs_hist_add_value(struct tracefs_hist *hist, const char *value);
diff --git a/src/tracefs-hist.c b/src/tracefs-hist.c
index 6519f7e..8501d64 100644
--- a/src/tracefs-hist.c
+++ b/src/tracefs-hist.c
@@ -141,7 +141,7 @@ void tracefs_hist_free(struct tracefs_hist *hist)
 }
 
 /**
- * tracefs_hist_alloc - Initialize a histogram
+ * tracefs_hist1d_alloc - Initialize one-dimensional histogram
  * @instance: The instance the histogram will be in (NULL for toplevel)
  * @system: The system the histogram event is in.
  * @event: The event that the histogram will be attached to.
@@ -157,14 +157,69 @@ void tracefs_hist_free(struct tracefs_hist *hist)
  * NULL on failure.
  */
 struct tracefs_hist *
+tracefs_hist1d_alloc(struct tracefs_instance * instance,
+		     const char *system, const char *event,
+		     const char *key, enum tracefs_hist_key_type type)
+{
+	struct tracefs_hist_axis axis[] = {{key, type}, {NULL, 0}};
+
+	return tracefs_hist_alloc(instance, system, event, axis);
+}
+
+/**
+ * tracefs_hist2d_alloc - Initialize two-dimensional histogram
+ * @instance: The instance the histogram will be in (NULL for toplevel)
+ * @system: The system the histogram event is in.
+ * @event: The event that the histogram will be attached to.
+ * @key1: The first primary key the histogram will use
+ * @type1: The format type of the first key.
+ * @key2: The second primary key the histogram will use
+ * @type2: The format type of the second key.
+ *
+ * Will initialize a histogram descriptor that will be attached to
+ * the @system/@event with the given @key1 and @key2 as the primaries.
+ * This only initializes the descriptor, it does not start the histogram
+ * in the kernel.
+ *
+ * Returns an initialized histogram on success.
+ * NULL on failure.
+ */
+struct tracefs_hist *
+tracefs_hist2d_alloc(struct tracefs_instance * instance,
+		     const char *system, const char *event,
+		     const char *key1, enum tracefs_hist_key_type type1,
+		     const char *key2, enum tracefs_hist_key_type type2)
+{
+	struct tracefs_hist_axis axis[] = {{key1, type1},
+					   {key2, type2},
+					   {NULL, 0}};
+
+	return tracefs_hist_alloc(instance, system, event, axis);
+}
+
+/**
+ * tracefs_hist_alloc - Initialize N-dimensional histogram
+ * @instance: The instance the histogram will be in (NULL for toplevel)
+ * @system: The system the histogram event is in
+ * @event: The event that the histogram will be attached to
+ * @axes: An array of histogram axes, terminated by a {NULL, 0} entry
+ *
+ * Will initialize a histogram descriptor that will be attached to
+ * the @system/@event. This only initializes the descriptor with the given
+ * @axes keys as primaries. This only initializes the descriptor, it does
+ * not start the histogram in the kernel.
+ *
+ * Returns an initialized histogram on success.
+ * NULL on failure.
+ */
+struct tracefs_hist *
 tracefs_hist_alloc(struct tracefs_instance * instance,
 		   const char *system, const char *event,
-		   const char *key, enum tracefs_hist_key_type type)
+		   struct tracefs_hist_axis *axes)
 {
 	struct tracefs_hist *hist;
-	int ret;
 
-	if (!system || !event || !key)
+	if (!system || !event)
 		return NULL;
 
 	if (!tracefs_event_file_exists(instance, system, event, HIST_FILE))
@@ -174,8 +229,7 @@ tracefs_hist_alloc(struct tracefs_instance * instance,
 	if (!hist)
 		return NULL;
 
-	ret = trace_get_instance(instance);
-	if (ret < 0) {
+	if (trace_get_instance(instance) < 0) {
 		free(hist);
 		return NULL;
 	}
@@ -184,16 +238,18 @@ tracefs_hist_alloc(struct tracefs_instance * instance,
 
 	hist->system = strdup(system);
 	hist->event = strdup(event);
+	if (!hist->system || !hist->event)
+		goto fail;
 
-	ret = tracefs_hist_add_key(hist, key, type);
-
-	if (!hist->system || !hist->event || ret < 0) {
-		tracefs_hist_free(hist);
-		return NULL;
-	}
-
+	for (; axes && axes->key; axes++)
+		if (tracefs_hist_add_key(hist, axes->key, axes->type) < 0)
+			goto fail;
 
 	return hist;
+
+ fail:
+	tracefs_hist_free(hist);
+	return NULL;
 }
 
 /**
-- 
2.30.2

