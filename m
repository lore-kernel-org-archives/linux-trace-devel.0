Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6A0B8C433EF
	for <linux-trace-devel@archiver.kernel.org>; Fri, 24 Sep 2021 09:57:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4A9CA610D1
	for <linux-trace-devel@archiver.kernel.org>; Fri, 24 Sep 2021 09:57:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245408AbhIXJ6t (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 24 Sep 2021 05:58:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60382 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245366AbhIXJ6t (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 24 Sep 2021 05:58:49 -0400
Received: from mail-ed1-x535.google.com (mail-ed1-x535.google.com [IPv6:2a00:1450:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 25015C061574
        for <linux-trace-devel@vger.kernel.org>; Fri, 24 Sep 2021 02:57:16 -0700 (PDT)
Received: by mail-ed1-x535.google.com with SMTP id v22so33185911edd.11
        for <linux-trace-devel@vger.kernel.org>; Fri, 24 Sep 2021 02:57:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Cs9pri9txCRkuN4l34KuLQVenfVooL4RZhs9R67bSBo=;
        b=MS3f5d6MHjPqFYuNMc6+UZ4ItONH7xdMureLS1dM52SB8SNx/BarmYBkHnDYq5rhzc
         I9mkuKRFAEGeBd+o97FGx0IVSgIvqKapiyaBSg6ZGaS/sbR+CdQevX2Njzz4F+4EQRud
         9FBcVWcQ+7IjK2NDLIAChLyOu9Adjh2iUau1eVMI9zd2n0aWYt05m55mCGaHxH04shZJ
         jwMwbqIfPpods5o2vLTS1UYJ1fVnrwtn/Lg8adr/KE69OkWQotOE+QQrnGGoIciH05J6
         W+eQGFZNq5UNsURl5g28YwtL24M2gZoAg7WrA57nMAvlNmK98oWADs8x4U3HO8HJ6S5R
         gBxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Cs9pri9txCRkuN4l34KuLQVenfVooL4RZhs9R67bSBo=;
        b=0siufhkYBV9K5fGT0tU6BkhbwamgCVjNSAMCWmKL4H5jMVxxnrDhxJm7OEGFQRRojS
         pNDgiRPrN71moihHQOxV6jKqPR6kxiTU6YdoVzPgndP82ZFKEztzSf7Q9uE/buXOMFJp
         ihb/aSHknQ6RaZ9Vhe3tIhCui48B7iA6qOUGF7N1zvhBby/NlPaeOV+xTno4eTiMeW3u
         SxEMaZdKr1smEqxRznf1D93p+ym0p2u9QzvwqaOf4CJYykARwlLYafh5/NmaPOS8nuJ4
         cYnLVH05lmFdcuhaqzovVA9AdQI9ipN9XrQxFdtBUxI7vbc2u1dhXLAfebFNIBKcug3f
         xGmA==
X-Gm-Message-State: AOAM530v/Hl1ujqH+OyZjsZnGyDpUlNCAKCDIcSbWa16d8lMFMKgishB
        fZfJS3Alia5smopIV/XZ12bST6EvuG0=
X-Google-Smtp-Source: ABdhPJzKDeRhodBYcfCogZfQUcdh5z9j/jUEwQx62qZ8fKpW9SUanJ0jEtWMOTClvoTDsQwTqMLa4A==
X-Received: by 2002:a17:907:98e6:: with SMTP id ke6mr10693130ejc.63.1632477434608;
        Fri, 24 Sep 2021 02:57:14 -0700 (PDT)
Received: from crow.. ([84.40.93.30])
        by smtp.gmail.com with ESMTPSA id n13sm4635907ejk.97.2021.09.24.02.57.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 Sep 2021 02:57:14 -0700 (PDT)
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org,
        "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Subject: [PATCH v2 1/4] libtracefs: Add new constructors for histograms
Date:   Fri, 24 Sep 2021 12:56:59 +0300
Message-Id: <20210924095702.151826-2-y.karadz@gmail.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210924095702.151826-1-y.karadz@gmail.com>
References: <20210924095702.151826-1-y.karadz@gmail.com>
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
 include/tracefs.h  | 19 +++++++++--
 src/tracefs-hist.c | 84 ++++++++++++++++++++++++++++++++++++++--------
 2 files changed, 87 insertions(+), 16 deletions(-)

diff --git a/include/tracefs.h b/include/tracefs.h
index 9d84777..5c4141e 100644
--- a/include/tracefs.h
+++ b/include/tracefs.h
@@ -310,10 +310,25 @@ enum tracefs_compare {
 };
 
 void tracefs_hist_free(struct tracefs_hist *hist);
+struct tracefs_hist *
+tracefs_hist1d_alloc(struct tep_handle *tep,
+		     const char *system, const char *event_name,
+		     const char *key, enum tracefs_hist_key_type type);
+struct tracefs_hist *
+tracefs_hist2d_alloc(struct tep_handle *tep,
+		     const char *system, const char *event_name,
+		     const char *key1, enum tracefs_hist_key_type type1,
+		     const char *key2, enum tracefs_hist_key_type type2);
+
+struct tracefs_hist_axis {
+	const char *key;
+	enum tracefs_hist_key_type type;
+};
+
 struct tracefs_hist *
 tracefs_hist_alloc(struct tep_handle *tep,
-		   const char *system, const char *event,
-		   const char *key, enum tracefs_hist_key_type type);
+		   const char *system, const char *event_name,
+		   struct tracefs_hist_axis *axes);
 int tracefs_hist_add_key(struct tracefs_hist *hist, const char *key,
 			 enum tracefs_hist_key_type type);
 int tracefs_hist_add_value(struct tracefs_hist *hist, const char *value);
diff --git a/src/tracefs-hist.c b/src/tracefs-hist.c
index c112b68..ea12204 100644
--- a/src/tracefs-hist.c
+++ b/src/tracefs-hist.c
@@ -189,7 +189,7 @@ void tracefs_hist_free(struct tracefs_hist *hist)
 }
 
 /**
- * tracefs_hist_alloc - Initialize a histogram
+ * tracefs_hist1d_alloc - Initialize one-dimensional histogram
  * @tep: The tep handle that has the @system and @event.
  * @system: The system the histogram event is in.
  * @event_name: The name of the event that the histogram will be attached to.
@@ -205,15 +205,70 @@ void tracefs_hist_free(struct tracefs_hist *hist)
  * NULL on failure.
  */
 struct tracefs_hist *
+tracefs_hist1d_alloc(struct tep_handle *tep,
+		     const char *system, const char *event_name,
+		     const char *key, enum tracefs_hist_key_type type)
+{
+	struct tracefs_hist_axis axis[] = {{key, type}, {NULL, 0}};
+
+	return tracefs_hist_alloc(tep, system, event_name, axis);
+}
+
+/**
+ * tracefs_hist2d_alloc - Initialize two-dimensional histogram
+ * @tep: The tep handle that has the @system and @event.
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
+tracefs_hist2d_alloc(struct tep_handle *tep,
+		     const char *system, const char *event_name,
+		     const char *key1, enum tracefs_hist_key_type type1,
+		     const char *key2, enum tracefs_hist_key_type type2)
+{
+	struct tracefs_hist_axis axis[] = {{key1, type1},
+					   {key2, type2},
+					   {NULL, 0}};
+
+	return tracefs_hist_alloc(tep, system, event_name, axis);
+}
+
+/**
+ * tracefs_hist_alloc - Initialize N-dimensional histogram
+ * @tep: The tep handle that has the @system and @event.
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
 tracefs_hist_alloc(struct tep_handle *tep,
 		   const char *system, const char *event_name,
-		   const char *key, enum tracefs_hist_key_type type)
+		   struct tracefs_hist_axis *axes)
 {
 	struct tep_event *event;
 	struct tracefs_hist *hist;
-	int ret;
 
-	if (!system || !event_name || !key)
+	if (!system || !event_name)
 		return NULL;
 
 	event = tep_find_event_by_name(tep, system, event_name);
@@ -226,20 +281,21 @@ tracefs_hist_alloc(struct tep_handle *tep,
 
 	tep_ref(tep);
 	hist->tep = tep;
-
 	hist->event = event;
 	hist->system = strdup(system);
 	hist->event_name = strdup(event_name);
+	if (!hist->system || !hist->event_name)
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
@@ -1768,8 +1824,8 @@ tracefs_synth_get_start_hist(struct tracefs_synth *synth)
 				return NULL;
 			}
 		} else {
-			hist = tracefs_hist_alloc(tep, system, event,
-						  key, type);
+			hist = tracefs_hist1d_alloc(tep, system, event,
+						    key, type);
 			if (!hist)
 				return NULL;
 		}
-- 
2.30.2

