Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F3C1DC433F5
	for <linux-trace-devel@archiver.kernel.org>; Thu, 11 Nov 2021 15:07:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DA578610A2
	for <linux-trace-devel@archiver.kernel.org>; Thu, 11 Nov 2021 15:07:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233818AbhKKPKL (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 11 Nov 2021 10:10:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36892 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233801AbhKKPKK (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 11 Nov 2021 10:10:10 -0500
Received: from mail-ed1-x529.google.com (mail-ed1-x529.google.com [IPv6:2a00:1450:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 04867C061766
        for <linux-trace-devel@vger.kernel.org>; Thu, 11 Nov 2021 07:07:21 -0800 (PST)
Received: by mail-ed1-x529.google.com with SMTP id j21so25165377edt.11
        for <linux-trace-devel@vger.kernel.org>; Thu, 11 Nov 2021 07:07:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=JZIz9Le2ldkZezE594obPY9U9Co86sAzYvTBxXbFeH8=;
        b=ggkQPtQ1IG8yTHiVE3olRA6I4dXpNfW7BzIao5q1v0+ouWOFZS+3COtpfhjkCETzhb
         BoomVpib298u/vxSh46RG0Mdf/CbjJ+OQn0qefJSSlRcPbdJcnsM9f8MLQrnkahqI1dt
         e+IMQw3+2g5a9vl6r0l8rGc1P8VlgGdecMzOgwqRFFsSGzcEggkyK85L5NXY6zTJwSSg
         R9rhIdmWVJpC9ef6e+KqQ81cA7M/M8zRfxlvqCOV9/4ydvKOrF2B5/h+ncr2tXdMYwFW
         PuCFdSRyDPx8oglnCz5x7s277G3Duxu5JWnDnhxhC1f7Qr1a/a/zGv+fz0rXToHGi6l0
         f+jA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=JZIz9Le2ldkZezE594obPY9U9Co86sAzYvTBxXbFeH8=;
        b=pejJD3F/RbS85fbXbdGVSCq8mKD1m8VeFrEUeGZLmTOrpfCb5vLlOMEUy97CS1zjsQ
         sCQOV88tfmfJAVRRxVMSC7I7olQzxzyaT1nRBE7Bd51+T1FJxfCOsB22uT+2+sWRZ44K
         ZNuu416TyL0I/+PeRxOkKPkjwPDd4lIxoomN5W0HdIAdDfbyY413oGGlvq4kKZRdTCl5
         9PKpU0q/47l5NzxMrYwnQrfJ658FRyPilriZgUw3g6HIfTqZpWUL2tH30tpe/P6AOo7x
         ori+BsLESLNBk1LOFpfnMusYWNH9n1irvwOC+QsyQimjNb0hUlPlJyI8JaDUlrPlCQW5
         g4+g==
X-Gm-Message-State: AOAM533ZQHkMUTueTsTIswMG7OPcP13eN9cg7qf95dD/SEtsJNCN8JXI
        gzVooxfbskF0hS7xMvwItt8=
X-Google-Smtp-Source: ABdhPJxwWZoYvjb9nyvnygQDodyspRuk+c5HvlFYcR+K7RHq4jGMGP+5S28qSZrZb6sKiFfLlK8HSg==
X-Received: by 2002:a50:da0a:: with SMTP id z10mr10547028edj.298.1636643239601;
        Thu, 11 Nov 2021 07:07:19 -0800 (PST)
Received: from oberon.zico.biz.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id d18sm963695edj.23.2021.11.11.07.07.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 Nov 2021 07:07:19 -0800 (PST)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v2 07/10] trace-cmd library: New API to write headers of a trace file
Date:   Thu, 11 Nov 2021 17:07:18 +0200
Message-Id: <20211111150718.86285-1-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.33.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

The API writes metadata headers in a trace file.
 tracecmd_output_write_headers()

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 .../include/private/trace-cmd-private.h       |  3 ++
 lib/trace-cmd/trace-output.c                  | 44 +++++++++++++++++--
 2 files changed, 43 insertions(+), 4 deletions(-)

diff --git a/lib/trace-cmd/include/private/trace-cmd-private.h b/lib/trace-cmd/include/private/trace-cmd-private.h
index 2a5ce996..f148d520 100644
--- a/lib/trace-cmd/include/private/trace-cmd-private.h
+++ b/lib/trace-cmd/include/private/trace-cmd-private.h
@@ -276,6 +276,9 @@ int tracecmd_output_set_trace_dir(struct tracecmd_output *handler, const char *t
 int tracecmd_output_set_kallsyms(struct tracecmd_output *handler, const char *kallsyms);
 int tracecmd_output_set_from_input(struct tracecmd_output *handler, struct tracecmd_input *ihandle);
 int tracecmd_output_write_init(struct tracecmd_output *handler);
+int tracecmd_output_write_headers(struct tracecmd_output *handler,
+				  struct tracecmd_event_list *list);
+
 struct tracecmd_output *tracecmd_create_file_latency(const char *output_file, int cpus);
 struct tracecmd_output *
 tracecmd_create_init_file_glob(const char *output_file,
diff --git a/lib/trace-cmd/trace-output.c b/lib/trace-cmd/trace-output.c
index 6e4549f9..f8a16d82 100644
--- a/lib/trace-cmd/trace-output.c
+++ b/lib/trace-cmd/trace-output.c
@@ -684,7 +684,7 @@ static int read_event_files(struct tracecmd_output *handle,
 			break;
 	}
 	/* all events are listed, use a global glob */
-	if (list)
+	if (!event_list || list)
 		event_list = &all_events;
 
 	systems = create_event_list(handle, event_list);
@@ -754,8 +754,7 @@ err:
 		tracecmd_warning("can't set kptr_restrict");
 }
 
-static int read_proc_kallsyms(struct tracecmd_output *handle,
-			      const char *kallsyms)
+static int read_proc_kallsyms(struct tracecmd_output *handle)
 {
 	unsigned int size, check_size, endian4;
 	const char *path = "/proc/kallsyms";
@@ -1083,6 +1082,43 @@ int tracecmd_output_write_init(struct tracecmd_output *handler)
 	return 0;
 }
 
+/**
+ * tracecmd_output_write_headers - Write the trace file headers
+ * @handle: output handler to a trace file.
+ * @list: desired events that will be included in the trace file.
+ *	  It can be NULL for all available events
+ *
+ * These headers are written in the file:
+ *  - header files from the tracing directory
+ *  - ftrace events from the tracing directory
+ *  - event file from the tracing directory - all or only the one from @list
+ *  - kernel symbols from the tracing directory
+ *  - kernel printk strings from the tracing directory
+ *
+ * Returns 0 on success, or -1 in case of an error.
+ */
+int tracecmd_output_write_headers(struct tracecmd_output *handler,
+				  struct tracecmd_event_list *list)
+{
+	if (!handler || handler->file_state < TRACECMD_FILE_ALLOCATED)
+		return -1;
+
+	/* Write init data, if not written yet */
+	if (handler->file_state < TRACECMD_FILE_INIT && tracecmd_output_write_init(handler))
+		return -1;
+	if (read_header_files(handler))
+		return -1;
+	if (read_ftrace_files(handler))
+		return -1;
+	if (read_event_files(handler, list))
+		return -1;
+	if (read_proc_kallsyms(handler))
+		return -1;
+	if (read_ftrace_printk(handler))
+		return -1;
+	return 0;
+}
+
 static int select_file_version(struct tracecmd_output *handle,
 				struct tracecmd_input *ihandle)
 {
@@ -1181,7 +1217,7 @@ create_file_fd(int fd, struct tracecmd_input *ihandle,
 	if (read_event_files(handle, list))
 		goto out_free;
 
-	if (read_proc_kallsyms(handle, kallsyms))
+	if (read_proc_kallsyms(handle))
 		goto out_free;
 
 	if (read_ftrace_printk(handle))
-- 
2.33.1

