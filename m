Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5F347C433F5
	for <linux-trace-devel@archiver.kernel.org>; Fri, 10 Dec 2021 10:55:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236956AbhLJK6e (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 10 Dec 2021 05:58:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34442 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237059AbhLJK6e (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 10 Dec 2021 05:58:34 -0500
Received: from mail-ed1-x530.google.com (mail-ed1-x530.google.com [IPv6:2a00:1450:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2CBE7C061746
        for <linux-trace-devel@vger.kernel.org>; Fri, 10 Dec 2021 02:54:59 -0800 (PST)
Received: by mail-ed1-x530.google.com with SMTP id r25so28150956edq.7
        for <linux-trace-devel@vger.kernel.org>; Fri, 10 Dec 2021 02:54:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=UFQ1ZduVWk3uIWBVYjuwejlgUbUzDGmfcZuRlpz4K+g=;
        b=iklBp2kdt57kwZ6s4M7WW9nX0Sc7kZZykY4yGItCZB/mqB8QXgtgTIfPAmYWRCP4mO
         AiV7BxJjshmc16ZRm6n36nV+llRtacAPHzwRlE0Mgb+OcwG1pBf4GiVm+7+MCiSzE8qv
         +cb2hr+DOKDIcUF8iTqc1sZD1jSpowTvU5uTJJe3KvoKUonvii6CvNf/bHWRBe2dGch4
         ZocyMFKarWQRMdZuYFlVnaAXTWMmnnU725NOcKx7LozL9WkUCbIcJJLPMMPWYUDee9Da
         QNLXkaLITW+ECKT9KRWhz4A8xMx3g7HQByn83QjDpST0UrZ6AZo3/VyNGi2Dn6tCSsCB
         tKuQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=UFQ1ZduVWk3uIWBVYjuwejlgUbUzDGmfcZuRlpz4K+g=;
        b=qiLJMkyzJVGoe4bdvSJDKVFJ9eRC49gy2zyEi14ab/rjEr42ez30xzvEiG1q32klSW
         2z2MQdueHoz+x76ikvOrDVboF+l41SS/6KMSxBL0D3YrJlPUxfbMQZ+pdJlcFUXCn8Rd
         d3Jet78NyHtSeWH657Me3osISAEyCB9zUN44tm96+p1USv4q08nxtYPU7B1qRcacf+tv
         cjbENJ2+VaNMscOPmcuhohirpdWaBlMOZYPFxZHHJRt+HeFnnPDdPsiuXqXd1P39qSra
         keXHQ8oQzvlYEvkmpHKD2B/rwkmjlM9YXQ6XnY1DV5DVyvx45K1TWM0uy5xkbPbrXVVD
         ioNQ==
X-Gm-Message-State: AOAM531dG9eC2mlR9IuWmSm5aa/ZQv7pHUA79VsUM07eAqmERK7JqI8i
        J8yf0i5OP5nqZLY46FjfKQE9dtWcm70=
X-Google-Smtp-Source: ABdhPJxiy5Lxe013cM1KgGIyx6/67GR35ZHXQPP/wEFETFHCFb52+ieFsmeLWXR0+qKI/Dbkj5CLaw==
X-Received: by 2002:aa7:d512:: with SMTP id y18mr38270493edq.163.1639133697616;
        Fri, 10 Dec 2021 02:54:57 -0800 (PST)
Received: from oberon.zico.biz.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id x7sm1306314edd.28.2021.12.10.02.54.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Dec 2021 02:54:57 -0800 (PST)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v7 08/25] trace-cmd library: Do not write CPU count section in trace files version 7
Date:   Fri, 10 Dec 2021 12:54:31 +0200
Message-Id: <20211210105448.97850-9-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211210105448.97850-1-tz.stoyanov@gmail.com>
References: <20211210105448.97850-1-tz.stoyanov@gmail.com>
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
index 6e07fece..59093be2 100644
--- a/lib/trace-cmd/trace-output.c
+++ b/lib/trace-cmd/trace-output.c
@@ -1477,10 +1477,16 @@ int tracecmd_write_cpus(struct tracecmd_output *handle, int cpus)
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

