Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6AD6BC4332B
	for <linux-trace-devel@archiver.kernel.org>; Mon, 15 Mar 2021 06:19:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3AF5F60240
	for <linux-trace-devel@archiver.kernel.org>; Mon, 15 Mar 2021 06:19:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229748AbhCOGS5 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 15 Mar 2021 02:18:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58158 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229607AbhCOGSY (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 15 Mar 2021 02:18:24 -0400
Received: from mail-ej1-x62c.google.com (mail-ej1-x62c.google.com [IPv6:2a00:1450:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4EAA5C061574
        for <linux-trace-devel@vger.kernel.org>; Sun, 14 Mar 2021 23:18:24 -0700 (PDT)
Received: by mail-ej1-x62c.google.com with SMTP id lr13so64240325ejb.8
        for <linux-trace-devel@vger.kernel.org>; Sun, 14 Mar 2021 23:18:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Vgzz58PdaxNMKx5EEcZo95hs3FRQzxRmIZnkT7jAA2c=;
        b=W1o7uyjaKIPFjX/TwgyxRwVsyiapP5nOmf5y3P2QZjnmapMeLois431ZlRGZ5Mpr2A
         3Cf2ZeUbLb186/BYs19Zn261YtsiYXaThSgkaPMJLdBiYLFeIwRq8+B5a0hyxsJw9sHn
         HXNCM6tmDTb9dwSckg8ee98+UAJuuilS8vqp37YmqT2A+e23c5lShjUYDgnjF+mWEPIQ
         aPL0V02Jv59YX0gTUDKWTEokPekMgZdQh8nzsDtQnzm7rJMJuJm/jOn51S3sB8hCmR0u
         Cpz7jddut2wQoaANFdJdzdd96Ody8luIi6SIH8OirCaGGn1BrW59NSpDTgKtnfZFs5kb
         EY7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Vgzz58PdaxNMKx5EEcZo95hs3FRQzxRmIZnkT7jAA2c=;
        b=cc6eRFf76ycD9r5T664trsdfvgsJs4rTzcJYa16SrQfDk9wr88xjv/kvj1lmXtwRUr
         wWpQZDVfdHPsAtVW8sP+lcVO/5epRYTbKWSOviwryOjkIEYtSD51bv8Y5T1t64NvTOPn
         uJOU07ubVUEXTQ6IO05wLoG3MDdoPsRpifkgofiNhMAJNO9RrnK9FdrK4hnS0hkZWh2+
         oWrPCeBGL0kUBL98mJPOoRuXwlqm8lNZj6EryVOQhEnJ5zq0cZiqfttK7mBQNP8sKP10
         tsXd3hJsi1KlrL0T1b7CH7syc9l5Nze6sugkx1P07lbPmZlg/CpFtL0jK72ZePva+o6H
         l48w==
X-Gm-Message-State: AOAM533x0fEp16lUqaZN5Nm63/lo7ooJD7Cyurjj8R2KdawDJdri/UGH
        6DLhs7xE1IsVcZ7+s+m4nIVXwImkyVSr4g==
X-Google-Smtp-Source: ABdhPJzEUDFEoqa4aX0OnSsz4k5WEijscs7QJJD5lYouu4WPHE9EsN3hVY5MPMpX9DgwtsiPi2raYQ==
X-Received: by 2002:a17:906:1a16:: with SMTP id i22mr21904752ejf.522.1615789103115;
        Sun, 14 Mar 2021 23:18:23 -0700 (PDT)
Received: from localhost.localdomain ([130.185.229.134])
        by smtp.gmail.com with ESMTPSA id nd36sm3575317ejc.21.2021.03.14.23.18.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 14 Mar 2021 23:18:22 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH 0/2] Refactoring and improvements of time sync logic
Date:   Mon, 15 Mar 2021 08:18:17 +0200
Message-Id: <20210315061819.168426-1-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

The logic for host-guest time synchronization is moved from trace-cmd
application context to the trace-cmd library.
Additional logic is added, to ensure the first pass of the
synchronization is completed before starting the trace.

Tzvetomir Stoyanov (VMware) (2):
  trace-cmd: Move time sync logic in the trace-cmd library
  trace-cmd: Wait for first time sync before the trace

 lib/trace-cmd/Makefile                        |   2 -
 .../include/private/trace-cmd-private.h       |  33 +-
 lib/trace-cmd/include/trace-tsync-local.h     |  16 +
 lib/trace-cmd/trace-timesync.c                | 517 ++++++++++++++++--
 tracecmd/Makefile                             |   3 -
 tracecmd/include/trace-local.h                |   5 +-
 tracecmd/trace-agent.c                        |  19 +-
 tracecmd/trace-record.c                       |  70 ++-
 tracecmd/trace-tsync.c                        | 294 ----------
 9 files changed, 579 insertions(+), 380 deletions(-)
 delete mode 100644 tracecmd/trace-tsync.c

-- 
2.29.2

