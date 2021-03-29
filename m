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
	by smtp.lore.kernel.org (Postfix) with ESMTP id B3BE9C433E1
	for <linux-trace-devel@archiver.kernel.org>; Mon, 29 Mar 2021 12:59:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8876961970
	for <linux-trace-devel@archiver.kernel.org>; Mon, 29 Mar 2021 12:59:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231316AbhC2M7B (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 29 Mar 2021 08:59:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53828 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230454AbhC2M63 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 29 Mar 2021 08:58:29 -0400
Received: from mail-ed1-x52c.google.com (mail-ed1-x52c.google.com [IPv6:2a00:1450:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B78FC061574
        for <linux-trace-devel@vger.kernel.org>; Mon, 29 Mar 2021 05:58:28 -0700 (PDT)
Received: by mail-ed1-x52c.google.com with SMTP id l18so14098588edc.9
        for <linux-trace-devel@vger.kernel.org>; Mon, 29 Mar 2021 05:58:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=v8cliC7+wJ1dqQpyuuVuJTTxWawlDDzsxkFfpVfbuP0=;
        b=k74wDRxrOtAyQHmRaHjzXLNwYsmoKiTN5ffFhbIBXCXMAD2UPJ6glVIunu1gLJ/GIi
         BWqYYcGRFvM7fHtuvEtOCOj3GeZBYQfeHPnwqu6GgDZxw3cldXiyoSPDFoWnx1TwBJem
         QMWAlH5YhubavUqmAxu2zjW8kp3lBDX/izNdlAK3oNQOLoGwV6+wdF2YXpb0qWOkzvgD
         MIs/o7cB+aZbsdCI3abf2ykJ4cuuyH/X2EUiY0di+PkC88KeobTWywopzYv3iPwh6nD4
         YHe2/j7QWVkhtVs9tugCB0VGVDdTOcqUVSGjJqmB4y73oifL2FTRS9PeCJ0BRJ/iDinK
         UoAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=v8cliC7+wJ1dqQpyuuVuJTTxWawlDDzsxkFfpVfbuP0=;
        b=cGC7ThZPGHBMVT9hIgb2IGla5I/CF2H0W6yIhCNVwsiYkBKlWsugCuA8APaNOcmrfX
         YjWGXsKnvGeZvYAb5bn8LU4Z6xRMjVAds9agxPnMo4sqgv0vCADcM255eTcIEGbzEzQp
         /iJ70uNQvhnk9NP6DNa0X7++wp36r86YEyNgJc9UBuRO+ZttOO36EzrA0guajFP/6/mk
         rKkScUr5LuuK0j0+tv/D+esPH/MYZA+o/z8I3t/SlDDpDJhGXUrD22Avxz06Ab4H1gPn
         40KobsZLQL218v/RTWZFIFmqQEhQYvLolFyrwiLXD+nmjAoj7/D8z99gDt5D1sHqdbej
         Fu1g==
X-Gm-Message-State: AOAM530M3bcVclbPoSIm6wGpsWw8ZSASaXkKJ4J5Q6ldCFbKm/DAJwIw
        0Z/WR8kz9DupGIp6OXsNAy8LlccCdWfizg==
X-Google-Smtp-Source: ABdhPJyQD6de4PuCOdd9mfeOmaIraS2rfOam9jRuEGsRd/gT1eTEqoztvnXmw3h3ZhXYxfMf6bVX6A==
X-Received: by 2002:aa7:d294:: with SMTP id w20mr28639849edq.68.1617022706842;
        Mon, 29 Mar 2021 05:58:26 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id d19sm8909075edr.45.2021.03.29.05.58.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 29 Mar 2021 05:58:26 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH 3/4] trace-cmd: Document --tsc2nsec option
Date:   Mon, 29 Mar 2021 15:58:20 +0300
Message-Id: <20210329125821.97496-4-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210329125821.97496-1-tz.stoyanov@gmail.com>
References: <20210329125821.97496-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Document the "trace-cmd record --tsc2nsec" option.

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 Documentation/trace-cmd/trace-cmd-record.1.txt | 5 +++++
 tracecmd/trace-usage.c                         | 2 ++
 2 files changed, 7 insertions(+)

diff --git a/Documentation/trace-cmd/trace-cmd-record.1.txt b/Documentation/trace-cmd/trace-cmd-record.1.txt
index 643659ad..d992002e 100644
--- a/Documentation/trace-cmd/trace-cmd-record.1.txt
+++ b/Documentation/trace-cmd/trace-cmd-record.1.txt
@@ -349,6 +349,11 @@ OPTIONS
         at the beginning and at the end of the trace.
         Timestamps synchronization with guests works only if there is support for VSOCK.\n"
 
+*--tsc2nsec*::
+    Convert the current clock to nanoseconds, using tsc multiplier and shift from the Linux
+        kernel's perf interface. This option does not change the trace clock, just assumes that
+        the tsc multiplier and shift are applicable for the selected clock. You may use the
+        "-C tsc2nsec" clock, if not sure what clock to select.
 *--stderr*::
     Have output go to stderr instead of stdout, but the output of the command
     executed will not be changed. This is useful if you want to monitor the
diff --git a/tracecmd/trace-usage.c b/tracecmd/trace-usage.c
index 22537d20..386e88fe 100644
--- a/tracecmd/trace-usage.c
+++ b/tracecmd/trace-usage.c
@@ -62,6 +62,8 @@ static struct usage_help usage_help[] = {
 		"          --no-filter include trace-cmd threads in the trace\n"
 		"          --proc-map save the traced processes address map into the trace.dat file\n"
 		"          --user execute the specified [command ...] as given user\n"
+		"          --tsc2nsec Convert the current clock to nanoseconds, using tsc multiplier and shift from the Linux"
+		"               kernel's perf interface\n"
 		"          --tsync-interval set the loop interval, in ms, for timestamps synchronization with guests:"
 		"               If a negative number is specified, timestamps synchronization is disabled"
 		"               If 0 is specified, no loop is performed - timestamps offset is calculated only twice,"
-- 
2.30.2

