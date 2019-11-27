Return-Path: <SRS0=q7JI=ZT=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4635FC432C0
	for <linux-trace-devel@archiver.kernel.org>; Wed, 27 Nov 2019 14:03:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1F2C320678
	for <linux-trace-devel@archiver.kernel.org>; Wed, 27 Nov 2019 14:03:06 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="dDthyxBh"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727124AbfK0ODG (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 27 Nov 2019 09:03:06 -0500
Received: from mail-lj1-f196.google.com ([209.85.208.196]:45430 "EHLO
        mail-lj1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727092AbfK0ODF (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 27 Nov 2019 09:03:05 -0500
Received: by mail-lj1-f196.google.com with SMTP id n21so24574809ljg.12
        for <linux-trace-devel@vger.kernel.org>; Wed, 27 Nov 2019 06:03:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=vzdQWNEyuhaMk+jU/YVwiG5laND8tSKj4Bi90X0jfs4=;
        b=dDthyxBhHjYvlRVcmgbO/pnrnlxyfQ8mPXGgjDw6C/8otLC0/QSiIFXpK/JsP2kI6M
         HifDkzDtimgt3HENFCAcNZ5lectgsAcCuchibTym41hbew94zmUM8kk0iMZwbE8gKhNJ
         Q3XTttuMH9vGd0N8qB9V+nHxR3I/k2vpCnC/fVAZfh3ldSAqytV+ZAlDKNfTEpN17SYF
         OessfFNS8Pg8YQGioM1OtPU9KegBE3BhmyRfcd0IytUBXxlgYzKBmCs7zo6FWFY7RUqH
         bJ3odTOwkZpxpYRk4N4O2zteULWebVFatNnoT2jdbe+iSWUbBpJjNt3o3B45YEErjQqF
         a6Wg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=vzdQWNEyuhaMk+jU/YVwiG5laND8tSKj4Bi90X0jfs4=;
        b=o2H//RfFHhnXZP2l9GyTs1j12FLx/iLXtBMCvIzGMa9MG1AHLZoBNavOm1xE21fBJc
         j9fl3eRmHvra+Z4egLNbhwZ1N84TR3XWpTkaTeug+m5gzEIl0nrnZp8UIG07y5TintxL
         emsexEi14kgSaHWpouISRFJWgSsQy/80zJ8rh3l7ekBpvvkwvUNV6sxkW85QSyx718sN
         T3FrKOMO5EoDATNElES5BeVLuUduQ6WQX0NcsxHvwdbQXUkcbc5pfIx+OB+ys88oE4ML
         +V5anu7KgmDoUjjQv5XN5XO+OkO2D0ma/92Uj8I7Zn/8YutprKuA+v8cW/yFYZcuBLP3
         nlow==
X-Gm-Message-State: APjAAAU+3M3P+0fTzxWstq3Kt8zUDK+V3oBSA1tafxINcsan0siv4mR8
        Cp7stFGrqWIIC7bmgdBo8PY=
X-Google-Smtp-Source: APXvYqyAtMDmxXTT8dq1gpbziqQAi/bG5g2O9qVTjylxQtD74lOdkKA977akPjkHVLKM3uGZQU1mrw==
X-Received: by 2002:a2e:9b4b:: with SMTP id o11mr31199375ljj.252.1574863382553;
        Wed, 27 Nov 2019 06:03:02 -0800 (PST)
Received: from oberon.eng.vmware.com ([146.247.46.5])
        by smtp.gmail.com with ESMTPSA id y18sm7268660lja.12.2019.11.27.06.03.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 27 Nov 2019 06:03:01 -0800 (PST)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v14 11/19] trace-cmd: Store the session tracing ID in the trace.dat file
Date:   Wed, 27 Nov 2019 16:02:39 +0200
Message-Id: <20191127140247.258766-12-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191127140247.258766-1-tz.stoyanov@gmail.com>
References: <20191127140247.258766-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

The ID of the current tracing session is stored in the trace.dat file.
A new file option is introduced:
	TRACECMD_OPTION_TRACEID
The data is stored in the file as NULL terminated string:
	"\nTraceID: %llu\n"
A new libtracecmd API is introduced, to get the ID when the trace.dat file is read:
	unsigned long long tracecmd_get_traceid(struct tracecmd_input *handle);

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 include/trace-cmd/trace-cmd.h |  2 ++
 lib/trace-cmd/trace-input.c   | 25 +++++++++++++++++++++++++
 tracecmd/trace-record.c       | 16 ++++++++++++++++
 3 files changed, 43 insertions(+)

diff --git a/include/trace-cmd/trace-cmd.h b/include/trace-cmd/trace-cmd.h
index 6d50b08..82def44 100644
--- a/include/trace-cmd/trace-cmd.h
+++ b/include/trace-cmd/trace-cmd.h
@@ -86,6 +86,7 @@ enum {
 	TRACECMD_OPTION_CPUCOUNT,
 	TRACECMD_OPTION_VERSION,
 	TRACECMD_OPTION_PROCMAPS,
+	TRACECMD_OPTION_TRACEID,
 };
 
 enum {
@@ -128,6 +129,7 @@ int tracecmd_copy_headers(struct tracecmd_input *handle, int fd);
 void tracecmd_set_flag(struct tracecmd_input *handle, int flag);
 void tracecmd_clear_flag(struct tracecmd_input *handle, int flag);
 unsigned long tracecmd_get_flags(struct tracecmd_input *handle);
+unsigned long long tracecmd_get_traceid(struct tracecmd_input *handle);
 
 void tracecmd_parse_trace_clock(struct tracecmd_input *handle, char *file, int size);
 
diff --git a/lib/trace-cmd/trace-input.c b/lib/trace-cmd/trace-input.c
index 91362f3..40d9825 100644
--- a/lib/trace-cmd/trace-input.c
+++ b/lib/trace-cmd/trace-input.c
@@ -79,6 +79,7 @@ struct tracecmd_input {
 	struct tep_plugin_list	*plugin_list;
 	struct tracecmd_input	*parent;
 	unsigned long		flags;
+	unsigned long long	trace_id;
 	int			fd;
 	int			long_size;
 	int			page_size;
@@ -2169,6 +2170,15 @@ static void procmap_free(struct pid_addr_maps *maps)
 	free(maps);
 }
 
+static int trace_traceid_load(struct tracecmd_input *handle, char *buf)
+{
+
+	if (sscanf(buf, "%*s %llu", &handle->trace_id) == 1)
+		return 0;
+
+	return -1;
+}
+
 #define STR_PROCMAP_LINE_MAX	(PATH_MAX+22)
 static int trace_pid_map_load(struct tracecmd_input *handle, char *buf)
 {
@@ -2406,6 +2416,10 @@ static int handle_options(struct tracecmd_input *handle)
 			if (buf[size-1] == '\0')
 				trace_pid_map_load(handle, buf);
 			break;
+		case TRACECMD_OPTION_TRACEID:
+			if (buf[size-1] == '\0')
+				trace_traceid_load(handle, buf);
+			break;
 		default:
 			warning("unknown option %d", option);
 			break;
@@ -3507,3 +3521,14 @@ void tracecmd_set_show_data_func(struct tracecmd_input *handle,
 {
 	handle->show_data_func = func;
 }
+
+/**
+ * tracecmd_get_traceid - get the trace id of the session
+ * @handle: input handle for the trace.dat file
+ *
+ * Returns the trace id, written in the trace file
+ */
+unsigned long long tracecmd_get_traceid(struct tracecmd_input *handle)
+{
+	return handle->trace_id;
+}
diff --git a/tracecmd/trace-record.c b/tracecmd/trace-record.c
index 70d75f6..938b642 100644
--- a/tracecmd/trace-record.c
+++ b/tracecmd/trace-record.c
@@ -3715,6 +3715,19 @@ add_pid_maps(struct tracecmd_output *handle, struct buffer_instance *instance)
 	trace_seq_destroy(&s);
 }
 
+static void
+add_trace_id(struct tracecmd_output *handle, struct buffer_instance *instance)
+{
+	char *str = NULL;
+	int len;
+
+	len = asprintf(&str, "\nTraceID: %llu\n", instance->trace_id);
+	if (len < 1)
+		return;
+	tracecmd_add_option(handle, TRACECMD_OPTION_TRACEID, len + 1, str);
+	free(str);
+}
+
 static void
 add_buffer_stat(struct tracecmd_output *handle, struct buffer_instance *instance)
 {
@@ -3819,6 +3832,9 @@ static void add_options(struct tracecmd_output *handle, struct common_record_con
 	add_option_hooks(handle);
 	add_uname(handle);
 	add_version(handle);
+	if (!no_top_instance())
+		add_trace_id(handle, &top_instance);
+
 	for_all_instances(instance) {
 		add_pid_maps(handle, instance);
 	}
-- 
2.23.0

