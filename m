Return-Path: <linux-trace-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A2285C001B0
	for <linux-trace-devel@archiver.kernel.org>; Tue,  8 Aug 2023 17:30:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234706AbjHHRaY (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 8 Aug 2023 13:30:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35032 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234674AbjHHR3v (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 8 Aug 2023 13:29:51 -0400
Received: from mail-qk1-x72c.google.com (mail-qk1-x72c.google.com [IPv6:2607:f8b0:4864:20::72c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F94A7D97
        for <linux-trace-devel@vger.kernel.org>; Tue,  8 Aug 2023 09:12:56 -0700 (PDT)
Received: by mail-qk1-x72c.google.com with SMTP id af79cd13be357-76cded293e8so417622285a.2
        for <linux-trace-devel@vger.kernel.org>; Tue, 08 Aug 2023 09:12:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1691511140; x=1692115940;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=pymTTMAWpgak4wnEpP61xlzcxw79iN+EeTosW6u0QRI=;
        b=N/ZaId3t+Vun/tiJyAqBJMRw4cHgBEpJYElzcfXEdad4Ui38M/wJA4vJsopvK/miC+
         AZkd0sq3qKa1Ith9YzXjcaAfYEDju2Od20D96csiLVqhGb0AWLt0zJiwtZrzJz49XWeQ
         pE+Y438LoF0HN47hSg1NRI7noIfYB6wyvvNovVc1pwjkU4kAXRbva4MQkfs0nTHQym6D
         nwlp4vtRGKgmMTG9vJKZlMVZBOKyEndooNCToV3bXtLlfQpDippVAM1rH8Bjjjy5y0Hl
         sC3PfNLeOvOgBg4GKWG76gtVSv/9kBghJb/tl2CNij5u5/jYgoaLookYNFwg3uKBr5We
         ZpAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691511140; x=1692115940;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=pymTTMAWpgak4wnEpP61xlzcxw79iN+EeTosW6u0QRI=;
        b=HM1QFJ3rmiaONMhZwjchdXCthPN7LxYrWV+AAHjWv2b1sOZ+z60eS3AMnUKPJvvnhR
         A4g2qz5gYOAxgRSkSIL0SSvh+MIvLM5//qhlVlrZVFSSvyI/Y5NIdDzwW+7YkERhgU3h
         zCtg9rjisqvF6sGlDMFh/vG++ttWnVsHLBHaC5x+bSRblEI6JwTAJmdW5zpK0m8olOg8
         ICkAQwsqiICe6DsTmEGSXB5hBFzTfNg/QvkEDX+9CJOcNDPENW09EhVsdu4rRiwcyWMS
         0DWA18Wr8hCwsps6uer6H3WcP1K9ZGu8y0EgK4P1C1uHnKS8aIK+4oPBV58B9MfElyBc
         VeJQ==
X-Gm-Message-State: AOJu0YwuqFR7b0GUtTke5zG2No/HMJkZPHop3lQTxam9zSdLieNmp3F3
        bR9Ofpdrx6tp41YK4MUDw+EChxGVmR4=
X-Google-Smtp-Source: AGHT+IGr8mEO17eonzrq1Bj2rargVr7Oa4J9dNJsG2cQZWr2BfmNnh0d0pq7a/WrRA/5qiCIbHSfCQ==
X-Received: by 2002:a05:620a:24e:b0:76c:ce1c:930c with SMTP id q14-20020a05620a024e00b0076cce1c930cmr150451qkn.53.1691511139694;
        Tue, 08 Aug 2023 09:12:19 -0700 (PDT)
Received: from 3xKetch.hsd1.ma.comcast.net ([2601:180:8300:500::6aa8])
        by smtp.gmail.com with ESMTPSA id s7-20020a05620a030700b0076c97ae43b9sm3381540qkm.66.2023.08.08.09.12.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Aug 2023 09:12:19 -0700 (PDT)
From:   Stevie Alvarez <stevie.6strings@gmail.com>
To:     linux-trace-devel@vger.kernel.org
Cc:     Stevie Alvarez <stevie.6strings@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Ross Zwisler <zwisler@google.com>
Subject: [PATCH v3 4/6] histograms: Add traceeval query
Date:   Tue,  8 Aug 2023 12:11:57 -0400
Message-ID: <20230808161204.5704-5-stevie.6strings@gmail.com>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230808161204.5704-1-stevie.6strings@gmail.com>
References: <20230808161204.5704-1-stevie.6strings@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: Stevie Alvarez (Google) <stevie.6strings@gmail.com>

traceeval_query() fetches the values (aka results) of an entry with
keys that match the array of keys provided. The results of a query can
be useful for aggregating data between entries/trace events.

traceeval_results_release() frees the results fetched by the query. The
user must free the results of a successful query.

Signed-off-by: Stevie Alvarez (Google) <stevie.6strings@gmail.com>
---
 include/traceeval-hist.h |   6 ++
 src/histograms.c         | 163 +++++++++++++++++++++++++++++++++++++++
 2 files changed, 169 insertions(+)

diff --git a/include/traceeval-hist.h b/include/traceeval-hist.h
index 5203520..4923de1 100644
--- a/include/traceeval-hist.h
+++ b/include/traceeval-hist.h
@@ -134,4 +134,10 @@ struct traceeval *traceeval_init(const struct traceeval_type *keys,
 
 void traceeval_release(struct traceeval *teval);
 
+int traceeval_query(struct traceeval *teval, const union traceeval_data *keys,
+		    union traceeval_data **results);
+
+void traceeval_results_release(struct traceeval *teval,
+			       union traceeval_data *results);
+
 #endif /* __LIBTRACEEVAL_HIST_H__ */
diff --git a/src/histograms.c b/src/histograms.c
index 6fac205..47ff175 100644
--- a/src/histograms.c
+++ b/src/histograms.c
@@ -521,3 +521,166 @@ void traceeval_release(struct traceeval *teval)
 	teval->val_types = NULL;
 	free(teval);
 }
+
+/*
+ * Find the entry that @keys corresponds to within @teval.
+ *
+ * Returns 0 on success, 1 if no match found, -1 on error.
+ */
+static int get_entry(struct traceeval *teval, const union traceeval_data *keys,
+		     struct entry **result)
+{
+	struct hist_table *hist;
+	int i;
+	int check;
+
+	if (!teval || !keys)
+		return -1;
+
+	hist = teval->hist;
+	i = 0;
+	for (struct entry *entry = hist->map; i < hist->nr_entries;
+			entry = &hist->map[++i]) {
+		check = compare_traceeval_data_set(entry->keys, keys,
+				teval->key_types, teval->nr_key_types);
+
+		/* return entry if keys match */
+		if (!check) {
+			*result = entry;
+			return 0;
+		} else if (check == 1) {
+			continue;
+		} else {
+			return check;
+		}
+	}
+
+	return 1;
+}
+
+/*
+ * Copy @orig to @copy with respect to @type.
+ *
+ * Return 0 on success, -1 on error.
+ */
+static int copy_traceeval_data(struct traceeval_type *type,
+				const union traceeval_data *orig,
+				union traceeval_data *copy)
+{
+	*copy = *orig;
+
+	switch (type->type) {
+	case TRACEEVAL_TYPE_STRING:
+		copy->string = NULL;
+		if (orig->string)
+			copy->string = strdup(orig->string);
+		if (!copy->string)
+			return -1;
+		break;
+
+	default:
+		break;
+	}
+
+	return 0;
+}
+
+/*
+ * Free @data with respect to @size and @type.
+ *
+ * Does not call dyn_release on type TRACEEVAL_TYPE_DYNAMIC.
+ */
+static void data_release(size_t size, union traceeval_data **data,
+				struct traceeval_type *type)
+{
+	for (size_t i = 0; i < size; i++) {
+		if (type[i].type == TRACEEVAL_TYPE_STRING)
+			free((*data)[i].string);
+	}
+	free(*data);
+	*data = NULL;
+}
+
+/*
+ * Copy @orig to @copy with respect to @size and @type.
+ *
+ * Returns 1 on success, -1 on error.
+ */
+static int copy_traceeval_data_set(size_t size, struct traceeval_type *type,
+				    const union traceeval_data *orig,
+				    union traceeval_data **copy)
+{
+	size_t i;
+
+	*copy = calloc(size, sizeof(**copy));
+	if (!*copy)
+		return -1;
+
+	for (i = 0; i < size; i++) {
+		if (copy_traceeval_data(type + i, orig + i, (*copy) + i))
+			goto fail;
+	}
+
+	return 1;
+
+fail:
+	data_release(i, copy, type);
+	return -1;
+}
+
+
+/*
+ * traceeval_query - find the last instance defined by the keys
+ * @teval: The descriptor to search from
+ * @keys: A list of data to look for
+ * @results: A pointer to where to place the results (if found)
+ *
+ * This does a lookup for an instance within the traceeval data.
+ * The @keys is an array defined by the keys declared in traceeval_init().
+ * The @keys will return an item that had the same keys when it was
+ * inserted by traceeval_insert(). The @keys here follow the same rules
+ * as the keys for traceeval_insert().
+ *
+ * Note, when the caller is done with @results, it must call
+ * traceeval_results_release() on it.
+ *
+ * Returns 1 if found, 0 if not found, and -1 on error.
+ */
+int traceeval_query(struct traceeval *teval, const union traceeval_data *keys,
+		    union traceeval_data **results)
+{
+	struct entry *entry;
+	int check;
+
+	if (!teval || !keys || !results)
+		return -1;
+
+	/* find key and copy its corresponding value pair */
+	if ((check = get_entry(teval, keys, &entry)))
+		return check;
+	return copy_traceeval_data_set(teval->nr_val_types, teval->val_types,
+			entry->vals, results);
+}
+
+/*
+ * traceeval_results_release - release the results return by traceeval_query()
+ * @teval: The descriptor used in traceeval_query()
+ * @results: The results returned by traceeval_query()
+ *
+ * The @results returned by traceeval_query() is owned by @teval, and
+ * how it manages it is implementation specific. The caller should not
+ * worry about it. When the caller of traceeval_query() is done with
+ * the @results, it must call traceeval_results_release() on it to
+ * allow traceeval to clean up its references.
+ */
+void traceeval_results_release(struct traceeval *teval,
+			       union traceeval_data *results)
+{
+	if (!teval || !results) {
+		if (!results)
+			print_err("Results to be freed without accompanied traceeval instance!");
+		return;
+	}
+
+	data_release(teval->nr_val_types, &results, teval->val_types);
+}
-- 
2.41.0

