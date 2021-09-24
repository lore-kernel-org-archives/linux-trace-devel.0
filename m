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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7D5A9C433FE
	for <linux-trace-devel@archiver.kernel.org>; Fri, 24 Sep 2021 09:57:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 57F6760E54
	for <linux-trace-devel@archiver.kernel.org>; Fri, 24 Sep 2021 09:57:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245422AbhIXJ6u (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 24 Sep 2021 05:58:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60386 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245366AbhIXJ6t (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 24 Sep 2021 05:58:49 -0400
Received: from mail-ed1-x52e.google.com (mail-ed1-x52e.google.com [IPv6:2a00:1450:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB0C1C061574
        for <linux-trace-devel@vger.kernel.org>; Fri, 24 Sep 2021 02:57:16 -0700 (PDT)
Received: by mail-ed1-x52e.google.com with SMTP id c21so33546837edj.0
        for <linux-trace-devel@vger.kernel.org>; Fri, 24 Sep 2021 02:57:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=WrqulUvtP74+nU2f2uM9SgxrL0TZt6t58MMlLBelMmM=;
        b=gBGH3tjssGoG4SetsguM56aBB195zgHfml9UPctX/Zodr9brL3v/uULXHOCILQAeNB
         gY0ukgZvH1fsVd4GZ9WVgGcylhX2tUneoTL3zoWMgOzj/i1x20/YXOi3/0K0R9UqKLvL
         JI5jHHKQApRRFKS1oCCqMhqfGkIQVhrLGx8fDpjJCEOdrIqCFuDkuQ+uPMnuqSYdvOsH
         gI7AERqFZ/K0ZETzd8RD62AWJuEBcPQhATOZF9XqhgL8TGp6zBwveUvF5Lj6zwGODx8W
         MRiP40DidbhV6Ze7fCrbgdbcvFguBcYKMMHgEbKj6TeJKeNK5Dzg23P3rsD01qmXIvz2
         1blA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=WrqulUvtP74+nU2f2uM9SgxrL0TZt6t58MMlLBelMmM=;
        b=DF+RMI06BUWS2Opmegg6KwTgNu/iXikCgPDZ18c+LjiouXP8u7sYOk+i/OL6QG/gUf
         Yb6v0WCVC2mw/J0ZNHrNzSvjwViisNgeskDh5e9RS/YKlzFJIWjpNHe36pzFvt7brgT9
         PyqdCiFryhiMDBs7SqptmD6p3371HQTgJ8IpRTH6oJzGRG1y40RTGtx5v7U7DF9D7lgI
         dKFyHI1JucCJqPf9uy2FvwqujGneaUDMKtaAI2P5oyKW07oY7tz4FRG2Xbt79+RNzhkw
         ineBN9cRZvpOFfk53PrigNqv4HYpMoFfVy7sWyywRRQMWuBpjK/8TkM9NNwHitjqfQFf
         9gJA==
X-Gm-Message-State: AOAM531mp/KMYbO699dlgWz+cG6P6H4lf39PLgOn2gQjoasrlzR8DtN1
        zLLotMwUPGu2BgXh7CCJvuzsggSCIpQ=
X-Google-Smtp-Source: ABdhPJy+ULjfyM6lRNkcxx/lj7LngUEsTVdjVb7TI+GvMDR2nTEzpzICCv2EbRKtYKSRm69afuJDTw==
X-Received: by 2002:a17:906:1707:: with SMTP id c7mr9702417eje.377.1632477435492;
        Fri, 24 Sep 2021 02:57:15 -0700 (PDT)
Received: from crow.. ([84.40.93.30])
        by smtp.gmail.com with ESMTPSA id n13sm4635907ejk.97.2021.09.24.02.57.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 Sep 2021 02:57:15 -0700 (PDT)
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org,
        "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Subject: [PATCH v2 2/4] libtracefs: Transform tracefs_hist_add_sort_key()
Date:   Fri, 24 Sep 2021 12:57:00 +0300
Message-Id: <20210924095702.151826-3-y.karadz@gmail.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210924095702.151826-1-y.karadz@gmail.com>
References: <20210924095702.151826-1-y.karadz@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

The current version of the API makes it hard to add multiple sort keys
to a histogram. The only way to do this is to use the variadic arguments,
however in order to do this the caller has to know the number of sort
keys at compile time, because the method overwrite all previously added
keys. The problem is addressed by creating a tracefs_hist_add_sort_key()
into two methods - one that overwrite and one that does not.
The current version of 'tracefs_hist_add_sort_key()' gets renamed to
'tracefs_hist_set_sort_key()' without introducing any functional changes.
In the same time a new 'tracefs_hist_add_sort_key()' function is
defined. The new function can add one new sort key to the list of
previously added sort keys.

Signed-off-by: Yordan Karadzhov (VMware) <y.karadz@gmail.com>
---
 include/tracefs.h  |  4 +++-
 src/tracefs-hist.c | 33 ++++++++++++++++++++++++++++++---
 2 files changed, 33 insertions(+), 4 deletions(-)

diff --git a/include/tracefs.h b/include/tracefs.h
index 5c4141e..230bc41 100644
--- a/include/tracefs.h
+++ b/include/tracefs.h
@@ -333,7 +333,9 @@ int tracefs_hist_add_key(struct tracefs_hist *hist, const char *key,
 			 enum tracefs_hist_key_type type);
 int tracefs_hist_add_value(struct tracefs_hist *hist, const char *value);
 int tracefs_hist_add_sort_key(struct tracefs_hist *hist,
-			      const char *sort_key, ...);
+			      const char *sort_key);
+int tracefs_hist_reset_sort_key(struct tracefs_hist *hist,
+				const char *sort_key, ...);
 int tracefs_hist_sort_key_direction(struct tracefs_hist *hist,
 				    const char *sort_key,
 				    enum tracefs_hist_sort_direction dir);
diff --git a/src/tracefs-hist.c b/src/tracefs-hist.c
index ea12204..a7c20de 100644
--- a/src/tracefs-hist.c
+++ b/src/tracefs-hist.c
@@ -437,16 +437,43 @@ add_sort_key(struct tracefs_hist *hist, const char *sort_key, char **list)
 /**
  * tracefs_hist_add_sort_key - add a key for sorting the histogram
  * @hist: The histogram to add the sort key to
+ * @sort_key: The key to sort
+ *
+ * Call the function to add to the list of sort keys of the histohram in
+ * the order of priority that the keys would be sorted on output.
+ *
+ * Returns 0 on success, -1 on error.
+ */
+int tracefs_hist_add_sort_key(struct tracefs_hist *hist,
+			      const char *sort_key)
+{
+	char **list = hist->sort;
+
+	if (!hist || !sort_key)
+		return -1;
+
+	list = add_sort_key(hist, sort_key, hist->sort);
+	if (!list)
+		return -1;
+
+	hist->sort = list;
+
+	return 0;
+}
+
+/**
+ * tracefs_hist_reset_sort_key - set a key for sorting the histogram
+ * @hist: The histogram to set the sort key to
  * @sort_key: The key to sort (and the strings after it)
  *  Last one must be NULL.
  *
- * Add a list of sort keys in the order of priority that the
+ * Set a list of sort keys in the order of priority that the
  * keys would be sorted on output. Keys must be added first.
  *
  * Returns 0 on success, -1 on error.
  */
-int tracefs_hist_add_sort_key(struct tracefs_hist *hist,
-			      const char *sort_key, ...)
+int tracefs_hist_reset_sort_key(struct tracefs_hist *hist,
+				const char *sort_key, ...)
 {
 	char **list = NULL;
 	char **tmp;
-- 
2.30.2

