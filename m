Return-Path: <SRS0=nG5h=4T=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 64D7BC3F2D2
	for <linux-trace-devel@archiver.kernel.org>; Mon,  2 Mar 2020 10:14:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3B87C20870
	for <linux-trace-devel@archiver.kernel.org>; Mon,  2 Mar 2020 10:14:15 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="GfoHwWzN"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727365AbgCBKOP (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 2 Mar 2020 05:14:15 -0500
Received: from mail-lj1-f196.google.com ([209.85.208.196]:37381 "EHLO
        mail-lj1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727198AbgCBKOO (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 2 Mar 2020 05:14:14 -0500
Received: by mail-lj1-f196.google.com with SMTP id q23so11083872ljm.4
        for <linux-trace-devel@vger.kernel.org>; Mon, 02 Mar 2020 02:14:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=4HSqYoXpGVaJJRD79Gr8kF6NKcTGM8YcdWtxTuMrwU4=;
        b=GfoHwWzNrYJ1c7A2Twn4hmLXrXp+tyxPUswWPgVsczHiw6RGed9dRlck6ttxhn/6l8
         sK0PRylTmTZ6LnbIGBhu9pKKmewlUluAojChXCOJyYi81Y7Zxszsvq9NKYxsohNS6D2Z
         vYThMnW9lFj5dOJzMEsV6PUG4w4ywr+UjbgKhfWJ1YearbMSTBkiNXPPq/b0aIkmCVT4
         escvk7hYU/wTsS0MEID8Hwt+2lTPCjq6QOcIAaapgVuJ883Ce4piF6sruAkrv4A7LLFy
         qfAS46Z1OUylFEBQT74Bjbp0Yrd4/EJAn4iNOcvySK6m/2ONntMC+oaqfEjCf/rcZ6WU
         I0vQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=4HSqYoXpGVaJJRD79Gr8kF6NKcTGM8YcdWtxTuMrwU4=;
        b=lpefkIAEXKVoogqk1SS8wROE5WvzCiehJ6HH9nbkqupn8zYxAKpZUI2UGKFukZtCtl
         3OT189QYomJseSK6sJxdzAYNhaZvOE4m8ZZ5/aJqSxPujMImc+A2Sj0su7VXMKRNQXAT
         q7RmiAH7fhuNdWPDPbAj3j+ypu4qriLdn8LkTYZs1EH+EX78firkJJVYyU7NZY312AHh
         jLBDcdX5Znlzf8AeFMNnQNaZfC9cHyq5jQdPVsja10bgfA39/RaRSN+kmSRx5cksnl7o
         JOm6VYURGO7njSVAt3E5s7ScYg8gvUGs7PE4JmkCniemgAlc5qh2GTdJwq8db30M/E60
         BNUA==
X-Gm-Message-State: ANhLgQ0S8ESvaVwoKf1B9csbBXT9cv4HctS5+AkZczV7fYaz6gPafBgG
        rkJUZNyRPOIdVfYisFwPO6T/hGXx
X-Google-Smtp-Source: ADFU+vtg2VFNhvDpKOTOi/qU7iO6vwSS6pLoy4qv1HUlAnZu+DJeVwxl9SAOI3tL0xx6K015HugidA==
X-Received: by 2002:a2e:7009:: with SMTP id l9mr11339909ljc.96.1583144052420;
        Mon, 02 Mar 2020 02:14:12 -0800 (PST)
Received: from oberon.eng.vmware.com ([146.247.46.5])
        by smtp.gmail.com with ESMTPSA id x10sm11048236ljd.68.2020.03.02.02.14.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Mar 2020 02:14:11 -0800 (PST)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v21 04/13] trace-cmd: Store the session tracing ID in the trace.dat file
Date:   Mon,  2 Mar 2020 12:13:55 +0200
Message-Id: <20200302101404.150035-5-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200302101404.150035-1-tz.stoyanov@gmail.com>
References: <20200302101404.150035-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

The ID of the current tracing session is stored in the trace.dat file.
A new file option is introduced:
	TRACECMD_OPTION_TRACEID
The data is stored in the file as unsigned long long integer
A new libtracecmd API is introduced, to get the ID when the trace.dat file is read:
	unsigned long long tracecmd_get_traceid(struct tracecmd_input *handle);

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 include/trace-cmd/trace-cmd.h |  2 ++
 lib/trace-cmd/trace-input.c   | 16 ++++++++++++++++
 tracecmd/trace-dump.c         | 11 +++++++++++
 tracecmd/trace-record.c       |  9 +++++++++
 4 files changed, 38 insertions(+)

diff --git a/include/trace-cmd/trace-cmd.h b/include/trace-cmd/trace-cmd.h
index 7519e82a..6075a37e 100644
--- a/include/trace-cmd/trace-cmd.h
+++ b/include/trace-cmd/trace-cmd.h
@@ -109,6 +109,7 @@ enum {
 	TRACECMD_OPTION_CPUCOUNT,
 	TRACECMD_OPTION_VERSION,
 	TRACECMD_OPTION_PROCMAPS,
+	TRACECMD_OPTION_TRACEID,
 };
 
 enum {
@@ -151,6 +152,7 @@ int tracecmd_copy_headers(struct tracecmd_input *handle, int fd);
 void tracecmd_set_flag(struct tracecmd_input *handle, int flag);
 void tracecmd_clear_flag(struct tracecmd_input *handle, int flag);
 unsigned long tracecmd_get_flags(struct tracecmd_input *handle);
+unsigned long long tracecmd_get_traceid(struct tracecmd_input *handle);
 
 void tracecmd_parse_trace_clock(struct tracecmd_input *handle, char *file, int size);
 
diff --git a/lib/trace-cmd/trace-input.c b/lib/trace-cmd/trace-input.c
index 209c1c98..8b5405fb 100644
--- a/lib/trace-cmd/trace-input.c
+++ b/lib/trace-cmd/trace-input.c
@@ -82,6 +82,7 @@ struct tracecmd_input {
 	struct tep_plugin_list	*plugin_list;
 	struct tracecmd_input	*parent;
 	unsigned long		flags;
+	unsigned long long	trace_id;
 	int			fd;
 	int			long_size;
 	int			page_size;
@@ -2319,6 +2320,10 @@ static int handle_options(struct tracecmd_input *handle)
 			if (buf[size-1] == '\0')
 				trace_pid_map_load(handle, buf);
 			break;
+		case TRACECMD_OPTION_TRACEID:
+			handle->trace_id = tep_read_number(handle->pevent,
+							   &cpus, 8);
+			break;
 		default:
 			warning("unknown option %d", option);
 			break;
@@ -3422,3 +3427,14 @@ void tracecmd_set_show_data_func(struct tracecmd_input *handle,
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
diff --git a/tracecmd/trace-dump.c b/tracecmd/trace-dump.c
index 415e9138..2dfeaa0f 100644
--- a/tracecmd/trace-dump.c
+++ b/tracecmd/trace-dump.c
@@ -358,6 +358,14 @@ static void dump_option_int(int fd, int size, char *desc)
 	do_print(OPTIONS, "%d\n", val);
 }
 
+static void dump_option_xlong(int fd, int size, char *desc)
+{
+	long long val;
+
+	do_print(OPTIONS, "\t\t[Option %s, %d bytes]\n", desc, size);
+	read_file_number(fd, &val, size);
+	do_print(OPTIONS, "0x%llX\n", val);
+}
 static void dump_options(int fd)
 {
 	unsigned short option;
@@ -408,6 +416,9 @@ static void dump_options(int fd)
 		case TRACECMD_OPTION_PROCMAPS:
 			dump_option_string(fd, size, "PROCMAPS");
 			break;
+		case TRACECMD_OPTION_TRACEID:
+			dump_option_xlong(fd, size, "TRACEID");
+			break;
 		default:
 			do_print(OPTIONS, " %d %d\t[Unknown option, size - skipping]\n",
 				 option, size);
diff --git a/tracecmd/trace-record.c b/tracecmd/trace-record.c
index ef05bbc6..c3f47a9a 100644
--- a/tracecmd/trace-record.c
+++ b/tracecmd/trace-record.c
@@ -3902,6 +3902,13 @@ add_pid_maps(struct tracecmd_output *handle, struct buffer_instance *instance)
 	trace_seq_destroy(&s);
 }
 
+static void
+add_trace_id(struct tracecmd_output *handle, struct buffer_instance *instance)
+{
+	tracecmd_add_option(handle, TRACECMD_OPTION_TRACEID,
+			    sizeof(long long), &instance->trace_id);
+}
+
 static void
 add_buffer_stat(struct tracecmd_output *handle, struct buffer_instance *instance)
 {
@@ -4007,6 +4014,8 @@ static void add_options(struct tracecmd_output *handle, struct common_record_con
 	add_option_hooks(handle);
 	add_uname(handle);
 	add_version(handle);
+	if (!no_top_instance())
+		add_trace_id(handle, &top_instance);
 }
 
 static void write_guest_file(struct buffer_instance *instance)
-- 
2.24.1

