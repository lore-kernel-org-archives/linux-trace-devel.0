Return-Path: <SRS0=GfdA=4P=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D7F5BC5ED3F
	for <linux-trace-devel@archiver.kernel.org>; Thu, 27 Feb 2020 14:20:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AFECA246AE
	for <linux-trace-devel@archiver.kernel.org>; Thu, 27 Feb 2020 14:20:21 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="E+/tB3QH"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389750AbgB0OUV (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 27 Feb 2020 09:20:21 -0500
Received: from mail-lj1-f194.google.com ([209.85.208.194]:40077 "EHLO
        mail-lj1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389828AbgB0OUP (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 27 Feb 2020 09:20:15 -0500
Received: by mail-lj1-f194.google.com with SMTP id 143so3490219ljj.7
        for <linux-trace-devel@vger.kernel.org>; Thu, 27 Feb 2020 06:20:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=MVPIveRg6oAAd84/z9Xl82WSwrk+YDdhl6fFI3ImcsY=;
        b=E+/tB3QH5yyVv8Zlq/pZfiluSdBgZ67oYhsFfHMVKcbl9oNYdQNMsgtoNeF761XCx/
         ypOXZQALp+lX3hmuns1rak18sEVXTCromOSExxcyqtczel06Zb1x8WgWjBWevqoVet5l
         hcc3DbH7TLXlJgM8K+4XGlap6fBDaU+I936tynKx9ctdtNgiwpkYqhUhQ/UBQDXZiN4K
         W6El+NwqFpOgg+xUgPEDndNhBLggjk0zSngoiGL8mh8Kf//5ezkkytobukOb7BZJxdOG
         DPGfFMJRQTS0Z9hsZ1u5dleVLnkdIDBilkrLWv0AWVbqbKf/8JHV7212DxBJpa55i+J7
         Xy8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=MVPIveRg6oAAd84/z9Xl82WSwrk+YDdhl6fFI3ImcsY=;
        b=X09a6OgSxQJ3HblyzWBueN4cFQyiR+QrKQV/SR1m0qQx9yyBdNowWN0H466XJ+9P4z
         UHmtRwV3a0UAYNF7Mnor0OwllaFqEIh2V0gsQ4HK7CZL85jk2Us+rkf0h0qe2Sgt8x2H
         wQiBbsCRsfqmnKKXujR3fC5HDY0ViKpetLtUvj9O3OS+lYgMTQ2/3gkomuBlmUFRWaua
         DiWOcsEjD4/rdg2Q7dxm09wl91d5VSTPUeaqvZyTLyWGW9biowCR5dY97xSmUhAgl1y6
         ZkZG0P7rjUdAK5h+AwUyWV7psxuuPcqMK8+Mj+VDG7FVVqhhimW57p+mfnHw17/+9898
         iA0w==
X-Gm-Message-State: ANhLgQ08Dk0V27QFEg340jODXw9s0mtnIiPwHE+2Y2sL4KeX0SkM8gcq
        7+C+8jQvwBNmFIkuhAiS34E=
X-Google-Smtp-Source: ADFU+vsfYR2psKFHQXQkxSG9sYjBgR/OXX3B4GHR9gfnAxZ4e3GLFMGwaFKgLsZWkA1fvO06QOSEYA==
X-Received: by 2002:a2e:9708:: with SMTP id r8mr3009811lji.92.1582813212363;
        Thu, 27 Feb 2020 06:20:12 -0800 (PST)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id l3sm3306437lja.78.2020.02.27.06.20.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 27 Feb 2020 06:20:11 -0800 (PST)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v20 06/15] trace-cmd: Store the session tracing ID in the trace.dat file
Date:   Thu, 27 Feb 2020 16:19:52 +0200
Message-Id: <20200227142001.61577-7-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200227142001.61577-1-tz.stoyanov@gmail.com>
References: <20200227142001.61577-1-tz.stoyanov@gmail.com>
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
index 842a4c3b..aca13c4e 100644
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
@@ -2316,6 +2317,10 @@ static int handle_options(struct tracecmd_input *handle)
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
@@ -3419,3 +3424,14 @@ void tracecmd_set_show_data_func(struct tracecmd_input *handle,
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
index 5d31cad8..3e24eb43 100644
--- a/tracecmd/trace-record.c
+++ b/tracecmd/trace-record.c
@@ -3895,6 +3895,13 @@ add_pid_maps(struct tracecmd_output *handle, struct buffer_instance *instance)
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
@@ -4000,6 +4007,8 @@ static void add_options(struct tracecmd_output *handle, struct common_record_con
 	add_option_hooks(handle);
 	add_uname(handle);
 	add_version(handle);
+	if (!no_top_instance())
+		add_trace_id(handle, &top_instance);
 }
 
 static void write_guest_file(struct buffer_instance *instance)
-- 
2.24.1

