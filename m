Return-Path: <linux-trace-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E4CA7C0015E
	for <linux-trace-devel@archiver.kernel.org>; Fri, 28 Jul 2023 19:05:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229509AbjG1TFp (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 28 Jul 2023 15:05:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36252 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229740AbjG1TFn (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 28 Jul 2023 15:05:43 -0400
Received: from mail-il1-x132.google.com (mail-il1-x132.google.com [IPv6:2607:f8b0:4864:20::132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 33FEC3AB3
        for <linux-trace-devel@vger.kernel.org>; Fri, 28 Jul 2023 12:05:42 -0700 (PDT)
Received: by mail-il1-x132.google.com with SMTP id e9e14a558f8ab-348db491d0eso10588355ab.3
        for <linux-trace-devel@vger.kernel.org>; Fri, 28 Jul 2023 12:05:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1690571141; x=1691175941;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Z1ssfZnnt5Fl/bPSmz3r2pmt8oVxKZGgBLxCrOoJiIc=;
        b=jX11NnuAJMphNL0qOdzPhAotZ7PIR1sQT6oPfMICBurSmTIAJCiehF9sehjtnxdpM+
         rBLs3Y9hvOeN7BXlcGXG7mCpa5TaH25LJt1SzYkbDzmzFnW/W+octu8UsGaHys8V0oeP
         Mg/sdBtbZsHPy/kp3TxzXeihjYMjA5zkPWB+o8Nruf5Llhudff3uzOcD/jdIoh4zLHDg
         cZEe6Rp92leYbJIsUSxmWdYOHgOi1hEYa3VxPxG9vx37ci6Z5e9zf9QmgN3ES12MXOr7
         VNmJlY87vqAXD08p04r7A4ZunwNdZErInFnc2t11e/ubrL33GWSzfHsIaJlK37FlEQoV
         elmA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690571141; x=1691175941;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Z1ssfZnnt5Fl/bPSmz3r2pmt8oVxKZGgBLxCrOoJiIc=;
        b=Y5kAdPOas5BuUalMFn9k671DjLu+7Sob1be8zkxpBSrZq/GgZiSXN6XDJjxQPRxFIn
         t/U3OcMdKr4YDLFVxmBtP9Y4f9qQ8T5fdPYAp7p/iafN7hKOwt9Ul45/pfDT/P75epAJ
         DxeVrUwWZcJVcLmwMW7tpQX5db7VzrY0F/FA62WwgSSGMt7UIvPFgbPG1eFoqVFiLxcb
         XAHFEPcvEGKu9h3gFnqfyBai/lL03taNWmSytRjfkwleMO9q+Z2YPx1iUIc9FofA2tK1
         oahYiGJTTEJK5FQnBzHOnHu9xo7J8HXzJSJADfCyv+2zYlUIXrMVCyzLW5vJ0DIalAWv
         tWWQ==
X-Gm-Message-State: ABy/qLZwNo/V2PA9HVQKe82EhCoca6pjTOy8xV6iaeE6oDP87wBxI/5d
        ngnKi5XdahQTPYGd2+hAuotKHII2EuuFxg==
X-Google-Smtp-Source: APBJJlFVPCATJoEPny6NMLYeOLLtZYdm8IqrJwBgnfeLa0NCHC39vxLtwZj38QKkAd7o6BXggPsacQ==
X-Received: by 2002:a05:6602:692:b0:780:ce72:ac55 with SMTP id dp18-20020a056602069200b00780ce72ac55mr436293iob.10.1690571141236;
        Fri, 28 Jul 2023 12:05:41 -0700 (PDT)
Received: from localhost.localdomain ([2a00:79e1:abc:1705:d317:f8ec:adf0:bb06])
        by smtp.gmail.com with ESMTPSA id u22-20020a02aa96000000b0042b3a328ee0sm1268452jai.166.2023.07.28.12.05.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 28 Jul 2023 12:05:40 -0700 (PDT)
From:   Stevie Alvarez <stevie.6strings@gmail.com>
To:     linux-trace-devel@vger.kernel.org
Cc:     "Stevie Alvarez (Google)" <stevie.6strings@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Ross Zwisler <zwisler@google.com>
Subject: [PATCH 3/5] histograms: traceeval release
Date:   Fri, 28 Jul 2023 15:04:38 -0400
Message-ID: <20230728190515.23088-3-stevie.6strings@gmail.com>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230728190515.23088-1-stevie.6strings@gmail.com>
References: <20230728190515.23088-1-stevie.6strings@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Stevie Alvarez (Google)" <stevie.6strings@gmail.com>

traceeval_release() deconstructs a given struct traceeval instance. It
frees any data allocated to the heap within the union traceeval_data
arrays of entries to the histogram, and the names allocated for the
struct traceeval_type key-value definitions.

Signed-off-by: Stevie Alvarez (Google) <stevie.6strings@gmail.com>
---
 src/histograms.c | 87 ++++++++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 85 insertions(+), 2 deletions(-)

diff --git a/src/histograms.c b/src/histograms.c
index 13830e4..f46a0e0 100644
--- a/src/histograms.c
+++ b/src/histograms.c
@@ -209,10 +209,93 @@ fail_eval_init_unalloced:
 	return NULL;
 }
 
-// TODO
-void traceeval_release(struct traceeval *teval)
+/**
+ * Deallocate array of traceeval_type's, which must be terminated by
+ * TRACEEVAL_TYPE_NONE.
+ */
+static void type_release(struct traceeval_type *defs)
 {
+	size_t i = 0;
+
+	if (!defs)
+		return;
+
+	for_each_key(i, defs) {
+		if (defs[i].name)
+			free(defs[i].name);
+	}
+
+	free(defs);
+}
+
+/**
+ * Deallocate any specified dynamic data in @data.
+ */
+static void clean_data(union traceeval_data *data, struct traceeval_type *def)
+{
+	size_t i = 0;
+
+	if (!data || !def)
+		return;
+
+	for_each_key(i, def) {
+		switch (def[i].type) {
+		case TRACEEVAL_TYPE_STRING:
+			if (data[i].string)
+				free(data[i].string);
+			break;
+		case TRACEEVAL_TYPE_DYNAMIC:
+			def[i].dyn_release(data[i].dyn_data, &def[i]);
+			break;
+		default:
+			break;
+		}
+	}
+}
 
+/**
+ * Deallocate all possible data stored within the entry.
+ */
+static void clean_entry(struct entry *entry, struct traceeval *teval)
+{
+	if (!entry)
+		return;
+
+	// deallocate dynamic traceeval_data
+	clean_data(entry->keys, teval->def_keys);
+	clean_data(entry->vals, teval->def_vals);
+	free(entry->keys);
+	free(entry->vals);
+}
+
+/**
+ * Deallocate the hist_table allocated to a traceeval instance.
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
+	free(hist->map);
+	free(hist);
+}
+
+/**
+ * Deallocate a traceeval instance.
+ */
+void traceeval_release(struct traceeval *teval)
+{
+	if (teval) {
+		hist_table_release(teval);
+		type_release(teval->def_keys);
+		type_release(teval->def_vals);
+		free(teval);
+	}
 }
 
 // TODO
-- 
2.41.0

