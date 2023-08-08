Return-Path: <linux-trace-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CC093C04A6A
	for <linux-trace-devel@archiver.kernel.org>; Tue,  8 Aug 2023 17:30:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234714AbjHHRa2 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 8 Aug 2023 13:30:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58396 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234690AbjHHR3y (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 8 Aug 2023 13:29:54 -0400
Received: from mail-qk1-x732.google.com (mail-qk1-x732.google.com [IPv6:2607:f8b0:4864:20::732])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2762F21789
        for <linux-trace-devel@vger.kernel.org>; Tue,  8 Aug 2023 09:12:58 -0700 (PDT)
Received: by mail-qk1-x732.google.com with SMTP id af79cd13be357-76d1dc1ebfdso717685a.0
        for <linux-trace-devel@vger.kernel.org>; Tue, 08 Aug 2023 09:12:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1691511140; x=1692115940;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/m1pL+FaoixPaPvdL+AmdJDAp2gwD/LY55IiQPiQG9Y=;
        b=KfHqg/eVYGkinsuhamhNPBQSaWjbJk64wLTj9KgCGWEfKF34D9urasr0Mn+cd8yz2R
         EGtW70YHnNUO8a6WloPvhcx8MSn0OHQV1m6+0xDTF7XeKmQOeTcDxIntTxR/LA+oX5UA
         UREOFjparVaafRPsReWoKpGNcjsyqq6qNbP/oS1JvKOJvhY06z8KrZT2PlvtGgpCf5GM
         r/o7ZcRUrAG/yfJjsYl8m1mNJw12zzkk73aBN91CHIVpojcgwqBJ0/4Cfzx89bRlWEof
         EZGLXV888Ek2+vecD5hXzB7eodE398CTXpfA6Qz7Z9tJqEBxWrIvwn4z8TljzAXilNfr
         KvDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691511140; x=1692115940;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=/m1pL+FaoixPaPvdL+AmdJDAp2gwD/LY55IiQPiQG9Y=;
        b=ZDpag0JQWSiDreSDzX5VGMGqyOMWg0kUlT+MB8hxf3ntEavXZiorTzWCD1gqFvyPYj
         ZtTekjiZgWaTGjyBqJwhep8g8H6rkWxyAosgmSGJ2c/hVoUtfBMb/pNbQumKdAdK0IXH
         KQK80ip1O8CbsawwDokss8Q7jc0sLKxW8BSqg5CoU99x4XCTQFOX4iZaEF+kXFVXmB90
         7LxeJ/XkIhYQbYYJdGk36FMT3TSfcdlzS1uw+Xb0JRuWoG6BeDwE/yF5vB7Amc+bJaLD
         dZ7pFIhiJCSWS/EnRwKn1oDDSB3Z+pS4UuQFGUUOIPm37H7onAwz//R6OMlkLS3UK8nr
         iEAg==
X-Gm-Message-State: AOJu0YxX4FgsPCwHah5AWDhrK9R01qL8a/C6TXTQGXzXZozpiJgltnIF
        B/gNpJ01ZzNMjjrtGq0dcrCAEo+KpJA=
X-Google-Smtp-Source: AGHT+IGbnzJEzs2g+LfzLCdcNf7Bva7COLu4BWqhDasZyZl5r35MXtIEcWxBcwFUlo6od6NKyQ1YKw==
X-Received: by 2002:a05:620a:2949:b0:767:ca49:bacd with SMTP id n9-20020a05620a294900b00767ca49bacdmr397717qkp.30.1691511140593;
        Tue, 08 Aug 2023 09:12:20 -0700 (PDT)
Received: from 3xKetch.hsd1.ma.comcast.net ([2601:180:8300:500::6aa8])
        by smtp.gmail.com with ESMTPSA id s7-20020a05620a030700b0076c97ae43b9sm3381540qkm.66.2023.08.08.09.12.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Aug 2023 09:12:20 -0700 (PDT)
From:   Stevie Alvarez <stevie.6strings@gmail.com>
To:     linux-trace-devel@vger.kernel.org
Cc:     Stevie Alvarez <stevie.6strings@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Ross Zwisler <zwisler@google.com>
Subject: [PATCH v3 5/6] histograms: Add traceeval insert
Date:   Tue,  8 Aug 2023 12:11:58 -0400
Message-ID: <20230808161204.5704-6-stevie.6strings@gmail.com>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230808161204.5704-1-stevie.6strings@gmail.com>
References: <20230808161204.5704-1-stevie.6strings@gmail.com>
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
 src/histograms.c         | 106 +++++++++++++++++++++++++++++++++++++++
 2 files changed, 110 insertions(+)

diff --git a/include/traceeval-hist.h b/include/traceeval-hist.h
index 4923de1..e713c70 100644
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
index 47ff175..a59542a 100644
--- a/src/histograms.c
+++ b/src/histograms.c
@@ -684,3 +684,109 @@ void traceeval_results_release(struct traceeval *teval,
 
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
+	if (check)
+		return create_entry(teval, keys, vals);
+	else
+		return update_entry(teval, entry, vals);
+}
-- 
2.41.0

