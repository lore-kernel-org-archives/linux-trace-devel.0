Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 342C2C433FE
	for <linux-trace-devel@archiver.kernel.org>; Thu, 11 Nov 2021 15:03:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1B4A16152A
	for <linux-trace-devel@archiver.kernel.org>; Thu, 11 Nov 2021 15:03:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233828AbhKKPGR (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 11 Nov 2021 10:06:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36014 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233847AbhKKPGP (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 11 Nov 2021 10:06:15 -0500
Received: from mail-ed1-x52d.google.com (mail-ed1-x52d.google.com [IPv6:2a00:1450:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9CF44C061767
        for <linux-trace-devel@vger.kernel.org>; Thu, 11 Nov 2021 07:03:26 -0800 (PST)
Received: by mail-ed1-x52d.google.com with SMTP id v11so25370906edc.9
        for <linux-trace-devel@vger.kernel.org>; Thu, 11 Nov 2021 07:03:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=7c7gV8CFoiWVKIvqBxrEnbh/EH4bh0MmnyVB/FyIe80=;
        b=fgsQn9/kCDSfyowMAGcFeAatMKaKJKcI2aEh/zXSCeXEzzC/FlSRLr0kNI4+FvhXPs
         6dcIOMAOGaS7nELpiXNPIqGsSIvB6ah1sCPZQGTj+7hBIqzORJ3MdQWNzv9c6gY1dJpw
         NrWScuMfNR09BJ5MGAyuuZhfDgOd14QP1X5+Ocd31Sxi9bZkJP58CV1rTRvHekJuU9PU
         Qmq/ylRC0rj76hYjFw4w1YURnrgN3FKB1BONXtdt673dSmFe5m4daTYohJ/VDFU37s6F
         yarm1IX/jEOehJJnvZjVNlyfrryTuR3hyYLbBEa4WpKdd6Q8ruBKmGU1aqGxpy3b4h6x
         dmzw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=7c7gV8CFoiWVKIvqBxrEnbh/EH4bh0MmnyVB/FyIe80=;
        b=F9dP468tGHUNAwnLZgFb+j8CDyA0MUdiYNcedAeA/24c5mpANS84XeHtjxH1bDwLB0
         TfN/blBfB7L6Fqqlkz01yBeoRSjnSsrtchsqXnHAyalql3dHbOKijUcky1E8cC6J1MHb
         Rbt+LZT1TOT7UyWW2UcJGIpVxFkZdjw6oWtil5lDQjz7HtcPEhBWx+Rey3PAUkqmT3UD
         uPJXbLP3Dhob/6uppqbWGqUHthxnq2q4JC6hbUKBHb1DBS8tlkrosAD7KCOyEra7PpLI
         Jh4kTWQUl5sK59LQleLmsXrl95AEiD3Kp0VkQGgZbU6/W+7QvkWA+7/jp6WV2MqwImbd
         iwDA==
X-Gm-Message-State: AOAM530wRmauhSkG3geDshatbjpNVelsYYaaMYV8HOTFRkXzxEQhDQs/
        2V6ONUf3AHaEPvJyTUflYAs=
X-Google-Smtp-Source: ABdhPJzDAreQyeaFxZN6bUTcfDZpBU3e8mMAMZWmoixzl4DxbG9VgEuBYxfWEVeumSf2pru+k6pABQ==
X-Received: by 2002:a17:907:948a:: with SMTP id dm10mr9982243ejc.455.1636643004960;
        Thu, 11 Nov 2021 07:03:24 -0800 (PST)
Received: from oberon.zico.biz.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id d13sm1656128edv.29.2021.11.11.07.03.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 Nov 2021 07:03:24 -0800 (PST)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v2 02/10] trace-cmd library: New API for setting a message context to an output handler
Date:   Thu, 11 Nov 2021 17:03:13 +0200
Message-Id: <20211111150321.85979-3-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211111150321.85979-1-tz.stoyanov@gmail.com>
References: <20211111150321.85979-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

The new API associates previously created handler to message context
with given output handler. The message context is used by the output
handler to send data over a network, instead writing to a local file.
 tracecmd_output_allocate()

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 .../include/private/trace-cmd-private.h       |  2 ++
 lib/trace-cmd/trace-output.c                  | 22 +++++++++++++++++++
 2 files changed, 24 insertions(+)

diff --git a/lib/trace-cmd/include/private/trace-cmd-private.h b/lib/trace-cmd/include/private/trace-cmd-private.h
index bed96657..49c8c138 100644
--- a/lib/trace-cmd/include/private/trace-cmd-private.h
+++ b/lib/trace-cmd/include/private/trace-cmd-private.h
@@ -270,6 +270,8 @@ struct tracecmd_option;
 struct tracecmd_msg_handle;
 
 struct tracecmd_output *tracecmd_output_allocate(int fd);
+int tracecmd_output_set_msg(struct tracecmd_output *handler,
+			    struct tracecmd_msg_handle *msg_handle);
 struct tracecmd_output *tracecmd_create_file_latency(const char *output_file, int cpus);
 struct tracecmd_output *
 tracecmd_create_init_file_glob(const char *output_file,
diff --git a/lib/trace-cmd/trace-output.c b/lib/trace-cmd/trace-output.c
index 3878b963..d73c4f99 100644
--- a/lib/trace-cmd/trace-output.c
+++ b/lib/trace-cmd/trace-output.c
@@ -918,6 +918,28 @@ struct tracecmd_output *tracecmd_output_allocate(int fd)
 	return handle;
 }
 
+/**
+ * tracecmd_output_set_msg - associated an output file handler with network message handler
+ * @handle: output handler to a trace file.
+ * @msg_handle: network handler, allocated by tracecmd_msg_handle_alloc()
+ *
+ * This API associates an output file handler with a network stream. All subsequent API calls
+ * with this output file handler will send data over the network using the @msg_handle, instead
+ * of writing to a file.
+ * This API must be called after the handler file version is set and before
+ * tracecmd_output_write_init().
+ *
+ * Returns 0 on success, or -1 if the output file handler is not allocated or not in expected state.
+ */
+int tracecmd_output_set_msg(struct tracecmd_output *handler, struct tracecmd_msg_handle *msg_handle)
+{
+	if (!handler || handler->file_state != TRACECMD_FILE_ALLOCATED)
+		return -1;
+
+	handler->msg_handle = msg_handle;
+
+	return 0;
+}
 
 static int select_file_version(struct tracecmd_output *handle,
 				struct tracecmd_input *ihandle)
-- 
2.33.1

