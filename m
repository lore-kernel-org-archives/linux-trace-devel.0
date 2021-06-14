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
	by smtp.lore.kernel.org (Postfix) with ESMTP id E2E46C49360
	for <linux-trace-devel@archiver.kernel.org>; Mon, 14 Jun 2021 07:52:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CC2B961370
	for <linux-trace-devel@archiver.kernel.org>; Mon, 14 Jun 2021 07:52:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232562AbhFNHyZ (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 14 Jun 2021 03:54:25 -0400
Received: from mail-ed1-f50.google.com ([209.85.208.50]:33686 "EHLO
        mail-ed1-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232640AbhFNHyY (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 14 Jun 2021 03:54:24 -0400
Received: by mail-ed1-f50.google.com with SMTP id f5so40212117eds.0
        for <linux-trace-devel@vger.kernel.org>; Mon, 14 Jun 2021 00:52:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=e0ixMsnikpyfSMZamlgZvIFRCDv7ZTHnXlFb3wlMRg0=;
        b=Ra3clube7+mk+HXaAWv52lwuZJZrAZykhgQE/ftcIxoGsmdLIjqykzjlQVgf5qyQIr
         M+GXsydGDX+Pk6cOcZQIajp+aC9+vBamHqbTGHGHtJ4RN/0E0AhjgsTa5ZZX7PLEQFwM
         i37z6LBzK64HCLCwLOUFw//EJUMau7BSw8Coh7tWS+lHH9jzv/I6dojVHH0KxX3hU8rc
         97I9nvhT04N+yDNIX1yDtvRBIYtRJFRmgKDSGY1bhhwoFbfT4OjrAihMrG898IHwej/Q
         I3TaRBIuNN39JMk5VR4pLGA+6OyiCZx7nasz3Cn6ThNr/l5lVgaJD5AutIh7Xo0byFRV
         GznA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=e0ixMsnikpyfSMZamlgZvIFRCDv7ZTHnXlFb3wlMRg0=;
        b=huThw74ilOKuLXkZq+r2wPqGmzzzTLFbUWatBOPHbWEm3OPisFY2bi6MaFuMs1lvUZ
         2ZbqW/39l/oPy0iqUOXQA6gSFehGy1EGFuVlghrSR/QoZjSZj/d6itc5b1j5XyxFPUx8
         WtQ7HBVzrI2EOnVnVdWjWsxc/qnX9bJ5qf6MxBXAteASfpk3j2O3WZpgraYzka76v7Oa
         je23pSmkr/Fv7BBcCYAlBUHBgGtNbTW1kfM4z54tEooQRUNLmWhEeD6jAcDEyuFkRpWu
         RQWGhNPqyigXiOdCgIogsi7hv0iY48Xlb1Csc3TDbmV7qTF8Z8n2whRFAQnX3OMcYyzJ
         +X+A==
X-Gm-Message-State: AOAM532HZ/j/udE06p6om0QepzohAzxIT29kbRGz6wgR2RtSU+vUByvv
        Pk8/rRSeIEghntW8xcHWAdnZY1T0ZJeY6g==
X-Google-Smtp-Source: ABdhPJwT5Vsuco+TsOVyC3vs3Ggo6TI5uF2gnPVDDz0P6hCJ6h2MkRVHLA7rXJ+4BuepjTOmqOXUaw==
X-Received: by 2002:aa7:c41a:: with SMTP id j26mr15435223edq.133.1623657067937;
        Mon, 14 Jun 2021 00:51:07 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id f6sm6536444eja.108.2021.06.14.00.51.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Jun 2021 00:51:07 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v6 38/45] trace-cmd: Copy trace data in tracecmd_copy
Date:   Mon, 14 Jun 2021 10:50:22 +0300
Message-Id: <20210614075029.598048-39-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210614075029.598048-1-tz.stoyanov@gmail.com>
References: <20210614075029.598048-1-tz.stoyanov@gmail.com>
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
index 54134d03..377c5863 100644
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

