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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 20CDCC433FE
	for <linux-trace-devel@archiver.kernel.org>; Fri, 10 Sep 2021 13:51:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 074F6611CC
	for <linux-trace-devel@archiver.kernel.org>; Fri, 10 Sep 2021 13:51:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233588AbhIJNwY (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 10 Sep 2021 09:52:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48686 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233735AbhIJNwY (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 10 Sep 2021 09:52:24 -0400
Received: from mail-ed1-x535.google.com (mail-ed1-x535.google.com [IPv6:2a00:1450:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E07DAC061574
        for <linux-trace-devel@vger.kernel.org>; Fri, 10 Sep 2021 06:51:12 -0700 (PDT)
Received: by mail-ed1-x535.google.com with SMTP id g8so2600046edt.7
        for <linux-trace-devel@vger.kernel.org>; Fri, 10 Sep 2021 06:51:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=DyXosnBNVez1kJvwW8Z59R0UfU/8CDxTC6gV2dbJ+wA=;
        b=gOU6l2gQMT3zLeRnN1QtlMcsWhadcu+ZGtuF1TQZMWSG7ittbK8e1XVC4mGqOLbGGG
         F4hI6aF1AMRTQgVeX4zE5lrhEzGolyfhTC3jtUaRknawAGR3o+ql2lC629fDGld6Q7mk
         xGTBAyCcBsYLpl0EP3pG/M31fhU1IDoqnzBhRxU7Y4uVl1w1PBrUTcA+pp2F1hI+DCRK
         gh0RwYVhE+p3mRpV7HcvlOqfYuba62A6q5D+mhRyTIdCkezRinBaiZ1E2ncfj/HwuVzC
         J0AJr3b3pd5ytal/CDdN862OUTXYLNhlRlBa2WAt4p7GAuIRkVq554Zdn/8Ta+fH2X+4
         9PBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=DyXosnBNVez1kJvwW8Z59R0UfU/8CDxTC6gV2dbJ+wA=;
        b=aRC8MjbjTrE7UPwaeoGmS/RWuept3BTIBeMVlyfRY9+z6E6TG0YMd6ixM/JDiurQPm
         SWlFTD5DKwrO3+QSopbkvcKNDv3qcFULucxpgy7uIYHj7AFuPhi2bVfQ4d5Ly+lDfzLc
         Dh+35eSDwfSUbcg7rcwJZxKfP7Va2PQUKrI1PHpOA4L9HKg48ixwv31mSjhBKB/6Sw1T
         Q9NfUgf0cSH/TyA3WY/1KHqzmC/iJ1JWtx5IAD+Xpvohv7rAy6XGT3NbXaLG11D0jTch
         OAHblARPXBiy4IXOTo5mbJ7sBVGMIydxSDI/fN6FNMepw6nv14Z6xS83FxeeoLZA3BUp
         r+Sg==
X-Gm-Message-State: AOAM530hZZlFlcesllsxcqkpWmqi3KQnSt11CgvZoHROGp6qJRNwG2Cl
        h1dFhlk41Z22iKUSsu0HmdOu4Nj9lfE=
X-Google-Smtp-Source: ABdhPJxl9t1kHvYsTfe+4acRyJtyqcnC0jzDQTyIQTgIeEI3P6fU+cAuqKHr0TFQy9P1w3N5doi91g==
X-Received: by 2002:aa7:c0c7:: with SMTP id j7mr7497773edp.58.1631281871495;
        Fri, 10 Sep 2021 06:51:11 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id w13sm2484683ejc.100.2021.09.10.06.51.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Sep 2021 06:51:11 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH 09/25] trace-cmd record: Append trace options after the trace data are written
Date:   Fri, 10 Sep 2021 16:50:45 +0300
Message-Id: <20210910135101.2865226-10-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210910135101.2865226-1-tz.stoyanov@gmail.com>
References: <20210910135101.2865226-1-tz.stoyanov@gmail.com>
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
index 35d9ee5f..879acb7c 100644
--- a/tracecmd/trace-record.c
+++ b/tracecmd/trace-record.c
@@ -4449,6 +4449,9 @@ static void write_guest_file(struct buffer_instance *instance)
 
 	if (tracecmd_write_cpu_data(handle, cpu_count, temp_files, "") < 0)
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
2.31.1

