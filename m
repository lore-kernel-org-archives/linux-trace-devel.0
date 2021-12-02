Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 727F3C433F5
	for <linux-trace-devel@archiver.kernel.org>; Thu,  2 Dec 2021 12:19:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357775AbhLBMXT (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 2 Dec 2021 07:23:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35200 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357784AbhLBMXS (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 2 Dec 2021 07:23:18 -0500
Received: from mail-ed1-x529.google.com (mail-ed1-x529.google.com [IPv6:2a00:1450:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA58EC06174A
        for <linux-trace-devel@vger.kernel.org>; Thu,  2 Dec 2021 04:19:55 -0800 (PST)
Received: by mail-ed1-x529.google.com with SMTP id z5so50215420edd.3
        for <linux-trace-devel@vger.kernel.org>; Thu, 02 Dec 2021 04:19:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=/tn2tYsFpEqDRifAEmJSAMR66AAJ1kM4Zd2AiiEOzf4=;
        b=omrGOnszSN/DCipPJI1maaop9jH7KBDwicWx4ZcuY3RYkI/jxFeViwmluFz3uBwrfW
         JRAfe0nR9VPa4ju1shNBJs6v79yvdXoULp/RSou4tIodxY0L1VzTIJ0qG99juDZ35fm2
         vQw4xB8D5uMmmEojIUGfIdafk20C6lKQ0muqvwr+5sevVoaTQQ7ZpmbOpdpkNfHVcVuJ
         HW2s6PGgocI3bMUSYXY8iN+v4zZTKm3xodU+xKwOpWfbJUzP4cMDosQdZYeNURLzBVNn
         GbvpXdLLt3w0Q0AXHSnIBLZ2BOYk3lzV+dPRYizAzIPSLrCeCSEQfJQWqE9lr+qFst+k
         BPNQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=/tn2tYsFpEqDRifAEmJSAMR66AAJ1kM4Zd2AiiEOzf4=;
        b=AmfdiB1uZu1Lpjg7KGZDlJqST636Mz4e/eVGz27Oq8efSC3KaBDqV5v68SLhz3pNww
         N6a+RIQdpSUpuoLoeAQJ2QC17lefhXfahAjIbQ/OzOGd1hwsOYC6mk8+VCtSpQA/PHwp
         BFF7UDvDr3AAyYQB6c7Jcv27A+90j5H+Z1AzL/FRhBgwgC4FDKilVoZwi/nB5R8OlVBV
         ZtbLPwnx3o0QAhDoevC727FTf6m97xT7LZDo1wAmUBQQ6cs8TZObuCXoHRW7b00WZUGm
         gh5WvObpUkQgCyLAvEh3L2LTiezfEBAPYg3vvP0UVdfI1DKKQKIV7ZP4qEkg2VJGPk0J
         6Njw==
X-Gm-Message-State: AOAM5322R9odAdByWeu9uAHWbHlxE46hoJL6nlYHiGTTPVR5AHPNWibV
        vQMI/QRHa5YVziHqLGf+FkhYdDG3KYEVfg==
X-Google-Smtp-Source: ABdhPJwoYJV6YKvkrbWzk4Kb+tpZaLwnvQbgsHkmUZw0tZh28Yys1KpMgQTyDIehezxs/8Jg36SRqg==
X-Received: by 2002:a50:f189:: with SMTP id x9mr17443087edl.95.1638447594427;
        Thu, 02 Dec 2021 04:19:54 -0800 (PST)
Received: from oberon.zico.biz.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id y15sm2229019eda.13.2021.12.02.04.19.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Dec 2021 04:19:53 -0800 (PST)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH 3/5] trace-cmd library: Rename tracecmd_output_allocate()
Date:   Thu,  2 Dec 2021 14:19:47 +0200
Message-Id: <20211202121949.43084-4-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211202121949.43084-1-tz.stoyanov@gmail.com>
References: <20211202121949.43084-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

The existing tracecmd_output_allocate() API is renamed to
tracecmd_output_create_fd(), to be consistent with
tracecmd_output_create() API.

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 lib/trace-cmd/include/private/trace-cmd-private.h | 2 +-
 lib/trace-cmd/trace-output.c                      | 8 ++++----
 tracecmd/trace-record.c                           | 2 +-
 3 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/lib/trace-cmd/include/private/trace-cmd-private.h b/lib/trace-cmd/include/private/trace-cmd-private.h
index 80027c9e..79196147 100644
--- a/lib/trace-cmd/include/private/trace-cmd-private.h
+++ b/lib/trace-cmd/include/private/trace-cmd-private.h
@@ -269,7 +269,6 @@ struct tracecmd_event_list {
 struct tracecmd_option;
 struct tracecmd_msg_handle;
 
-struct tracecmd_output *tracecmd_output_allocate(int fd);
 int tracecmd_output_set_msg(struct tracecmd_output *handle,
 			    struct tracecmd_msg_handle *msg_handle);
 int tracecmd_output_set_trace_dir(struct tracecmd_output *handle, const char *tracing_dir);
@@ -280,6 +279,7 @@ int tracecmd_output_write_headers(struct tracecmd_output *handle,
 				  struct tracecmd_event_list *list);
 
 struct tracecmd_output *tracecmd_output_create(const char *output_file);
+struct tracecmd_output *tracecmd_output_create_fd(int fd);
 struct tracecmd_output *tracecmd_create_file_latency(const char *output_file, int cpus);
 struct tracecmd_output *tracecmd_create_init_fd(int fd);
 
diff --git a/lib/trace-cmd/trace-output.c b/lib/trace-cmd/trace-output.c
index 2f8ebf25..067deae8 100644
--- a/lib/trace-cmd/trace-output.c
+++ b/lib/trace-cmd/trace-output.c
@@ -898,7 +898,7 @@ out_free:
 }
 
 /**
- * tracecmd_output_allocate - allocate new output handle to a trace file
+ * tracecmd_output_create_fd - allocate new output handle to a trace file
  * @fd: File descriptor for the handle to write to.
  *
  * Allocate a tracecmd_output descriptor and perform minimal initialization.
@@ -909,7 +909,7 @@ out_free:
  * a tracecmd data file. In case of an error, NULL is returned. The returned
  * handle must be freed with tracecmd_output_close() or tracecmd_output_free()
  */
-struct tracecmd_output *tracecmd_output_allocate(int fd)
+struct tracecmd_output *tracecmd_output_create_fd(int fd)
 {
 	struct tracecmd_output *handle;
 
@@ -1819,7 +1819,7 @@ struct tracecmd_output *tracecmd_output_create(const char *output_file)
 		if (fd < 0)
 			return NULL;
 	}
-	out = tracecmd_output_allocate(fd);
+	out = tracecmd_output_create_fd(fd);
 	if (!out && fd >= 0) {
 		close(fd);
 		unlink(output_file);
@@ -1832,7 +1832,7 @@ struct tracecmd_output *tracecmd_create_init_fd(int fd)
 {
 	struct tracecmd_output *out;
 
-	out = tracecmd_output_allocate(fd);
+	out = tracecmd_output_create_fd(fd);
 	if (!out)
 		return NULL;
 	if (tracecmd_output_write_init(out))
diff --git a/tracecmd/trace-record.c b/tracecmd/trace-record.c
index 677a4bd9..b4200db1 100644
--- a/tracecmd/trace-record.c
+++ b/tracecmd/trace-record.c
@@ -3737,7 +3737,7 @@ setup_connection(struct buffer_instance *instance, struct common_record_context
 		if (ret)
 			goto error;
 	} else {
-		network_handle = tracecmd_output_allocate(msg_handle->fd);
+		network_handle = tracecmd_output_create_fd(msg_handle->fd);
 		if (!network_handle)
 			goto error;
 		if (tracecmd_output_write_headers(network_handle, listed_events))
-- 
2.33.1

