Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 03A09C433F5
	for <linux-trace-devel@archiver.kernel.org>; Fri,  8 Oct 2021 04:13:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DC5CC60F6E
	for <linux-trace-devel@archiver.kernel.org>; Fri,  8 Oct 2021 04:13:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237217AbhJHEPX (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 8 Oct 2021 00:15:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48294 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237160AbhJHEPW (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 8 Oct 2021 00:15:22 -0400
Received: from mail-ed1-x52b.google.com (mail-ed1-x52b.google.com [IPv6:2a00:1450:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E22A2C061570
        for <linux-trace-devel@vger.kernel.org>; Thu,  7 Oct 2021 21:13:27 -0700 (PDT)
Received: by mail-ed1-x52b.google.com with SMTP id y12so17935865eda.4
        for <linux-trace-devel@vger.kernel.org>; Thu, 07 Oct 2021 21:13:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=JmSHQOTfdOzRzctnytqTBAoaR6Vu2rTRbusrUGqCZYk=;
        b=plA5/3BRN0cat6nhlzdoHb19je0Icn6DM9/zlEX46yH/eKg6DAz8ZPbJTh5cvd69Uu
         +N/JVJjg87Nu8bxg8f4zt+tLEipaRXCYBEhbXKeD0YyTgqGTJVsQIXRtNvxFv6HE/VYW
         pcYgOBjrcZIJ8Vqjh6dz4F/uHnq7Io+IO9Pj2p2YGmfUNmCfFWbTlo4h5Gn+lh2lqiAO
         WEVRD+ru1+yS9+Ki0FVwZCQ2Ohab3ITxfGorrV9KEeP1z9FNjRFqyjOBPCFMIIZDTOG+
         2VMrH7wyc2+HsqOc0Rl37vJpC8fgEe0EBe5Y0y9Y2oZW1kQA6IutvK1xFMkt9YjlYu5L
         LYaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=JmSHQOTfdOzRzctnytqTBAoaR6Vu2rTRbusrUGqCZYk=;
        b=sNKLGGD4CYLoh4iMysJZGJC9zfkpNfuMZmzJwxkSyAD9XhW+Dcm/+hf2WslkOX3cb8
         7SfKeUglY1x32wyUAzeo3ZdblVdt5F0sbIMFbUq7UVf95SVAdA7kSJnFXwAjoFv5v7Cu
         4fv+ibOEAp9JNGGYnelFL+9dhvziXWx3QBesQenhOwNy37UTdaak/72GO3R1AGZKcbWm
         ZYxJ/beX6cHm/zvF4g4fLkFAkakCdwDC8B09n/KhXxZtmo6SHYWrcExtH/SHPU6TdKGP
         pI+QyH0CYPJ2WLe/a9Kldp5+4DbE3BC37uQmx49Kco/EIFzsI29wp5wHxOPs9o3HsQNH
         iZGQ==
X-Gm-Message-State: AOAM532tc3Sq6E0Pjy2Jum7+h06hMYstpqozrweaOaFGXkeU+N63p/RT
        GfiJH/y2t5tf8/v5GcOzuZ7JoBRVOd3t7w==
X-Google-Smtp-Source: ABdhPJz7/TAFwYOmiEb7ag3zGhmFDQWvLAy5Xm3UzQpBLkAl3mtfECcXbAytEQ2tB8txrUc7c/BUmw==
X-Received: by 2002:a50:cfc1:: with SMTP id i1mr11643528edk.251.1633666406565;
        Thu, 07 Oct 2021 21:13:26 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id lb12sm465740ejc.28.2021.10.07.21.13.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Oct 2021 21:13:25 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH 03/10] trace-cmd library: New API for setting a custom trace directory to an output handler
Date:   Fri,  8 Oct 2021 07:13:14 +0300
Message-Id: <20211008041321.973755-4-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211008041321.973755-1-tz.stoyanov@gmail.com>
References: <20211008041321.973755-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

The new API associates a custom tracing directory with an output file
handler. It is used when creating the trace file instead of the system
default tracing directory.
 tracecmd_output_set_trace_dir()

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 .../include/private/trace-cmd-private.h       |  1 +
 lib/trace-cmd/trace-output.c                  | 27 +++++++++++++++++++
 2 files changed, 28 insertions(+)

diff --git a/lib/trace-cmd/include/private/trace-cmd-private.h b/lib/trace-cmd/include/private/trace-cmd-private.h
index 2f34af13..ad9d5265 100644
--- a/lib/trace-cmd/include/private/trace-cmd-private.h
+++ b/lib/trace-cmd/include/private/trace-cmd-private.h
@@ -272,6 +272,7 @@ struct tracecmd_msg_handle;
 struct tracecmd_output *tracecmd_output_allocate(int fd);
 int tracecmd_output_set_msg(struct tracecmd_output *handler,
 			    struct tracecmd_msg_handle *msg_handle);
+int tracecmd_output_set_trace_dir(struct tracecmd_output *handler, const char *tracing_dir);
 struct tracecmd_output *tracecmd_create_file_latency(const char *output_file, int cpus);
 struct tracecmd_output *
 tracecmd_create_init_file_glob(const char *output_file,
diff --git a/lib/trace-cmd/trace-output.c b/lib/trace-cmd/trace-output.c
index d73c4f99..a5d7ed5f 100644
--- a/lib/trace-cmd/trace-output.c
+++ b/lib/trace-cmd/trace-output.c
@@ -941,6 +941,33 @@ int tracecmd_output_set_msg(struct tracecmd_output *handler, struct tracecmd_msg
 	return 0;
 }
 
+/**
+ * tracecmd_output_set_trace_dir - Set a custom tracing dir, instead of system default
+ * @handle: output handler to a trace file.
+ * @tracing_dir: full path to a directory with tracing files
+ *
+ * This API associates an output file handler with a custom tracing directory, to be used when
+ * creating the trace file instead of the system default tracing directory.
+ * This API must be called before tracecmd_output_write_init().
+ *
+ * Returns 0 on success, or -1 if the output file handler is not allocated or not in expected state.
+ */
+int tracecmd_output_set_trace_dir(struct tracecmd_output *handler, const char *tracing_dir)
+{
+	if (!handler || handler->file_state != TRACECMD_FILE_ALLOCATED)
+		return -1;
+
+	free(handler->tracing_dir);
+	if (tracing_dir) {
+		handler->tracing_dir = strdup(tracing_dir);
+		if (!handler->tracing_dir)
+			return -1;
+	} else
+		handler->tracing_dir = NULL;
+
+	return 0;
+}
+
 static int select_file_version(struct tracecmd_output *handle,
 				struct tracecmd_input *ihandle)
 {
-- 
2.31.1

