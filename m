Return-Path: <linux-trace-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4529FC71130
	for <linux-trace-devel@archiver.kernel.org>; Thu, 17 Aug 2023 22:24:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355707AbjHQWY3 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 17 Aug 2023 18:24:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49966 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355703AbjHQWYU (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 17 Aug 2023 18:24:20 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4BE0930E1
        for <linux-trace-devel@vger.kernel.org>; Thu, 17 Aug 2023 15:24:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5246B66CCE
        for <linux-trace-devel@vger.kernel.org>; Thu, 17 Aug 2023 22:24:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 343DBC43391;
        Thu, 17 Aug 2023 22:24:17 +0000 (UTC)
Received: from rostedt by gandalf with local (Exim 4.96)
        (envelope-from <rostedt@rostedt.homelinux.com>)
        id 1qWlPj-000Usb-2a;
        Thu, 17 Aug 2023 18:24:23 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-trace-devel@vger.kernel.org
Cc:     Ross Zwisler <zwisler@google.com>,
        Stevie Alvarez <stevie.6strings@gmail.com>,
        "Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH 6/9] libtraceveal: Add type checks to traceeval_data vals and keys
Date:   Thu, 17 Aug 2023 18:24:19 -0400
Message-Id: <20230817222422.118568-7-rostedt@goodmis.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230817222422.118568-1-rostedt@goodmis.org>
References: <20230817222422.118568-1-rostedt@goodmis.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (Google)" <rostedt@goodmis.org>

Now that the traceeval_data has a type, add checks to traceeval_insert()
and traceveal_query() as well as traceeval_stat() to make sure the keys
and vals match the types that were for the traceeval.

Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
 src/histograms.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/src/histograms.c b/src/histograms.c
index 7c0eef6cf421..560046cc8d96 100644
--- a/src/histograms.c
+++ b/src/histograms.c
@@ -479,10 +479,16 @@ static int get_entry(struct traceeval *teval, const struct traceeval_data *keys,
 	struct hash_item *item;
 	unsigned key;
 	int check = 0;
+	int i;
 
 	if (!teval || !keys)
 		return -1;
 
+	for (i = 0; i < teval->nr_key_types; i++) {
+		if (keys[i].type != teval->key_types[i].type)
+			return -1;
+	}
+
 	key = make_hash(teval, keys, hist->bits);
 
 	for (iter = hash_iter_bucket(hist, key); (item = hash_iter_bucket_next(iter)); ) {
@@ -928,10 +934,16 @@ int traceeval_insert(struct traceeval *teval,
 {
 	struct entry *entry;
 	int check;
+	int i;
 
 	entry = NULL;
 	check = get_entry(teval, keys, &entry);
 
+	for (i = 0; i < teval->nr_val_types; i++) {
+		if (vals[i].type != teval->val_types[i].type)
+			return -1;
+	}
+
 	if (check == -1)
 		return check;
 
-- 
2.40.1

