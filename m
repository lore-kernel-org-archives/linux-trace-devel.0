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
	by smtp.lore.kernel.org (Postfix) with ESMTP id A4BF3C4338F
	for <linux-trace-devel@archiver.kernel.org>; Wed, 28 Jul 2021 13:33:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 89DD660FED
	for <linux-trace-devel@archiver.kernel.org>; Wed, 28 Jul 2021 13:33:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236648AbhG1NdY (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 28 Jul 2021 09:33:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54142 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236626AbhG1NdY (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 28 Jul 2021 09:33:24 -0400
Received: from mail-ej1-x632.google.com (mail-ej1-x632.google.com [IPv6:2a00:1450:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 722C3C061764
        for <linux-trace-devel@vger.kernel.org>; Wed, 28 Jul 2021 06:33:22 -0700 (PDT)
Received: by mail-ej1-x632.google.com with SMTP id x11so3694794ejj.8
        for <linux-trace-devel@vger.kernel.org>; Wed, 28 Jul 2021 06:33:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=+xzGS4lMzgEZCd2cBF9hSNcgr/kC71xtcPquJSbbf3w=;
        b=Rk12p8X7voJi6L9GgD3JLqqaeCQZSiz6K3xok95JxvN0BSAzHyJhahB63gVUas/3p8
         kDliKFbNHOsGKJy1UXRHRQAGTHFhVGG+2GBUkjUxL4nb1v7OdNK36PEQAwoipWKpJcyh
         hv0xB0zA9/nbFSdRu4nxcKc/t++rV29J1V8KDH8r5lxcyZ9fF/NZJSrEr0zi3DTaaXCM
         pIv7BgDJyq2m6ZB4bykkAo5pWDw1RKjLtgO0F8e3XSkv9LhJ95+WuBZU2s7OxkeZFQok
         cGcI9VPWVkTn5xDQS6vNQzrpn8SOzf7y2wQycCV8FtDbf8e3f60baBF3nMQBlyTY7oyx
         lxQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=+xzGS4lMzgEZCd2cBF9hSNcgr/kC71xtcPquJSbbf3w=;
        b=O5P0i9yDMhJav54wki4IJSS/Xv4o6MijjdpXPpLf3qbPJMXrD4wJ9weS3pEYFUzNCn
         piNmZHQUbNrXiKp6N20YdjooUK/j1tKc0wW9Q/hAFeHO18eKDWuEejWwQd+IA8BWb04A
         pgp9Lt7alvk1muRwqi9voJbB5NIajJJbWCDlHwwKCcDq0rTnTaYHRrLjHU1NvirroYZg
         ohWlUl0MOvaEg5LmQp1vhup1yMiSTLStH55TL06wt9wwr43hrLZ8ftLeUrjpVnN1V1xd
         D5Io36q79kq6VDmJHSevp+XzKVu46OjxV72/YhRdmh/SmQtpSw96PWbxuo+KxtxMCGOo
         t5Jw==
X-Gm-Message-State: AOAM533GVrZXb1XBmzqtx7kA/NMkkmPflR93i7JcQ5s2YbL0FXuI3G8R
        JPNuQvG5juKQcN7I0dPCqeg=
X-Google-Smtp-Source: ABdhPJzZACHH7ycbVBhSQyzzkafVsnUxlOd1oZayB2jiPDbbxkXc8qtVLbOdREaTTkEwGsti1qvZYQ==
X-Received: by 2002:a17:906:2bd4:: with SMTP id n20mr27395869ejg.390.1627479201107;
        Wed, 28 Jul 2021 06:33:21 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id b25sm2700705edv.9.2021.07.28.06.33.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Jul 2021 06:33:20 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH 29/87] trace-cmd record: Append trace options after the trace data are written
Date:   Wed, 28 Jul 2021 16:31:52 +0300
Message-Id: <20210728133250.234140-30-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210728133250.234140-1-tz.stoyanov@gmail.com>
References: <20210728133250.234140-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

In trace file version 7, the CPU trace metadata is saved in a trace
option. As this metadata has file offsets, which depend on the CPU trace
data, the option must be written in the file after the CPU trace data.

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 tracecmd/trace-record.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/tracecmd/trace-record.c b/tracecmd/trace-record.c
index 350d2811..f8c1c090 100644
--- a/tracecmd/trace-record.c
+++ b/tracecmd/trace-record.c
@@ -4466,6 +4466,9 @@ static void write_guest_file(struct buffer_instance *instance)
 
 	if (tracecmd_write_cpu_data(handle, cpu_count, temp_files, "") < 0)
 		die("failed to write CPU data");
+	if (tracecmd_get_out_file_version(handle) >= 7)
+		tracecmd_write_options(handle);
+
 	tracecmd_output_close(handle);
 
 	for (i = 0; i < cpu_count; i++)
@@ -4623,7 +4626,8 @@ static void record_data(struct common_record_context *ctx)
 				append_buffer(handle, instance, temp_files);
 			}
 		}
-
+		if (tracecmd_get_out_file_version(handle) >= 7)
+			tracecmd_write_options(handle);
 		free(temp_files);
 	}
 	if (!handle)
-- 
2.31.1

