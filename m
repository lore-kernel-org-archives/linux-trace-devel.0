Return-Path: <linux-trace-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E60CAEB64DD
	for <linux-trace-devel@archiver.kernel.org>; Fri, 11 Aug 2023 05:39:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232929AbjHKFju (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 11 Aug 2023 01:39:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47012 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232450AbjHKFjr (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 11 Aug 2023 01:39:47 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA24C2D5B
        for <linux-trace-devel@vger.kernel.org>; Thu, 10 Aug 2023 22:39:46 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 052E26527F
        for <linux-trace-devel@vger.kernel.org>; Fri, 11 Aug 2023 05:39:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E0703C43397;
        Fri, 11 Aug 2023 05:39:44 +0000 (UTC)
Received: from rostedt by gandalf with local (Exim 4.96)
        (envelope-from <rostedt@rostedt.homelinux.com>)
        id 1qUKsB-005uQJ-39;
        Fri, 11 Aug 2023 01:39:43 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-trace-devel@vger.kernel.org
Cc:     Stevie Alvarez <stevie.6strings@gmail.com>,
        Ross Zwisler <zwisler@google.com>,
        "Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH v2 12/17] libtraceeval histogram: Add data copy callback
Date:   Fri, 11 Aug 2023 01:39:35 -0400
Message-Id: <20230811053940.1408424-13-rostedt@goodmis.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230811053940.1408424-1-rostedt@goodmis.org>
References: <20230811053940.1408424-1-rostedt@goodmis.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (Google)" <rostedt@goodmis.org>

Add a callback "copy" to the type that gets called when a copy is done.
This is can be used to copy dynamic types. Otherwise the old one is just
going to be released.

Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
 include/traceeval-hist.h | 5 +++++
 src/histograms.c         | 3 +++
 2 files changed, 8 insertions(+)

diff --git a/include/traceeval-hist.h b/include/traceeval-hist.h
index 2fc81a64e324..1a24d6117b93 100644
--- a/include/traceeval-hist.h
+++ b/include/traceeval-hist.h
@@ -82,6 +82,10 @@ typedef int (*traceeval_data_hash_fn)(struct traceeval *teval,
 				      const struct traceeval_type *type,
 				      const union traceeval_data *data);
 
+typedef int (*traceeval_data_copy_fn)(const struct traceeval_type *type,
+				      union traceeval_data *copy,
+				      const union traceeval_data *origin);
+
 /*
  * struct traceeval_type - Describes the type of a traceevent_data instance
  * @type: The enum type that describes the traceeval_data
@@ -126,6 +130,7 @@ struct traceeval_type {
 	size_t				id;
 	traceeval_data_release_fn	release;
 	traceeval_data_cmp_fn		cmp;
+	traceeval_data_copy_fn		copy;
 	traceeval_data_hash_fn		hash;
 };
 
diff --git a/src/histograms.c b/src/histograms.c
index 2b823ad5c26d..f7f72dd3a50b 100644
--- a/src/histograms.c
+++ b/src/histograms.c
@@ -512,6 +512,9 @@ static int copy_traceeval_data(struct traceeval_type *type,
 {
 	unsigned long long val;
 
+	if (type->copy)
+		return type->copy(type, copy, orig);
+
 	*copy = *orig;
 
 	switch(type->type) {
-- 
2.40.1

