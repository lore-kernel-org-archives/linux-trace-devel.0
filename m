Return-Path: <SRS0=wnl5=DG=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1E400C4727D
	for <linux-trace-devel@archiver.kernel.org>; Tue, 29 Sep 2020 13:42:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B9F5A208FE
	for <linux-trace-devel@archiver.kernel.org>; Tue, 29 Sep 2020 13:42:21 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="aZO3WnDu"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730239AbgI2NmV (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 29 Sep 2020 09:42:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57888 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728617AbgI2NmV (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 29 Sep 2020 09:42:21 -0400
Received: from mail-wm1-x342.google.com (mail-wm1-x342.google.com [IPv6:2a00:1450:4864:20::342])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E4136C061755
        for <linux-trace-devel@vger.kernel.org>; Tue, 29 Sep 2020 06:42:20 -0700 (PDT)
Received: by mail-wm1-x342.google.com with SMTP id q9so4689394wmj.2
        for <linux-trace-devel@vger.kernel.org>; Tue, 29 Sep 2020 06:42:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=DzUmGxIhcAbhF8zkRtUK4r2k7e/iyzLx0CUdk/1pNVU=;
        b=aZO3WnDu2NiVSwRGzZL7HtLz0VvsFVKsFjWkGKKDrphKuOm7zK4mZ2XA3V/0IGMlq3
         vRhcSlY6Yn0VMs6aWaFepO6KolE8AyOqxK0e9XHtdt1gKAmDGqnKL9NojNO9uD+eLstK
         Tsxhko65gX21MnNTjsmWRBr5e7SCvXB5GrIV+AhzyTLN/T2SnA5n/emo+8AJYRDEg0sn
         b7HFDYaihZR+7lCQ644w1SLQMNNqfKBmPq96N86fYGJAwjzjcFSLKquobhQ+wy7e4lKa
         nHoUnhGDXX3csREvccfoFL71jdm7bHBVPRfF9VCTz9gHT7xDAtoE9UZByf0/KRVyLjSE
         hKMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=DzUmGxIhcAbhF8zkRtUK4r2k7e/iyzLx0CUdk/1pNVU=;
        b=Qj7V9cYw+06vcalX5PjVtc7/xZr2hPbHk5nPN38EKSSmQUbULqra+pz6etW7A8NF6r
         +uIJmKS1cPYQe2hbgf7/HH/29Whmy/omqlTa5z9XQut6I7jp1F+2xgio+vjPSn74ABIK
         QT+mfJvKz9yBkDJcNQTcnbfLDXjaxiLnLfQ/3xeHK0APZhf6+OsP0U7q6HLEAyJxFt3u
         AAUu+k8Jx42LRAadnaGk1wL2sqP4IoB0utr/78jmJobAl7sCPUkV4X3vKvPhxP0qrFm0
         li1VLHO7IxBl+4H9f7CIBGK7r5SOEAiwOhxjlJv39ch379xRGoAHpGh3I+crrZmYJk3j
         AFMA==
X-Gm-Message-State: AOAM531jyhf+GgU2piG72pg5sQl5pZc7LCQP5VT5tprpUMy7PZS1t8eG
        dZPcD/VJnAZ2jJFn9ZJhPfY=
X-Google-Smtp-Source: ABdhPJwtLUIL856U/43s1++gNtXANd6kAv5jsJoHLzAp5dfnRrDDerNgq8YGeyBXLJ3lscmrWPwduQ==
X-Received: by 2002:a1c:63d7:: with SMTP id x206mr4846564wmb.183.1601386939588;
        Tue, 29 Sep 2020 06:42:19 -0700 (PDT)
Received: from localhost.localdomain ([84.40.93.108])
        by smtp.gmail.com with ESMTPSA id b84sm6162792wmd.0.2020.09.29.06.42.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 29 Sep 2020 06:42:19 -0700 (PDT)
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org,
        "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Subject: [PATCH 14/15] kernel-shark: Add methods for time calibration
Date:   Tue, 29 Sep 2020 16:41:22 +0300
Message-Id: <20200929134123.178688-15-y.karadz@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200929134123.178688-1-y.karadz@gmail.com>
References: <20200929134123.178688-1-y.karadz@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

We add an infrastructure for correcting the timestamps of the entries.
This is needed in order to correlate Data streams that have been
recorded using non-synchronized clocks. The infrastructure can handle
an arbitrary timestamps correction formula, however for the moment we
only provide calibration that adds a constant offset.

Signed-off-by: Yordan Karadzhov (VMware) <y.karadz@gmail.com>
---
 src/libkshark.c | 67 +++++++++++++++++++++++++++++++++++++++++++++++++
 src/libkshark.h |  6 +++++
 2 files changed, 73 insertions(+)

diff --git a/src/libkshark.c b/src/libkshark.c
index 02927d2..667ebbe 100644
--- a/src/libkshark.c
+++ b/src/libkshark.c
@@ -1184,6 +1184,73 @@ kshark_get_entry_back(const struct kshark_entry_request *req,
 	return get_entry(req, data, index, req->first, end, -1);
 }
 
+static int compare_time(const void* a, const void* b)
+{
+	const struct kshark_entry *entry_a, *entry_b;
+
+	entry_a = *(const struct kshark_entry **) a;
+	entry_b = *(const struct kshark_entry **) b;
+
+	if (entry_a->ts > entry_b->ts)
+		return 1;
+
+	if (entry_a->ts < entry_b->ts)
+		return -1;
+
+	return 0;
+}
+
+static void kshark_data_qsort(struct kshark_entry **entries, size_t size)
+{
+	qsort(entries, size, sizeof(struct kshark_entry *), compare_time);
+}
+
+/**
+ * Add constant offset to the timestamp of the entry. To be used by the sream
+ * object as a System clock calibration callback function.
+ */
+void kshark_offset_calib(int64_t *ts, int64_t *argv)
+{
+	*ts += argv[0];
+}
+
+/**
+ * @brief Apply constant offset to the timestamps of all entries from a given
+ *	  Data stream.
+ *
+ * @param kshark_ctx: Input location for the session context pointer.
+ * @param entries: Input location for the trace data.
+ * @param size: The size of the trace data.
+ * @param sd: Data stream identifier.
+ * @param offset: The constant offset to be added (in nanosecond).
+ */
+void kshark_set_clock_offset(struct kshark_context *kshark_ctx,
+			     struct kshark_entry **entries, size_t size,
+			     int sd, int64_t offset)
+{
+	struct kshark_data_stream *stream;
+	int64_t correction;
+
+	stream = kshark_get_data_stream(kshark_ctx, sd);
+	if (!stream)
+		return;
+
+	if (!stream->calib_array) {
+		stream->calib = kshark_offset_calib;
+		stream->calib_array = calloc(1, sizeof(*stream->calib_array));
+		stream->calib_array_size = 1;
+	}
+
+	correction = offset - stream->calib_array[0];
+	stream->calib_array[0] = offset;
+
+	for (size_t i = 0; i < size; ++i)
+		if (entries[i]->stream_id == sd)
+			entries[i]->ts += correction;
+
+	kshark_data_qsort(entries, size);
+}
+
 static int first_in_time_entry(struct kshark_entry_data_set *buffer, int n_buffers, size_t *count)
 {
 	int64_t t_min = INT64_MAX;
diff --git a/src/libkshark.h b/src/libkshark.h
index 6878d6d..b39a107 100644
--- a/src/libkshark.h
+++ b/src/libkshark.h
@@ -1096,6 +1096,12 @@ struct kshark_config_doc *kshark_open_config_file(const char *file_name,
 
 struct kshark_config_doc *kshark_json_to_conf(struct json_object *jobj);
 
+void kshark_offset_calib(int64_t *ts, int64_t *atgv);
+
+void kshark_set_clock_offset(struct kshark_context *kshark_ctx,
+			     struct kshark_entry **entries, size_t size,
+			     int sd, int64_t offset);
+
 /** Structure representing a data set made of KernelShark entries. */
 struct kshark_entry_data_set {
 	/** Array of entries pointers. */
-- 
2.25.1

