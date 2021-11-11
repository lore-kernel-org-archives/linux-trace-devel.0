Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 801DDC433F5
	for <linux-trace-devel@archiver.kernel.org>; Thu, 11 Nov 2021 15:09:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 68D796135E
	for <linux-trace-devel@archiver.kernel.org>; Thu, 11 Nov 2021 15:09:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233928AbhKKPM0 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 11 Nov 2021 10:12:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37450 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233899AbhKKPM0 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 11 Nov 2021 10:12:26 -0500
Received: from mail-ed1-x52b.google.com (mail-ed1-x52b.google.com [IPv6:2a00:1450:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CBE77C061766
        for <linux-trace-devel@vger.kernel.org>; Thu, 11 Nov 2021 07:09:36 -0800 (PST)
Received: by mail-ed1-x52b.google.com with SMTP id v11so25448474edc.9
        for <linux-trace-devel@vger.kernel.org>; Thu, 11 Nov 2021 07:09:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=TdhLGISiojXTI4BDqsvCg6kF4bBHfTBPwhzqSux3QuQ=;
        b=misq5FsH48CuWTX4aK13aBQTkSIWNWkqLNm6REUVIMbjR/5eg1SNsQlgkMXzDd+sHb
         kaObP4SXpuYQnty9Q5F9WxLA8ASr4SBFQ4vlNwxkz/g7gh9ryp/KTtuczK2UHekP/s9v
         IKnVUWR+X4ldEX3f8jgK4tggN5FtnBdx1932gt0idPn4NshjrtWhLbENBpiM9r03fOir
         RKxeBI02uOBXcb125HLDqqdQLmWSuu2SMYyKSBmB5nu9bA78ALMVy/6EwEe+33AtZWY9
         YEnJmO2L4a4Zz6JF+qrq64jy2ISXWsBxoZ0cLYu3G93WDyoLaGVROpnlviieWN1bwMA7
         Yk3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=TdhLGISiojXTI4BDqsvCg6kF4bBHfTBPwhzqSux3QuQ=;
        b=BNKHdJwBSGZC0H0FBz13paqNQp4a1rVDMjdq4IXK+ciQVXBFW3xVcP6pqhyJpN0+cJ
         QycGOIfeOkBYu4K61mSU5g09R5tcnw9+E2E231JEXWLnUcbR9PdO0tBjVT39ehe1mpoq
         pdiGFTSwU9zZU7PV1LFmSW73pyAQGGYfAr/0r+PNHozcnCAoKSVyPsdXWP57AlXZM1KS
         HuyowaBj14y5ABWUjO4HFK7saAaAqeFfa4zFoaSZm8xRu/xrdAUcQPwBGAl41vK8HDbL
         GXRgWYmqd1UzRu/EeKLcZdYowo32a6xmmNi66Lg4XSJezkkDJGag+2MPH+LFjwe3y5bc
         PLcQ==
X-Gm-Message-State: AOAM5303p2JLImgM5hon88P4NoWa/i9aSnrmzgeLRRJ0l4uiJqsRk1vr
        jHSrbOmYSIm7Mr8Z59cYqTJLEheKRsZmuQ==
X-Google-Smtp-Source: ABdhPJxTrnZM/9w0qxHC/k/Ga3I67y5GNAWvXR9Bo/1NJAtGHZxelPtV8fTpETqit543dSukY+a+Rw==
X-Received: by 2002:aa7:da55:: with SMTP id w21mr10546850eds.159.1636643375156;
        Thu, 11 Nov 2021 07:09:35 -0800 (PST)
Received: from oberon.zico.biz.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id q14sm1739059edj.42.2021.11.11.07.09.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 Nov 2021 07:09:34 -0800 (PST)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v5 09/25] trace-cmd record: Append trace options after the trace data are written
Date:   Thu, 11 Nov 2021 17:09:33 +0200
Message-Id: <20211111150933.86678-1-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.33.1
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
index 757dab0f..32270e20 100644
--- a/tracecmd/trace-record.c
+++ b/tracecmd/trace-record.c
@@ -4449,6 +4449,9 @@ static void write_guest_file(struct buffer_instance *instance)
 
 	if (tracecmd_write_cpu_data(handle, cpu_count, temp_files, NULL) < 0)
 		die("failed to write CPU data");
+	if (tracecmd_get_out_file_version(handle) >= FILE_VERSION_SECTIONS)
+		tracecmd_write_options(handle);
+
 	tracecmd_output_close(handle);
 
 	for (i = 0; i < cpu_count; i++)
@@ -4597,7 +4600,8 @@ static void record_data(struct common_record_context *ctx)
 				append_buffer(handle, instance, temp_files);
 			}
 		}
-
+		if (tracecmd_get_out_file_version(handle) >= FILE_VERSION_SECTIONS)
+			tracecmd_write_options(handle);
 		free(temp_files);
 	}
 	if (!handle)
-- 
2.33.1

