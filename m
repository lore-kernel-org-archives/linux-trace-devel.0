Return-Path: <linux-trace-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3F7C8C001E0
	for <linux-trace-devel@archiver.kernel.org>; Wed,  9 Aug 2023 17:53:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229554AbjHIRxx (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 9 Aug 2023 13:53:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45022 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231743AbjHIRxx (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 9 Aug 2023 13:53:53 -0400
Received: from mail-qv1-xf2b.google.com (mail-qv1-xf2b.google.com [IPv6:2607:f8b0:4864:20::f2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D57010FB
        for <linux-trace-devel@vger.kernel.org>; Wed,  9 Aug 2023 10:53:52 -0700 (PDT)
Received: by mail-qv1-xf2b.google.com with SMTP id 6a1803df08f44-63d1238c300so609206d6.0
        for <linux-trace-devel@vger.kernel.org>; Wed, 09 Aug 2023 10:53:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1691603631; x=1692208431;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=VLaMsZyfh3kdnwuZu2mOjfu9FkuAZKI4YATx7fYp+SU=;
        b=JZi5r2k/JoHKrRav5S0b15oiB4UJ1s9Uao5B+91wwDP7sAYrlo3wS7z4SI9MaInLVp
         /CmwcfyHItO5Plk7RMw7BxlF6r1pyVzFGwDyxYOPGPOsQ7nC46IGLw0sO42rzFt1QlFZ
         oU9xkw2ao8GL2qqnteYAbbzY8hHURULW8Yxt1N4HGxzZExBB+dPXfoLoY3yX/BEJq3ac
         OzAyA3Ye759yQ6iP8etYIeFgKaFss0iwWqLyPlgQ/cZS/vG7W2j/Y5KbDPbXqZCJEAbG
         GEcZv6Dvp/0YgwDNfcTybVPyh7ypB2i/jP9fAnYUe1tyHr2zFNY4D/EHdU8y5h4b6NQj
         Sfug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691603631; x=1692208431;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=VLaMsZyfh3kdnwuZu2mOjfu9FkuAZKI4YATx7fYp+SU=;
        b=iKPG7ykYEayF4A65/U/fKtd0EEzMVGkPDqeau4Mex81GJA4tcxtQcbkagmOefUnTQR
         Dz/tz1+HUITT2MOQdcti7JjWDSI1ow4+CUvPKjXkGda8P90udjlZwO+6chesrJ+cDzQZ
         WN0lZugAIuxo12lBtW3lOo6UugeSECUdBAi3CUZ2kivEYDD6GeNjKNyFJzjlxKAAblPc
         a5ULiYh5vUHRZBRxeIj+M4bmx3N1+FMN9mzq25KPWVlF/dtL2Ot1CQfONYBybeFLDmp4
         DWX9cLFpikcdhjVtqLB97fNFo4b7gyXYO1Z24Mtvrjw3KZZdaJ+Qe1WmIVjUl86sODRg
         yEfQ==
X-Gm-Message-State: AOJu0Yx+2ytuwBfOwVY0pv0/u6VYL3wKgVRautvKtvmr4vDAv/ld95no
        qNCaVhjBx6JdhkBwRzuPgJvW9Pb8Tgo=
X-Google-Smtp-Source: AGHT+IFEofSb+Ozy/WxneQxEqSJesOB0D0tiJVOEDHjwcoPgXEnpm+BJFVGfBBqE47btk5HxeK2xZg==
X-Received: by 2002:a0c:f18e:0:b0:635:e0dd:db4c with SMTP id m14-20020a0cf18e000000b00635e0dddb4cmr3057438qvl.25.1691603630964;
        Wed, 09 Aug 2023 10:53:50 -0700 (PDT)
Received: from 3xKetch.hsd1.ma.comcast.net ([2601:180:8300:500::2409])
        by smtp.gmail.com with ESMTPSA id x4-20020a0c8e84000000b00623839cba8csm4633646qvb.44.2023.08.09.10.53.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Aug 2023 10:53:50 -0700 (PDT)
From:   Stevie Alvarez <stevie.6strings@gmail.com>
To:     linux-trace-devel@vger.kernel.org
Cc:     Stevie Alvarez <stevie.6strings@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Ross Zwisler <zwisler@google.com>
Subject: [PATCH v4 4/5] histograms: Add traceeval query
Date:   Wed,  9 Aug 2023 13:53:37 -0400
Message-ID: <20230809175340.3066-5-stevie.6strings@gmail.com>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230809175340.3066-1-stevie.6strings@gmail.com>
References: <20230809175340.3066-1-stevie.6strings@gmail.com>
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
 src/histograms.c         | 161 +++++++++++++++++++++++++++++++++++++++
 2 files changed, 167 insertions(+)

diff --git a/include/traceeval-hist.h b/include/traceeval-hist.h
index 63e8b0e..82cfbb1 100644
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
index ed631b0..1b6e3a0 100644
--- a/src/histograms.c
+++ b/src/histograms.c
@@ -527,3 +527,164 @@ void traceeval_release(struct traceeval *teval)
 	teval->val_types = NULL;
 	free(teval);
 }
+
+/*
+ * Find the entry that @keys corresponds to within @teval.
+ *
+ * Returns 1 on success, 0 if no match found, -1 on error.
+ */
+static int get_entry(struct traceeval *teval, const union traceeval_data *keys,
+		     struct entry **result)
+{
+	struct hist_table *hist;
+	struct entry *entry;
+	int check = 0;
+	int i;
+
+	if (!teval || !keys)
+		return -1;
+
+	hist = teval->hist;
+	for (i = 0, entry = hist->map; i < hist->nr_entries; entry = &hist->map[++i]) {
+		check = compare_traceeval_data_set(entry->keys, keys,
+				teval->key_types, teval->nr_key_types);
+
+		if (!check)
+			continue;
+		break;
+	}
+
+	if (check > 0)
+		*result = entry;
+	return check;
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
+	if (type->type == TRACEEVAL_TYPE_STRING) {
+		copy->string = NULL;
+
+		if (orig->string)
+			copy->string = strdup(orig->string);
+		else
+			return 0;
+
+		if (!copy->string)
+			return -1;
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
+	*copy = NULL;
+	if (!size)
+		return 1;
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
+	if ((check = get_entry(teval, keys, &entry)) < 1)
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

