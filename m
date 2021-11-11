Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8DDCFC433F5
	for <linux-trace-devel@archiver.kernel.org>; Thu, 11 Nov 2021 15:09:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6F05661252
	for <linux-trace-devel@archiver.kernel.org>; Thu, 11 Nov 2021 15:09:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233810AbhKKPMP (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 11 Nov 2021 10:12:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37390 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233715AbhKKPMN (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 11 Nov 2021 10:12:13 -0500
Received: from mail-ed1-x52c.google.com (mail-ed1-x52c.google.com [IPv6:2a00:1450:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 445C6C061766
        for <linux-trace-devel@vger.kernel.org>; Thu, 11 Nov 2021 07:09:24 -0800 (PST)
Received: by mail-ed1-x52c.google.com with SMTP id f8so25615442edy.4
        for <linux-trace-devel@vger.kernel.org>; Thu, 11 Nov 2021 07:09:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=bunGmG6t4DdPm171IFBPKJoBlEqIDwR02+aCLO4f1QA=;
        b=KJp+9gMuTp+XuDS17+OU+wKVBNH6olUskvTauosABlK5AEq7yCw5z494ugfQCXn0Pi
         WFHFRPZDIr+quXjS/0CgaFWFA9l7HZarSQ0GlEXn+XYAlkAINJq2lFS1sGq+Qs+jeaW9
         0TwcsWziOWYjXwAr72f1IPSXFyiECwOtQ2IGH94bRDh2lgiNwCgV4zUxY97RZr+XXkDr
         5KiSoOKc3NJZW+uoMFTLiH66NS869RjlfgoDlwFk3XwpCTrKu7N8czMLgDDRDdzOUEta
         o7Q4wB+v1JiJAQhtXL6FksVfy35iqk3MotnVUJx15wisbt8DwXRpY3jMCH5sS11IFDCz
         r0nw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=bunGmG6t4DdPm171IFBPKJoBlEqIDwR02+aCLO4f1QA=;
        b=hlvMAstxTiWlrVrbqXrIn1tahKC6QpT68UrWry7HA/eMvbn5lkgRIF8s29Wb8Tgytp
         q8ws6lXcQL7ti7fE1s0FRXZER0KiG1GFW4/kPRZ3+EwzPhE8C39o4PYUEooZYzNe49Q1
         ugObI4g486CClwgdG6fkqS7/Rcbo59WnKNe+rN9cIYZkuLZHYgoSUxfQhfhbnTVmVpKy
         Bx5rZNEUQcQ84CWVFtZ2Lx3ADKbt8QhJC5ZHPGpAEmwPfRNRqNqAoJc7NPZC8ExwfBey
         Mcpjlr2YRc+jV0sGT+oPLt2CT6HXWyYQidH4jmw3Qp0N5sA5mwd7fLLcU5EctVlX/Kli
         Q7Fg==
X-Gm-Message-State: AOAM5323REv660f+UGIp9K0uhyZRYVhCgOyFBd8lJ5jHWuxjhiaJ1gz1
        +pDPvoP41I/HoO19dK2AmxlGLVMfOfMohA==
X-Google-Smtp-Source: ABdhPJwvageKsDHTYWB8RvDIhcrSgoNI4ZEBuyvOT4DjZK2VR9m57swC3S9dWO1wKbXXbTzBAMfukQ==
X-Received: by 2002:a17:906:b51:: with SMTP id v17mr10504374ejg.262.1636643362812;
        Thu, 11 Nov 2021 07:09:22 -0800 (PST)
Received: from oberon.zico.biz.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id z25sm1425008ejd.80.2021.11.11.07.09.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 Nov 2021 07:09:22 -0800 (PST)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v5 07/25] trace-cmd library: Do not write CPU count section in trace files version 7
Date:   Thu, 11 Nov 2021 17:09:21 +0200
Message-Id: <20211111150921.86643-1-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.33.1
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
index 48e69850..02fc78f9 100644
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
2.33.1

