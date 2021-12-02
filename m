Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6F762C433FE
	for <linux-trace-devel@archiver.kernel.org>; Thu,  2 Dec 2021 12:22:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357953AbhLBMZe (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 2 Dec 2021 07:25:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35688 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357905AbhLBMZZ (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 2 Dec 2021 07:25:25 -0500
Received: from mail-ed1-x535.google.com (mail-ed1-x535.google.com [IPv6:2a00:1450:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF98DC0613DD
        for <linux-trace-devel@vger.kernel.org>; Thu,  2 Dec 2021 04:22:02 -0800 (PST)
Received: by mail-ed1-x535.google.com with SMTP id y13so115180044edd.13
        for <linux-trace-devel@vger.kernel.org>; Thu, 02 Dec 2021 04:22:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=k0xW0KyvIP7c95JW3AbcA29V/UnwLtVKzel20KKhsvg=;
        b=AVVJrFi4JAfjwpRTihO6zy2ja55/JuLq7QHwPlC/hBGSRrtPNV3HhwCKl4O8bQueYe
         i+OXy38y3mgdeZAODDpsyM14SgpHCJVnqN0hdJlQqEpdu8s+dL49wMtO0uydEFm8T3b0
         /IF69F5YTCVPWNzEXZEpcQCOHz+7d+Qeeq/I1GZbgmBXSKvVKykt0PjvFDjJk0Evk2XZ
         C6gRjZVOQMMp2UWs7QUL2ETzK2uT/KHT2ByVIZIBtJvkk+CntDmRE3hF8J63gdgpbReG
         C75K/8FLS2ZVU8lTXKYA5NVOAcQYInObfoo/KIgv51S3Mey5DLv3MU+/6E4Kse2MSzhQ
         i6xQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=k0xW0KyvIP7c95JW3AbcA29V/UnwLtVKzel20KKhsvg=;
        b=mnyHkf1rx7TRRL5vxt0Bxl7EiRdi0c9QROCwjOkWIwNp926Ghl2kfYT8rS66ltc+78
         PZw8h2enh/b/g6obp6ApwB7IHfSL8gU2S3+N2sYHga219ajeRy48i/Vm+JIYIN0DVJGc
         s1XbjgNk2VMwldIpjkSS2vCE6ZpIZ+Z3/CCMOScEJBu4iq06cDim3CPZ84aw/agYWZW8
         Surk5XXOrgVhr/PTAW8xUeWTwY9Ks0bFPZk/euLeITVXUVfJIDDIFejvrdEBO5AQCWdO
         MR094rRuHVkmyL1UJPIuodSjQF3g2dvYlNjjjT+dRLoYkTrPjwX9xE2V3iQJP5bhfZqL
         0+FQ==
X-Gm-Message-State: AOAM533R40A6OptorU6D3/+CMdkA506w4VLZn0T2qBEbfpltUDc60jxn
        ckJDa0qAfNZRZR4+N5GkpoXF2omioXg0Zg==
X-Google-Smtp-Source: ABdhPJx/NWg2eiyvt4VvzR5pjgz3ltZ3WujWgq1qu5IO5yz+nufv3ZrflggMi0/fYro4Cv7GshwnmQ==
X-Received: by 2002:aa7:d997:: with SMTP id u23mr18017700eds.164.1638447721359;
        Thu, 02 Dec 2021 04:22:01 -0800 (PST)
Received: from oberon.zico.biz.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id gb42sm1892772ejc.49.2021.12.02.04.22.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Dec 2021 04:22:00 -0800 (PST)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v6 07/23] trace-cmd library: Do not write CPU count section in trace files version 7
Date:   Thu,  2 Dec 2021 14:21:36 +0200
Message-Id: <20211202122152.43275-8-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211202122152.43275-1-tz.stoyanov@gmail.com>
References: <20211202122152.43275-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Writing CPU count as a separate section in the trace file is redundant,
as there is already an option for that. Use that option in trace files
version 7.

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 lib/trace-cmd/trace-output.c | 14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

diff --git a/lib/trace-cmd/trace-output.c b/lib/trace-cmd/trace-output.c
index 40d5fe9c..caa3e2f5 100644
--- a/lib/trace-cmd/trace-output.c
+++ b/lib/trace-cmd/trace-output.c
@@ -1408,10 +1408,16 @@ int tracecmd_write_cpus(struct tracecmd_output *handle, int cpus)
 				 handle->file_state);
 		return -1;
 	}
-	cpus = convert_endian_4(handle, cpus);
-	ret = do_write_check(handle, &cpus, 4);
-	if (ret < 0)
-		return ret;
+
+	if (!HAS_SECTIONS(handle)) {
+		cpus = convert_endian_4(handle, cpus);
+		ret = do_write_check(handle, &cpus, 4);
+		if (ret < 0)
+			return ret;
+	} else {
+		tracecmd_add_option(handle, TRACECMD_OPTION_CPUCOUNT, sizeof(int), &cpus);
+	}
+
 	handle->file_state = TRACECMD_FILE_CPU_COUNT;
 	return 0;
 }
-- 
2.33.1

