Return-Path: <linux-trace-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 64A82C71132
	for <linux-trace-devel@archiver.kernel.org>; Thu, 17 Aug 2023 22:24:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355708AbjHQWY2 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 17 Aug 2023 18:24:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49998 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355707AbjHQWYU (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 17 Aug 2023 18:24:20 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C00430E9
        for <linux-trace-devel@vger.kernel.org>; Thu, 17 Aug 2023 15:24:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 56F1C66B63
        for <linux-trace-devel@vger.kernel.org>; Thu, 17 Aug 2023 22:24:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 35915C433CD;
        Thu, 17 Aug 2023 22:24:17 +0000 (UTC)
Received: from rostedt by gandalf with local (Exim 4.96)
        (envelope-from <rostedt@rostedt.homelinux.com>)
        id 1qWlPj-000Usj-2i;
        Thu, 17 Aug 2023 18:24:23 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-trace-devel@vger.kernel.org
Cc:     Ross Zwisler <zwisler@google.com>,
        Stevie Alvarez <stevie.6strings@gmail.com>,
        "Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH 8/9] libtraceeval: Add checks to traceeval_insert() and query()
Date:   Thu, 17 Aug 2023 18:24:21 -0400
Message-Id: <20230817222422.118568-9-rostedt@goodmis.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230817222422.118568-1-rostedt@goodmis.org>
References: <20230817222422.118568-1-rostedt@goodmis.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (Google)" <rostedt@goodmis.org>

Now that there are size functions for traceeval_insert() and
traceveal_query(), add checks to make sure that the size being passed in
is actually the size expected.

Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
 src/histograms.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/src/histograms.c b/src/histograms.c
index 5e2e9200cbf6..973bf3ad279c 100644
--- a/src/histograms.c
+++ b/src/histograms.c
@@ -684,6 +684,9 @@ int traceeval_query_size(struct traceeval *teval, const struct traceeval_data *k
 	if (!teval || !keys || !results)
 		return -1;
 
+	if (nr_keys != teval->nr_key_types)
+		return -1;
+
 	/* find key and copy its corresponding value pair */
 	if ((check = get_entry(teval, keys, &entry)) < 1)
 		return check;
@@ -936,6 +939,9 @@ int traceeval_insert_size(struct traceeval *teval,
 	int check;
 	int i;
 
+	if (nr_keys != teval->nr_key_types || nr_vals != teval->nr_val_types)
+		return -1;
+
 	entry = NULL;
 	check = get_entry(teval, keys, &entry);
 
-- 
2.40.1

