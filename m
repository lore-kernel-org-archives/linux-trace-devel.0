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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 446D1C49360
	for <linux-trace-devel@archiver.kernel.org>; Mon, 14 Jun 2021 07:51:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2D8AE610A1
	for <linux-trace-devel@archiver.kernel.org>; Mon, 14 Jun 2021 07:51:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232602AbhFNHxe (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 14 Jun 2021 03:53:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53118 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232608AbhFNHxa (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 14 Jun 2021 03:53:30 -0400
Received: from mail-ed1-x531.google.com (mail-ed1-x531.google.com [IPv6:2a00:1450:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D9A3BC0613A2
        for <linux-trace-devel@vger.kernel.org>; Mon, 14 Jun 2021 00:51:14 -0700 (PDT)
Received: by mail-ed1-x531.google.com with SMTP id s6so45190070edu.10
        for <linux-trace-devel@vger.kernel.org>; Mon, 14 Jun 2021 00:51:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=+arG/TI83+6RRm6R28kM8v5MCinHpDND+5u8cLV9aC0=;
        b=de+Yq16lU+D5lLpd8UnrQURXa+1OxCLD6FZRP/3MsKEc8NdtbSwRkyPWGLBJdf0bYT
         Az2TqaRcV8UxNriQbAqYo5PyFonJETUGPBZbETuLKFfuyZpBFr6nILTKmFcoAwXfUqa9
         J9xmWKRhRyNFTjmYhx7bVPww8CbvUj4kWQGQEj3nERMvyTY/SgqLpJGdxbePN1n5V7Y4
         mJcs+CCOB+2ipcceRLFjYWM3co+Z6wNN3oUN4DxiEhdSiSg9lzD2tylHiHZz5OE8k5b4
         trzcUk8aJYtvIXwmqoNr//kDpvWe+OG38Nc0mLn8/RbZRhXwFRhR+hQX8uv/tofwqgjM
         a+hQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=+arG/TI83+6RRm6R28kM8v5MCinHpDND+5u8cLV9aC0=;
        b=NPIOrvSqYdHAcaDr57JgXyimzipFBlfclH7fDPTgOodgZgrlRsxQNVWoTqMnHyujkZ
         YPzpZLTal6wqYBEMjy4avhndqZKsSTGVz/zD71EDgkCchxVjkUubefgerbFVR1npsPiQ
         sF/HhrqkMgwsIDjKFydTQTr8tCKWDGi22un2OJSSg9tzX4DF+N3Y4x/FWiqjA1klcPpq
         /fQmMPjBWBSek1iVSaV70grc+w7LEgxddODE0zrAoKS2dM2YfdLPT/nyWFx3TJP6qmpg
         fyvDOjvcLYvsaF0XY3emYGqhx4oDEldoq5wanyaBmGpGvGZmD1uaXKzLUAY7uNoPZvU6
         unMA==
X-Gm-Message-State: AOAM530YmesOTnexRtzqqt4dYIy08VDQm80gIxMcQmItuAe7yZiixSJk
        QstLbMQHrB0ztpoopGUtUKY=
X-Google-Smtp-Source: ABdhPJwzMdpgagElqq9NpVLQC4ZEUB0079fiLvNC+Xf3TZM+tmoYq6zNiVykOWIpkLWVGHQFp+jVjQ==
X-Received: by 2002:a05:6402:b5a:: with SMTP id bx26mr15163160edb.81.1623657073489;
        Mon, 14 Jun 2021 00:51:13 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id f6sm6536444eja.108.2021.06.14.00.51.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Jun 2021 00:51:13 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v6 44/45] trace-cmd list: Update the man page
Date:   Mon, 14 Jun 2021 10:50:28 +0300
Message-Id: <20210614075029.598048-45-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210614075029.598048-1-tz.stoyanov@gmail.com>
References: <20210614075029.598048-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Added documentation of the 'trace-cmd list -c' parameter in the man
page.

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 Documentation/trace-cmd/trace-cmd-list.1.txt | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/Documentation/trace-cmd/trace-cmd-list.1.txt b/Documentation/trace-cmd/trace-cmd-list.1.txt
index a5c6b16c..b77e3460 100644
--- a/Documentation/trace-cmd/trace-cmd-list.1.txt
+++ b/Documentation/trace-cmd/trace-cmd-list.1.txt
@@ -71,6 +71,9 @@ OPTIONS
     List defined clocks that can be used with trace-cmd record -C.
     The one in brackets ([]) is the active clock.
 
+*-c*::
+    List the available trace file compression algorithms.
+
 SEE ALSO
 --------
 trace-cmd(1), trace-cmd-record(1), trace-cmd-report(1), trace-cmd-start(1),
-- 
2.31.1

