Return-Path: <linux-trace-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D6B8CC64EAE
	for <linux-trace-devel@archiver.kernel.org>; Thu, 17 Aug 2023 20:46:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354999AbjHQUpy (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 17 Aug 2023 16:45:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52118 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354982AbjHQUp0 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 17 Aug 2023 16:45:26 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ADA9D2698
        for <linux-trace-devel@vger.kernel.org>; Thu, 17 Aug 2023 13:45:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3AABF63B1E
        for <linux-trace-devel@vger.kernel.org>; Thu, 17 Aug 2023 20:45:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A04C8C433C8;
        Thu, 17 Aug 2023 20:45:22 +0000 (UTC)
Received: from rostedt by gandalf with local (Exim 4.96)
        (envelope-from <rostedt@rostedt.homelinux.com>)
        id 1qWjs1-000Tp6-0W;
        Thu, 17 Aug 2023 16:45:29 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-trace-devel@vger.kernel.org
Cc:     Ross Zwisler <zwisler@google.com>,
        Stevie Alvarez <stevie.6strings@gmail.com>,
        "Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH v4 02/20] libtraceeval: Reverse params of copy_traceeval_data()
Date:   Thu, 17 Aug 2023 16:45:10 -0400
Message-Id: <20230817204528.114577-3-rostedt@goodmis.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230817204528.114577-1-rostedt@goodmis.org>
References: <20230817204528.114577-1-rostedt@goodmis.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (Google)" <rostedt@goodmis.org>

Most C library functions copy data from "dst", "src" order, but
copy_traceeval_data() does it as "src", "dst", and I already made one bug
because of this. Reverse the order of the copy_traceeval_data()
parameters, and also rename them to match standard library names "dst" and
"src".

Link: https://lore.kernel.org/linux-trace-devel/20230817192926.GA73817@google.com/

Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
 src/histograms.c | 18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff --git a/src/histograms.c b/src/histograms.c
index d22d15238616..071e30e73768 100644
--- a/src/histograms.c
+++ b/src/histograms.c
@@ -560,25 +560,25 @@ static int get_entry(struct traceeval *teval, const union traceeval_data *keys,
 }
 
 /*
- * Copy @orig to @copy with respect to @type.
+ * Copy @src to @dst with respect to @type.
  *
  * Return 0 on success, -1 on error.
  */
 static int copy_traceeval_data(struct traceeval_type *type,
-				const union traceeval_data *orig,
-				union traceeval_data *copy)
+				union traceeval_data *dst,
+				const union traceeval_data *src)
 {
-	*copy = *orig;
+	*dst = *src;
 
 	if (type->type == TRACEEVAL_TYPE_STRING) {
-		copy->string = NULL;
+		dst->string = NULL;
 
-		if (orig->string)
-			copy->string = strdup(orig->string);
+		if (src->string)
+			dst->string = strdup(src->string);
 		else
 			return 0;
 
-		if (!copy->string)
+		if (!dst->string)
 			return -1;
 	}
 
@@ -621,7 +621,7 @@ static int copy_traceeval_data_set(size_t size, struct traceeval_type *type,
 		return -1;
 
 	for (i = 0; i < size; i++) {
-		if (copy_traceeval_data(type + i, orig + i, (*copy) + i))
+		if (copy_traceeval_data(type + i, (*copy) + i, orig + i))
 			goto fail;
 	}
 
-- 
2.40.1

