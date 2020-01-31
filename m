Return-Path: <SRS0=DRQG=3U=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2D4BDC33CB2
	for <linux-trace-devel@archiver.kernel.org>; Fri, 31 Jan 2020 12:11:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EC61320CC7
	for <linux-trace-devel@archiver.kernel.org>; Fri, 31 Jan 2020 12:11:25 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="JLtzpFQ0"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728503AbgAaMLZ (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 31 Jan 2020 07:11:25 -0500
Received: from mail-lj1-f196.google.com ([209.85.208.196]:36522 "EHLO
        mail-lj1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728461AbgAaMLZ (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 31 Jan 2020 07:11:25 -0500
Received: by mail-lj1-f196.google.com with SMTP id r19so6868150ljg.3
        for <linux-trace-devel@vger.kernel.org>; Fri, 31 Jan 2020 04:11:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=A55aOi4gXMEz1SkJayzOdfZfYFGQsS8P4N3H4KMjD3Q=;
        b=JLtzpFQ0MHi8u0DgAXA4OAUw+eSfFhuGB45Np0lSkyNXvHN2bAzmBmp5nI0DiWO+NR
         0UjTauzZ2vdDPG3CNa8AWzvNVS2aT2q0UErxcvYLKdD7QdxTDA00DEY5ogsIMUgMxQRE
         TCSXiG9kl/cjgJG5voE/49Z0cuC8OSeqaevZO6HBCIRE70DMzGwmIcHaxxL9VGoWgrNT
         lTA/tC3Cqb54WABoVJB/O6MZ08+ZzBjv1qXMfuuBqTuDe0uNF/p0Tln7jz0FIupxkgmQ
         +Ybc+WSEkuvFBoxG8WfB03+4iTxNJMFrdBIwI5fL0nR+H1QNBko8FteZjJ/66Gvffjpa
         36kw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=A55aOi4gXMEz1SkJayzOdfZfYFGQsS8P4N3H4KMjD3Q=;
        b=Uyv6qIzjVF+qaS9ryeeSdX+M9at6bireoVTKz83MWyTHi5N/Df/mO9kIL0CN6IdY/O
         XGHixJXtZkcmSl4ENZRfJjproJTwgx6w2Ke3QKMUB4stpd6luvIFDXwTfJpNEDFV2VDp
         N/fSA5aX1kTGQIdoDKKNcIYF5ISNE2SSkJCof0HfbSFdg74A0cVEj3GnUiyJrkFMHeB4
         UKxKEe89+RFb2IRibs8Egw+/qwnI12hmO21Ae8K7f96Y/sTfQB6UH6I2eO7YeSGVOFst
         OzrGiI1Ht36dj2TsVevUc/z6xDcbdAAsJH0kLcImrqZcKbdKWIYd27ZkAE7lqlTi0Ht3
         rCng==
X-Gm-Message-State: APjAAAXa1MidQkf2/Qnjqv7bwsDS3UUym9We18RYWDVqRp3UORCEO11j
        kglBB/CovBGmmkOHoTPx1UM=
X-Google-Smtp-Source: APXvYqysC0oU1d7lC9Ys8rbWJtnJAme70Ye8S/c8E97sV+nnLee2bjR7fkT9E5b5HJRgJ5SoG1xIag==
X-Received: by 2002:a2e:7005:: with SMTP id l5mr5384782ljc.230.1580472682604;
        Fri, 31 Jan 2020 04:11:22 -0800 (PST)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id i19sm4559965lfj.17.2020.01.31.04.11.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 31 Jan 2020 04:11:22 -0800 (PST)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v19 06/15] trace-cmd: Store the session tracing ID in the trace.dat file
Date:   Fri, 31 Jan 2020 14:11:02 +0200
Message-Id: <20200131121111.130355-7-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200131121111.130355-1-tz.stoyanov@gmail.com>
References: <20200131121111.130355-1-tz.stoyanov@gmail.com>
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
index 7519e82..6075a37 100644
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
index 842a4c3..aca13c4 100644
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
index 415e913..2dfeaa0 100644
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
index a815a85..b6e55ee 100644
--- a/tracecmd/trace-record.c
+++ b/tracecmd/trace-record.c
@@ -3872,6 +3872,13 @@ add_pid_maps(struct tracecmd_output *handle, struct buffer_instance *instance)
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
@@ -3977,6 +3984,8 @@ static void add_options(struct tracecmd_output *handle, struct common_record_con
 	add_option_hooks(handle);
 	add_uname(handle);
 	add_version(handle);
+	if (!no_top_instance())
+		add_trace_id(handle, &top_instance);
 }
 
 static void write_guest_file(struct buffer_instance *instance)
-- 
2.24.1

