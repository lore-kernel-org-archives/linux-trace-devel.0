Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9FB76C433F5
	for <linux-trace-devel@archiver.kernel.org>; Tue, 14 Sep 2021 13:23:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7D022606A5
	for <linux-trace-devel@archiver.kernel.org>; Tue, 14 Sep 2021 13:23:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232862AbhINNY6 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 14 Sep 2021 09:24:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50940 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232762AbhINNY5 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 14 Sep 2021 09:24:57 -0400
Received: from mail-ej1-x62b.google.com (mail-ej1-x62b.google.com [IPv6:2a00:1450:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 668C3C061574
        for <linux-trace-devel@vger.kernel.org>; Tue, 14 Sep 2021 06:23:40 -0700 (PDT)
Received: by mail-ej1-x62b.google.com with SMTP id h9so28931773ejs.4
        for <linux-trace-devel@vger.kernel.org>; Tue, 14 Sep 2021 06:23:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=0/BtKhkbD9K3IXSFfQayrcMLLSlDuVUVsW6Pxdpz42M=;
        b=WLJ9YesaniQNxGfWHocmh3Gjbzye3EvKZFhz8yOKREbkurokcNrbbEVBSJgQjNcM2j
         N87UqpWLLkVVNKZJPHFEXx/Myh57UPBscrR7v5P4AOE9+H/9RbFLU4l+Q/70YS0Ux9se
         TPOMGuwbxUhXbVttSJEtJUGRhfxMK6ipzLYdW2oSQXcEiNYqC04avMMjG/6bKrdlCBNC
         gsPg78J/2cnjjbxiqAKs26/vyErIRpIBPpOTuCMOQ0UZrdQQbPr3q9/qZ376g9fUWufk
         jrKEgvOWyG+0Tycm7cU/KdOHZnxCdzMMD8IPHV9HEHai0M9BLWUAydsUJc6M3Hgp/gt/
         pp6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=0/BtKhkbD9K3IXSFfQayrcMLLSlDuVUVsW6Pxdpz42M=;
        b=y731kyOXUZc899kBmX/9g6KpUVJsHvGufnGuRiO/PeUZlbzQ3YN5znZVcpzOasjHCt
         4ejDlTdrSCXLYG9Gux5T1+RUV3DrywL6beHXLcK+6qxfONbDkLh9tn2t7aDX5LKGwmYl
         MsbN63YvRkb3+Bzzt1Jj0YjMHonARXJAsebnhKkiV7ESm7D7sLZGNkaCsHr0yaM7sJuG
         ItSvtHfi+uH963hwXZEWj+z+LMD5MkCdNOTMXc0Sj61IkrrB8GVvGNy4Biv+i63xLfbr
         AM4hlCr8fBMgfl6JXirzrD3uz7FtMHN7Yjd4CArAgDeMpDuAUANWST1xtHo1To4Q8iv0
         2rnA==
X-Gm-Message-State: AOAM5311UWMUvPcXoz+DyiyYnncaXXD5cRqkSWHumyt7LJIYXSsZvv0N
        eQ7nVB2dh/DKm+jXKTc0RachqCaB/tw=
X-Google-Smtp-Source: ABdhPJyeMvoKNLXmio3sFJzVt8hVfScvVJxfQEALDogX8nqlD6mlbca3ulPOWVuw0u4myUEZBYssIg==
X-Received: by 2002:a17:907:7844:: with SMTP id lb4mr18709594ejc.381.1631625819065;
        Tue, 14 Sep 2021 06:23:39 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id h10sm5689970edf.85.2021.09.14.06.23.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Sep 2021 06:23:38 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v2 0/4] trace-cmd documentation update for v7 files
Date:   Tue, 14 Sep 2021 16:23:33 +0300
Message-Id: <20210914132337.3969125-1-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Added documentation of trace file version 7.

This patch-set depends on "[PATCH v2 00/10] trace-cmd dump - v7 update",
should be applied on top of it:
 https://lore.kernel.org/linux-trace-devel/20210914132148.3968401-1-tz.stoyanov@gmail.com/

v2 changes:
 - fixed issues of split and convert commands with some corner cases

Tzvetomir Stoyanov (VMware) (4):
  trace-cmd: Update bash completion
  tarce-cmd: Man page for "trace-cmd convert"
  tarce-cmd: Update record man page
  trace-cmd: Document trace file version 7

 .../trace-cmd/trace-cmd-convert.1.txt         |  65 +++
 .../trace-cmd/trace-cmd-record.1.txt          |  13 +
 Documentation/trace-cmd/trace-cmd.1.txt       |   4 +-
 ...e-cmd.dat.5.txt => trace-cmd.dat.v6.5.txt} |   9 +-
 .../trace-cmd/trace-cmd.dat.v7.5.txt          | 442 ++++++++++++++++++
 tracecmd/trace-cmd.bash                       |  37 ++
 6 files changed, 564 insertions(+), 6 deletions(-)
 create mode 100644 Documentation/trace-cmd/trace-cmd-convert.1.txt
 rename Documentation/trace-cmd/{trace-cmd.dat.5.txt => trace-cmd.dat.v6.5.txt} (98%)
 create mode 100644 Documentation/trace-cmd/trace-cmd.dat.v7.5.txt

-- 
2.31.1

