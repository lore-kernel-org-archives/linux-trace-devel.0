Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.9 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNWANTED_LANGUAGE_BODY,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7A59EC48BD1
	for <linux-trace-devel@archiver.kernel.org>; Thu, 10 Jun 2021 11:36:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 62FDF613E9
	for <linux-trace-devel@archiver.kernel.org>; Thu, 10 Jun 2021 11:36:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230245AbhFJLiP (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 10 Jun 2021 07:38:15 -0400
Received: from mail-wr1-f50.google.com ([209.85.221.50]:39578 "EHLO
        mail-wr1-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230250AbhFJLiP (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 10 Jun 2021 07:38:15 -0400
Received: by mail-wr1-f50.google.com with SMTP id l2so1909828wrw.6
        for <linux-trace-devel@vger.kernel.org>; Thu, 10 Jun 2021 04:36:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=H/Nld6QJK8ob2cGGOO/ZYw75wyLuGDA6phwis20loh4=;
        b=hmv4uCFlR2hqiaAHZvX+ff14aJPNAgKd4LIITVF0BaHCN/gIPFBevOoy3NIVWcI9MA
         OSCCwYbMGa33/ymSwKT1hLKUFaUdq3orI0UQOFs3bkm+3ukxsVtJhR1O3TLT8UMBZUqp
         b74rS7ivdlOcLLfSNwWOvbZLXnVYUEP3/YQr3Ie6RKWWRQmi0E6jC5XBQrDHEC031gUu
         OCf8ZU9LjM6YD2IVruGVIrcf/XSBh2dPDGmvpW3ePv57I0jMiXGEaRNgVGEhCyrtalUd
         qXU68GxJwp4Nl4sfbX9/DzJIQAOeX9TIinYs93FYeYORO6SKVS19KJDC+Muu/bA3GO1E
         12oQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=H/Nld6QJK8ob2cGGOO/ZYw75wyLuGDA6phwis20loh4=;
        b=hAByD4j8t/Pdg/NSGKjIRM9uUlmKH8ZnybCR7uKumYRvgPRT9SREtN3vXC+IbksvwK
         k9jz4Kpa6Y9jA1oM8sHzaesgclKIEzjk/Nl6pq/e3QYtbcxmnRDwWw/7u0kCj/6ycG79
         jfDfnaxWQ7VCYcnu7A/fEcJiWQ0A1u1yX7U36s7jsz5asKjBpeIG4CLzNWAVjcsVd/Yj
         b2Ad3VFbvKhz4/IyoU/YkVfWvtyK+MDMXWlkqW6q/mYuUYE4ClMQaiBETqVSfvqPybT2
         rghA4S3bnS4q2xwCCtJjyfiyo+y1j9CUB09K8cLo035igkBvLWX+xcj4JQIOJpy9ZCl1
         6fmA==
X-Gm-Message-State: AOAM532hQcp2hpX9c0xOzevpe0Srh7Alm4Mi+fBunA4H6WQsZ3PwsiPj
        4H5E8J6rKSdXiUiVjpZtkdQ=
X-Google-Smtp-Source: ABdhPJxFNKW4cbMVEGGQu1f7CM9v1VtIti0892cJTb3ZeoiXPEaRc2341uECrV4q8W1LaHYbyhZ56g==
X-Received: by 2002:a5d:4a43:: with SMTP id v3mr4788223wrs.397.1623324903952;
        Thu, 10 Jun 2021 04:35:03 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id n42sm8898391wms.29.2021.06.10.04.35.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Jun 2021 04:35:03 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v5 38/40] trace-cmd: Copy trace data in tracecmd_copy
Date:   Thu, 10 Jun 2021 14:34:24 +0300
Message-Id: <20210610113426.257931-39-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210610113426.257931-1-tz.stoyanov@gmail.com>
References: <20210610113426.257931-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Extend the tracecmd_copy() API to support copying of trace data
from input to output trace handler.

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 .../include/private/trace-cmd-private.h       |   2 +
 lib/trace-cmd/trace-input.c                   | 101 ++++++++++++++++++
 lib/trace-cmd/trace-output.c                  |   3 +
 3 files changed, 106 insertions(+)

diff --git a/lib/trace-cmd/include/private/trace-cmd-private.h b/lib/trace-cmd/include/private/trace-cmd-private.h
index 595ba688..79fef884 100644
--- a/lib/trace-cmd/include/private/trace-cmd-private.h
+++ b/lib/trace-cmd/include/private/trace-cmd-private.h
@@ -178,6 +178,8 @@ int tracecmd_copy_buffer_descr(struct tracecmd_input *in_handle,
 			       struct tracecmd_output *out_handle);
 int tracecmd_copy_options(struct tracecmd_input *in_handle,
 			  struct tracecmd_output *out_handle);
+int tracecmd_copy_trace_data(struct tracecmd_input *in_handle,
+			     struct tracecmd_output *out_handle);
 void tracecmd_set_flag(struct tracecmd_input *handle, int flag);
 void tracecmd_clear_flag(struct tracecmd_input *handle, int flag);
 unsigned long tracecmd_get_flags(struct tracecmd_input *handle);
diff --git a/lib/trace-cmd/trace-input.c b/lib/trace-cmd/trace-input.c
index 794f8ea3..2544d825 100644
--- a/lib/trace-cmd/trace-input.c
+++ b/lib/trace-cmd/trace-input.c
@@ -4291,6 +4291,107 @@ int tracecmd_copy_options(struct tracecmd_input *in_handle,
 	return 0;
 }
 
+static int copy_trace_latency(struct tracecmd_input *in_handle,
+			      struct tracecmd_output *out_handle)
+{
+	int fd;
+
+	if (do_write_check(out_handle, "latency  ", 10))
+		return -1;
+
+	if (in_handle->lat_cfd >= 0)
+		fd = in_handle->lat_cfd;
+	else
+		fd = in_handle->fd;
+
+	if (!out_copy_fd_compress(out_handle, fd, 0, NULL))
+		return -1;
+
+	out_set_file_state(out_handle, TRACECMD_FILE_CPU_LATENCY);
+	return 0;
+}
+
+static int copy_trace_flyrecord_data(struct tracecmd_input *in_handle,
+				     struct tracecmd_output *out_handle)
+{
+	struct cpu_data_source *data;
+	int ret;
+	int i;
+
+	data = calloc(in_handle->cpus, sizeof(struct cpu_data_source));
+	if (!data)
+		return -1;
+	for (i = 0; i < in_handle->cpus; i++) {
+		data[i].size = in_handle->cpu_data[i].file_size;
+		if (in_handle->cpu_data[i].cfd >= 0) {
+			data[i].fd = in_handle->cpu_data[i].cfd;
+			data[i].offset = 0;
+		} else {
+			data[i].fd = in_handle->fd;
+			data[i].offset = in_handle->cpu_data[i].file_offset;
+		}
+	}
+	ret = out_write_cpu_data(out_handle, in_handle->cpus, data);
+
+	return ret;
+}
+
+static int copy_trace_flyrecord(struct tracecmd_input *in_handle,
+				struct tracecmd_output *out_handle)
+{
+	struct tracecmd_input *instance;
+	const char *name;
+	int ret;
+	int i;
+
+	/* top instance */
+	ret = copy_trace_flyrecord_data(in_handle, out_handle);
+	if (ret)
+		return ret;
+
+	for (i = 0; i < in_handle->nr_buffers; i++) {
+		name = tracecmd_buffer_instance_name(in_handle, i);
+		if (!name)
+			continue;
+		instance = tracecmd_buffer_instance_handle(in_handle, i);
+		if (!instance)
+			continue;
+		if (!tracecmd_get_quiet(out_handle))
+			fprintf(stderr, "\nBuffer: %s\n\n", name);
+
+		if (!out_update_buffer_cpu_offset(out_handle, name))
+			copy_trace_flyrecord_data(instance, out_handle);
+
+		tracecmd_close(instance);
+	}
+
+	return 0;
+}
+
+int tracecmd_copy_trace_data(struct tracecmd_input *in_handle,
+			     struct tracecmd_output *out_handle)
+{
+	char buf[10];
+
+	if (!check_in_state(in_handle, TRACECMD_FILE_CPU_FLYRECORD) ||
+	    !check_out_state(out_handle, TRACECMD_FILE_CPU_FLYRECORD))
+		return -1;
+
+	tracecmd_set_out_clock(out_handle, in_handle->trace_clock);
+
+	if (do_read_check(in_handle, buf, 10))
+		return -1;
+	if (strncmp(buf, "latency", 7) == 0) {
+		in_handle->file_state = TRACECMD_FILE_CPU_LATENCY;
+		return copy_trace_latency(in_handle, out_handle);
+	} else if (strncmp(buf, "flyrecord", 9) == 0) {
+		in_handle->file_state = TRACECMD_FILE_CPU_FLYRECORD;
+		return copy_trace_flyrecord(in_handle, out_handle);
+	}
+
+	return -1;
+}
+
 /**
  * tracecmd_record_at_buffer_start - return true if record is first on subbuffer
  * @handle: input handle for the trace.dat file
diff --git a/lib/trace-cmd/trace-output.c b/lib/trace-cmd/trace-output.c
index 9933224c..fd7ea06c 100644
--- a/lib/trace-cmd/trace-output.c
+++ b/lib/trace-cmd/trace-output.c
@@ -2025,6 +2025,9 @@ struct tracecmd_output *tracecmd_copy(struct tracecmd_input *ihandle, const char
 	if (state >= TRACECMD_FILE_OPTIONS &&
 	    tracecmd_copy_options(ihandle, handle) < 0)
 		goto out_free;
+	if (state >= TRACECMD_FILE_CPU_LATENCY &&
+	    tracecmd_copy_trace_data(ihandle, handle) < 0)
+		goto out_free;
 
 	/* The file is all ready to have cpu data attached */
 	return handle;
-- 
2.31.1

