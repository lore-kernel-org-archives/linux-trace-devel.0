Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 74469C433F5
	for <linux-trace-devel@archiver.kernel.org>; Fri,  8 Oct 2021 04:20:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5D57860F6E
	for <linux-trace-devel@archiver.kernel.org>; Fri,  8 Oct 2021 04:20:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237703AbhJHEWX (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 8 Oct 2021 00:22:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49900 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237621AbhJHEWW (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 8 Oct 2021 00:22:22 -0400
Received: from mail-ed1-x52c.google.com (mail-ed1-x52c.google.com [IPv6:2a00:1450:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E39C5C061570
        for <linux-trace-devel@vger.kernel.org>; Thu,  7 Oct 2021 21:20:26 -0700 (PDT)
Received: by mail-ed1-x52c.google.com with SMTP id a25so15466185edx.8
        for <linux-trace-devel@vger.kernel.org>; Thu, 07 Oct 2021 21:20:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=uB3Qsk23VlWa2/eiAtFtCxFmLJ7APCYNqPxtkENhLP4=;
        b=h6vyYVMilN/OH5WoS4YLwgBMlC6qZKC/y+/zB3FOXnx9XQbMHOBcQb9d0ZOW1OU12F
         +LbapxoK1LB2kK+GKRYj9Bx/AT9RvgRlcOjn3ydK/8qav8RYusL0AdXpobT6UnlPAjEe
         pwUGdWcyBe1isCIjvynLp0C2zHxpM7UTq65MbN5qZe2u9v8F8B+5qY3xcBVuxldOBMf6
         r8gohwesiGv8QXS2AMtF9xi6LeV9rUWab+PA3swNIMFs+MI5Bscb9N8ocwBp6jOA3DKq
         xE7sXFO5vO820EhLlnE7UJqFSoN9lR0UdPVQiRI7E1XhVbu6a3UjfXgBEl01pHD0XyFG
         skBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=uB3Qsk23VlWa2/eiAtFtCxFmLJ7APCYNqPxtkENhLP4=;
        b=hgJ8ro/yQhIspCtkPH+Hvco6ed4eBfwNvcDZyHOzjQ7FCSARQ2+I5yJTjBNP5Vr8rq
         fhxlBVsEPYh/Bl0B2v/GyOV68BRtAckuCNoF4h0nfDhe/NH2ip05YryALOQpuVO2wO6H
         9sCwdyfQwE7reexlHkqwmUF7U8oM6KGqDQ5xHkm88kQ39AGq7QN1bPEQWmx2UWR5xAcz
         s0pVhBUvA8LQTSDCef7B1vWZLA0oVFiLqPdghCjBV1U8s4ud7xde+GolbqxbNspndBpf
         h2PviDkejOUoUYpi/UX7bZ8LDN//GKUkYFwjt3/9VZYGzRlgypKF59iOoT8nVUeZbq69
         L3tQ==
X-Gm-Message-State: AOAM531rZE/MdXysFjCkOq2VHhJocKQwYijfzX64DM8V3IUb40ZOOZw0
        7+5Wg9sdJlHNW3PJmRU9or1tSSDEdwuaWw==
X-Google-Smtp-Source: ABdhPJxajdN7+HIJEyPcnLmJ/Ai/Z/1iLG4PIvL+QKJZ46G6yYGZaiT/wdgcV10AntpWXY1wslaoJg==
X-Received: by 2002:a05:6402:493:: with SMTP id k19mr11880366edv.386.1633666825513;
        Thu, 07 Oct 2021 21:20:25 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id p6sm511669edi.18.2021.10.07.21.20.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Oct 2021 21:20:25 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v4 24/25] trace-cmd: Call additional APIs when creating trace file
Date:   Fri,  8 Oct 2021 07:19:57 +0300
Message-Id: <20211008041958.976309-25-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211008041958.976309-1-tz.stoyanov@gmail.com>
References: <20211008041958.976309-1-tz.stoyanov@gmail.com>
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
index 45ba1211..28be6e7b 100644
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
 	ret = tracecmd_write_cpu_data(handle, cpus, temp_files, NULL);
 
+	if (!ret && tracecmd_get_out_file_version(handle) >= FILE_VERSION_SECTIONS)
+		tracecmd_write_options(handle);
+
 out:
 	tracecmd_output_close(handle);
 	for (cpu--; cpu >= 0; cpu--) {
diff --git a/tracecmd/trace-record.c b/tracecmd/trace-record.c
index 0b1dc508..338a6a8a 100644
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

