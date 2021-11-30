Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 62FF2C433FE
	for <linux-trace-devel@archiver.kernel.org>; Tue, 30 Nov 2021 14:35:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242257AbhK3OjS (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 30 Nov 2021 09:39:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56910 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242164AbhK3OjK (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 30 Nov 2021 09:39:10 -0500
Received: from mail-ed1-x52a.google.com (mail-ed1-x52a.google.com [IPv6:2a00:1450:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 13284C061748
        for <linux-trace-devel@vger.kernel.org>; Tue, 30 Nov 2021 06:35:50 -0800 (PST)
Received: by mail-ed1-x52a.google.com with SMTP id x15so87474050edv.1
        for <linux-trace-devel@vger.kernel.org>; Tue, 30 Nov 2021 06:35:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=fLo/kbYa5Fwczo5LoHjYbVQSaXRMhrl5jnTIOJdDWCY=;
        b=IHBTr5GcvYf3i+BVRXcX5WXg24/iwvte/dDI2FIcmmyNlsLXagIE0lMOHiNq2bs3gU
         rkYkhOu2Jw6IHH6mYO3Pkit9lN66b6nAUIkD8iPUCqQ2NSoOkdEK+Nu27cMD1W/Q9Ml3
         Alj/V2coe4yzCMFsiDVuZHg2LViWhrUFecGZVU38cNRpK1a70dXgL8UpbVnRD+S/9NYu
         KAvcOU9QeKEmmb7KCEOL6PCGbsdPQi1Phm+cBBqIMZEdm0ez96zDMh9BvzBAsUkYPSv/
         5FDM9RjhZVDZ6zh4Kg+G+lbPu36qek8s5xj4Ea7v0jO8akM9I1asnoGJCfTZot48M9dB
         5OGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=fLo/kbYa5Fwczo5LoHjYbVQSaXRMhrl5jnTIOJdDWCY=;
        b=d/30XvZkHVqmDPxDxbdNSrI7U7wJmrDkc7O4SoKf3Zj9sJxV1/QmGDQTtDEYfU8/be
         CioiBcxeDtcTry2Scc+QlUj3R4rjMFUzZSNxaDFBRCISdvsrbaGzaJDm8SIgBk57Y6J8
         G1WeWCWc5ssKiwuyoP7U+EKFVUlIxuzbUZUqMwKPwkusD9HIfCtRfRYkikn2VAUWvs3w
         E3sbqNLOHQiyu69PeH1xXAyk3rLWq7UVXvX8Q/4VimtlIakQzOgFKtZg2ctv7rxMRqQq
         VBnxhjfqiBqaEXJc9gepWsyhrzsOXuiiZb7yY2Z5in8MEVWgWfkGPVWjzwZUswyZ3+Bq
         /Z0Q==
X-Gm-Message-State: AOAM530HVhabBiAAViMxvi2+Ahbf0gHIuNrftYY6R52NXXbrukggIS1O
        oJPe8VD33AxLKgu5OUgc9gG9DbHl7to=
X-Google-Smtp-Source: ABdhPJwb2ksQLGZggpn3QulWZg8tIP/Sc6WiE2QePUkEgQUOADIH15MLvmngvRshT/4aX4keubvlVQ==
X-Received: by 2002:a17:906:3b18:: with SMTP id g24mr68607379ejf.27.1638282946286;
        Tue, 30 Nov 2021 06:35:46 -0800 (PST)
Received: from crow.. ([95.87.219.163])
        by smtp.gmail.com with ESMTPSA id de15sm9105940ejc.70.2021.11.30.06.35.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 30 Nov 2021 06:35:46 -0800 (PST)
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
To:     linux-trace-devel@vger.kernel.org, rostedt@goodmis.org
Cc:     "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Subject: [PATCH 1/1] libtracefs: New API for clearing filter on event
Date:   Tue, 30 Nov 2021 16:34:22 +0200
Message-Id: <20211130143422.127433-2-y.karadz@gmail.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20211130143422.127433-1-y.karadz@gmail.com>
References: <20211130143422.127433-1-y.karadz@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

There is no API for clearing filter from event. After adding an API that
applys a filter we must provide an identical API for clearing the filter.

Signed-off-by: Yordan Karadzhov (VMware) <y.karadz@gmail.com>
---
 Documentation/libtracefs-filter.txt |  7 ++++++-
 include/tracefs.h                   |  2 ++
 src/tracefs-filter.c                | 14 ++++++++++++++
 3 files changed, 22 insertions(+), 1 deletion(-)

diff --git a/Documentation/libtracefs-filter.txt b/Documentation/libtracefs-filter.txt
index 7532c96..cdb0bcf 100644
--- a/Documentation/libtracefs-filter.txt
+++ b/Documentation/libtracefs-filter.txt
@@ -3,7 +3,7 @@ libtracefs(3)
 
 NAME
 ----
-tracefs_event_append_filter, tracefs_event_verify_filter tracefs_event_apply_filter -
+tracefs_event_append_filter, tracefs_event_verify_filter tracefs_event_apply_filter tracefs_event_clear_filter -
 Add, verify and apply event filters
 
 SYNOPSIS
@@ -17,6 +17,7 @@ int tracefs_event_append_filter(struct tep_event pass:[*]event, char pass:[**] f
 				 enum tracefs_synth_compare compare, const char pass:[*]val);
 int tracefs_event_verify_filter(struct tep_event pass:[*]event, const char pass:[*]filter, char pass:[**]err);
 int tracefs_event_apply_filter(struct tracefs_instance pass:[*]instance, struct tep_event pass:[*]event, const char pass:[*]filter);
+int tracefs_event_clear_filter(struct tracefs_instance pass:[*]instance, struct tep_event pass:[*]event);
 
 --
 
@@ -70,6 +71,8 @@ with *free*().
 
 *tracefs_event_apply_filter*() applies given _filter_ string on _event_ in given _instance_.
 
+*tracefs_event_clear_filter*() clear all filters on _event_ in given _instance_.
+
 RETURN VALUE
 ------------
 *tracefs_event_append_filter*() returns 0 on success and -1 on error.
@@ -81,6 +84,8 @@ freed with *free*().
 
 *tracefs_event_apply_filter*() returns 0 on success and -1 on error.
 
+*tracefs_event_clear_filter*() returns 0 on success and -1 on error.
+
 EXAMPLE
 -------
 [source,c]
diff --git a/include/tracefs.h b/include/tracefs.h
index 8ac9694..effc3e5 100644
--- a/include/tracefs.h
+++ b/include/tracefs.h
@@ -477,6 +477,8 @@ int tracefs_event_verify_filter(struct tep_event *event, const char *filter,
 				char **err);
 int tracefs_event_apply_filter(struct tracefs_instance *instance,
 			       struct tep_event *event, const char *filter);
+int tracefs_event_clear_filter(struct tracefs_instance *instance,
+			       struct tep_event *event);
 
 
 #define TRACEFS_TIMESTAMP "common_timestamp"
diff --git a/src/tracefs-filter.c b/src/tracefs-filter.c
index 43683d0..6d8c66f 100644
--- a/src/tracefs-filter.c
+++ b/src/tracefs-filter.c
@@ -764,3 +764,17 @@ int tracefs_event_apply_filter(struct tracefs_instance *instance,
 					 "filter", filter);
 }
 
+/**
+ * tracefs_event_clear_filter - clear the filter on event in given instance
+ * @instance: The instance in which the filter will be applied (NULL for toplevel).
+ * @event: The event to clear the filter on.
+ *
+ * Returns 0 on succes and -1 on error.
+ */
+int tracefs_event_clear_filter(struct tracefs_instance *instance,
+			       struct tep_event *event)
+{
+	return tracefs_event_file_write(instance, event->system, event->name,
+					"filter", "0");
+}
+
-- 
2.32.0

