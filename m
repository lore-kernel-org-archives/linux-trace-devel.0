Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 51F8AC47094
	for <linux-trace-devel@archiver.kernel.org>; Thu, 10 Jun 2021 11:36:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3C61E61406
	for <linux-trace-devel@archiver.kernel.org>; Thu, 10 Jun 2021 11:36:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230410AbhFJLh5 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 10 Jun 2021 07:37:57 -0400
Received: from mail-wm1-f53.google.com ([209.85.128.53]:44991 "EHLO
        mail-wm1-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230265AbhFJLh5 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 10 Jun 2021 07:37:57 -0400
Received: by mail-wm1-f53.google.com with SMTP id m41-20020a05600c3b29b02901b9e5d74f02so3101243wms.3
        for <linux-trace-devel@vger.kernel.org>; Thu, 10 Jun 2021 04:35:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=O4tw/vtCdoHAkqVILpd8GpKTrQc88oL92rc/FfJiJWk=;
        b=DEWgAuq7qbCRRGbek9yHsnc8D5UeBUhbqLNpiLYFh7Hd+YTRXpSH84z+zU1AsXjbTk
         htwtpn/vIdjia2L1J5Hp1jvLhFCx7csa8+Oj4RaOxilrSv6KEJlK4rFC0pAd349tW4bW
         rspjTS0yATlpB0QXArrXQ17ZVe7PZnn3zCa7P9XOedmPBCrmi+D+Dom//FpJ8Zrik1s7
         hvHeVRJNaDvFzCYAfTmJ82/hI+avqUX0wDsS78QMKGlZ5PE2gnajw/K3RU3Jzlb6veZH
         rEy428oYtYFSBvGCX+MbklzNUMbFIOG3cjTBhZMBiL9zcQ1xxPVIRVjDIYKLjtoy/XpQ
         xMSQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=O4tw/vtCdoHAkqVILpd8GpKTrQc88oL92rc/FfJiJWk=;
        b=B+Pw0GvzmQSPe1zyNLnY8mpFnj3eGt3AMbbjES8ROZR2dubLSowkiV1/s8rFMldjUw
         iM4dbX3nVaf9wipXyy5JgfwQ+qFNLdGTY8RpxmgGlCWL96hgboB2diTQ7YP1ogsnL4mn
         gwJoi18WYR6lEvvbCFkM1RcGYsDIa/sF7rd7pfzzW1NQEHN7MQT+dvcPvFyx4NJM+yJR
         ayULpt8JxQMpKcqMAhHwmrPv1P1t3G9PDFtjYGv5m4CGyPIVcA1akpAtZmx1CPDpkyYh
         NWZ1xlZsKp4bH3b3sc5th0c/xllfWlqDJOWLs8PX1RVqlkpvMheMmxWC9uchk6PHCeBd
         lHeQ==
X-Gm-Message-State: AOAM532iQ1PeiwiXxVfytQ52AQoW8obm2XC1jF800ANpH5XIQBpl+Uz4
        Wq8SQw0DmYOUFXzfSysseqY/+HrDVCPSOQ==
X-Google-Smtp-Source: ABdhPJwXAMr2Y2+5yKjdTOPVXlzJ9gj9LQJzK1QB2TAuG9xwZbeHCLdllH/f5aGBPbrsAhsrNGfC8g==
X-Received: by 2002:a7b:c19a:: with SMTP id y26mr14529901wmi.132.1623324893501;
        Thu, 10 Jun 2021 04:34:53 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id n42sm8898391wms.29.2021.06.10.04.34.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Jun 2021 04:34:53 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v5 27/40] trace-cmd: Read compressed latency trace data
Date:   Thu, 10 Jun 2021 14:34:13 +0300
Message-Id: <20210610113426.257931-28-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210610113426.257931-1-tz.stoyanov@gmail.com>
References: <20210610113426.257931-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

When reading trace file version 7 with latency trace data, uncompress the
data. A new trace-cmd API is introduced to handle that case:
  tracecmd_latency_data_read()

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 .../include/private/trace-cmd-private.h       |  2 +
 lib/trace-cmd/trace-input.c                   | 42 ++++++++++++++++++-
 tracecmd/trace-read.c                         |  6 +--
 3 files changed, 46 insertions(+), 4 deletions(-)

diff --git a/lib/trace-cmd/include/private/trace-cmd-private.h b/lib/trace-cmd/include/private/trace-cmd-private.h
index 067ba34d..4a3eb1bc 100644
--- a/lib/trace-cmd/include/private/trace-cmd-private.h
+++ b/lib/trace-cmd/include/private/trace-cmd-private.h
@@ -208,6 +208,8 @@ tracecmd_peek_data_ref(struct tracecmd_input *handle, int cpu)
 	return rec;
 }
 
+int tracecmd_latency_data_read(struct tracecmd_input *handle, void *buf, size_t size);
+
 struct tep_record *
 tracecmd_read_prev(struct tracecmd_input *handle, struct tep_record *record);
 
diff --git a/lib/trace-cmd/trace-input.c b/lib/trace-cmd/trace-input.c
index 327082a2..12876838 100644
--- a/lib/trace-cmd/trace-input.c
+++ b/lib/trace-cmd/trace-input.c
@@ -137,6 +137,9 @@ struct tracecmd_input {
 	bool			read_page;
 	bool			use_pipe;
 	int			file_version;
+	/* temporary file for uncompressed latency data */
+	int			lat_cfd;
+	char			lat_cfile[26]; /* strlen(COMPR_TEMP_FILE) */
 	struct cpu_data 	*cpu_data;
 	long long		ts_offset;
 	struct tsc2nsec		tsc_calc;
@@ -2995,6 +2998,35 @@ static int read_options_type(struct tracecmd_input *handle)
 	return 0;
 }
 
+int tracecmd_latency_data_read(struct tracecmd_input *handle, void *buf, size_t size)
+{
+	int fd, r;
+
+	if (handle->file_state != TRACECMD_FILE_CPU_LATENCY)
+		return -1;
+	if (handle->lat_cfd >= 0)
+		fd = handle->lat_cfd;
+	else
+		fd = handle->fd;
+	r = read(fd, buf, size);
+
+	return r;
+}
+
+static int latency_data_uncompress(struct tracecmd_input *handle)
+{
+	int ret;
+
+	strcpy(handle->lat_cfile, COMPR_TEMP_FILE);
+	handle->lat_cfd = mkstemp(handle->lat_cfile);
+	if (handle->lat_cfd < 0)
+		return -1;
+	ret = tracecmd_uncompress_copy_to(handle->compress, handle->lat_cfd, NULL, NULL);
+	if (!ret)
+		lseek64(handle->lat_cfd, 0, SEEK_SET);
+	return ret;
+}
+
 static int read_cpu_data(struct tracecmd_input *handle)
 {
 	struct tep_handle *pevent = handle->pevent;
@@ -3009,8 +3041,11 @@ static int read_cpu_data(struct tracecmd_input *handle)
 	/*
 	 * Check if this is a latency report or not.
 	 */
-	if (handle->file_state == TRACECMD_FILE_CPU_LATENCY)
+	if (handle->file_state == TRACECMD_FILE_CPU_LATENCY) {
+		if (handle->file_version >= 7 && latency_data_uncompress(handle))
+			return -1;
 		return 1;
+	}
 
 	/* We expect this to be flyrecord */
 	if (handle->file_state != TRACECMD_FILE_CPU_FLYRECORD)
@@ -3448,6 +3483,7 @@ struct tracecmd_input *tracecmd_alloc_fd(int fd, int flags)
 
 	handle->fd = fd;
 	handle->ref = 1;
+	handle->lat_cfd = -1;
 
 	if (do_read_check(handle, buf, 3))
 		goto failed_read;
@@ -3698,6 +3734,10 @@ void tracecmd_close(struct tracecmd_input *handle)
 	free(handle->uname);
 	free(handle->trace_clock);
 	close(handle->fd);
+	if (handle->lat_cfd >= 0) {
+		close(handle->lat_cfd);
+		unlink(handle->lat_cfile);
+	}
 
 	tracecmd_free_hooks(handle->hooks);
 	handle->hooks = NULL;
diff --git a/tracecmd/trace-read.c b/tracecmd/trace-read.c
index d605d05a..dfb814b7 100644
--- a/tracecmd/trace-read.c
+++ b/tracecmd/trace-read.c
@@ -948,13 +948,13 @@ void trace_show_data(struct tracecmd_input *handle, struct tep_record *record)
 	printf("\n");
 }
 
-static void read_rest(void)
+static void read_latency(struct tracecmd_input *handle)
 {
 	char buf[BUFSIZ + 1];
 	int r;
 
 	do {
-		r = read(input_fd, buf, BUFSIZ);
+		r = tracecmd_latency_data_read(handle, buf, BUFSIZ);
 		if (r > 0) {
 			buf[r] = 0;
 			printf("%s", buf);
@@ -1241,7 +1241,7 @@ static void read_data_info(struct list_head *handle_list, enum output_type otype
 		if (ret > 0) {
 			if (multi_inputs)
 				die("latency traces do not work with multiple inputs");
-			read_rest();
+			read_latency(handles->handle);
 			return;
 		}
 
-- 
2.31.1

