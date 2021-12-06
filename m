Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CD8E3C43217
	for <linux-trace-devel@archiver.kernel.org>; Mon,  6 Dec 2021 15:14:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357157AbhLFPRy (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 6 Dec 2021 10:17:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54800 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358287AbhLFPQc (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 6 Dec 2021 10:16:32 -0500
Received: from mail-wr1-x42b.google.com (mail-wr1-x42b.google.com [IPv6:2a00:1450:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 61301C08EACB
        for <linux-trace-devel@vger.kernel.org>; Mon,  6 Dec 2021 07:09:10 -0800 (PST)
Received: by mail-wr1-x42b.google.com with SMTP id a9so23035001wrr.8
        for <linux-trace-devel@vger.kernel.org>; Mon, 06 Dec 2021 07:09:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=4W12fV+NtHd0BChwAsmuBju1L/2hdDUrECESygVCeco=;
        b=OFlZJvgR/HdNoIXpApHHd6gkms39lMNkLOsgQpbj8grWJHJB+EszxhPXYJb2dXfRtL
         Z+7s/2oRtF+vdiqtDE4rZo8a3Y4msm/XpggQrFQG6qZ6H31ZVImcm27nPTgh6oj6P7Cl
         LMikmGSn+xnVCP8vNwk7t+pIMSBjS2UlTTXcqMWlA5JK2PsKJ6gK1XOfrOYvq0+pUbNq
         344BNkO2IGIzF8CUDb3As+ndmWSeEuu89qzOKXMNE3Hbs/G/eUux0iUHchxqYG65u4FQ
         BMMerF14P1JNUt9KPt28yqnW6sUE+paYASGfZrZ7b4d0C2h0VXooHFfjyxW0C+plHF2I
         UfOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=4W12fV+NtHd0BChwAsmuBju1L/2hdDUrECESygVCeco=;
        b=e6Ti6rvcqxQ9cr+ICSrzDXNVjdq51ZdRKLgQU7zx0Hxq7CP1ZsAQUr4zqfGvPjLsLD
         USubjQo6eJWz9p8XIe+sqbEkGwoIeQyoDlixn9RfzwIm/sIAml3KJxac4S+iI3I8zGrq
         y4mgNf6XvPuvOsdEdARa52dyQbWhzZ+KRqMWspPslHxp6WDGDNAPhrCqW61kVMvS0NxZ
         4fYwK92rUOD1Lm99BonpKTgCVcGbd9ajfRyL+r0OON/ldTUsuO5qeyeaA81QWv4upiOb
         j1eOxB8HXtjFcTV2IiIjiht+r/K3mhvhRzNqI03HYFrwQTiFOcOLQELM8UQ+k+YvTgLV
         CYGA==
X-Gm-Message-State: AOAM533rMxzR5nD42A30Bb8QxsbcLBLCyCNydJKaz/ixPg97efmVPoCI
        B6VVZe+hNlXJTd0C1fBOLrlumiJW+o0=
X-Google-Smtp-Source: ABdhPJy+4njnVYQCpPfxYHACJbPh3Kxe6+RJgKwCc1jO80/BHMFUN3NOEIWSQtOf+JtJn6gL0uJFcQ==
X-Received: by 2002:a5d:630b:: with SMTP id i11mr42748542wru.316.1638803348722;
        Mon, 06 Dec 2021 07:09:08 -0800 (PST)
Received: from crow.. ([95.87.219.163])
        by smtp.gmail.com with ESMTPSA id d6sm11782668wrn.53.2021.12.06.07.09.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Dec 2021 07:09:08 -0800 (PST)
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
To:     linux-trace-devel@vger.kernel.org, rostedt@goodmis.org
Cc:     "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Subject: [PATCH 1/3] libtracefs: New API for getting the raw format of a histogram
Date:   Mon,  6 Dec 2021 17:08:53 +0200
Message-Id: <20211206150855.361202-2-y.karadz@gmail.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20211206150855.361202-1-y.karadz@gmail.com>
References: <20211206150855.361202-1-y.karadz@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

The new API is similar to tracefs_hist_echo_cmd(), but prints just
the raw format descriptor of the histogram. It can be useful in the
case whene the user wants to check what exactly gets passed to the
kernel as definition of the histogram.

Signed-off-by: Yordan Karadzhov (VMware) <y.karadz@gmail.com>
---
 Documentation/libtracefs-hist.txt | 11 ++++++++--
 include/tracefs.h                 |  3 +++
 src/tracefs-hist.c                | 34 +++++++++++++++++++++++++++++++
 3 files changed, 46 insertions(+), 2 deletions(-)

diff --git a/Documentation/libtracefs-hist.txt b/Documentation/libtracefs-hist.txt
index 2eef718..c8230e5 100644
--- a/Documentation/libtracefs-hist.txt
+++ b/Documentation/libtracefs-hist.txt
@@ -4,7 +4,8 @@ libtracefs(3)
 NAME
 ----
 tracefs_hist_alloc, tracefs_hist_free, tracefs_hist_add_key, tracefs_hist_add_value, tracefs_hist_add_name, tracefs_hist_start,
-tracefs_hist_destory, tracefs_hist_add_sort_key, tracefs_hist_set_sort_key,tracefs_hist_sort_key_direction - Create and update event histograms
+tracefs_hist_destory, tracefs_hist_add_sort_key, tracefs_hist_set_sort_key, tracefs_hist_sort_key_direction
+tracefs_hist_echo_cmd, tracefs_hist_echo_fmt - Create and update event histograms
 
 SYNOPSIS
 --------
@@ -69,6 +70,9 @@ int tracefs_hist_command(struct tracefs_instance pass:[*]instance,
 			 struct tracefs_hist pass:[*]hist,
 			 enum tracefs_hist_command command);
 
+int tracefs_hist_echo_fmt(struct trace_seq pass:[*]s, struct tracefs_instance pass:[*]instance,
+			  struct tracefs_hist pass:[*]hist);
+
 --
 
 DESCRIPTION
@@ -178,11 +182,14 @@ _field_, _compare_, and _val_ are ignored unless _type_ is equal to
 
 *TRACEFS_COMPARE_AND* - _field_ & _val_ : where _field_ is a flags field.
 
-*trace_hist_echo_cmd*() prints the commands needed to create the given histogram
+*tracefs_hist_echo_cmd*() prints the commands needed to create the given histogram
 in the given _instance_, or NULL for the top level, into the _seq_.
 The command that is printed is described by _command_ and shows the functionality
 that would be done by *tracefs_hist_command*(3).
 
+*tracefs_hist_echo_fmt*() prints the raw format that describes the state of the
+histogram in the given _instance_, or NULL for the top level, into the _seq_.
+
 *tracefs_hist_command*() is called to process a command on the histogram
 _hist_ for its event in the given _instance_, or NULL for the top level.
 The _cmd_ can be one of:
diff --git a/include/tracefs.h b/include/tracefs.h
index 3ac3d9c..c2a6db7 100644
--- a/include/tracefs.h
+++ b/include/tracefs.h
@@ -377,6 +377,9 @@ int tracefs_hist_echo_cmd(struct trace_seq *seq,  struct tracefs_instance *insta
 			  struct tracefs_hist *hist, enum tracefs_hist_command command);
 int tracefs_hist_command(struct tracefs_instance *instance,
 			 struct tracefs_hist *hist, enum tracefs_hist_command cmd);
+int tracefs_hist_echo_fmt(struct trace_seq *seq,
+			  struct tracefs_instance *instance,
+			  struct tracefs_hist *hist);
 
 /**
  * tracefs_hist_start - enable a histogram
diff --git a/src/tracefs-hist.c b/src/tracefs-hist.c
index ea9e127..9beafe0 100644
--- a/src/tracefs-hist.c
+++ b/src/tracefs-hist.c
@@ -142,6 +142,40 @@ tracefs_hist_echo_cmd(struct trace_seq *seq, struct tracefs_instance *instance,
 	return 0;
 }
 
+/*
+ * tracefs_hist_echo_fmt - show the raw format of the histogram
+ * @seq: A trace_seq to store the format string
+ * @hist: The histogram to read format from
+ *
+ * This show the raw format that describes the state of the histogram.
+ *
+ * Returns the size of the format string on succes -1 on error.
+ */
+int tracefs_hist_echo_fmt(struct trace_seq *seq,
+			  struct tracefs_instance *instance,
+			  struct tracefs_hist *hist)
+{
+	const char *event = hist->event_name;
+	const char *system = hist->system;
+	int fmt_size;
+	char *path;
+	char *fmt;
+
+	path = tracefs_event_get_file(instance, system, event, "trigger");
+	if (!path)
+		return -1;
+
+	fmt = tracefs_event_file_read(instance, system, event, path,
+				      &fmt_size);
+	if (!fmt)
+		return -1;
+
+	trace_seq_puts(seq, fmt);
+	tracefs_put_tracing_file(path);
+
+	return fmt_size;
+}
+
 /*
  * tracefs_hist_command - Create, start, pause, destroy a histogram for an event
  * @instance: The instance the histogram will be in (NULL for toplevel)
-- 
2.32.0

