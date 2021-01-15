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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8A467C433E0
	for <linux-trace-devel@archiver.kernel.org>; Fri, 15 Jan 2021 05:04:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5197822CBE
	for <linux-trace-devel@archiver.kernel.org>; Fri, 15 Jan 2021 05:04:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727224AbhAOFEe (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 15 Jan 2021 00:04:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55646 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726361AbhAOFEc (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 15 Jan 2021 00:04:32 -0500
Received: from mail-ed1-x52d.google.com (mail-ed1-x52d.google.com [IPv6:2a00:1450:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2EFF4C061757
        for <linux-trace-devel@vger.kernel.org>; Thu, 14 Jan 2021 21:03:52 -0800 (PST)
Received: by mail-ed1-x52d.google.com with SMTP id s11so879350edd.5
        for <linux-trace-devel@vger.kernel.org>; Thu, 14 Jan 2021 21:03:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=WbynNcrEOflMftJmYtRG3udxa9RLTidklK8ulgAsL8A=;
        b=cUbKDmEKxYqQ0nOUK0IZK2wSn2O0ghgP0HWEX2LUa/I0YMfaCS7mAkgI00XitgpQh0
         ohWENen+xgx4ldtWpFk+tLwEeEcgDxwcdtaMwbQR9nPjX8vVuJXRX5Wga64TAQeeF/Qo
         SqGVjBGxv0mNUPYB93cNexqBp58c69OWCrJ+zdmPOHElXb2MtfjchUNGjXnW42p77V+P
         VGbppRicUNMbIkFOB+ij4M+W5dad6B9vB6ybmCghzsQu/Yw7xqJKbdiQLqpQ4urN7laJ
         N7+KcIyRwq6mXzOKcn7oxAaecAJQpTc9G5cRU4TsxL+0C90MjODq+mEUuuVCa5R4LQlX
         K1lA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=WbynNcrEOflMftJmYtRG3udxa9RLTidklK8ulgAsL8A=;
        b=b/FmeFYLDmFPQDHQ/Zkr1eo0lc5LkbEGqyB6xp75S8v3peeexmjaupysx2RTp+qm0P
         FUCsHiMSX9GrNUX3sZ+2OBYcQl+lQMTtZW7wFU50wuhiRKFcJzvdl3ohlCTWjD/dF6bj
         pHR4d8N9viXWs+lAIslDH8jjuRC9Iw9MX5rnLlmWhV+HmFeChOYp1VSdYK8LuR5ca66/
         fuwY6rZ7GcorS0AnS2iynLkT3HuN9LuAa8MRDycpLU1MY5kpmprNJ5LuWAWKmGsx/Ol6
         8mIoCGopxzHsjFDoOM2WD5bsFyiww1KrRcHQGbiVKJl8G6NcCl0LmDMdlAwMqgVKSgGN
         Iefw==
X-Gm-Message-State: AOAM530ulGaGzwIS8eNvOeYa4vMy8DCwxZUTmuzfVl9bh+IwrMc6W+ds
        cWGofJaoY4vaMJskNvCxudz+5rMPD8VIYHAJ
X-Google-Smtp-Source: ABdhPJwq/8sX0DrgiTCc2sm8gPX20/rqu6eOqd/YEsLas7c3NQPuIULsMloRVlC2sQUy523WecWECg==
X-Received: by 2002:aa7:d148:: with SMTP id r8mr8222523edo.127.1610687030941;
        Thu, 14 Jan 2021 21:03:50 -0800 (PST)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id n13sm2747183ejr.93.2021.01.14.21.03.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 Jan 2021 21:03:50 -0800 (PST)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH] libtracefs: Enhance error checking when reading a number from trace file
Date:   Fri, 15 Jan 2021 07:03:49 +0200
Message-Id: <20210115050349.1193918-1-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Additional check is added to tracefs_instance_file_read_number() API to
handle the case when the trace file does not contain any number.

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 src/tracefs-instance.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/src/tracefs-instance.c b/src/tracefs-instance.c
index 97bbb00..b5f8298 100644
--- a/src/tracefs-instance.c
+++ b/src/tracefs-instance.c
@@ -316,13 +316,14 @@ int tracefs_instance_file_read_number(struct tracefs_instance *instance,
 	long long num;
 	int ret = -1;
 	int size = 0;
+	char *endptr;
 	char *str;
 
 	str = tracefs_instance_file_read(instance, file, &size);
 	if (size && str) {
 		errno = 0;
-		num = strtoll(str, NULL, 0);
-		if (errno == 0) {
+		num = strtoll(str, &endptr, 0);
+		if (errno == 0 && str != endptr) {
 			*res = num;
 			ret = 0;
 		}
-- 
2.29.2

