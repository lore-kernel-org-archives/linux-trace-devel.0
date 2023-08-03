Return-Path: <linux-trace-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8B4E7C04A94
	for <linux-trace-devel@archiver.kernel.org>; Thu,  3 Aug 2023 22:54:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230330AbjHCWyf (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 3 Aug 2023 18:54:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41800 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229879AbjHCWye (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 3 Aug 2023 18:54:34 -0400
Received: from mail-pg1-x52c.google.com (mail-pg1-x52c.google.com [IPv6:2607:f8b0:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 60894AC
        for <linux-trace-devel@vger.kernel.org>; Thu,  3 Aug 2023 15:54:33 -0700 (PDT)
Received: by mail-pg1-x52c.google.com with SMTP id 41be03b00d2f7-55b22f82ac8so1809944a12.1
        for <linux-trace-devel@vger.kernel.org>; Thu, 03 Aug 2023 15:54:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1691103272; x=1691708072;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=8s1Njp7emT56RUebp/kjFqv/g8h2ZqfPKfPF7K5wmXY=;
        b=kvJEqIHd+xKKoDzfPQ4DQSsA5LRJvRVodEgdT7gprgWLhHRRHJ0Ysj5AjDMEDdVmUf
         3ff8QFG+Pv18pRtWnMqiZfaZcHWzqm2F95UDGDXd+mrIy7U/JBhaeuv9mli7GwiQAK2j
         cHk81UMczxGwZb0uVBMMcZLbVvZDEpZIGVxAbV3aRU8mLH02sJbUF2FNjv7q1Sh/cSd3
         MiPtTQgBG62xId+6cAQ7IjtqmVY8oZJEVhCROu2tbS7mjpKxbdEnIsspUY/utshPo5Ak
         Gzv4n0SOofu/MTe4pWPu93V1F8cZHBo/765D9BHxZPtfyHTDXZj54UfZANhJeHuMwEJG
         0UWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691103272; x=1691708072;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=8s1Njp7emT56RUebp/kjFqv/g8h2ZqfPKfPF7K5wmXY=;
        b=JPZ4DEL8OeOJpjXH4x6b4vIkHWXk5tq6DnQPoQZ8YJLesbvCLdOIDHpYFrphlbHr/z
         jqWEztKiINmTl4UAYuE2hyBn1va1eDmAZdG8wXVEVTKWZ9zLk8gWeaOXKzuBuxWQVc7j
         GrRWIMbA2ZubOfE02fv5slmtKNXPOibzWlUT+giCB24XWvmNjh3Z7Hrml3wAOr4RKIx+
         04aCa9ksoglUPxk3YoRqZtxUvklhU5eTa1AR5rV563TIzVlZ11PqYpyIshHd4jlx+v0r
         EdwQyE5k37hWJn5yF0T22lBMcAr0byCYjUXKLBOSQz6VwSUzw5f8djji1igtMa7KKPs0
         8hDA==
X-Gm-Message-State: AOJu0YzOnal37msuhphvJ4kZvBpvQyxjJWoqgx/JXjcM0hZpk4xQ7WMM
        9gtnmJlcvBypWKvy+CcmJv5BFLEyBm74gg==
X-Google-Smtp-Source: AGHT+IGLkSKvHzu+ON0NvDc8NAjxETEO3xUA7L/V0gQI3nneMvNjFfHL1ZGBwDslfhHpUT2cQXya/Q==
X-Received: by 2002:a17:90b:3111:b0:268:409:e795 with SMTP id gc17-20020a17090b311100b002680409e795mr137517pjb.22.1691103272462;
        Thu, 03 Aug 2023 15:54:32 -0700 (PDT)
Received: from 3xKetch.lan ([2601:600:a17f:b422::ffc])
        by smtp.gmail.com with ESMTPSA id o14-20020a17090a4b4e00b00268b439a0cbsm351120pjl.23.2023.08.03.15.54.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Aug 2023 15:54:32 -0700 (PDT)
From:   Stevie Alvarez <stevie.6strings@gmail.com>
To:     linux-trace-devel@vger.kernel.org
Cc:     "Stevie Alvarez (Google)" <stevie.6strings@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Ross Zwisler <zwisler@google.com>
Subject: [PATCH v2 3/5] histograms: Add traceeval release
Date:   Thu,  3 Aug 2023 18:54:01 -0400
Message-ID: <20230803225413.40697-4-stevie.6strings@gmail.com>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230803225413.40697-1-stevie.6strings@gmail.com>
References: <20230803225413.40697-1-stevie.6strings@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Stevie Alvarez (Google)" <stevie.6strings@gmail.com>

traceeval_release() deconstructs a given struct traceeval instance. It
frees any data allocated to the heap within the entries to the histogram,
and the names allocated for the struct traceeval_type key-value
definitions.

Signed-off-by: Stevie Alvarez (Google) <stevie.6strings@gmail.com>
---
 include/traceeval-hist.h |  2 +
 src/histograms.c         | 84 ++++++++++++++++++++++++++++++++++++++++
 2 files changed, 86 insertions(+)

diff --git a/include/traceeval-hist.h b/include/traceeval-hist.h
index 5bea025..cd74d3e 100644
--- a/include/traceeval-hist.h
+++ b/include/traceeval-hist.h
@@ -130,4 +130,6 @@ struct traceeval;
 struct traceeval *traceeval_init(const struct traceeval_type *keys,
 		const struct traceeval_type *vals);
 
+void traceeval_release(struct traceeval *teval);
+
 #endif /* __LIBTRACEEVAL_HIST_H__ */
diff --git a/src/histograms.c b/src/histograms.c
index be17b89..95243b0 100644
--- a/src/histograms.c
+++ b/src/histograms.c
@@ -221,3 +221,87 @@ fail_init_unalloced:
 	print_err(err_msg);
 	return NULL;
 }
+
+/*
+ * Free any specified dynamic data in @data.
+ */
+static void clean_data(union traceeval_data *data, struct traceeval_type *defs,
+		size_t size)
+{
+	size_t i;
+
+	if (!data || !defs)
+		return;
+
+	for (i = 0; i < size; i++) {
+		switch (defs[i].type) {
+		case TRACEEVAL_TYPE_STRING:
+			free(data[i].string);
+			break;
+		case TRACEEVAL_TYPE_DYNAMIC:
+			if (defs[i].dyn_release)
+				defs[i].dyn_release(data[i].dyn_data, &defs[i]);
+			break;
+		default:
+			break;
+		}
+	}
+}
+
+/*
+ * Free all possible data stored within the entry.
+ */
+static void clean_entry(struct entry *entry, struct traceeval *teval)
+{
+	if (!entry)
+		return;
+
+	/* free dynamic traceeval_data */
+	clean_data(entry->keys, teval->key_types, teval->nr_key_types);
+	clean_data(entry->vals, teval->val_types, teval->nr_val_types);
+	free(entry->keys);
+	free(entry->vals);
+}
+
+/*
+ * Free the hist_table allocated to a traceeval instance.
+ */
+static void hist_table_release(struct traceeval *teval)
+{
+	struct hist_table *hist = teval->hist;
+
+	if (!hist)
+		return;
+
+	for (size_t i = 0; i < hist->nr_entries; i++) {
+		clean_entry(&hist->map[i], teval);
+	}
+
+	free(hist->map);
+	free(hist);
+	teval->hist = NULL;
+}
+
+/*
+ * traceeval_release - release a traceeval descriptor
+ * @teval: An instance of traceeval returned by traceeval_init()
+ *
+ * When the caller of traceeval_init() is done with the returned @teval,
+ * it must call traceeval_release().
+ *
+ * This frees all internally allocated data of @teval and will call the
+ * corresponding dyn_release() functions registered for keys and values of
+ * type TRACEEVAL_TYPE_DYNAMIC.
+ */
+void traceeval_release(struct traceeval *teval)
+{
+	if (!teval)
+		return;
+
+	hist_table_release(teval);
+	type_release(teval->key_types, teval->nr_key_types);
+	type_release(teval->val_types, teval->nr_val_types);
+	teval->key_types = NULL;
+	teval->val_types = NULL;
+	free(teval);
+}
-- 
2.41.0

