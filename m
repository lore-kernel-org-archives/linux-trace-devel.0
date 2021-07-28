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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 859EDC4338F
	for <linux-trace-devel@archiver.kernel.org>; Wed, 28 Jul 2021 13:34:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 71A2460FED
	for <linux-trace-devel@archiver.kernel.org>; Wed, 28 Jul 2021 13:34:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236809AbhG1Ne3 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 28 Jul 2021 09:34:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54484 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236344AbhG1Ne2 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 28 Jul 2021 09:34:28 -0400
Received: from mail-ed1-x534.google.com (mail-ed1-x534.google.com [IPv6:2a00:1450:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 85777C061764
        for <linux-trace-devel@vger.kernel.org>; Wed, 28 Jul 2021 06:34:26 -0700 (PDT)
Received: by mail-ed1-x534.google.com with SMTP id x14so3200307edr.12
        for <linux-trace-devel@vger.kernel.org>; Wed, 28 Jul 2021 06:34:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=7/tzADKHCs+G6aHZyQMgF666aPdEc8iV9Wpqr5trpyE=;
        b=JWkdE3Ck6qxwRbExApHKyEsgmYmM8RorV9yvJkqCvScp8541Otosb8Rd8hBYV8IyK5
         vvINwC//uw/EVWar96lvo+8m85HTqR2hj6S+Mp/W45QVxWcOOc0GvSp49nY/t29QDc8w
         n9r0ymZ800fECmQDZgMsyQqbsURoS5ZwzW0m1u+sRwEJXONeeKX85e/yDcfFVGc/DZHc
         grv+qYCHq279qy6EEcTZwTlVXZpUgTzKnctgCnPKJWjD0M6qShv+u7kPFN8BxxEzFPYg
         b2WRI5F6Hv3ln4+EMZbfstKCnBKCORmP3vWW2VWsQr6bhZeKPoUIIHsFjKlH+qj65JQc
         vURQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=7/tzADKHCs+G6aHZyQMgF666aPdEc8iV9Wpqr5trpyE=;
        b=ZBzcEnf3XEp0CEAg06ochAD9R5Uh9+2WDRN2OiHZsYMCnYBqOnMQkhKdnTz11MEEJG
         W/Y3c4Gdr9T2YVrWnUylVRTB/hfaCIKwU6f7Jxs9wsk3GkkfRez2lC3A685SuIFX5uDa
         6OXhaSRTdQdW+Whbxiss+Gw7hOj3I4AKHXlNZPTiXMNZ3Nt1mIXmeIDAgGKulTqVXRoO
         E4YeRD0UeX+Qy2yjzmZJsT4uAKFpMfzYyDkWy7N1AuPydd4zeDGaXfVu/thCipBemp+4
         R+SHHfywJ4NNXKWoQI51CgzqTeaBO7iiyOYxNrOsIB1BxqLNOBzxNtyKT5ToqL400zp2
         GGyA==
X-Gm-Message-State: AOAM533OWuyGA9vi0drW/CCxLHOJPS0U0gPcxJGfuT9hlWju+YOTk/R/
        4z9loIbKX8ZRiwWcSriwzTQ=
X-Google-Smtp-Source: ABdhPJyzb22SAnfbTAYauzSYuWPcOPUsDq/bUmT5o8jK5jm2IZR6pmKBkfN+i8hGMZBBkNoHWJ2YxQ==
X-Received: by 2002:a05:6402:268f:: with SMTP id w15mr33910854edd.368.1627479265221;
        Wed, 28 Jul 2021 06:34:25 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id b25sm2700705edv.9.2021.07.28.06.34.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Jul 2021 06:34:24 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH 86/87] tarce-cmd: Update record man page
Date:   Wed, 28 Jul 2021 16:32:49 +0300
Message-Id: <20210728133250.234140-87-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210728133250.234140-1-tz.stoyanov@gmail.com>
References: <20210728133250.234140-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Documented new arguments of the "trace-cmd record" subcommand:
 --compression
 --file-version

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 Documentation/trace-cmd/trace-cmd-record.1.txt | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/Documentation/trace-cmd/trace-cmd-record.1.txt b/Documentation/trace-cmd/trace-cmd-record.1.txt
index 96c27108..b3620474 100644
--- a/Documentation/trace-cmd/trace-cmd-record.1.txt
+++ b/Documentation/trace-cmd/trace-cmd-record.1.txt
@@ -377,6 +377,19 @@ OPTIONS
 
       trace-cmd record --verbose=warning
 
+*--file-version*::
+    Desired version of the output file. Supported versions are 6 or 7.
+
+*--compression*::
+    Compression of the trace output file, one of these strings can be passed:
+
+    'any'  - auto select the best available compression algorithm
+
+    'none' - do not compress the trace file
+
+    'name' - the name of the desired compression algorithms. Available algorithms can be listed with
+    trace-cmd list -c
+
 EXAMPLES
 --------
 
-- 
2.31.1

