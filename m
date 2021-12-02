Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9C8FFC433F5
	for <linux-trace-devel@archiver.kernel.org>; Thu,  2 Dec 2021 17:44:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355674AbhLBRrX (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 2 Dec 2021 12:47:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53680 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352111AbhLBRrV (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 2 Dec 2021 12:47:21 -0500
Received: from mail-ed1-x52c.google.com (mail-ed1-x52c.google.com [IPv6:2a00:1450:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C157C06174A
        for <linux-trace-devel@vger.kernel.org>; Thu,  2 Dec 2021 09:43:58 -0800 (PST)
Received: by mail-ed1-x52c.google.com with SMTP id v1so1261119edx.2
        for <linux-trace-devel@vger.kernel.org>; Thu, 02 Dec 2021 09:43:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=dtQag/aXMYyvpWDoageg8fmE5ScxcmYRZnxCgGdyOiM=;
        b=m52gwqBEo1RvRzRTeCvD7XH9bS/24xbn0Ij2gfJs9BDgfYcKer2joWSKUasxHwWHQv
         PukOgarvrFW+iJz3JGGofD2XtNv8iFOC8aNC86KttnLkVIM78EUXRWjB+BVjiocN5vRo
         pgTxs29he2KXzaJy56dl5/RKZkpWlZeppWWGx7wVQmZzaORWaenvGrnKPcO09gKZBbI9
         krb8DDGg9pywxsQ+nSFwvXGo8WnXsRJ/YcGIO3IH4+n02701YiQ5xflZ+C+OWNyYJmMB
         AGa21j1nNdP3lu8c77bjFZdmouKhyMan5LEe26XjG1bAo48UzpCmLvKLihXYmy+8PKnf
         kj6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=dtQag/aXMYyvpWDoageg8fmE5ScxcmYRZnxCgGdyOiM=;
        b=gH26Ni8fou9VrHZ31Vi/WIGuODKqsh1O0z4BqxFhfDUS7JaqntwGmR8idYMTG0CZcN
         lITBzTSX7cY3zzsB9AVIeb2bmnI0XfYULxhyUN17UXBdrfVTHd36/j6swAc24FexW9sa
         5lRkc5Y3FV/K/+IpvQkJ7mBkbKA72OgtlGEEm4jV/oyYd8uai9w2Y8pInRsBdO7Lrk0/
         RxB/tFU873wr5HUz6tc0WR5S52CWecCellwGPNFGllmAM2xbs30FnauUzM6rbzDggVtC
         /zDKwPw7T4ES3QDekSJ7WYW3EWcInjxVqi0joVZ0mAvDvyj5y65UEtLb1u0SOygmZ04c
         8fyA==
X-Gm-Message-State: AOAM53170G6VmKooLEvTRRFM4B7UwI4IN1pnQgduy7AUKpZiWiBWAR2+
        XwjxWnOdXiRNkfxeaCEIkQlDvNlI7KQ=
X-Google-Smtp-Source: ABdhPJzjWzG4B02zfDJJgEzr0gusr+DwcY0iWLQomz4sfDySuH2DRy8PD1YG7Z6LJmX3DqZYt3GxRA==
X-Received: by 2002:a17:907:7f28:: with SMTP id qf40mr16960704ejc.196.1638467036946;
        Thu, 02 Dec 2021 09:43:56 -0800 (PST)
Received: from crow.. ([95.87.219.163])
        by smtp.gmail.com with ESMTPSA id a13sm280065edk.29.2021.12.02.09.43.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Dec 2021 09:43:56 -0800 (PST)
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
To:     linux-trace-devel@vger.kernel.org, rostedt@goodmis.org
Cc:     "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Subject: [PATCH v2] libtracefs: New API for clearing filter on event
Date:   Thu,  2 Dec 2021 19:43:45 +0200
Message-Id: <20211202174345.229200-1-y.karadz@gmail.com>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

There is no API for clearing filter from event. After adding an API that
applys a filter we must provide an identical API for clearing the filter.

Signed-off-by: Yordan Karadzhov (VMware) <y.karadz@gmail.com>
---
 Documentation/libtracefs-filter.txt |  8 +++++++-
 include/tracefs.h                   |  3 ++-
 src/tracefs-filter.c                | 14 ++++++++++++++
 3 files changed, 23 insertions(+), 2 deletions(-)

diff --git a/Documentation/libtracefs-filter.txt b/Documentation/libtracefs-filter.txt
index 7db3d60..f7bbb17 100644
--- a/Documentation/libtracefs-filter.txt
+++ b/Documentation/libtracefs-filter.txt
@@ -3,7 +3,7 @@ libtracefs(3)
 
 NAME
 ----
-tracefs_filter_string_append, tracefs_filter_string_verify, tracefs_event_apply_filter -
+tracefs_filter_string_append, tracefs_filter_string_verify, tracefs_event_filter_apply tracefs_event_filter_clear -
 Add, verify and apply event filters
 
 SYNOPSIS
@@ -17,6 +17,8 @@ int tracefs_filter_string_append(struct tep_event pass:[*]event, char pass:[**]
 				 enum tracefs_synth_compare compare, const char pass:[*]val);
 int tracefs_filter_string_verify(struct tep_event pass:[*]event, const char pass:[*]filter, char pass:[**]err);
 int tracefs_event_filter_apply(struct tracefs_instance pass:[*]instance, struct tep_event pass:[*]event, const char pass:[*]filter);
+int tracefs_event_filter_clear(struct tracefs_instance pass:[*]instance, struct tep_event pass:[*]event);
+
 --
 
 DESCRIPTION
@@ -69,6 +71,8 @@ with *free*().
 
 *tracefs_event_filter_apply*() applies given _filter_ string on _event_ in given _instance_.
 
+*tracefs_event_filter_clear*() clear all filters on _event_ in given _instance_.
+
 RETURN VALUE
 ------------
 *tracefs_filter_string_append*() returns 0 on success and -1 on error.
@@ -80,6 +84,8 @@ freed with *free*().
 
 *tracefs_event_filter_apply*() returns 0 on success and -1 on error.
 
+*tracefs_event_filter_clear*() returns 0 on success and -1 on error.
+
 EXAMPLE
 -------
 [source,c]
diff --git a/include/tracefs.h b/include/tracefs.h
index ac92dca..3ac3d9c 100644
--- a/include/tracefs.h
+++ b/include/tracefs.h
@@ -479,6 +479,8 @@ int tracefs_filter_string_verify(struct tep_event *event, const char *filter,
 int tracefs_event_filter_apply(struct tracefs_instance *instance,
 			       struct tep_event *event, const char *filter);
 
+int tracefs_event_filter_clear(struct tracefs_instance *instance,
+			       struct tep_event *event);
 
 /** Deprecated do not use: Instead use tracefs_filter_string_append() **/
 int tracefs_event_append_filter(struct tep_event *event, char **filter,
@@ -490,7 +492,6 @@ int tracefs_event_append_filter(struct tep_event *event, char **filter,
 int tracefs_event_verify_filter(struct tep_event *event, const char *filter,
 				char **err);
 
-
 #define TRACEFS_TIMESTAMP "common_timestamp"
 #define TRACEFS_TIMESTAMP_USECS "common_timestamp.usecs"
 
diff --git a/src/tracefs-filter.c b/src/tracefs-filter.c
index 7bc36fe..85d0be1 100644
--- a/src/tracefs-filter.c
+++ b/src/tracefs-filter.c
@@ -764,6 +764,20 @@ int tracefs_event_filter_apply(struct tracefs_instance *instance,
 					"filter", filter);
 }
 
+/**
+ * tracefs_event_filter_clear - clear the filter on event in given instance
+ * @instance: The instance in which the filter will be applied (NULL for toplevel).
+ * @event: The event to apply the filter on.
+ *
+ * Returns 0 on succes and -1 on error.
+ */
+int tracefs_event_filter_clear(struct tracefs_instance *instance,
+			       struct tep_event *event)
+{
+	return tracefs_event_file_write(instance, event->system, event->name,
+					"filter", "0");
+}
+
 /** Deprecated **/
 int tracefs_event_append_filter(struct tep_event *event, char **filter,
 				enum tracefs_filter type,
-- 
2.32.0

