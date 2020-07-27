Return-Path: <SRS0=2N9E=BG=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.1 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1F933C433DF
	for <linux-trace-devel@archiver.kernel.org>; Mon, 27 Jul 2020 07:18:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E95582072E
	for <linux-trace-devel@archiver.kernel.org>; Mon, 27 Jul 2020 07:18:33 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="nBZuo8OO"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726513AbgG0HSd (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 27 Jul 2020 03:18:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55760 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726171AbgG0HSd (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 27 Jul 2020 03:18:33 -0400
Received: from mail-wm1-x342.google.com (mail-wm1-x342.google.com [IPv6:2a00:1450:4864:20::342])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 202FFC0619D2
        for <linux-trace-devel@vger.kernel.org>; Mon, 27 Jul 2020 00:18:33 -0700 (PDT)
Received: by mail-wm1-x342.google.com with SMTP id g8so1971392wmk.3
        for <linux-trace-devel@vger.kernel.org>; Mon, 27 Jul 2020 00:18:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=BPxN0Ghj3w2l4jnmIbCvXUdceTQZ6JtOEaSS9JN8T3g=;
        b=nBZuo8OOI9Q4kiuIDfg+l02smDwhAbxTMNF3s/ykQwTvCp1UZhGQXD9JJdMrcirs/p
         CAk+rJiD34XdBoGxzUbz7QxRxh8778+mDbh3fTihAuakKtFIXBHC6t/ULJshsrMV3eRt
         lM6KqvRDl7LGwTtdCIIfLPwQ77fmvQuR1MLVgae2oFWSDqkmOWslNbRWo/VFUuVrvNja
         b5oM2UhBiZG370R1K2aqRfkUQQhr4MgASodycgZiyCPNmAhaX9di9bS41O1BOCs+dnWD
         ZpxP0ReRBS7yZlg5v/93hRXiKTp/91NCj4aMbGsVUUL9HGAnkw598hb+DaBjHpHd2l7Q
         x0nQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=BPxN0Ghj3w2l4jnmIbCvXUdceTQZ6JtOEaSS9JN8T3g=;
        b=rSMPpyuZJmGAFuc2sz6UGXITQ/GVvWUCRr9ga9YdRrI2dQ4AEVYB6HUMPrJKkWTGku
         IN0IiEai+D9Zd687UNTqinJ0JEK5Ax/0SK5JnHjyCRcB79AYm1q9Si1JFsNQcRCMs1MU
         eqKI8W/h+7H+oIi0Els1dgKHXxJkJbQa6YYwGluuwivIq1mAWtfMR9Cbqlqa1+IF0Zej
         L+hhNX0abkDksznl+fe2QEp0OTwUTqGsDckits/yua4K/eYAx3GfVjDd10xooqLRTy7q
         n7oHGbubF6mUOmrbq8UtpmfI5d0s1zTurUcZi/5FC6fWMT8eY3kd/ueEt641GPS4wOxB
         jr3w==
X-Gm-Message-State: AOAM533zVbQl7aAAX4I/MuVhSFwEHX2jamM+2X6z6QqJE+sXxjnmjhPJ
        n8lg2S3crvZaJEA18r6hdmQ=
X-Google-Smtp-Source: ABdhPJzVSb20ANiX5ll1dtz+ohx/dg2pFIMma9EI1qb7JOiShYgzwedgLxfHNBkhjGpmAJAGhoBZcA==
X-Received: by 2002:a1c:62d6:: with SMTP id w205mr19602807wmb.154.1595834311854;
        Mon, 27 Jul 2020 00:18:31 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id j24sm12312162wrb.49.2020.07.27.00.18.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Jul 2020 00:18:31 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH 5/5] KernelShark: New libkshark API for loading all entries from given file
Date:   Mon, 27 Jul 2020 10:18:23 +0300
Message-Id: <20200727071823.169962-6-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200727071823.169962-1-tz.stoyanov@gmail.com>
References: <20200727071823.169962-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: Tzvetomir (VMware)  Stoyanov <tz.stoyanov@gmail.com>

The existing API kshark_load_entries() loads data in a single stream. It
cannot be used in case there are more than one streams in the same file.
A new API is implemented:
	kshark_load_file_entries()
which loads and merges entries in all sessions, related to given
trace file.

Signed-off-by: Tzvetomir (VMware)  Stoyanov <tz.stoyanov@gmail.com>
---
 src/KsUtils.cpp |  4 ++--
 src/libkshark.c | 36 +++++++++++++++++++++++++++++++-----
 src/libkshark.h |  3 +++
 3 files changed, 36 insertions(+), 7 deletions(-)

diff --git a/src/KsUtils.cpp b/src/KsUtils.cpp
index bcb88b5..f3e93ad 100644
--- a/src/KsUtils.cpp
+++ b/src/KsUtils.cpp
@@ -501,7 +501,7 @@ int  KsDataStore::loadDataFile(const QString &file,
 		kshark_handle_dpi(stream, plugin, KSHARK_PLUGIN_INIT);
 	}
 
-	n = kshark_load_entries(kshark_ctx, sd, &_rows);
+	n = kshark_load_file_entries(kshark_ctx, &_rows, file.toStdString().c_str());
 	if (n < 0) {
 		kshark_close(kshark_ctx, sd);
 		return n;
@@ -541,7 +541,7 @@ int KsDataStore::appendDataFile(const QString &file, int64_t offset)
 	*(kshark_ctx->stream[sd]->calib_array) = offset;
 	kshark_ctx->stream[sd]->calib_array_size = 1;
 
-	nApnd = kshark_load_entries(kshark_ctx, sd, &apndRows);
+	nApnd = kshark_load_file_entries(kshark_ctx, &_rows, file.toStdString().c_str());
 	if (nApnd <= 0) {
 		QErrorMessage *em = new QErrorMessage();
 		em->showMessage(QString("File %1 contains no data.").arg(file));
diff --git a/src/libkshark.c b/src/libkshark.c
index 375874d..a5126fd 100644
--- a/src/libkshark.c
+++ b/src/libkshark.c
@@ -1331,7 +1331,7 @@ void kshark_set_clock_offset(struct kshark_context *kshark_ctx,
 }
 
 /**
- * @brief Load the content of the all opened data file into an array of
+ * @brief Load the content of data from given file into an array of
  *	  kshark_entries.
  *	  If one or more filters are set, the "visible" fields of each entry
  *	  is updated according to the criteria provided by the filters. The
@@ -1346,11 +1346,12 @@ void kshark_set_clock_offset(struct kshark_context *kshark_ctx,
  * @returns The size of the outputted data in the case of success, or a
  *	    negative error code on failure.
  */
-ssize_t kshark_load_all_entries(struct kshark_context *kshark_ctx,
-				struct kshark_entry ***data_rows)
+ssize_t kshark_load_file_entries(struct kshark_context *kshark_ctx,
+				 struct kshark_entry ***data_rows, const char *file)
 {
 	size_t data_size = 0;
 	int i, *stream_ids, sd;
+	struct kshark_data_stream *stream;
 
 	if (!kshark_ctx->n_streams)
 		return data_size;
@@ -1359,16 +1360,18 @@ ssize_t kshark_load_all_entries(struct kshark_context *kshark_ctx,
 	sd = stream_ids[0];
 
 	data_size = kshark_load_entries(kshark_ctx, sd, data_rows);
-
 	for (i = 1; i < kshark_ctx->n_streams; ++i) {
 		struct kshark_entry **stream_data_rows = NULL;
 		struct kshark_entry **merged_data_rows;
 		size_t stream_data_size;
 
 		sd = stream_ids[i];
+		stream = kshark_get_data_stream(kshark_ctx, sd);
+		if (!stream || (file && strcmp(stream->file, file)))
+			continue;
+
 		stream_data_size = kshark_load_entries(kshark_ctx, sd,
 						       &stream_data_rows);
-
 		merged_data_rows =
 			kshark_data_merge(*data_rows, data_size,
 					  stream_data_rows, stream_data_size);
@@ -1387,6 +1390,29 @@ ssize_t kshark_load_all_entries(struct kshark_context *kshark_ctx,
 	return data_size;
 }
 
+
+/**
+ * @brief Load the content of the all opened data file into an array of
+ *	  kshark_entries.
+ *	  If one or more filters are set, the "visible" fields of each entry
+ *	  is updated according to the criteria provided by the filters. The
+ *	  field "filter_mask" of the session's context is used to control the
+ *	  level of visibility/invisibility of the filtered entries.
+ *
+ * @param kshark_ctx: Input location for context pointer.
+ * @param data_rows: Output location for the trace data. The user is
+ *		     responsible for freeing the elements of the outputted
+ *		     array.
+ *
+ * @returns The size of the outputted data in the case of success, or a
+ *	    negative error code on failure.
+ */
+ssize_t kshark_load_all_entries(struct kshark_context *kshark_ctx,
+				struct kshark_entry ***data_rows)
+{
+	return kshark_load_file_entries(kshark_ctx, data_rows, NULL);
+}
+
 static inline void free_ptr(void *ptr)
 {
 	if (ptr)
diff --git a/src/libkshark.h b/src/libkshark.h
index 44bec79..a76ec92 100644
--- a/src/libkshark.h
+++ b/src/libkshark.h
@@ -751,6 +751,9 @@ void kshark_set_clock_offset(struct kshark_context *kshark_ctx,
 ssize_t kshark_load_all_entries(struct kshark_context *kshark_ctx,
 				struct kshark_entry ***data_rows);
 
+ssize_t kshark_load_file_entries(struct kshark_context *kshark_ctx,
+				 struct kshark_entry ***data_rows, const char *file);
+
 /**
  * Data collections are used to optimize the search for an entry having an
  * abstract property, defined by a Matching condition function and an array of
-- 
2.26.2

