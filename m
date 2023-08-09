Return-Path: <linux-trace-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 86EF6C04FDF
	for <linux-trace-devel@archiver.kernel.org>; Wed,  9 Aug 2023 17:53:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229978AbjHIRxy (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 9 Aug 2023 13:53:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45024 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229913AbjHIRxy (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 9 Aug 2023 13:53:54 -0400
Received: from mail-yw1-x112f.google.com (mail-yw1-x112f.google.com [IPv6:2607:f8b0:4864:20::112f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3286510D2
        for <linux-trace-devel@vger.kernel.org>; Wed,  9 Aug 2023 10:53:53 -0700 (PDT)
Received: by mail-yw1-x112f.google.com with SMTP id 00721157ae682-58439daf39fso1893407b3.1
        for <linux-trace-devel@vger.kernel.org>; Wed, 09 Aug 2023 10:53:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1691603632; x=1692208432;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=H/GVNR1+f6ibHYECjkTJhLM5qBcdko90xedLKCgtzDM=;
        b=QVHc80OLn9QbsKPVPTQNZMCUdSU7ViidHsRHuSNJnXpronG6y463ZphIJD9lrok3Ub
         zx5ExzsUrBqcqgXAHs62HhCkXumOJe1Kr3grZyqfOHEYTFM+NRleX7tJvgf+HG65YMOO
         QxcAC6ZicqLufFE5jLLvzvO1FmExWdgGWYPW8Nm6xTjE7rTv2iiRVf0xiMBxllEz3paR
         HGntegmAtzEK6SL6+oXi4VhCJMrmG0h5uAJolz1IVx0TtYLAKrfDyVL03xngDfjoQ0Tp
         u2go1GUkiFkFStmUHw0BSW2JMDkmj+eCo+OkVT7lgvJXlL6ZvZDwj4regKnWYz8rju/P
         Wq4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691603632; x=1692208432;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=H/GVNR1+f6ibHYECjkTJhLM5qBcdko90xedLKCgtzDM=;
        b=dtCiwYQZTwo5RIuYPtyXzRTdDxaG9sAm1EEFbRb1e3LPJSoMGfiljXgggmcMSFUik0
         uibQd+4U2xr+Vs9TZuou7bBSRRXMH7yvCv1MwrlCNlPwSuYr9MMcb6n47Qvz2EX5E+NL
         UgpvnYTdEmEOp/h4cMK8WXUVXUHPDyCHa1t+IH1kaZmEaVbTcSUZUTHle7edjJlcDCQF
         2V1A/Nr0/CgoVlGCoaI2ZBPps/8Ydu/MEHPm4/QmD/R33p3zL9LijYRg8dlDIYTYzRyI
         F7gG/47x2iGgTGkN1abxKxT1e7owBlBWg9oiZ4mzmhq1a6wa7H/IeHrA/x2V41P2dKg4
         eA3w==
X-Gm-Message-State: AOJu0Yy/sxqs8WF1qo1Un2dRI1CoXihAfYF36Bn9CUdTiJ2ipkyf7PHI
        2dBFTzy3Yv0ounN3BqeXNN1rAxSiZWo=
X-Google-Smtp-Source: AGHT+IGPM1wmwNCP17/C6n27AFhli8woEieVQGra3AZ2A7p9Fo3lrwdA5hMT9pj/YX/ie0HLVFlaAQ==
X-Received: by 2002:a81:914e:0:b0:576:777f:28bc with SMTP id i75-20020a81914e000000b00576777f28bcmr13341ywg.21.1691603631982;
        Wed, 09 Aug 2023 10:53:51 -0700 (PDT)
Received: from 3xKetch.hsd1.ma.comcast.net ([2601:180:8300:500::2409])
        by smtp.gmail.com with ESMTPSA id x4-20020a0c8e84000000b00623839cba8csm4633646qvb.44.2023.08.09.10.53.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Aug 2023 10:53:51 -0700 (PDT)
From:   Stevie Alvarez <stevie.6strings@gmail.com>
To:     linux-trace-devel@vger.kernel.org
Cc:     Stevie Alvarez <stevie.6strings@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Ross Zwisler <zwisler@google.com>
Subject: [PATCH v4 5/5] histograms: Add traceeval insert
Date:   Wed,  9 Aug 2023 13:53:38 -0400
Message-ID: <20230809175340.3066-6-stevie.6strings@gmail.com>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230809175340.3066-1-stevie.6strings@gmail.com>
References: <20230809175340.3066-1-stevie.6strings@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: Stevie Alvarez (Google) <stevie.6strings@gmail.com>

traceeval_insert() updates the provided struct traceeval's histogram.
If an entry that exists with a keys field that match the keys argument,
the entries vals field are updated with a copy of the vals argument.
If such an entry does not exist, a new entry is added to the histogram,
with respect to the keys and vals arguments.

Signed-off-by: Stevie Alvarez (Google) <stevie.6strings@gmail.com>
---
 include/traceeval-hist.h |   4 ++
 src/histograms.c         | 114 +++++++++++++++++++++++++++++++++++++++
 2 files changed, 118 insertions(+)

diff --git a/include/traceeval-hist.h b/include/traceeval-hist.h
index 82cfbb1..08e0696 100644
--- a/include/traceeval-hist.h
+++ b/include/traceeval-hist.h
@@ -134,6 +134,10 @@ struct traceeval *traceeval_init(const struct traceeval_type *keys,
 
 void traceeval_release(struct traceeval *teval);
 
+int traceeval_insert(struct traceeval *teval,
+		     const union traceeval_data *keys,
+		     const union traceeval_data *vals);
+
 int traceeval_query(struct traceeval *teval, const union traceeval_data *keys,
 		    union traceeval_data **results);
 
diff --git a/src/histograms.c b/src/histograms.c
index 1b6e3a0..a159892 100644
--- a/src/histograms.c
+++ b/src/histograms.c
@@ -688,3 +688,117 @@ void traceeval_results_release(struct traceeval *teval,
 
 	data_release(teval->nr_val_types, &results, teval->val_types);
 }
+
+/*
+ * Create a new entry in @teval with respect to @keys and @vals.
+ *
+ * Returns 0 on success, -1 on error.
+ */
+static int create_entry(struct traceeval *teval,
+			const union traceeval_data *keys,
+			const union traceeval_data *vals)
+{
+	union traceeval_data *new_keys;
+	union traceeval_data *new_vals;
+	struct entry *tmp_map;
+	struct hist_table *hist = teval->hist;
+
+	/* copy keys */
+	if (copy_traceeval_data_set(teval->nr_key_types, teval->key_types,
+				keys, &new_keys) == -1)
+		return -1;
+
+	/* copy vals */
+	if (copy_traceeval_data_set(teval->nr_val_types, teval->val_types,
+				vals, &new_vals) == -1)
+		goto fail_vals;
+
+	/* create new entry */
+	tmp_map = realloc(hist->map, ++hist->nr_entries * sizeof(*tmp_map));
+	if (!tmp_map)
+		goto fail;
+	tmp_map->keys = new_keys;
+	tmp_map->vals = new_vals;
+	hist->map = tmp_map;
+
+	return 0;
+
+fail:
+	data_release(teval->nr_val_types, &new_vals, teval->val_types);
+
+fail_vals:
+	data_release(teval->nr_key_types, &new_keys, teval->key_types);
+	return -1;
+}
+
+/*
+ * Update @entry's vals field with a copy of @vals, with respect to @teval.
+ *
+ * Frees the old vals field of @entry, unless an error occurs.
+ *
+ * Return 0 on success, -1 on error.
+ */
+static int update_entry(struct traceeval *teval, struct entry *entry,
+			const union traceeval_data *vals)
+{
+	union traceeval_data *new_vals;
+
+	if (copy_traceeval_data_set(teval->nr_val_types, teval->val_types,
+				vals, &new_vals) == -1)
+		return -1;
+
+	clean_data_set(entry->vals, teval->val_types, teval->nr_val_types);
+	entry->vals = new_vals;
+	return 0;
+}
+
+/*
+ * traceeval_insert - insert an item into the traceeval descriptor
+ * @teval: The descriptor to insert into
+ * @keys: The list of keys that defines what is being inserted.
+ * @vals: The list of values that defines what is being inserted.
+ *
+ * The @keys is an array that holds the data in the order of the keys
+ * passed into traceeval_init(). That is, if traceeval_init() had
+ * keys = { { .type = TRACEEVAL_STRING }, { .type = TRACEEVAL_NUMBER_8 },
+ * { .type = TRACEEVAL_NONE } }; then the @keys array passed in must
+ * be a string (char *) followed by a 8 byte number (char).
+ *
+ * The @keys and @vals are only examined to where it expects data. That is,
+ * if the traceeval_init() keys had 3 items where the first two was defining
+ * data, and the last one was the TRACEEVAL_TYPE_NONE, then the @keys
+ * here only needs to be an array of 2, inserting the two items defined
+ * by traceeval_init(). The same goes for @vals.
+ *
+ * If an entry with keys that match @keys exists, it's vals field is freed and
+ * set to a copy of @vals. This process calls dyn_release() on any data of
+ * type TRACEEVAL_TYPE_DYNAMIC.
+ * Otherwise, a new entry is created with copies of @keys and @vals.
+ *
+ * For all elements of @keys and @vals that correspond to a struct
+ * traceeval_type of type TRACEEVAL_TYPE_STRING, the string field must be set
+ * a valid pointer or NULL.
+ *
+ * On error, @teval is left unchanged.
+ *
+ * Returns 0 on success, and -1 on error.
+ */
+int traceeval_insert(struct traceeval *teval,
+		     const union traceeval_data *keys,
+		     const union traceeval_data *vals)
+{
+	struct entry *entry;
+	int check;
+
+	entry = NULL;
+	check = get_entry(teval, keys, &entry);
+
+	if (check == -1)
+		return check;
+
+	/* insert key-value pair */
+	if (check == 0)
+		return create_entry(teval, keys, vals);
+	else
+		return update_entry(teval, entry, vals);
+}
-- 
2.41.0

