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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8A2CFC49361
	for <linux-trace-devel@archiver.kernel.org>; Mon, 14 Jun 2021 07:51:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6DA2F61289
	for <linux-trace-devel@archiver.kernel.org>; Mon, 14 Jun 2021 07:51:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232608AbhFNHyB (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 14 Jun 2021 03:54:01 -0400
Received: from mail-ej1-f49.google.com ([209.85.218.49]:36652 "EHLO
        mail-ej1-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232617AbhFNHx7 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 14 Jun 2021 03:53:59 -0400
Received: by mail-ej1-f49.google.com with SMTP id nd37so7326494ejc.3
        for <linux-trace-devel@vger.kernel.org>; Mon, 14 Jun 2021 00:51:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=qXFp8nHwN12Mahu0aozsJZDGSYor14IBt4n92eO2+hI=;
        b=p/hkdiRmaeWg0GHAkIrkkbmrVRGMVFl/y8doHKHIN6ftcuV5LHwIFHuKrqNtevKtRl
         KvMQfybTLFSS0hGaSMjPM1lNDCBGVhy18d0pp6lI7ocTT52IdXOXffQT4vbIjfNa+qJj
         GbIP3fEI0ti7ry36ypFURsTzS8qGpa23IQgb0yw+QN7xutdT8veOnAlbnFE3VHJlYTuT
         g0ZMuhue7ppD8k5f1miRnK6dUFJz3CGPj/Mku2EeTg7R2KifGuuemoiCeIjw7JgypBTV
         uDzoOYVdQyWMjEe2Y6keNvZvrgNimN29RhMpLiHqGv1+YOx4Xyc+ozTE0/gxQPo8c6Dp
         I00g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=qXFp8nHwN12Mahu0aozsJZDGSYor14IBt4n92eO2+hI=;
        b=XyoEWQQ7ZQjmja0P7WBQW0zXevpPi05g58QCo995n23oKHm4BeYO3y0k/Ed/todfQ9
         Jf73Bp5h9DRLnz+0HDx3/AN+fepH0Nqbe+3RS6Ln9ic3FrjuFgQZ1AujEiFc/gQvok+X
         4KcuqiuO0VB9bxjidN5VdLLAhNTB+eCkPwIV+vPnTNni1306A+bpGEgMWaLv/KUvC3Lv
         2VNCseaLOn0LfZV6BGbTsqpaKygHlnlrOvPfJxeK5FwIRE9ihIWHpk9rdIAo/JdLiU+H
         XFIRyuzne+zHm+xtRvqUBKAaGWIzmVTkgNMNBK4DYjFaSK89ZeQYAX8UBNej7JLn1D+/
         JlMg==
X-Gm-Message-State: AOAM532HHe6+yQYiz8K+zM8BSH4I/q+9Nh69YrBiA0OPqftURMhUsEUO
        1FHCVlk2KsPl5PsMsphf3pw=
X-Google-Smtp-Source: ABdhPJzxPxaGXfSxtrPGVFBHdHjvBS+U35HSVYzQeLh3TQiSLCGyPbNzVt46FrjM+FrvGCB2NWRJhg==
X-Received: by 2002:a17:906:b2d1:: with SMTP id cf17mr14409672ejb.225.1623657056896;
        Mon, 14 Jun 2021 00:50:56 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id f6sm6536444eja.108.2021.06.14.00.50.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Jun 2021 00:50:56 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v6 26/45] trace-cmd library: Compress latency trace data
Date:   Mon, 14 Jun 2021 10:50:10 +0300
Message-Id: <20210614075029.598048-27-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210614075029.598048-1-tz.stoyanov@gmail.com>
References: <20210614075029.598048-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

When creating latency trace file of version 7, compress the latency
trace data.

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 lib/trace-cmd/trace-output.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/lib/trace-cmd/trace-output.c b/lib/trace-cmd/trace-output.c
index 20a646af..017b3d7d 100644
--- a/lib/trace-cmd/trace-output.c
+++ b/lib/trace-cmd/trace-output.c
@@ -1661,7 +1661,7 @@ struct tracecmd_output *tracecmd_create_file_latency(const char *output_file, in
 	if (!path)
 		goto out_free;
 
-	copy_file(handle, path);
+	copy_file_compress(handle, path, NULL);
 
 	put_tracing_file(path);
 
-- 
2.31.1

