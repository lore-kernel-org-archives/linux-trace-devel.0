Return-Path: <SRS0=Pf13=4V=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 38D61C3F2D1
	for <linux-trace-devel@archiver.kernel.org>; Wed,  4 Mar 2020 09:12:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 115032073B
	for <linux-trace-devel@archiver.kernel.org>; Wed,  4 Mar 2020 09:12:31 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="CMxUaqHC"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728319AbgCDJMa (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 4 Mar 2020 04:12:30 -0500
Received: from mail-lj1-f193.google.com ([209.85.208.193]:44690 "EHLO
        mail-lj1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725283AbgCDJMa (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 4 Mar 2020 04:12:30 -0500
Received: by mail-lj1-f193.google.com with SMTP id a10so1130437ljp.11
        for <linux-trace-devel@vger.kernel.org>; Wed, 04 Mar 2020 01:12:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=h8E73yH5rGuVGk+xnXmUkya0tjc4TWl3DlS5tZ5aL5U=;
        b=CMxUaqHCEvtKNNamoX/2Q3FJo+qqWWmwHbZ8Nmy2JMoN89DR33SsbjLqXEFfAup6w0
         UO8eJeDe8gvImLcUwK1U8Tciwwtc0p/NFNOStCGDo+n+D2slFTNd8LFlsdmsQcWEWRaD
         mFEVXbSaDxjZoBKV2TGDmVxrd17VTxzBqoJgDPzzV70c26Ys6W/hF9StvATJn+AMHN/4
         YiyXPF8oZT01VIDeCXCZS2wgF0B0V8RzBnw2drsQL3C6A8JaC90qxDQtBBSIOsED7kbq
         4zdj/4TbZPycQU/mJe2wzrBHFI3z1Bq/QAcaLXswBNqCKKDHoYnlHoPC5s6YNrY/cNEh
         F/aQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=h8E73yH5rGuVGk+xnXmUkya0tjc4TWl3DlS5tZ5aL5U=;
        b=PjiMds8DyI7DPuo9Dk6N/LBab8rVMrsKCrWLuwgUinPheEfyKeEG6VKqw/BF6Y8fP+
         6I2ilEAL3hUTqbOwL8/3PTQsM/aKF5BsTuHlX/6StWtDTKmkXpK9PcnzyCpUWp1WnF8v
         Tl/ciEvb8PSb64PNQqRrfoqkwwVBGGKE7kxnCEYKycKFRI0dlDquECHZp4LNhsea5oDU
         FtcVOrpPL1b/rygi8jQ49bRkutnRCON2MNLRDEDpXk3FgS0NTT4dLgbL4/MRHXkUUjxf
         uxOQRRqhRHJdZ3ZlwLBAKpiWP6H1gyI0n0FcFmDi4flfaqyes5ef58yw0fHEDVQ+pArH
         GzEA==
X-Gm-Message-State: ANhLgQ23cFWiRbLogNY9gQaVwyFpSBhr8MoV5fNmzbaIiK9yAT6o77/f
        B+F2zJBZaCGOrkA9uMZZjqN0F76g
X-Google-Smtp-Source: ADFU+vuGxkFwqevVRhKRjosa34q7XTUMfNfxKRArkIAIRwBGzA9OBigdO1JaFXnSX9Bsgo6qxEdLiw==
X-Received: by 2002:a2e:b8c3:: with SMTP id s3mr1407107ljp.84.1583313147929;
        Wed, 04 Mar 2020 01:12:27 -0800 (PST)
Received: from oberon.eng.vmware.com ([146.247.46.5])
        by smtp.gmail.com with ESMTPSA id v15sm13327462lfg.51.2020.03.04.01.12.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Mar 2020 01:12:27 -0800 (PST)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v22 04/13] trace-cmd: Store the session tracing ID in the trace.dat file
Date:   Wed,  4 Mar 2020 11:12:11 +0200
Message-Id: <20200304091220.30936-5-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200304091220.30936-1-tz.stoyanov@gmail.com>
References: <20200304091220.30936-1-tz.stoyanov@gmail.com>
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
index 9cd8f590..4f8c4d46 100644
--- a/tracecmd/trace-record.c
+++ b/tracecmd/trace-record.c
@@ -3903,6 +3903,13 @@ add_pid_maps(struct tracecmd_output *handle, struct buffer_instance *instance)
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
@@ -4008,6 +4015,8 @@ static void add_options(struct tracecmd_output *handle, struct common_record_con
 	add_option_hooks(handle);
 	add_uname(handle);
 	add_version(handle);
+	if (!no_top_instance())
+		add_trace_id(handle, &top_instance);
 }
 
 static void write_guest_file(struct buffer_instance *instance)
-- 
2.24.1

