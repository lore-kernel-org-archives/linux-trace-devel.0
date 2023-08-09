Return-Path: <linux-trace-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6EAF3C04A94
	for <linux-trace-devel@archiver.kernel.org>; Wed,  9 Aug 2023 03:13:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230321AbjHIDNY (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 8 Aug 2023 23:13:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32848 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230448AbjHIDNT (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 8 Aug 2023 23:13:19 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A02F1FCC
        for <linux-trace-devel@vger.kernel.org>; Tue,  8 Aug 2023 20:13:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D2E1A62EFB
        for <linux-trace-devel@vger.kernel.org>; Wed,  9 Aug 2023 03:13:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 44969C433CD;
        Wed,  9 Aug 2023 03:13:17 +0000 (UTC)
Received: from rostedt by gandalf with local (Exim 4.96)
        (envelope-from <rostedt@rostedt.homelinux.com>)
        id 1qTZdL-005Rvs-34;
        Tue, 08 Aug 2023 23:13:15 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-trace-devel@vger.kernel.org
Cc:     Stevie Alvarez <stevie.6strings@gmail.com>,
        Ross Zwisler <zwisler@google.com>,
        "Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH 5/6] libtraceeval histogram: Fix the return value of traceeval_query()
Date:   Tue,  8 Aug 2023 23:13:12 -0400
Message-Id: <20230809031313.1298605-6-rostedt@goodmis.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230809031313.1298605-1-rostedt@goodmis.org>
References: <20230809031313.1298605-1-rostedt@goodmis.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (Google)" <rostedt@goodmis.org>

The comments state that traceeval_query() returns 1 if found, 0 if not,
and -1 on error, but in reality it returns 0 if found and 1 if not found.

It makes more sense to have it return 1 if found and zero if not found as
the comment states.

Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
 src/histograms.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/src/histograms.c b/src/histograms.c
index 3cf5c5389700..226c2792995c 100644
--- a/src/histograms.c
+++ b/src/histograms.c
@@ -551,7 +551,7 @@ static int get_entry(struct traceeval *teval, const union traceeval_data *keys,
 		/* return entry if keys match */
 		if (!check) {
 			*result = entry;
-			return 0;
+			return 1;
 		} else if (check == 1) {
 			continue;
 		} else {
@@ -559,7 +559,7 @@ static int get_entry(struct traceeval *teval, const union traceeval_data *keys,
 		}
 	}
 
-	return 1;
+	return 0;
 }
 
 /*
@@ -660,7 +660,7 @@ int traceeval_query(struct traceeval *teval, const union traceeval_data *keys,
 		return -1;
 
 	/* find key and copy its corresponding value pair */
-	if ((check = get_entry(teval, keys, &entry)))
+	if ((check = get_entry(teval, keys, &entry)) < 0)
 		return check;
 	return copy_traceeval_data_set(teval->nr_val_types, teval->val_types,
 			entry->vals, results);
-- 
2.40.1

