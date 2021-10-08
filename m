Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C04F6C433EF
	for <linux-trace-devel@archiver.kernel.org>; Fri,  8 Oct 2021 04:20:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A984B60F6B
	for <linux-trace-devel@archiver.kernel.org>; Fri,  8 Oct 2021 04:20:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229932AbhJHEWE (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 8 Oct 2021 00:22:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49802 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237325AbhJHEWE (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 8 Oct 2021 00:22:04 -0400
Received: from mail-ed1-x532.google.com (mail-ed1-x532.google.com [IPv6:2a00:1450:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7062EC061755
        for <linux-trace-devel@vger.kernel.org>; Thu,  7 Oct 2021 21:20:09 -0700 (PDT)
Received: by mail-ed1-x532.google.com with SMTP id y12so17983737eda.4
        for <linux-trace-devel@vger.kernel.org>; Thu, 07 Oct 2021 21:20:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=bsgLLvFLLxYut68N6l18PC0yNfjdgCP+TUh1lz29fjY=;
        b=XIG4eJ6piejYX1SgKdz0xuyXepU2NFM+KaGkWJVc3121nDCZ5T7s8TvrqA66F9bBHi
         M8CdQh1xDk7kao8b5luP7ZUhIUeN9XUSECmUJbBhnIMaGN2G2LjbLclhjs+aZV/KrjKA
         3r8IKmckzvkxoPAWDMWs+b840yPGX4zx5bEu1cNE68t0K46w7P3sxEQpvoNXhQUeGoRo
         AJCf0sjpdm//CfscU0YFishrmJFZ8ABAKsPeUUHAV1ZLAErXyOatR19RkqhtvH1jCk2i
         0EASHjhHdWXdcP59A+BHR5UWGIAmDPzEATT11OySVumkdx+Fx2WBGlV5e4ZA05eneb4i
         7egw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=bsgLLvFLLxYut68N6l18PC0yNfjdgCP+TUh1lz29fjY=;
        b=V6M3q84TyT5hC+T91bgGY1/HLYU+20xgORaIjOoIoeA2GaoCcdFFhwmq1AFpuNUVFA
         xYAD6kvtf61l2u/N1KvYorAFCVc5jBVtuqc0Z8xpJuLeLCsspPXxVpR6fQ6MxVWocM7o
         Dl0vaT6Z6b/E/ASyF7ZAxQyVK59f5w0Ec0Uy+ck56n4H2R8QKfea/80yDP8T94uvuAwJ
         Btz1xrVglXxowwfhSqZWmeBAN/OShGGh/mntreSC7lwubms9TUSQZkHOUTaeDgZfrroC
         wjF3jU+RFvzd/LjS0yDAkwpsFMjpRRySxEVMVMkWm22YUYrgTdXR5voKdXSBDCOiaTie
         JS4Q==
X-Gm-Message-State: AOAM5305TNIzxZhFnphAmsVJzhA5axwvUHMNlX0iHvlx6CwEshs9ZRPB
        ralfYkvMfSN1ZbhDAnpsiyBj1GTaqCASFw==
X-Google-Smtp-Source: ABdhPJyOLhtBpfHXrjMRRvKTs+VbKSpiJ0ZVe/vg3oAnkoHtp+a+e46MN0sWUniNAMXUq0t0JyWRMg==
X-Received: by 2002:a50:fc97:: with SMTP id f23mr11858480edq.176.1633666808049;
        Thu, 07 Oct 2021 21:20:08 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id p6sm511669edi.18.2021.10.07.21.20.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Oct 2021 21:20:07 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v4 07/25] trace-cmd library: Do not write CPU count section in trace files version 7
Date:   Fri,  8 Oct 2021 07:19:40 +0300
Message-Id: <20211008041958.976309-8-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211008041958.976309-1-tz.stoyanov@gmail.com>
References: <20211008041958.976309-1-tz.stoyanov@gmail.com>
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
index 7cafaca6..a49aecfb 100644
--- a/lib/trace-cmd/trace-output.c
+++ b/lib/trace-cmd/trace-output.c
@@ -1390,10 +1390,16 @@ int tracecmd_write_cpus(struct tracecmd_output *handle, int cpus)
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
2.31.1

