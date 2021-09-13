Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3D7C6C433F5
	for <linux-trace-devel@archiver.kernel.org>; Mon, 13 Sep 2021 12:30:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2829260FC0
	for <linux-trace-devel@archiver.kernel.org>; Mon, 13 Sep 2021 12:30:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239963AbhIMMbb (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 13 Sep 2021 08:31:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47096 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240000AbhIMMba (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 13 Sep 2021 08:31:30 -0400
Received: from mail-wr1-x429.google.com (mail-wr1-x429.google.com [IPv6:2a00:1450:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E1AAC061574
        for <linux-trace-devel@vger.kernel.org>; Mon, 13 Sep 2021 05:30:14 -0700 (PDT)
Received: by mail-wr1-x429.google.com with SMTP id m9so14446080wrb.1
        for <linux-trace-devel@vger.kernel.org>; Mon, 13 Sep 2021 05:30:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=03pkaD3PStP0fZOQqnALHuGm44wpLKhfVZ0L3E+wbpo=;
        b=dQ5q2pVM806q1OiqahEPNRqY6UHMtbuskAHO+H5ssr+N3ocVrn+pb4bFrosz5fxzTy
         mcpqFLp/93wm33nWIgr6Q566Ibh2C8mq69PRjHD9Ov36s9i2KplyVrDK6Wil5pV4cy1V
         GTyCEv1Rb7nGJmsM6vD9DesbtWmNbut3H7NBKSXM5/ftozmihFf45XHcDyPcZZ4smP0u
         HsfQEgO2+zAk2avaSMAVtHE7NVkdQbKkREOHzyNmDdj6GfZxoNcmXyaH4k5/B7HRKxa9
         k58cQ/KLl7sywyt/lq+H4/tRCZcervN5ysYZl86ktUGCgUJioZ8P7WsDVhA9tWQGrfyb
         vFHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=03pkaD3PStP0fZOQqnALHuGm44wpLKhfVZ0L3E+wbpo=;
        b=dnf0OfiyEXVfXjCreowhUxvoYLxxXehs33huoADiJSkt2xiWmE79pI0J8RC0r3WDAB
         ofyeZd5E+UbBFTSSF3zjTEM4/IQUGKgb6QOii/fxIuEgHtEQNs6JXaGAkg0EiNVqlxqv
         E2VcQ7OjhHTlYOKEH22Ez8PQbiTRbo4WRWC78gHCI/PTWGNwEBnJ7OZT+9E+m7cDlky3
         0jYuKeWcCLbIDMoi7Lv1LCZ5Gr+HPMnLRs00Czi7YHz/4/YiBC58uQxXG5SFkwcIW+jr
         UcbT2VKXbW4wxwrxPMINQujRdh65zYHuW40fuPMWVUsAkDJSURNUb7pY7zBXGSXHw9j9
         CzUw==
X-Gm-Message-State: AOAM5326v0n6hnUtk/Av8EPIeDa62UKN5pyD6gvAvGdTcoo14u9JNtpL
        Z2PQYB6xJRVhpVJAmXAh8mYZ4qzUPW0=
X-Google-Smtp-Source: ABdhPJwdLhlCTTj2251Baohp3FYfgZEFSBGVbFfOVqYdElKwT65MsAKjrksGTuk6xJ+fkfaDAmrzyQ==
X-Received: by 2002:a05:6000:1809:: with SMTP id m9mr10979170wrh.396.1631536212940;
        Mon, 13 Sep 2021 05:30:12 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id z5sm6842030wmf.33.2021.09.13.05.30.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Sep 2021 05:30:12 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v2 24/25] trace-cmd: Call additional APIs when creating trace file
Date:   Mon, 13 Sep 2021 15:29:46 +0300
Message-Id: <20210913122947.3673239-25-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210913122947.3673239-1-tz.stoyanov@gmail.com>
References: <20210913122947.3673239-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

When creating a trace file, two more APIs should be called, compared to
the old flow:
 - tracecmd_write_buffer_info(), to write version 6 buffers metadata in
   the file.
 - tracecmd_write_options() after the trace data is written, for version
   7 trace files, as the buffer metadata is appended to the options at
   the end.

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 tracecmd/trace-listen.c  | 6 ++++++
 tracecmd/trace-record.c  | 4 ++++
 tracecmd/trace-restore.c | 3 ++-
 tracecmd/trace-split.c   | 3 +++
 4 files changed, 15 insertions(+), 1 deletion(-)

diff --git a/tracecmd/trace-listen.c b/tracecmd/trace-listen.c
index d812145b..fa04c6da 100644
--- a/tracecmd/trace-listen.c
+++ b/tracecmd/trace-listen.c
@@ -604,6 +604,9 @@ static int put_together_file(int cpus, int ofd, const char *node,
 
 	if (write_options) {
 		ret = tracecmd_write_cpus(handle, cpus);
+		if (ret)
+			goto out;
+		ret = tracecmd_write_buffer_info(handle);
 		if (ret)
 			goto out;
 		ret = tracecmd_write_options(handle);
@@ -612,6 +615,9 @@ static int put_together_file(int cpus, int ofd, const char *node,
 	}
 	ret = tracecmd_write_cpu_data(handle, cpus, temp_files, "");
 
+	if (!ret && tracecmd_get_out_file_version(handle) >= FILE_VERSION_SECTIONS)
+		tracecmd_write_options(handle);
+
 out:
 	tracecmd_output_close(handle);
 	for (cpu--; cpu >= 0; cpu--) {
diff --git a/tracecmd/trace-record.c b/tracecmd/trace-record.c
index af7f332c..f94eee6f 100644
--- a/tracecmd/trace-record.c
+++ b/tracecmd/trace-record.c
@@ -3729,6 +3729,9 @@ setup_connection(struct buffer_instance *instance, struct common_record_context
 		if (ret)
 			goto error;
 		ret = tracecmd_write_cpus(network_handle, instance->cpu_count);
+		if (ret)
+			goto error;
+		ret = tracecmd_write_buffer_info(network_handle);
 		if (ret)
 			goto error;
 		ret = tracecmd_write_options(network_handle);
@@ -4092,6 +4095,7 @@ static void setup_agent(struct buffer_instance *instance,
 	add_options(network_handle, ctx);
 	tracecmd_write_cmdlines(network_handle);
 	tracecmd_write_cpus(network_handle, instance->cpu_count);
+	tracecmd_write_buffer_info(network_handle);
 	tracecmd_write_options(network_handle);
 	tracecmd_msg_finish_sending_data(instance->msg_handle);
 	instance->network_handle = network_handle;
diff --git a/tracecmd/trace-restore.c b/tracecmd/trace-restore.c
index 8d2fcae8..a903c21a 100644
--- a/tracecmd/trace-restore.c
+++ b/tracecmd/trace-restore.c
@@ -163,6 +163,7 @@ void trace_restore (int argc, char **argv)
 
 	if (tracecmd_append_cpu_data(handle, args, &argv[first_arg]) < 0)
 		die("failed to append data");
-
+	if (tracecmd_get_out_file_version(handle) >= FILE_VERSION_SECTIONS)
+		tracecmd_write_options(handle);
 	return;
 }
diff --git a/tracecmd/trace-split.c b/tracecmd/trace-split.c
index e4a0c3b3..671d6e9f 100644
--- a/tracecmd/trace-split.c
+++ b/tracecmd/trace-split.c
@@ -391,6 +391,9 @@ static double parse_file(struct tracecmd_input *handle,
 	if (tracecmd_append_cpu_data(ohandle, cpus, cpu_list) < 0)
 		die("Failed to append tracing data\n");
 
+	if (tracecmd_get_out_file_version(ohandle) >= FILE_VERSION_SECTIONS)
+		tracecmd_write_options(ohandle);
+
 	current = end;
 	for (cpu = 0; cpu < cpus; cpu++) {
 		/* Set the tracecmd cursor to the next set of records */
-- 
2.31.1

