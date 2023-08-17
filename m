Return-Path: <linux-trace-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CD1D4C05052
	for <linux-trace-devel@archiver.kernel.org>; Thu, 17 Aug 2023 01:33:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347558AbjHQBdM (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 16 Aug 2023 21:33:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58016 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347550AbjHQBdK (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 16 Aug 2023 21:33:10 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A9E7272B
        for <linux-trace-devel@vger.kernel.org>; Wed, 16 Aug 2023 18:33:09 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3FFEC64A72
        for <linux-trace-devel@vger.kernel.org>; Thu, 17 Aug 2023 01:33:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2096CC4339A;
        Thu, 17 Aug 2023 01:33:07 +0000 (UTC)
Received: from rostedt by gandalf with local (Exim 4.96)
        (envelope-from <rostedt@rostedt.homelinux.com>)
        id 1qWRst-000N4M-2I;
        Wed, 16 Aug 2023 21:33:11 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-trace-devel@vger.kernel.org
Cc:     Ross Zwisler <zwisler@google.com>,
        Stevie Alvarez <stevie.6strings@gmail.com>,
        "Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH v3 12/18] libtraceeval histogram: Add data copy callback
Date:   Wed, 16 Aug 2023 21:33:04 -0400
Message-Id: <20230817013310.88582-13-rostedt@goodmis.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230817013310.88582-1-rostedt@goodmis.org>
References: <20230817013310.88582-1-rostedt@goodmis.org>
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
index e8a7981ac2c0..8992ace81cdf 100644
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
index 8cd1b288a7fc..fe13884ccff6 100644
--- a/src/histograms.c
+++ b/src/histograms.c
@@ -511,6 +511,9 @@ static int copy_traceeval_data(struct traceeval_type *type,
 {
 	unsigned long long val;
 
+	if (type->copy)
+		return type->copy(type, copy, orig);
+
 	*copy = *orig;
 
 	switch(type->type) {
-- 
2.40.1

