Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B33C2C433F5
	for <linux-trace-devel@archiver.kernel.org>; Wed, 19 Jan 2022 08:25:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352387AbiASIZU (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 19 Jan 2022 03:25:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45776 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352370AbiASIZU (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 19 Jan 2022 03:25:20 -0500
Received: from mail-ed1-x52a.google.com (mail-ed1-x52a.google.com [IPv6:2a00:1450:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 95585C06161C
        for <linux-trace-devel@vger.kernel.org>; Wed, 19 Jan 2022 00:25:19 -0800 (PST)
Received: by mail-ed1-x52a.google.com with SMTP id cx27so7678916edb.1
        for <linux-trace-devel@vger.kernel.org>; Wed, 19 Jan 2022 00:25:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ZPvlC3t3hhq/8hKs8oI0cCeyGegZXfQvrYNXq/lPZkg=;
        b=pzS690Ch2BhXbsOYegDuJpPr+uUQz21YQf7ibKtBI2++OCo5hlg3Lf6zc/m5CPgARW
         odV76TAtn3zLAdcWDiC1Is4ZFv6d1qCcx0beL8wZit0xEi/GVo+DRYppcqg+EGhlQDcJ
         cIjaSTmPj3AuGu4sQaGFg/i3lgG4QExPz7UkHAb9Z2pp17J59QB2tLFX64dcafpErUbd
         ahaE81YRA4KGvocECVpPqmlJQvG8yHMAJT9e6YIr2DJpQTu1jc8GZe4cSZ3AHjkRTvZH
         zA+DjcB3Ko/qB7RB4uPIdovv7jW8BSdPVwVQbB7RBkjMnGD2i/HLLrvm7fJTCPuTHOMq
         KAYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ZPvlC3t3hhq/8hKs8oI0cCeyGegZXfQvrYNXq/lPZkg=;
        b=G3VqOoQg3XDVvPPHVVvDS8jkr7bIayWlXpDMdmbHOM12nIn8LUtsxzSDjVkxcUOwb6
         88IPQx56H1T/NbtOLMpBrRy3xu7DsBKBIhhLNBZcPOcWDlbDcfqCMFECX70dSg+pmfaL
         X+X0QPCAFZXeKzdoVt9ZTzXhCwPj7i+s8eDatLw3ZyMI1NFXYBrv772KONgRQPBs7qOR
         duWo3FQm55aMHsdsUaBEVBdViRFikngR/FQyHLPuLcFG48/NhqhT7OPwhXGwS4FqPOQT
         ZMAFgWNt3DqjznPFuYWnOSTbTt/JswbxZfUHcxdXW/NLoxcfdsbipTa47kLlwHLkIGMC
         Cnfg==
X-Gm-Message-State: AOAM5336ebNFx/PmxgyxBs6C60PFMh65vcPF+y7++kjLy1Lt4Sq4Zxrf
        sO7XZ67Yo6A/b48PisP3Nm4pyPuyK8M=
X-Google-Smtp-Source: ABdhPJxgPNf1vD7L1LXZoEe8+JYztNTjY09rQYU/yQDdBMcAsi/py7JXf7h+F47gJ4uNwSZgdgKoAg==
X-Received: by 2002:a17:907:2d26:: with SMTP id gs38mr24160590ejc.280.1642580718224;
        Wed, 19 Jan 2022 00:25:18 -0800 (PST)
Received: from oberon.zico.biz.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id l1sm5011122ejf.44.2022.01.19.00.25.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Jan 2022 00:25:17 -0800 (PST)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v8 08/25] trace-cmd library: Do not write CPU count section in trace files version 7
Date:   Wed, 19 Jan 2022 10:24:50 +0200
Message-Id: <20220119082507.245600-9-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220119082507.245600-1-tz.stoyanov@gmail.com>
References: <20220119082507.245600-1-tz.stoyanov@gmail.com>
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
index 8a8d4e55..c075ab6d 100644
--- a/lib/trace-cmd/trace-output.c
+++ b/lib/trace-cmd/trace-output.c
@@ -1482,10 +1482,16 @@ int tracecmd_write_cpus(struct tracecmd_output *handle, int cpus)
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
2.34.1

