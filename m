Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 752ADC433EF
	for <linux-trace-devel@archiver.kernel.org>; Tue, 30 Nov 2021 05:01:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231238AbhK3FE0 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 30 Nov 2021 00:04:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37022 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230259AbhK3FE0 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 30 Nov 2021 00:04:26 -0500
Received: from mail-ed1-x535.google.com (mail-ed1-x535.google.com [IPv6:2a00:1450:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 570C4C061574
        for <linux-trace-devel@vger.kernel.org>; Mon, 29 Nov 2021 21:01:07 -0800 (PST)
Received: by mail-ed1-x535.google.com with SMTP id o20so81102813eds.10
        for <linux-trace-devel@vger.kernel.org>; Mon, 29 Nov 2021 21:01:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Gcj0J3fBRHssSuSdtbmvDqbgZlYLq9ZwE6299+89U00=;
        b=JRw/ov1KbuwZnSnujQcUII5Sn1vlZlteYd6rLgE8SyJUS6PoVGTn5C8fzWrtuO5mgu
         nk0oMtujh77ZUvQy6aho+f0th0P0hOojzrxVYBLCLT1AX5klZsClNFuhET637kbdoTLy
         lvm9B4yPgWfkyaOoe+vn8mFDBkrKr14A5QZ4TDHncZHgf1EhcRoNWoHEQnAFsfW3QJxo
         tnuc1kuTtnD80s8OwO24gzrK5di5RS/fEYOFjZ9V/ioX70Y6jDV1kL25oJueFeI8YlNx
         xpQti3Ym4v8qhHX+RhAxrAY8bSjJ1hUkAi/U7827R0M3euekrXs5FxNMNPBK6pPkWfCR
         NBtg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Gcj0J3fBRHssSuSdtbmvDqbgZlYLq9ZwE6299+89U00=;
        b=HlgZJ58fPolIHH2fZ+D6hWeEJ0GY2kg7+6n/LTw5ZY/Xz0KpD2apPKFDac5vP/zqsQ
         aeWHXMQeArovVhASRlhLVRQGLeUeuv5FVk5xNrp02gMycHYPI8ChMx/XIibpXg2y4dgW
         kF7gGcesSCaG+LW6oSOy2t/r/cPGXsd3WZMFy89MDxoNNmWtF8hwbKVieznjd3m0oWGO
         DW/Czwoh2cdUQZtFdBZcyw3KRlsFxcRX/5JkB7l20xGspGpRPshCsg1pHITT/hM6xaLP
         rFm8ThfUvd6p6uwK5C/aYbrorl295APOrfdkpdmvqvcPmmNU7YYPcgQ4wc0ME893BJY4
         AzAQ==
X-Gm-Message-State: AOAM533izSdJGpYZ414b0ZnZF/+TTWJ/WdyfvsbubquGODowDUsBGS9P
        XXvUUo2bgEhEodhAxSzUzEyJvEGpa9tjmQ==
X-Google-Smtp-Source: ABdhPJwUNHVyB/gm2enHiGRcMYdsT+1XUpvf76xUKT1KLJIEL/J3zYRzElL+wZzDH79vhEgvVvAQgA==
X-Received: by 2002:a05:6402:358c:: with SMTP id y12mr83296377edc.44.1638248465967;
        Mon, 29 Nov 2021 21:01:05 -0800 (PST)
Received: from oberon.zico.biz.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id w18sm10385849edx.55.2021.11.29.21.01.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 29 Nov 2021 21:01:05 -0800 (PST)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org, y.karadz@gmail.com
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH 4/4] libtracefs: New API for applying filter on event.
Date:   Tue, 30 Nov 2021 07:00:57 +0200
Message-Id: <20211130050057.336228-5-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211130050057.336228-1-tz.stoyanov@gmail.com>
References: <20211130050057.336228-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

There is no API for applying a filter string on event. Existing APIs
only constructs and verifies the filter string. Even though the actual
applying is just writing into the event's filter file, it is good to
have a dedicated API for that:
	tracefs_event_apply_filter()

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 Documentation/libtracefs-filter.txt | 11 ++++++++++-
 include/tracefs.h                   |  3 +++
 src/tracefs-filter.c                | 19 +++++++++++++++++++
 3 files changed, 32 insertions(+), 1 deletion(-)

diff --git a/Documentation/libtracefs-filter.txt b/Documentation/libtracefs-filter.txt
index 7e167bc..7532c96 100644
--- a/Documentation/libtracefs-filter.txt
+++ b/Documentation/libtracefs-filter.txt
@@ -3,7 +3,8 @@ libtracefs(3)
 
 NAME
 ----
-tracefs_event_append_filter, tracefs_event_verify_filter - Add and verify event filters
+tracefs_event_append_filter, tracefs_event_verify_filter tracefs_event_apply_filter -
+Add, verify and apply event filters
 
 SYNOPSIS
 --------
@@ -15,6 +16,7 @@ int tracefs_event_append_filter(struct tep_event pass:[*]event, char pass:[**] f
 				 struct tracefs_filter type, const char pass:[*]field,
 				 enum tracefs_synth_compare compare, const char pass:[*]val);
 int tracefs_event_verify_filter(struct tep_event pass:[*]event, const char pass:[*]filter, char pass:[**]err);
+int tracefs_event_apply_filter(struct tracefs_instance pass:[*]instance, struct tep_event pass:[*]event, const char pass:[*]filter);
 
 --
 
@@ -66,6 +68,8 @@ error in the syntax, and _err_ is not NULL, then it will be allocated with an
 error message stating what was found wrong with the filter. _err_ must be freed
 with *free*().
 
+*tracefs_event_apply_filter*() applies given _filter_ string on _event_ in given _instance_.
+
 RETURN VALUE
 ------------
 *tracefs_event_append_filter*() returns 0 on success and -1 on error.
@@ -75,6 +79,8 @@ is an error, and _errno_ is not *ENOMEM*, then _err_ is allocated and will
 contain a string describing what was found wrong with _filter_. _err_ must be
 freed with *free*().
 
+*tracefs_event_apply_filter*() returns 0 on success and -1 on error.
+
 EXAMPLE
 -------
 [source,c]
@@ -269,6 +275,9 @@ int main (int argc, char **argv)
 		}
 	}
 
+	if (tracefs_event_apply_filter(NULL, event, new_filter))
+		fprintf(stderr, "Failed to apply filter on event");
+
 	tep_free(tep);
 
 	printf("Created new filter: '%s'\n", new_filter);
diff --git a/include/tracefs.h b/include/tracefs.h
index fbd7d31..8ac9694 100644
--- a/include/tracefs.h
+++ b/include/tracefs.h
@@ -475,6 +475,9 @@ int tracefs_event_append_filter(struct tep_event *event, char **filter,
 				const char *val);
 int tracefs_event_verify_filter(struct tep_event *event, const char *filter,
 				char **err);
+int tracefs_event_apply_filter(struct tracefs_instance *instance,
+			       struct tep_event *event, const char *filter);
+
 
 #define TRACEFS_TIMESTAMP "common_timestamp"
 #define TRACEFS_TIMESTAMP_USECS "common_timestamp.usecs"
diff --git a/src/tracefs-filter.c b/src/tracefs-filter.c
index def8f68..43683d0 100644
--- a/src/tracefs-filter.c
+++ b/src/tracefs-filter.c
@@ -745,3 +745,22 @@ int tracefs_event_verify_filter(struct tep_event *event, const char *filter,
 	free(str);
 	return 0;
 }
+
+/**
+ * tracefs_event_apply_filter - apply given filter on event in given instance
+ * @instance: The instance in which the filter will be applied (NULL for toplevel).
+ * @event: The event to apply the filter on.
+ * @filter: The filter to apply.
+ *
+ * Apply the @filter to given @event in givem @instance. The @filter string
+ * should be created with tracefs_event_append_filter().
+ *
+ * Returns 0 on succes and -1 on error.
+ */
+int tracefs_event_apply_filter(struct tracefs_instance *instance,
+			       struct tep_event *event, const char *filter)
+{
+	return tracefs_event_file_append(instance, event->system, event->name,
+					 "filter", filter);
+}
+
-- 
2.33.1

