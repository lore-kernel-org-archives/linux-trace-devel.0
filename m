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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 23167C433DB
	for <linux-trace-devel@archiver.kernel.org>; Wed, 23 Dec 2020 04:23:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E20A0207B1
	for <linux-trace-devel@archiver.kernel.org>; Wed, 23 Dec 2020 04:23:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727029AbgLWEX1 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 22 Dec 2020 23:23:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54864 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726969AbgLWEX1 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 22 Dec 2020 23:23:27 -0500
Received: from mail-wm1-x331.google.com (mail-wm1-x331.google.com [IPv6:2a00:1450:4864:20::331])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 003ABC0617A6
        for <linux-trace-devel@vger.kernel.org>; Tue, 22 Dec 2020 20:22:23 -0800 (PST)
Received: by mail-wm1-x331.google.com with SMTP id 3so4954164wmg.4
        for <linux-trace-devel@vger.kernel.org>; Tue, 22 Dec 2020 20:22:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=fJ2i5w1Bs+SXxQG8ein0W4BhCVYatyYeWSf8K7cFpEw=;
        b=IBxbDg+uCj/PCcQHH5VYI8EvEBf1dLxlAau+S6wXs8Thx1+bMx4dCk+U2D0Ir816nN
         yS4WzDMKieFonwVorthkoFSGt9wtvTiYiIyaaxeNgPGxjTTmRXzbryZL2WIcS9++yJDH
         59h48X7/jE6EMYgf65w7CR9ZpzUpntHjLYwNh3lyZN3BdAEnp3MDdIFcFFFWMP+JSper
         cB4CnFvwKFUDDXzB3SKG1qJxv/AMt4d4aix8dmR7C79BjHLF26uTq9Xte6N016l5i9q7
         iEcTk3IGdzbIiQnKkuACwain8dqePtB0DvTQ9tu61X6LvOdEUMQhj36qxKJ9S8zAfN9f
         lssg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=fJ2i5w1Bs+SXxQG8ein0W4BhCVYatyYeWSf8K7cFpEw=;
        b=rmlJfyTu4ikCReVEJTCUlLt8aJqkKiIQX3BPuZG2oxAIqqhculPNF2kVQb5jUGdD71
         Tk5uaJos2dwaeVhA6Zf1BjxKOYZo5ZtzmiHzXM9o460PND4kfW/BKb1TMpUSifi657P6
         KTNNB7fw30jTJDnlhm+NFeu3KxPYVcLxiAVkHb8/sY61gc+NrfKz0G+kF5kIM6nR3tGs
         lItaxcTq3KhuMB++ET+f7XjJYenlseLc3+LlYEZYOVFVOpUK2z5Ve301BC77wfYcMxzH
         7Yde0sqifHgjLbaOidQhDzM9oZ96uEYYwTVZvtmEUyFrKXjiXChLXxEEj1M15w6SOx6a
         EzxA==
X-Gm-Message-State: AOAM532YBTUKjY+FkveVL3tIg1GrqvBAJMNhh7YPLx/Xl6VhiwjS+q+H
        f6jPJ6wgPxPtyC2JmJIco3Y5J778IG+bfpNv
X-Google-Smtp-Source: ABdhPJwN3W4nS4qjbGTB1JUkq2leCgieedajhIG0z/oreeMNYNvPfQQgv5k95BhVe18/ANc2jz+8iQ==
X-Received: by 2002:a7b:c5d6:: with SMTP id n22mr23927411wmk.70.1608697342825;
        Tue, 22 Dec 2020 20:22:22 -0800 (PST)
Received: from oberon.vmware.com ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id a25sm24594001wmb.25.2020.12.22.20.22.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Dec 2020 20:22:22 -0800 (PST)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH] trace-cmd: Add new libtracecmd API tracecmd_unpair_peer()
Date:   Wed, 23 Dec 2020 06:22:20 +0200
Message-Id: <20201223042220.582558-1-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.28.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

The tracecmd_unpair_peer() is exposed as official trace-cmd library API.
It is used to unpair a tracing peer, previously paired with
tracecmd_pair_peer().

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 include/trace-cmd/trace-cmd.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/include/trace-cmd/trace-cmd.h b/include/trace-cmd/trace-cmd.h
index 75352309..7dc88cb0 100644
--- a/include/trace-cmd/trace-cmd.h
+++ b/include/trace-cmd/trace-cmd.h
@@ -15,6 +15,7 @@ struct tracecmd_input *tracecmd_open_head(const char *file);
 void tracecmd_close(struct tracecmd_input *handle);
 int tracecmd_pair_peer(struct tracecmd_input *handle,
 		       struct tracecmd_input *peer);
+void tracecmd_unpair_peer(struct tracecmd_input *handle);
 
 int tracecmd_init_data(struct tracecmd_input *handle);
 struct tep_record *
-- 
2.28.0

