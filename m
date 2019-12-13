Return-Path: <SRS0=xbdb=2D=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C2244C3B18F
	for <linux-trace-devel@archiver.kernel.org>; Fri, 13 Dec 2019 20:38:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id ED1292478D
	for <linux-trace-devel@archiver.kernel.org>; Fri, 13 Dec 2019 20:38:21 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Qfvvgswf"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727858AbfLMPar (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 13 Dec 2019 10:30:47 -0500
Received: from mail-lj1-f193.google.com ([209.85.208.193]:32963 "EHLO
        mail-lj1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727891AbfLMPar (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 13 Dec 2019 10:30:47 -0500
Received: by mail-lj1-f193.google.com with SMTP id 21so3124635ljr.0
        for <linux-trace-devel@vger.kernel.org>; Fri, 13 Dec 2019 07:30:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=OHX9FmkNhd+Pbj8xjfzSIWCxfXec02ikOgWpwFoRdNU=;
        b=Qfvvgswf3fj/feKWlPGY4FJlMNPas8FafN6GOU7YMrEjGnPu344FWeDKhoB/+XqFb3
         jM2Cfrjgcx/yLruy4w9rPoCavLBpM0EdzKWLGfbiIE3BqBZAC+DXS+ZxEiUQsGWU/M7e
         nG6nTNpr7o+GbIfWKullyZQHkjmjHibG1CQ/mDt0RI6nfA6yo+pJrV5kMvlTV67ce1lh
         N9z6EehkzWjXbHqLs1MU9ZDy70hCrExyDkYCxN3161whn6CNZF3UguWJ/SJaPEWIJo4V
         qdTH86aXtgVLQlBpjMtV1QG5eLNd7WqGNv1c6iArdfmFXMgagVJ6PeG+ebNT0H3lPaQc
         d5fQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=OHX9FmkNhd+Pbj8xjfzSIWCxfXec02ikOgWpwFoRdNU=;
        b=Q0+NBEhbCT1ArfG6tX5dDqPpRtznNYP4yONEQm3fsK/+YopkTf8TnbSqfuGebDS3B+
         lAEnvIeZ+Zhw+s6oaRO6Cpfko5O6wfqklDLLM9K/+QPMXWMUs5Mo3dFDbhO40ajgtj9l
         hJmLYPkRqha4V7m+g0owyZFsoPqax8W64wUsUXveHnK0wU6jPZUw0pplUkhS3VJNWY0K
         1vVVJyZJweUjUvf591gphON4IjqT628tcegF6waMic0LbIOu8fyqwJLXkgReiEDxZXCv
         +YyOq9tXkicW6QSP+yatPpXrX2jjqWcT+laAtPwVM7OwPi2EAiz8zfgvtrLnxYGXlHac
         Hjlg==
X-Gm-Message-State: APjAAAVV7lF+vZ+A9nL7QJ3jenRybXK7yy9+kQog5S8OJ5hv+h9hWW0p
        rYDj3aCabVR+w5KFSCmcTyYedKRWi2w=
X-Google-Smtp-Source: APXvYqz7RMDATG2Ece9NhFrSrjQfdlvAB9nYyqQPVTCl8LlJ7smoDoohfFx62HXeC6F/goW4GmHMJA==
X-Received: by 2002:a2e:9a8b:: with SMTP id p11mr9959759lji.5.1576251044659;
        Fri, 13 Dec 2019 07:30:44 -0800 (PST)
Received: from oberon.eng.vmware.com ([146.247.46.5])
        by smtp.gmail.com with ESMTPSA id u19sm5012806ljk.75.2019.12.13.07.30.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Dec 2019 07:30:44 -0800 (PST)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v18 10/18] trace-cmd: Store the session tracing ID in the trace.dat file
Date:   Fri, 13 Dec 2019 17:30:21 +0200
Message-Id: <20191213153029.133570-11-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191213153029.133570-1-tz.stoyanov@gmail.com>
References: <20191213153029.133570-1-tz.stoyanov@gmail.com>
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
index ad69313..6cc2913 100644
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
index 7089f7b..b65aeb2 100644
--- a/tracecmd/trace-record.c
+++ b/tracecmd/trace-record.c
@@ -3714,6 +3714,19 @@ add_pid_maps(struct tracecmd_output *handle, struct buffer_instance *instance)
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
@@ -3817,6 +3830,8 @@ static void add_options(struct tracecmd_output *handle, struct common_record_con
 	add_option_hooks(handle);
 	add_uname(handle);
 	add_version(handle);
+	if (!no_top_instance())
+		add_trace_id(handle, &top_instance);
 }
 
 static void write_guest_file(struct buffer_instance *instance)
-- 
2.23.0

