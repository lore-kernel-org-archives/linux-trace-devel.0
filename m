Return-Path: <SRS0=wCVW=VV=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4F296C7618B
	for <linux-trace-devel@archiver.kernel.org>; Wed, 24 Jul 2019 15:41:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 242C8206B8
	for <linux-trace-devel@archiver.kernel.org>; Wed, 24 Jul 2019 15:41:00 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="s5PKAIt5"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387637AbfGXPlA (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 24 Jul 2019 11:41:00 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:35215 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387394AbfGXPk7 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 24 Jul 2019 11:40:59 -0400
Received: by mail-wr1-f67.google.com with SMTP id y4so47525185wrm.2
        for <linux-trace-devel@vger.kernel.org>; Wed, 24 Jul 2019 08:40:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=2FKD0UEiJP4GyqOPIYG1PA0KGvvAv4TgsN6F0517/kg=;
        b=s5PKAIt5PhacPKalKNx8FfghqU3gWoBFMGE/jMHZVylxa73hYnZ9dwf0uWzSdnwt80
         iHvYmFoY5DH3JJTrlXwWU/h4ltNL3M53XXG8knS5SMrn0BKmnHCra75hGlWp5lrLaEpc
         CSQjdJKEVtmok1se1oSLKl7k7vgaMvATquXC/PsetSYAKtHoW4bQq2v7gW+bZhsu0Jbg
         YVVtn6ddQ+mY1GqsCGVjIGX+QhfxwzC9N36q89dq8wcUzcgItalaMPiKk136oaIBlfUU
         TqV0Q/ZhFDP62MgBM2kvnFx8hjE0yqx+K1fNRrgPlNLH2e8ruNGyMRAz3w11D03kSbXK
         xMeA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=2FKD0UEiJP4GyqOPIYG1PA0KGvvAv4TgsN6F0517/kg=;
        b=oKs54GKwWjibEcUa6kfBRUYZLiX6MR8/7IEM+RNoOjvitl5xhiaZOJKvnnBrS5gr11
         KwIAusieQ9AZ7e5A/rkOJFQD8szks7LC1Aeg+nX7CTfZj4ETg8jLvHTx7aX5r2yAePl8
         cBNk2/9xdemE7yGPMwEfNvh0TQAr5ZaK4H0g4I+N+H9Cb/JEi+Gahu+sqCn7NDuDWQrJ
         De06cTkIkoQSZl2P6n4PRSEkRd/xpX2jexFTvHibT+ag2HXKUSKKvbTWgZlMBvKFm4aA
         pHL/OTHLLbtKVHoepBAnbrqGe5VHf3eyfPIKLgAd8zj1qui7meHeqgbz4MnCu8BdaBb3
         KZ5w==
X-Gm-Message-State: APjAAAWtj3jEBKC3UhklXfKSIDsfvCJqxA92+SQ2yZcdsEd13rE1fMjw
        pkeAB1u02gZi9mTAoGhOe+Q=
X-Google-Smtp-Source: APXvYqxGj/nlHaMBH+bjqDXGmxTh+GFLDLqpqgpXPBegjRACItGDOVYHQ9UUDRlvyr6lyOe2elmeTQ==
X-Received: by 2002:adf:e2c1:: with SMTP id d1mr92911330wrj.283.1563982856918;
        Wed, 24 Jul 2019 08:40:56 -0700 (PDT)
Received: from localhost.localdomain ([95.87.223.238])
        by smtp.gmail.com with ESMTPSA id a64sm45510570wmf.1.2019.07.24.08.40.56
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Wed, 24 Jul 2019 08:40:56 -0700 (PDT)
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org,
        "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Subject: [PATCH 1/4] kernel-shark: kshark_import_event_filter() tolerates non-existing events
Date:   Wed, 24 Jul 2019 18:40:36 +0300
Message-Id: <20190724154039.23705-2-y.karadz@gmail.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190724154039.23705-1-y.karadz@gmail.com>
References: <20190724154039.23705-1-y.karadz@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Instead of aborting, the function will ignore (skip) the non-existing
event and will continue loading the other events in the configuration
file. The return type is changed to int in order to provide information
about the number of events successfully added to the filter.

Signed-off-by: Yordan Karadzhov (VMware) <y.karadz@gmail.com>
---
 kernel-shark/src/libkshark-configio.c | 33 +++++++++++++++------------
 kernel-shark/src/libkshark.h          |  8 +++----
 2 files changed, 23 insertions(+), 18 deletions(-)

diff --git a/kernel-shark/src/libkshark-configio.c b/kernel-shark/src/libkshark-configio.c
index cac27a7..5d7323f 100644
--- a/kernel-shark/src/libkshark-configio.c
+++ b/kernel-shark/src/libkshark-configio.c
@@ -793,7 +793,7 @@ bool kshark_export_event_filter(struct tep_handle *pevent,
 	}
 }
 
-static bool kshark_event_filter_from_json(struct tep_handle *pevent,
+static int kshark_event_filter_from_json(struct tep_handle *pevent,
 					  struct tracecmd_filter_id *filter,
 					  const char *filter_name,
 					  struct json_object *jobj)
@@ -801,7 +801,7 @@ static bool kshark_event_filter_from_json(struct tep_handle *pevent,
 	json_object *jfilter, *jevent, *jsystem, *jname;
 	const char *system_str, *name_str;
 	struct tep_event *event;
-	int i, length;
+	int i, length, count = 0;
 
 	/*
 	 * Use the name of the filter to find the array of events associated
@@ -809,7 +809,7 @@ static bool kshark_event_filter_from_json(struct tep_handle *pevent,
 	 * contain no data for this particular filter.
 	 */
 	if (!json_object_object_get_ex(jobj, filter_name, &jfilter))
-		return false;
+		return 0;
 
 	if (!kshark_json_type_check(jobj, "kshark.config.filter") ||
 	    json_object_get_type(jfilter) != json_type_array)
@@ -829,16 +829,21 @@ static bool kshark_event_filter_from_json(struct tep_handle *pevent,
 
 		event = tep_find_event_by_name(pevent, system_str, name_str);
 		if (!event)
-			goto fail;
+			continue;
 
 		tracecmd_filter_id_add(filter, event->id);
+		++count;
 	}
 
-	return true;
+	if (count != length)
+		count = -count;
+
+	return count;
 
  fail:
 	fprintf(stderr, "Failed to load event filter from json_object.\n");
-	return false;
+	tracecmd_filter_id_clear(filter);
+	return 0;
 }
 
 /**
@@ -851,14 +856,14 @@ static bool kshark_event_filter_from_json(struct tep_handle *pevent,
  * @param conf: Input location for the kshark_config_doc instance. Currently
  *		only Json format is supported.
  *
- * @returns True, if a filter has been loaded. If the filter configuration
- *	    document contains no data for this particular filter or in a case
- *	    of an error, the function returns False.
+ * @returns The total number of events added to the filter. If not all events
+ *	    listed in the input configuration have been added successfully,
+ *	    the returned number is negative.
  */
-bool kshark_import_event_filter(struct tep_handle *pevent,
-				struct tracecmd_filter_id *filter,
-				const char *filter_name,
-				struct kshark_config_doc *conf)
+int kshark_import_event_filter(struct tep_handle *pevent,
+			       struct tracecmd_filter_id *filter,
+			       const char *filter_name,
+			       struct kshark_config_doc *conf)
 {
 	switch (conf->format) {
 	case KS_CONFIG_JSON:
@@ -869,7 +874,7 @@ bool kshark_import_event_filter(struct tep_handle *pevent,
 	default:
 		fprintf(stderr, "Document format %d not supported\n",
 			conf->format);
-		return false;
+		return 0;
 	}
 }
 
diff --git a/kernel-shark/src/libkshark.h b/kernel-shark/src/libkshark.h
index fe35333..04e9cbf 100644
--- a/kernel-shark/src/libkshark.h
+++ b/kernel-shark/src/libkshark.h
@@ -587,10 +587,10 @@ bool kshark_export_event_filter(struct tep_handle *pevent,
 				const char *filter_name,
 				struct kshark_config_doc *conf);
 
-bool kshark_import_event_filter(struct tep_handle *pevent,
-				struct tracecmd_filter_id *filter,
-				const char *filter_name,
-				struct kshark_config_doc *conf);
+int kshark_import_event_filter(struct tep_handle *pevent,
+			       struct tracecmd_filter_id *filter,
+			       const char *filter_name,
+			       struct kshark_config_doc *conf);
 
 bool kshark_export_user_mask(struct kshark_context *kshark_ctx,
 			     struct kshark_config_doc **conf);
-- 
2.20.1

