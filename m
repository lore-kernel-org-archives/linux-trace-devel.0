Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-20.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4F4EBC433E0
	for <linux-trace-devel@archiver.kernel.org>; Mon,  8 Feb 2021 06:18:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 132ED64E6E
	for <linux-trace-devel@archiver.kernel.org>; Mon,  8 Feb 2021 06:18:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229581AbhBHGSa (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 8 Feb 2021 01:18:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50120 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229669AbhBHGSa (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 8 Feb 2021 01:18:30 -0500
Received: from mail-ed1-x52c.google.com (mail-ed1-x52c.google.com [IPv6:2a00:1450:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 941A5C061788
        for <linux-trace-devel@vger.kernel.org>; Sun,  7 Feb 2021 22:17:49 -0800 (PST)
Received: by mail-ed1-x52c.google.com with SMTP id q2so16774691edi.4
        for <linux-trace-devel@vger.kernel.org>; Sun, 07 Feb 2021 22:17:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=+Mf+IfNt6WZXwCUi1S4JcV+ZjD0Hww96HTqPp5lhJPQ=;
        b=miqS+sVyZRhYT7Hs6qxqrXWlZRcizlUCALXbRcMVfL2veY2w66VGCvlUFBrou5pvgi
         iZAfvL6+v2f3+0gjq064g3hF1cRHzfIKxz7/2uMvyLvwJFcQsvoaOcpVF/mKyQzxuLZX
         +0F8kQ2dx0iLdxOwPnjBHATGQl9JDx1LtsyTIoklQLU/zAwnd5ryEtHTkULdVc6qpRqk
         7lyBgtlqXJidl9S+S3Fj4ClKa+gijtMyZEetOvX5fTopnd/dUPmaBDQAoPCkkDvyL/EQ
         Ny+DkR6rX9WYTAVj+ZmzUUWwoeZgUPncTmt2aEckTRt8TV4mAbMBtNugTQJ/zZCErg2z
         /gzQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=+Mf+IfNt6WZXwCUi1S4JcV+ZjD0Hww96HTqPp5lhJPQ=;
        b=MQ4zkukW10GnZCpF7Oi65V9jufQsh+N6fIxqbeYIvpw5AEdQvOTL5/ZDr6TNTUvYIp
         dXeBMJ9yaWuI52gomq255Z6lIkOeMQmUDVWoN3sPlOu5EBMfBAfo6lOPECKWBJZyPpt/
         ClXhXmPa7zuBPcFAmfZsG5t3g5nTNPf8MQ196D7BsQrdmN1UXaauCd8K0j8FpJLYs4Ip
         T0OzLKsUGW98nWifeqlD9L1WSZE9olZZkB1rK48lp/gG8phB3FHnMDVdF9F0KW2mdsDL
         4nKUtEydrWOfHWyrQWrbQ50p4/PnyDJzdHPPqKGG1zpsDgymS1GMJruktv+mX9ThTvDz
         Z2Rg==
X-Gm-Message-State: AOAM531u0AujBsXwF4itZdS6z4SNHxeNJ/gIkeWI7uQzw5XgeB1VI1GJ
        5Cipu6tU2N4n/DuBz+Cn53jqlEEKOyhCQg==
X-Google-Smtp-Source: ABdhPJzzHdyF5HOoOSfqhwOLVXNxBRdDgsfB9AiTFXJUCoIYyByjGOP9WKPeBt3HYukoWfAfEShAug==
X-Received: by 2002:a05:6402:1589:: with SMTP id c9mr16063816edv.282.1612765068333;
        Sun, 07 Feb 2021 22:17:48 -0800 (PST)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id 35sm135618edp.85.2021.02.07.22.17.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 07 Feb 2021 22:17:47 -0800 (PST)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v28 1/8] trace-cmd: Save command lines in VM agent
Date:   Mon,  8 Feb 2021 08:17:36 +0200
Message-Id: <20210208061743.510964-2-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210208061743.510964-1-tz.stoyanov@gmail.com>
References: <20210208061743.510964-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Command lines were not saved in the guest tracing file, due to bug
inrtoduced by commit:
https://git.kernel.org/pub/scm/utils/trace-cmd/trace-cmd.git/commit/?id=1eea02a4bef10507d157489a1ee97f273db7b319

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 lib/trace-cmd/include/private/trace-cmd-private.h | 3 +++
 lib/trace-cmd/trace-output.c                      | 4 ++--
 tracecmd/trace-record.c                           | 1 +
 3 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/lib/trace-cmd/include/private/trace-cmd-private.h b/lib/trace-cmd/include/private/trace-cmd-private.h
index a08566e6..d370fa8b 100644
--- a/lib/trace-cmd/include/private/trace-cmd-private.h
+++ b/lib/trace-cmd/include/private/trace-cmd-private.h
@@ -503,4 +503,7 @@ void *tracecmd_record_page(struct tracecmd_input *handle,
 void *tracecmd_record_offset(struct tracecmd_input *handle,
 			     struct tep_record *record);
 
+int save_tracing_file_data(struct tracecmd_output *handle,
+			   const char *filename);
+
 #endif /* _TRACE_CMD_PRIVATE_H */
diff --git a/lib/trace-cmd/trace-output.c b/lib/trace-cmd/trace-output.c
index 032c8ff4..4ffb4d47 100644
--- a/lib/trace-cmd/trace-output.c
+++ b/lib/trace-cmd/trace-output.c
@@ -797,8 +797,8 @@ static int read_ftrace_printk(struct tracecmd_output *handle)
 	return -1;
 }
 
-static int save_tracing_file_data(struct tracecmd_output *handle,
-						const char *filename)
+int save_tracing_file_data(struct tracecmd_output *handle,
+			   const char *filename)
 {
 	unsigned long long endian8;
 	char *file = NULL;
diff --git a/tracecmd/trace-record.c b/tracecmd/trace-record.c
index a1c4e919..a0a0b8b5 100644
--- a/tracecmd/trace-record.c
+++ b/tracecmd/trace-record.c
@@ -3770,6 +3770,7 @@ static void setup_agent(struct buffer_instance *instance,
 	network_handle = tracecmd_create_init_fd_msg(instance->msg_handle,
 						     listed_events);
 	add_options(network_handle, ctx);
+	save_tracing_file_data(network_handle, "saved_cmdlines");
 	tracecmd_write_cpus(network_handle, instance->cpu_count);
 	tracecmd_write_options(network_handle);
 	tracecmd_msg_finish_sending_data(instance->msg_handle);
-- 
2.29.2

