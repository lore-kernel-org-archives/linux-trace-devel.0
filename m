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
	by smtp.lore.kernel.org (Postfix) with ESMTP id A1942C433E1
	for <linux-trace-devel@archiver.kernel.org>; Mon, 22 Mar 2021 10:00:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 794BD61969
	for <linux-trace-devel@archiver.kernel.org>; Mon, 22 Mar 2021 10:00:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229508AbhCVJ7z (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 22 Mar 2021 05:59:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47194 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230016AbhCVJ7v (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 22 Mar 2021 05:59:51 -0400
Received: from mail-ej1-x62d.google.com (mail-ej1-x62d.google.com [IPv6:2a00:1450:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F8B2C061763
        for <linux-trace-devel@vger.kernel.org>; Mon, 22 Mar 2021 02:59:51 -0700 (PDT)
Received: by mail-ej1-x62d.google.com with SMTP id kt15so10700148ejb.12
        for <linux-trace-devel@vger.kernel.org>; Mon, 22 Mar 2021 02:59:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=+xeRlthL1+GIubmgF5iUWUn30iJC7ShY382hQ6L4NE4=;
        b=K/HFWzsmTrZRbzoLuG/g1L0avaOamWdw77cp59xccB98vCGjSnjT4QFwUZ8mgWEiPa
         +x8Z38jE2W+5xrG/LTbjULP9KKPQdTv+QxmQpDDtfXdmMTtWnSFJh6ue3kI2YAnoshAK
         wbKBxmeDZCwiL4x4DYh1BONowyrd5BiWauVp3LqVii1qPESN8/8sWiGORDnevsxczASs
         g/3ZQci121gM0sxBWhhRsIqyHakuLtvPQzFrjPxhd2SGuNo400kMFs7+m8Enrw1gMapp
         XGglA+ni8HueUjUvtgNhKznFmRKk9UVV/U8BDCJTt49GUxRgXc4q/MFfH+/Wt4pR8MuL
         9SGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=+xeRlthL1+GIubmgF5iUWUn30iJC7ShY382hQ6L4NE4=;
        b=H1zjX+uooJlbL2yZ5t+/ltLDRoD5JydMaRmejLNwYD/jGSjga/az4KDJQSSLFm+qbj
         vFIHOnQE/FB50XqDcLdHxC6GlRetgwPXA7aEgAPqF769eBoH7bKdkyezve2YHCtUO6/h
         Hp50fFNyFmvBUUIw+h+DLo28Z2iDC97rY/WeAo5bw+37dhxarthgkdMJ0wke/ucai2LQ
         KmNbC4sEMMkBc1IAGMJrHosewpTXjq/O5ogOzLjJyIY/CkIb6DM7qWjbLOZqtn4eO8b8
         QnzJIAz2PRUbFF+ZxgKfjCEMYE12n/3GJT7F1ykZK48rZo59hqQnt5QfDl0lBizhCJ5E
         RVmg==
X-Gm-Message-State: AOAM530iA8nGL5+YDdoI1SiNjlAqXz0aPq7XdiAqJSTQExN3Pr21SOqX
        3i4o3XpT05G/f0WNzqyDyEtXwhOiZWx8mg==
X-Google-Smtp-Source: ABdhPJxkbRUqvVy1de59bRVgllHJhG6P42XfdBFDHpbW7FDWnopX2wkgCzinKUh2Tz9Y7zPMASm1NQ==
X-Received: by 2002:a17:906:1f93:: with SMTP id t19mr18750743ejr.443.1616407190224;
        Mon, 22 Mar 2021 02:59:50 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id g26sm9288424ejz.70.2021.03.22.02.59.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 Mar 2021 02:59:49 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v2 03/18] trace-cmd: Save only the selected clock in the trace.dat file
Date:   Mon, 22 Mar 2021 11:59:30 +0200
Message-Id: <20210322095945.259300-4-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210322095945.259300-1-tz.stoyanov@gmail.com>
References: <20210322095945.259300-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Trace clock, used for curent trace sessions is saved in the trace.dat
file. This information is used when displaying timestamps of the events.
However, only the selected clock is needed.
A new API is added:
 tracecmd_set_out_clock();
that can be used to set the trace clock on the output handle.

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 .../include/private/trace-cmd-private.h       |  1 +
 lib/trace-cmd/trace-output.c                  | 65 +++++++++++++++----
 2 files changed, 55 insertions(+), 11 deletions(-)

diff --git a/lib/trace-cmd/include/private/trace-cmd-private.h b/lib/trace-cmd/include/private/trace-cmd-private.h
index 27f4c9c3..a4637046 100644
--- a/lib/trace-cmd/include/private/trace-cmd-private.h
+++ b/lib/trace-cmd/include/private/trace-cmd-private.h
@@ -83,6 +83,7 @@ tracecmd_plugin_context_output(struct trace_plugin_context *trace_context);
 
 void tracecmd_set_quiet(struct tracecmd_output *handle, bool set_quiet);
 bool tracecmd_get_quiet(struct tracecmd_output *handle);
+void tracecmd_set_out_clock(struct tracecmd_output *handle, char *clock);
 
 static inline int tracecmd_host_bigendian(void)
 {
diff --git a/lib/trace-cmd/trace-output.c b/lib/trace-cmd/trace-output.c
index 54ddcb54..5b6bef28 100644
--- a/lib/trace-cmd/trace-output.c
+++ b/lib/trace-cmd/trace-output.c
@@ -59,6 +59,7 @@ struct tracecmd_output {
 	unsigned long		file_state;
 	struct list_head	options;
 	struct tracecmd_msg_handle *msg_handle;
+	char			*trace_clock;
 };
 
 struct list_event {
@@ -118,6 +119,12 @@ void tracecmd_set_quiet(struct tracecmd_output *handle, bool set_quiet)
 		handle->quiet = set_quiet;
 }
 
+void tracecmd_set_out_clock(struct tracecmd_output *handle, char *clock)
+{
+	if (handle && clock)
+		handle->trace_clock = strdup(clock);
+}
+
 /**
  * tracecmd_get_quiet - Get if to print output to the screen
  * Returns non zero, if no output to the screen should be printed
@@ -150,7 +157,7 @@ void tracecmd_output_free(struct tracecmd_output *handle)
 		free(option->data);
 		free(option);
 	}
-
+	free(handle->trace_clock);
 	free(handle);
 }
 
@@ -1359,6 +1366,45 @@ out_free:
 	return NULL;
 }
 
+static int save_clock(struct tracecmd_output *handle, char *clock)
+{
+	unsigned long long endian8;
+	char *str = NULL;
+	int ret;
+
+	ret = asprintf(&str, "[%s]", clock);
+	if (ret < 0)
+		return -1;
+
+	endian8 = convert_endian_8(handle, strlen(str));
+	ret = do_write_check(handle, &endian8, 8);
+	if (ret)
+		goto out;
+	ret = do_write_check(handle, str, strlen(str));
+
+out:
+	free(str);
+	return ret;
+}
+
+static char *get_clock(struct tracecmd_output *handle)
+{
+	struct tracefs_instance *inst;
+
+	if (handle->trace_clock)
+		return handle->trace_clock;
+
+	/* If no clock is set on this handle, get the trace clock of
+	 * the top instance in the handle's tracing dir
+	 * */
+	inst = tracefs_instance_alloc(handle->tracing_dir, NULL);
+	if (!inst)
+		return NULL;
+	handle->trace_clock = tracefs_get_clock(inst);
+	tracefs_instance_free(inst);
+	return handle->trace_clock;
+}
+
 int tracecmd_write_cpu_data(struct tracecmd_output *handle,
 			    int cpus, char * const *cpu_data_files)
 {
@@ -1366,6 +1412,7 @@ int tracecmd_write_cpu_data(struct tracecmd_output *handle,
 	unsigned long long *sizes = NULL;
 	off64_t offset;
 	unsigned long long endian8;
+	char *clock = NULL;
 	off64_t check_size;
 	char *file;
 	struct stat st;
@@ -1403,18 +1450,14 @@ int tracecmd_write_cpu_data(struct tracecmd_output *handle,
 	 * we need to find the size of it before we define the final
 	 * offsets.
 	 */
-	file = get_tracing_file(handle, "trace_clock");
-	if (!file)
+	clock = get_clock(handle);
+	if (!clock)
 		goto out_free;
-
 	/* Save room for storing the size */
 	offset += 8;
-
-	ret = stat(file, &st);
-	if (ret >= 0)
-		offset += get_size(file);
-
-	put_tracing_file(file);
+	offset += strlen(clock);
+	/* 2 bytes for [] around the clock */
+	offset += 2;
 
 	/* Page align offset */
 	offset = (offset + (handle->page_size - 1)) & ~(handle->page_size - 1);
@@ -1439,7 +1482,7 @@ int tracecmd_write_cpu_data(struct tracecmd_output *handle,
 			goto out_free;
 	}
 
-	if (save_tracing_file_data(handle, "trace_clock") < 0)
+	if (save_clock(handle, clock))
 		goto out_free;
 
 	for (i = 0; i < cpus; i++) {
-- 
2.30.2

