Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 34349C55ABD
	for <linux-trace-devel@archiver.kernel.org>; Thu, 12 Nov 2020 09:11:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CCFE7216FD
	for <linux-trace-devel@archiver.kernel.org>; Thu, 12 Nov 2020 09:11:15 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="hmzFCUqT"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727654AbgKLJLP (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 12 Nov 2020 04:11:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37766 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726725AbgKLJLN (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 12 Nov 2020 04:11:13 -0500
Received: from mail-wr1-x42a.google.com (mail-wr1-x42a.google.com [IPv6:2a00:1450:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D50DC0613D1
        for <linux-trace-devel@vger.kernel.org>; Thu, 12 Nov 2020 01:11:12 -0800 (PST)
Received: by mail-wr1-x42a.google.com with SMTP id 23so5154408wrc.8
        for <linux-trace-devel@vger.kernel.org>; Thu, 12 Nov 2020 01:11:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=2b3JiwpRarVNWxGZcuoCzu3nFOcrh+GkF9zBr4kNLJY=;
        b=hmzFCUqTiel8hMp7VP1niebKnFGh+/Npg/E60d9BUG1AI9RZdM/rIfTHc5soYAgyzW
         +CrsK999YAyYrj+3i2GkjZaTJDC9aGuRSFcoNYmdfokhCVPDNLi1l3c48CZEekWc9Qpq
         HyaxOKOLcJ0S1x9judjtLtC2v8Qj6ducmHzfGbvRpYm5xB9C6/bQCXKqvcqW7KPsrc1g
         4KD2ptt5KnVg7SNhQdEPqxMDx00JwjQVDyf8baU5F8F/jUtNoc4uAVXCRE+mMLNM3Y8x
         88kEkOd3oqy/nebpoJw/C5J+31CJXR/Y2R68khGjGFISUgeUmj97k0MMlv6KyriMxyGx
         9dcg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=2b3JiwpRarVNWxGZcuoCzu3nFOcrh+GkF9zBr4kNLJY=;
        b=fMuBsJsNb+5kNQ5mb8afTxwcnXVo+TKid6i6zLu/vUGKGAhkmmQqKLhE8OQvKFZiee
         uomQRDpikHcKdmNDMiZyEDhqdZ20XuKr0a2mmO0bDbMcqrPFq6shOYldUGVICageYh9L
         d/e6JY+Y+d26dv5tcFtGyVefU8JM5wnD1mU0BDl6Cl4XTPDJg3cXK851VeLAii+BDgkV
         LyZUHbTyW3SBo4DDsRFGyOFg1Diqvxgytl6WvrUgO21M7R3SgIdim4GqLLrnQN0D9DCS
         O+a156bCAu6Sv4Rk4hbMUHgc8xlswAsfIVzRqMIbvefrT10l+19hXYcdh/t43V00V23n
         7Z1Q==
X-Gm-Message-State: AOAM531vhMqpeKvEQGPZqh/UhWY/YlHmQlTFxuI4/cTufefHSVpLNl4y
        2XaC/jSFcsnCF2SindSWy+EH4GbQvNmNodWd
X-Google-Smtp-Source: ABdhPJwcDMK0ih7vNBWPBvL6pcQCQUMen/EeMMpPCIads5IuROdp743jKirfPDpNbh72FwadBMO/lg==
X-Received: by 2002:adf:97dd:: with SMTP id t29mr35373708wrb.185.1605172271233;
        Thu, 12 Nov 2020 01:11:11 -0800 (PST)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id r18sm6705718wrj.50.2020.11.12.01.11.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Nov 2020 01:11:10 -0800 (PST)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v3 0/6] libtracefs fixes and improvements
Date:   Thu, 12 Nov 2020 11:11:03 +0200
Message-Id: <20201112091109.1239169-1-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.28.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

A few final tracefs library fixes and improvements, before releasing it as
an official library.

v3 chabges:
 - Addressed Steven's comments.
v2 changes:
 - Change tracefs_instance_create() to return pointer to allocated trace
   instance structure
 - Add new API: tracefs_instance_is_new() to check if the trace instance is
   newly created by the library.

Tzvetomir Stoyanov (VMware) (6):
  trace-cmd: Change tracefs.h include path
  libtracefs: Change get name API to return constant string
  libtracefs: Add new API to check if instance exists
  libtracefs: Combine allocate and create APIs into one
  libtracefs: Add new tracefs API tracefs_instances_walk()
  trace-cmd: Add new libtrasefs API to get the current trace clock

 include/trace-cmd/trace-cmd.h       |   1 +
 include/tracefs/tracefs.h           |  10 +-
 lib/trace-cmd/trace-timesync.c      |   3 +-
 lib/tracefs/include/tracefs-local.h |   1 +
 lib/tracefs/tracefs-events.c        |  26 ++---
 lib/tracefs/tracefs-instance.c      | 173 +++++++++++++++++++++++++---
 tracecmd/include/trace-local.h      |   4 +-
 tracecmd/trace-record.c             |  72 ++++++------
 tracecmd/trace-show.c               |   2 +-
 tracecmd/trace-stat.c               |  83 ++++---------
 utest/tracefs-utest.c               | 107 ++++++++++++++---
 11 files changed, 327 insertions(+), 155 deletions(-)

-- 
2.28.0

