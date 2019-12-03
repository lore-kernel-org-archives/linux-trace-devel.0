Return-Path: <SRS0=Ozv+=ZZ=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DD58DC432C3
	for <linux-trace-devel@archiver.kernel.org>; Tue,  3 Dec 2019 10:35:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B4C6A2080A
	for <linux-trace-devel@archiver.kernel.org>; Tue,  3 Dec 2019 10:35:41 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="oIIGHNcJ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726139AbfLCKfl (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 3 Dec 2019 05:35:41 -0500
Received: from mail-lj1-f195.google.com ([209.85.208.195]:37684 "EHLO
        mail-lj1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726115AbfLCKfl (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 3 Dec 2019 05:35:41 -0500
Received: by mail-lj1-f195.google.com with SMTP id u17so3205233lja.4
        for <linux-trace-devel@vger.kernel.org>; Tue, 03 Dec 2019 02:35:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=dJh9bOTjIBbrOvc3zjfyKy7sz2k7yipWu0hohdR9QZQ=;
        b=oIIGHNcJ9W4sBhJ4t4iYLfm+xqpJGWvKj5KJWetiE6so9Fh+0nCt/WTqYjfDOWHToP
         JRbE9z+UeFC4jzIbctD+py0W2VvAUBgaUV/1txRZOoKqkaHu5/n+XvtneXO17UdZZJz0
         3UkbQJx6d2uAGFqlEdsu2noD2rht6+zmFJDvaugCZjk+j9EglOkJ9dbyW0nvcFn1N7Gk
         LPBerUOmen+pPmV7GSgMdSNoe8LeVMeq/A9fQQtIGqlKgZ45INkxTRmD+kS61rZIl+OL
         u3uWFRPX2n1gDDGUkFaOqnxe7q6n54bu/Ck/vPm2pe3+4Qe40sbIOt3BOs9djGTNDxOj
         3rzA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=dJh9bOTjIBbrOvc3zjfyKy7sz2k7yipWu0hohdR9QZQ=;
        b=dhHPik+F1QZe8H+QYIIku0vQ7rWb4Fjy1OkREMuhpomJNFDHb2XMFZSgaOQWVBaZa5
         XFfTCR2uZcMKoDWSDhyXsI8IuE0yX4/W2WcxcLEgt5G2Rzw2y4y+AIXgLQbxyX2ssq8I
         F+N+k0r9NuQYB/af463jI4GdxQix0dHv3o1Zfp/Nle21uA0TnWfV+c6ZLnW3RRzKhRmu
         rm91N1yWMDSFa0uxzBemRykaEUV07zMhdiebLqahcs3xNPT1Xyv1BVqNLKsq3TxYXnCu
         Hsr3oAQDVy023xsIz2XlTz12SiJayfPH1q7vpXnW92+K93cD2LrHudl//4bfteCWwnyE
         z2ow==
X-Gm-Message-State: APjAAAU2RvZTAlMOs8ZzaTRvzUquFniEICt4vPWMloM+Fy6h8Cmioh41
        qNQpmMZDFWzhreJV88DCsEY=
X-Google-Smtp-Source: APXvYqxOJrT2FKI3LL4R7rpHpVN7mO/KtLhVn5RAK3PNpU3gZl732EYtnTDOlwx44ijlVa5/+gSuoA==
X-Received: by 2002:a2e:b52a:: with SMTP id z10mr2067892ljm.178.1575369338583;
        Tue, 03 Dec 2019 02:35:38 -0800 (PST)
Received: from oberon.eng.vmware.com ([146.247.46.5])
        by smtp.gmail.com with ESMTPSA id t9sm1053023lfl.51.2019.12.03.02.35.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Dec 2019 02:35:38 -0800 (PST)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v17 10/18] trace-cmd: Store the session tracing ID in the trace.dat file
Date:   Tue,  3 Dec 2019 12:35:14 +0200
Message-Id: <20191203103522.482684-11-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191203103522.482684-1-tz.stoyanov@gmail.com>
References: <20191203103522.482684-1-tz.stoyanov@gmail.com>
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
 tracecmd/trace-record.c       | 15 +++++++++++++++
 3 files changed, 42 insertions(+)

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
index 1583c53..01a74f1 100644
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
@@ -3818,6 +3831,8 @@ static void add_options(struct tracecmd_output *handle, struct common_record_con
 	add_option_hooks(handle);
 	add_uname(handle);
 	add_version(handle);
+	if (!no_top_instance())
+		add_trace_id(handle, &top_instance);
 }
 
 static void write_guest_file(struct buffer_instance *instance)
-- 
2.23.0

