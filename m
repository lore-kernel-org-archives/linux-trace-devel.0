Return-Path: <linux-trace-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 30051C001DE
	for <linux-trace-devel@archiver.kernel.org>; Fri, 11 Aug 2023 05:39:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229907AbjHKFjw (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 11 Aug 2023 01:39:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47042 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232663AbjHKFjr (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 11 Aug 2023 01:39:47 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 498A12D4F
        for <linux-trace-devel@vger.kernel.org>; Thu, 10 Aug 2023 22:39:47 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 135D365353
        for <linux-trace-devel@vger.kernel.org>; Fri, 11 Aug 2023 05:39:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E9AF9C433AD;
        Fri, 11 Aug 2023 05:39:44 +0000 (UTC)
Received: from rostedt by gandalf with local (Exim 4.96)
        (envelope-from <rostedt@rostedt.homelinux.com>)
        id 1qUKsB-005uQN-3D;
        Fri, 11 Aug 2023 01:39:44 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-trace-devel@vger.kernel.org
Cc:     Stevie Alvarez <stevie.6strings@gmail.com>,
        Ross Zwisler <zwisler@google.com>,
        "Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH v2 13/17] libtraceeval histogram: Do the release on updates
Date:   Fri, 11 Aug 2023 01:39:36 -0400
Message-Id: <20230811053940.1408424-14-rostedt@goodmis.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230811053940.1408424-1-rostedt@goodmis.org>
References: <20230811053940.1408424-1-rostedt@goodmis.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (Google)" <rostedt@goodmis.org>

If no copy() function exists for a type but a release() function does,
then do the release on the old copy.

Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
 src/histograms.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/src/histograms.c b/src/histograms.c
index f7f72dd3a50b..8c73d8cd9f45 100644
--- a/src/histograms.c
+++ b/src/histograms.c
@@ -596,12 +596,16 @@ static int copy_traceeval_data(struct traceeval_type *type,
 /*
  * Free @data with respect to @size and @type.
  *
- * Does not call release on type TRACEEVAL_TYPE_DYNAMIC.
+ * Does not call release() if a copy() exists.
  */
 static void data_release(size_t size, union traceeval_data **data,
 				struct traceeval_type *type)
 {
 	for (size_t i = 0; i < size; i++) {
+		/* A copy should handle releases */
+		if (type[i].release && !type[i].copy)
+			type[i].release(&type[i], &(*data)[i]);
+
 		if (type[i].type == TRACEEVAL_TYPE_STRING)
 			free((*data)[i].string);
 	}
-- 
2.40.1

