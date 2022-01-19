Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9BF12C433FE
	for <linux-trace-devel@archiver.kernel.org>; Wed, 19 Jan 2022 08:25:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352368AbiASIZQ (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 19 Jan 2022 03:25:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45754 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352348AbiASIZP (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 19 Jan 2022 03:25:15 -0500
Received: from mail-ed1-x531.google.com (mail-ed1-x531.google.com [IPv6:2a00:1450:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 82DD2C061574
        for <linux-trace-devel@vger.kernel.org>; Wed, 19 Jan 2022 00:25:15 -0800 (PST)
Received: by mail-ed1-x531.google.com with SMTP id b13so7807900edn.0
        for <linux-trace-devel@vger.kernel.org>; Wed, 19 Jan 2022 00:25:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=N7QBpH5k2pjW5kIzyo+rJLcLvrdcWSp1lEuVsY13NwY=;
        b=QlHCwcka7zwYJZX//2Ksf53rI9eTC4oMGTPHs6PYh6xH94PVhRB/eUKRGiTn2bSd0h
         nNsbYDle2p7JHJXmhQrX7Aw/RqgKTdvc5NYAkYdJe4uxQmaeNILz12LDUAM+G0RuiZ12
         UFVNvfCEPS7bbM3cHSrh9n102A0096Fnp9JSSXUh1qizyvaBBnQdjGnq8d4kx0R+iUqv
         bXhGxB1sLdd8IjTk0vKJOVw9VMKAYCADAt6dCUfLnndaE9Ebz+BL9w5Pgapqfsguun8I
         05QM7LbroujOMS6BKc/tU/Zyx+1yi//ceR0D+CNFzidWzvIW9461PPSwVHves8WR2dKM
         9lUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=N7QBpH5k2pjW5kIzyo+rJLcLvrdcWSp1lEuVsY13NwY=;
        b=4WHZp+LswEmLRMpeISK41o7WrwxeDBAPgAxRNSVROHK4p6TV+ZQ/cWtvrGaDrhlzT7
         mdybqo8EebBbFjx127Yy5Ax4hp6ELhhFGT2foVhRs257OetlE0kPR8dfQ4mdxSz4d4h2
         rQSXc3Sv2v8DmmxDPMdmowLH/Ov+VjntjuOPTXqFh0TzLriZXZf3rOA2IbFu/FMmbg36
         m66iPbeXxHdDO3y8mcqVJFqRqgtYqBiUMCJ40vWzlIA5MjoktbfepbNjT3ZUyI21YvuZ
         /tIVlIiThAqMtfoqn82vIn9ocRgD8GoQQ83SHk6bxoM0LmidAR4dmzkVkvgYSDgpmnaI
         /Prw==
X-Gm-Message-State: AOAM5325+c1h4mWc4vAkd25QnL/rfNUlItLAWWPdZDUEIQ2OQ3h9TZGM
        yT1UkZsCuJp8F4kESOvNzhqZj/Y7lGk=
X-Google-Smtp-Source: ABdhPJzyE0sRsNoz6Fpcty7yRYNOF7qqDmFUXf7c5WmIpPHwLnRs+i4xvEvwHHeo/DOIasNH1jy+/A==
X-Received: by 2002:a17:907:72c4:: with SMTP id du4mr1027506ejc.564.1642580714104;
        Wed, 19 Jan 2022 00:25:14 -0800 (PST)
Received: from oberon.zico.biz.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id l1sm5011122ejf.44.2022.01.19.00.25.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Jan 2022 00:25:13 -0800 (PST)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v8 04/25] trace-cmd library: Add strings section in trace file version 7
Date:   Wed, 19 Jan 2022 10:24:46 +0200
Message-Id: <20220119082507.245600-5-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220119082507.245600-1-tz.stoyanov@gmail.com>
References: <20220119082507.245600-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

In the trace file metadata there are various dynamic strings. Collecting
all these strings in a dedicated section in the file simplifies parsing
of the metadata. The string section is added in trace files version 7,
at the end of the file.

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 .../include/private/trace-cmd-private.h       |  2 +
 lib/trace-cmd/trace-output.c                  | 68 +++++++++++++++++++
 tracecmd/trace-record.c                       |  1 +
 3 files changed, 71 insertions(+)

diff --git a/lib/trace-cmd/include/private/trace-cmd-private.h b/lib/trace-cmd/include/private/trace-cmd-private.h
index 77374000..e1467971 100644
--- a/lib/trace-cmd/include/private/trace-cmd-private.h
+++ b/lib/trace-cmd/include/private/trace-cmd-private.h
@@ -143,6 +143,7 @@ enum {
 	TRACECMD_OPTION_TIME_SHIFT,
 	TRACECMD_OPTION_GUEST,
 	TRACECMD_OPTION_TSC2NSEC,
+	TRACECMD_OPTION_STRINGS,
 };
 
 enum {
@@ -306,6 +307,7 @@ int tracecmd_write_buffer_info(struct tracecmd_output *handle);
 int tracecmd_write_cpus(struct tracecmd_output *handle, int cpus);
 int tracecmd_write_cmdlines(struct tracecmd_output *handle);
 int tracecmd_write_options(struct tracecmd_output *handle);
+int tracecmd_write_meta_strings(struct tracecmd_output *handle);
 int tracecmd_append_options(struct tracecmd_output *handle);
 void tracecmd_output_close(struct tracecmd_output *handle);
 void tracecmd_output_free(struct tracecmd_output *handle);
diff --git a/lib/trace-cmd/trace-output.c b/lib/trace-cmd/trace-output.c
index 4d165ac2..d3c73ceb 100644
--- a/lib/trace-cmd/trace-output.c
+++ b/lib/trace-cmd/trace-output.c
@@ -62,6 +62,12 @@ struct tracecmd_output {
 	bool			quiet;
 	unsigned long		file_state;
 	unsigned long		file_version;
+
+	/* size of meta-data strings, not yet stored in the file */
+	unsigned long		strings_p;
+	/* current virtual offset of meta-data string */
+	unsigned long		strings_offs;
+
 	size_t			options_start;
 	bool			big_endian;
 
@@ -69,6 +75,9 @@ struct tracecmd_output {
 	struct list_head	buffers;
 	struct tracecmd_msg_handle *msg_handle;
 	char			*trace_clock;
+
+	/* meta-data strings, not yet stored in the file */
+	char			*strings;
 };
 
 struct list_event {
@@ -85,6 +94,8 @@ struct list_event_system {
 
 #define HAS_SECTIONS(H) ((H)->file_version >= FILE_VERSION_SECTIONS)
 
+static int save_string_section(struct tracecmd_output *handle);
+
 static stsize_t
 do_write_check(struct tracecmd_output *handle, const void *data, tsize_t size)
 {
@@ -127,6 +138,22 @@ static unsigned long long convert_endian_8(struct tracecmd_output *handle,
 	return tep_read_number(handle->pevent, &val, 8);
 }
 
+static long add_string(struct tracecmd_output *handle, const char *string)
+{
+	int size = strlen(string) + 1;
+	int pos = handle->strings_p;
+	char *strings;
+
+	strings = realloc(handle->strings, pos + size);
+	if (!strings)
+		return -1;
+	handle->strings = strings;
+	memcpy(handle->strings + pos, string, size);
+	handle->strings_p += size;
+
+	return handle->strings_offs + pos;
+}
+
 /**
  * tracecmd_set_quiet - Set if to print output to the screen
  * @quiet: If non zero, print no output to the screen
@@ -185,6 +212,7 @@ void tracecmd_output_free(struct tracecmd_output *handle)
 		free(option);
 	}
 
+	free(handle->strings);
 	free(handle->trace_clock);
 	free(handle);
 }
@@ -194,6 +222,11 @@ void tracecmd_output_close(struct tracecmd_output *handle)
 	if (!handle)
 		return;
 
+	if (HAS_SECTIONS(handle)) {
+		/* write strings section */
+		save_string_section(handle);
+	}
+
 	if (handle->fd >= 0) {
 		close(handle->fd);
 		handle->fd = -1;
@@ -332,6 +365,32 @@ int tracecmd_ftrace_enable(int set)
 	return ret;
 }
 
+static int save_string_section(struct tracecmd_output *handle)
+{
+	if (!handle->strings || !handle->strings_p)
+		return 0;
+
+	if (!check_out_state(handle, TRACECMD_OPTION_STRINGS)) {
+		tracecmd_warning("Cannot write strings, unexpected state 0x%X",
+				 handle->file_state);
+		return -1;
+	}
+
+	if (do_write_check(handle, handle->strings, handle->strings_p))
+		goto error;
+
+	handle->strings_offs += handle->strings_p;
+	free(handle->strings);
+	handle->strings = NULL;
+	handle->strings_p = 0;
+	handle->file_state = TRACECMD_OPTION_STRINGS;
+	return 0;
+
+error:
+	return -1;
+}
+
+
 static int read_header_files(struct tracecmd_output *handle)
 {
 	tsize_t size, check_size, endian8;
@@ -1328,6 +1387,15 @@ int tracecmd_write_options(struct tracecmd_output *handle)
 	return 0;
 }
 
+int tracecmd_write_meta_strings(struct tracecmd_output *handle)
+{
+	if (!HAS_SECTIONS(handle))
+		return 0;
+
+	return save_string_section(handle);
+}
+
+
 int tracecmd_append_options(struct tracecmd_output *handle)
 {
 	struct tracecmd_option *options;
diff --git a/tracecmd/trace-record.c b/tracecmd/trace-record.c
index 7b2b59bb..f599610e 100644
--- a/tracecmd/trace-record.c
+++ b/tracecmd/trace-record.c
@@ -4093,6 +4093,7 @@ static void setup_agent(struct buffer_instance *instance,
 	tracecmd_write_cmdlines(network_handle);
 	tracecmd_write_cpus(network_handle, instance->cpu_count);
 	tracecmd_write_options(network_handle);
+	tracecmd_write_meta_strings(network_handle);
 	tracecmd_msg_finish_sending_data(instance->msg_handle);
 	instance->network_handle = network_handle;
 }
-- 
2.34.1

