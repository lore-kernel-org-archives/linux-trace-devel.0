Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E417FC433F5
	for <linux-trace-devel@archiver.kernel.org>; Tue, 14 Sep 2021 13:14:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CD38661130
	for <linux-trace-devel@archiver.kernel.org>; Tue, 14 Sep 2021 13:14:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233227AbhINNQH (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 14 Sep 2021 09:16:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48866 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233214AbhINNQG (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 14 Sep 2021 09:16:06 -0400
Received: from mail-wr1-x432.google.com (mail-wr1-x432.google.com [IPv6:2a00:1450:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3AF7AC061574
        for <linux-trace-devel@vger.kernel.org>; Tue, 14 Sep 2021 06:14:49 -0700 (PDT)
Received: by mail-wr1-x432.google.com with SMTP id x6so20128849wrv.13
        for <linux-trace-devel@vger.kernel.org>; Tue, 14 Sep 2021 06:14:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=08pjarJ57TCo8MnXdaaZPrIHEI8NWlUNiEyQPylWnr4=;
        b=qNmH9Wenxu4quCs6S6xqi4sZf3vhs/G9GiAf4fEIeC+m/d/oN+C0OckB9olrNWMgMe
         yaPDzTzTeg6DbBcBXUikN0S4WVCjsuoxyG3yrQKKkCd/6mceA4wWNXcoEse9GIrNVvg4
         x6xIkJfeFYq75VCjbvCcQth23U/dwcVkJuzegZb3/mbFIbteKKFBZhfCwA1GRJeHnqta
         ulBDI/jxpi57Z+OhYYkB0hkqmHPN9yAVQGrMOm/b58YLZUXzYIv6vK6fGbhd3PVRMwB7
         iP9al4/7Cs50eCTIZ405/djbJWD1h1ZaLxISuat29vTuTwsG/bdwv9klfm7YIlcaofgK
         X4Yw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=08pjarJ57TCo8MnXdaaZPrIHEI8NWlUNiEyQPylWnr4=;
        b=uJBArEU+pXYgXkNG8Gbf00iaiu7WPxafeWV99SfNPY+5iI1BWOIAwtWQf2ge3anRsi
         0XHeBPuaI25HRcDdTmV+LYDYtKVrybT7ta/LvWvwiz7o+eD3s2JZC6r9nFtwhhfeMJ6R
         KRTY0yIf9pxT6/kOMzTzmYoJof9r5Sbv/5R3MMdPe/ZZ3/mdhZqLWj3iQHp+YAsnRuSb
         ZBlto/2Fedp327YHYrQ5qC5XAIdFXpP6RVRM4NMA4sPP9dTd1g2vRlFTs9Z46mp/o3/x
         K7bfMCgkfGe9Bco6CXK3eng+AE8uZqVcr1kqOPIIjXCo5I1/YbzZq0J7mMkcffkd8bs2
         EMGA==
X-Gm-Message-State: AOAM53038DJl3mNpr1wixPgsd/UZUfJboEK6axaBiX0C96oZmisSjtJn
        rObU1FdEg9vvZVbb7K3wG7k=
X-Google-Smtp-Source: ABdhPJyX6q+2p+uimx+RVb+ng2JRY3MdMU1oLHZLEs+s5I8pSYzO3SZmtwE1a7HKwyNdNnaD3ejwkw==
X-Received: by 2002:adf:b348:: with SMTP id k8mr18776969wrd.123.1631625287803;
        Tue, 14 Sep 2021 06:14:47 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id y9sm1274760wmj.36.2021.09.14.06.14.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Sep 2021 06:14:47 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v3 07/25] trace-cmd library: Do not write CPU count section in trace files version 7
Date:   Tue, 14 Sep 2021 16:14:20 +0300
Message-Id: <20210914131438.3965484-8-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210914131438.3965484-1-tz.stoyanov@gmail.com>
References: <20210914131438.3965484-1-tz.stoyanov@gmail.com>
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
index 28bfed32..8bc995c7 100644
--- a/lib/trace-cmd/trace-output.c
+++ b/lib/trace-cmd/trace-output.c
@@ -1398,10 +1398,16 @@ int tracecmd_write_cpus(struct tracecmd_output *handle, int cpus)
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

