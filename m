Return-Path: <SRS0=cHGG=LM=vger.kernel.org=linux-trace-devel-owner@goodmis.org>
Received: from mail-wr1-f65.google.com ([209.85.221.65]:46091 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727324AbeH2U1a (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 29 Aug 2018 16:27:30 -0400
Received: by mail-wr1-f65.google.com with SMTP id a108-v6so5392843wrc.13
        for <linux-trace-devel@vger.kernel.org>; Wed, 29 Aug 2018 09:29:47 -0700 (PDT)
From: "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
To: rostedt@goodmis.org
Cc: linux-trace-devel@vger.kernel.org,
        "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Subject: [PATCH 2/4] kernel-shark-qt: Restore the alignment in libkshark-configio.c
Date: Wed, 29 Aug 2018 19:29:25 +0300
Message-Id: <20180829162927.20200-2-y.karadz@gmail.com>
In-Reply-To: <20180829162927.20200-1-y.karadz@gmail.com>
References: <20180829162927.20200-1-y.karadz@gmail.com>
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>

The alignment of the function arguments has to be fixed after the
naming convention changes.

This version of the patch contains a number of improvements suggested
by Steven Rostedt. Thanks Steven!

Signed-off-by: Yordan Karadzhov (VMware) <y.karadz@gmail.com>
---
 kernel-shark-qt/src/libkshark-configio.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/kernel-shark-qt/src/libkshark-configio.c b/kernel-shark-qt/src/libkshark-configio.c
index 484da93..cdc8c76 100644
--- a/kernel-shark-qt/src/libkshark-configio.c
+++ b/kernel-shark-qt/src/libkshark-configio.c
@@ -1034,7 +1034,7 @@ static bool kshark_adv_filters_to_json(struct kshark_context *kshark_ctx,
 
 	for (i = 0; events[i]; i++) {
 		str = tep_filter_make_string(adv_filter,
-						events[i]->id);
+					     events[i]->id);
 		if (!str)
 			continue;
 
@@ -1137,7 +1137,7 @@ static bool kshark_adv_filters_from_json(struct kshark_context *kshark_ctx,
 			 json_object_get_string(jcond));
 
 		ret = tep_filter_add_filter_str(adv_filter,
-						   filter_str);
+						filter_str);
 		if (ret < 0)
 			goto fail;
 	}
@@ -1149,7 +1149,7 @@ static bool kshark_adv_filters_from_json(struct kshark_context *kshark_ctx,
 	char error_str[200];
 	int error_status =
 		tep_strerror(kshark_ctx->pevent, ret, error_str,
-							 sizeof(error_str));
+						      sizeof(error_str));
 
 	if (error_status == 0)
 		fprintf(stderr, "filter failed due to: %s\n", error_str);
-- 
2.17.1
