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
	by smtp.lore.kernel.org (Postfix) with ESMTP id C42F7C433EF
	for <linux-trace-devel@archiver.kernel.org>; Fri, 10 Sep 2021 13:51:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B0800611CC
	for <linux-trace-devel@archiver.kernel.org>; Fri, 10 Sep 2021 13:51:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233783AbhIJNwj (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 10 Sep 2021 09:52:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48770 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233767AbhIJNwi (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 10 Sep 2021 09:52:38 -0400
Received: from mail-ej1-x633.google.com (mail-ej1-x633.google.com [IPv6:2a00:1450:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 981A4C061574
        for <linux-trace-devel@vger.kernel.org>; Fri, 10 Sep 2021 06:51:27 -0700 (PDT)
Received: by mail-ej1-x633.google.com with SMTP id ho42so4371429ejc.9
        for <linux-trace-devel@vger.kernel.org>; Fri, 10 Sep 2021 06:51:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=03pkaD3PStP0fZOQqnALHuGm44wpLKhfVZ0L3E+wbpo=;
        b=KNZ8pbLkVXHjh64S/6DnWs58qVnM+gWMJaUT+88yL2G7A3f7IhmP46961ty4aoHg4i
         uALBmnp6UW0kxjPpBoeSPPwMhzS3uaF2oOzNpz91Mio9Ub49Keea0uR5Sx+he/qSj7BJ
         hs4nIFe/ELw7b5P/45NfFn1JaIveYDz03B8OFol8JCKlj2GS9Rxjwp+atbP7PsOmN5SN
         fb31q9hE3rrI2YBUGIj7PbgoxDS/1PyvZN50SjRJcPLwSrvUspbWcjs4p4tSsaW9eLWY
         M60z38nP916yBBqrsFyaLvI+3gelc3yx/pBPeADxjmUegWWrc7S5aVqjV5DHGkhhzuqz
         QVPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=03pkaD3PStP0fZOQqnALHuGm44wpLKhfVZ0L3E+wbpo=;
        b=sjKCk6KJG5CCfzrRRQcg04aRGyRLm8QMEYc4Pdgf5A++6epgy/S71MORIltncB/MVG
         zv7SZRjq8olbBIF8pkotEUTZjTKHy5rlQnVBnFffK/fej4fBxe/dIqXzjtzTODvJb+Fu
         DgULACb7UOZOKdfTHwybzRXHkZ9J3dd0bIu9nIBfzEfjc1aVoQEWxcCrL/6yLP6bpC3B
         WNOfcpEdhoy8qoQL6T7ZxyE7Sjse4Bfl/RQQt57Pj1tuc0xUeIBKzdRbBNQdZIFSQPCU
         59QhKZovDBkLJS7HjqUr+VceFxWyR1t61K7Cas7YWgGtJegcOdyFAwcoRFrgVGmB9HLI
         7Imw==
X-Gm-Message-State: AOAM533umjxvWgfPDfrAlrOhkA0FL/lhHsLmHx8LUoWMbw/O+Mq2Eu9E
        Pwv8cfoQg98Oq0RP0WY7ZfAJHk70ekE=
X-Google-Smtp-Source: ABdhPJxOrK1GctTaiTfYf7YBkIxcncJCRYrdkwbxwh6KQlQYypRF1OyDgtVJQkzyXf5SuNTF1eOtKw==
X-Received: by 2002:a17:906:a012:: with SMTP id p18mr9609304ejy.331.1631281886249;
        Fri, 10 Sep 2021 06:51:26 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id w13sm2484683ejc.100.2021.09.10.06.51.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Sep 2021 06:51:25 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH 24/25] trace-cmd: Call additional APIs when creating trace file
Date:   Fri, 10 Sep 2021 16:51:00 +0300
Message-Id: <20210910135101.2865226-25-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210910135101.2865226-1-tz.stoyanov@gmail.com>
References: <20210910135101.2865226-1-tz.stoyanov@gmail.com>
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

