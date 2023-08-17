Return-Path: <linux-trace-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B8AB6C71131
	for <linux-trace-devel@archiver.kernel.org>; Thu, 17 Aug 2023 20:46:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354998AbjHQUqC (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 17 Aug 2023 16:46:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51242 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355009AbjHQUpa (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 17 Aug 2023 16:45:30 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C508D30E1
        for <linux-trace-devel@vger.kernel.org>; Thu, 17 Aug 2023 13:45:28 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 74C8265DAC
        for <linux-trace-devel@vger.kernel.org>; Thu, 17 Aug 2023 20:45:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1B714C433BA;
        Thu, 17 Aug 2023 20:45:23 +0000 (UTC)
Received: from rostedt by gandalf with local (Exim 4.96)
        (envelope-from <rostedt@rostedt.homelinux.com>)
        id 1qWjs1-000TqH-1s;
        Thu, 17 Aug 2023 16:45:29 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-trace-devel@vger.kernel.org
Cc:     Ross Zwisler <zwisler@google.com>,
        Stevie Alvarez <stevie.6strings@gmail.com>,
        "Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH v4 20/20] libtraceeval: Add traceeval_remove()
Date:   Thu, 17 Aug 2023 16:45:28 -0400
Message-Id: <20230817204528.114577-21-rostedt@goodmis.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230817204528.114577-1-rostedt@goodmis.org>
References: <20230817204528.114577-1-rostedt@goodmis.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (Google)" <rostedt@goodmis.org>

Add a way to remove an entry that's in the traceeval. Currently there's
only ways to add entries, but there also needs to be a way to remove them
too.

Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
 include/traceeval-hist.h |  3 +++
 src/histograms.c         | 29 +++++++++++++++++++++++++++++
 2 files changed, 32 insertions(+)

diff --git a/include/traceeval-hist.h b/include/traceeval-hist.h
index 4e0e9c057045..0cee9bcbeb83 100644
--- a/include/traceeval-hist.h
+++ b/include/traceeval-hist.h
@@ -160,6 +160,9 @@ int traceeval_insert(struct traceeval *teval,
 		     const union traceeval_data *keys,
 		     const union traceeval_data *vals);
 
+int traceeval_remove(struct traceeval *teval,
+		     const union traceeval_data *keys);
+
 int traceeval_query(struct traceeval *teval, const union traceeval_data *keys,
 		    const union traceeval_data **results);
 
diff --git a/src/histograms.c b/src/histograms.c
index c008694b41b7..96f0926f062c 100644
--- a/src/histograms.c
+++ b/src/histograms.c
@@ -934,6 +934,35 @@ int traceeval_insert(struct traceeval *teval,
 		return update_entry(teval, entry, vals);
 }
 
+/**
+ * traceeval_remove - remove an item from the traceeval descriptor
+ * @teval: The descriptor to removed from
+ * @keys: The list of keys that defines what is being removed
+ *
+ * This is the opposite of traceeval_insert(). Instead of inserting
+ * an item into the traceeval historgram, it removes it.
+ *
+ * Returns 1 if it found and removed an item,
+ *         0 if it did not find an time matching @keys
+ *        -1 if there was an error.
+ */
+int traceeval_remove(struct traceeval *teval,
+		     const union traceeval_data *keys)
+{
+	struct hash_table *hist = teval->hist;
+	struct entry *entry;
+	int check;
+
+	entry = NULL;
+	check = get_entry(teval, keys, &entry);
+
+	if (check < 1)
+		return check;
+
+	hash_remove(hist, &entry->hash);
+	return 1;
+}
+
 /**
  * traceeval_iterator_put - release a given iterator
  * @iter: The iterartor to release
-- 
2.40.1

