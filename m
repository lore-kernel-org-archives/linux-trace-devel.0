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
	by smtp.lore.kernel.org (Postfix) with ESMTP id D2AD6C433F5
	for <linux-trace-devel@archiver.kernel.org>; Mon, 13 Sep 2021 12:28:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B53D260F0F
	for <linux-trace-devel@archiver.kernel.org>; Mon, 13 Sep 2021 12:28:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239995AbhIMM30 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 13 Sep 2021 08:29:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46568 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235143AbhIMM3Z (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 13 Sep 2021 08:29:25 -0400
Received: from mail-wr1-x42c.google.com (mail-wr1-x42c.google.com [IPv6:2a00:1450:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C9DCC061574
        for <linux-trace-devel@vger.kernel.org>; Mon, 13 Sep 2021 05:28:10 -0700 (PDT)
Received: by mail-wr1-x42c.google.com with SMTP id g16so14443651wrb.3
        for <linux-trace-devel@vger.kernel.org>; Mon, 13 Sep 2021 05:28:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=iHbl/58swxEP+2R4EUL7BmGjrykf7sAqFNSgdDuIakQ=;
        b=HZWRQJLq3FWXR2VmYiBdGWZlU6AuQu3IZ0T6ED+UdoGjzQy5IEMIJGSg3EYypvo97E
         R7glxMJt99pUlAlEgq/joChrQd5dAs5mQzgNff0qfIZOgHRScGcBkZjdZJEFfRrMwQxJ
         Rai6bI0+P9Aikelb/h+FQbsCHYY6/mnWJYF8MASB8sELiFqahq5/gNnPAPj8SMaxdZ8B
         Vdl0XgeYEKCkSAbpzUM1wOsH5qFrKzrSUgPL0GQHUIawB4OPHU9qLslU2ZNAANI6dlC5
         U4xJt3ASxcGaMecv+peXHj1cG+q1UyXVEqVayd6gvR8lWR7AoSV3gbWWXsPV4aZq9mG2
         hqRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=iHbl/58swxEP+2R4EUL7BmGjrykf7sAqFNSgdDuIakQ=;
        b=3dcsaVzytxgW51vd2QSEM5O2Fahc59bo9vK7rY6fRc1pLoXA/vcUkpQYcMxuXiGY4b
         JRiPVQ2hnWGzJJvzYU/es34DtPcY1JbSMFmB+cNhwEmXXSk3oC+Tn+mtTzAd0UITMNDJ
         2DUf6iroAIQDmQuQw46KD26sSI+6sE+ZpWEyZnLIXmw2Zh4s6vQyeyItaIR4E0HesPOB
         ypyxsONc8UklXoIltNFHVM0YXAPOmGHwRkZih1HC7evlklFl0M6w2rvev/+5Cq2AX8lY
         bu/0/HyzJLQtIwed+M/NtR/NXhVP20yVDwax/DUsL/HGhkYm9Fw7xJqEPuFBn4IM3yq7
         mrbw==
X-Gm-Message-State: AOAM531ArmvOkDuXxY7Dv9R3Z9n6193LTPGjl3zxWhCOK6kAykjMETrD
        Z6xrCeXBjhXKfguskWR7tFONfTiF1x4=
X-Google-Smtp-Source: ABdhPJydfrCK30jWCtfkF4U94O1UIribC1s8hodUPNlSY02731DRr20vQ9+pNHTR6vmLVe84m2gpRQ==
X-Received: by 2002:a5d:650b:: with SMTP id x11mr12135512wru.350.1631536088758;
        Mon, 13 Sep 2021 05:28:08 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id z6sm6839689wmp.1.2021.09.13.05.28.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Sep 2021 05:28:08 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v2 07/21] trace-cmd library: Do not use local variables when reading CPU stat option
Date:   Mon, 13 Sep 2021 15:27:45 +0300
Message-Id: <20210913122759.3672494-8-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210913122759.3672494-1-tz.stoyanov@gmail.com>
References: <20210913122759.3672494-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Using a local variable to read all CPUSTAT options assumes that all of
them are in a single option section. While this is true for the current
trace file version format, this assumption limits the design of a more
flexible format with multiple options sections. Use input handler context
instead of the local variable.

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 lib/trace-cmd/trace-input.c | 20 +++++++++++---------
 1 file changed, 11 insertions(+), 9 deletions(-)

diff --git a/lib/trace-cmd/trace-input.c b/lib/trace-cmd/trace-input.c
index 3d7f1c48..d020cfae 100644
--- a/lib/trace-cmd/trace-input.c
+++ b/lib/trace-cmd/trace-input.c
@@ -138,6 +138,7 @@ struct tracecmd_input {
 
 	struct host_trace_info	host;
 	double			ts2secs;
+	unsigned int		cpustats_size;
 	char *			cpustats;
 	char *			uname;
 	char *			version;
@@ -2658,7 +2659,6 @@ static int handle_options(struct tracecmd_input *handle)
 	unsigned short option;
 	unsigned int size;
 	char *cpustats = NULL;
-	unsigned int cpustats_size = 0;
 	struct input_buffer_instance *buffer;
 	struct hook_list *hook;
 	char *buf;
@@ -2738,12 +2738,16 @@ static int handle_options(struct tracecmd_input *handle)
 			break;
 		case TRACECMD_OPTION_CPUSTAT:
 			buf[size-1] = '\n';
-			cpustats = realloc(cpustats, cpustats_size + size + 1);
-			if (!cpustats)
-				return -ENOMEM;
-			memcpy(cpustats + cpustats_size, buf, size);
-			cpustats_size += size;
-			cpustats[cpustats_size] = 0;
+			cpustats = realloc(handle->cpustats,
+					   handle->cpustats_size + size + 1);
+			if (!cpustats) {
+				ret = -ENOMEM;
+				return ret;
+			}
+			memcpy(cpustats + handle->cpustats_size, buf, size);
+			handle->cpustats_size += size;
+			cpustats[handle->cpustats_size] = 0;
+			handle->cpustats = cpustats;
 			break;
 		case TRACECMD_OPTION_BUFFER:
 			/* A buffer instance is saved at the end of the file */
@@ -2813,8 +2817,6 @@ static int handle_options(struct tracecmd_input *handle)
 
 	}
 
-	handle->cpustats = cpustats;
-
 	return 0;
 }
 
-- 
2.31.1

