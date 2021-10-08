Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AB069C433F5
	for <linux-trace-devel@archiver.kernel.org>; Fri,  8 Oct 2021 04:29:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 80D7661090
	for <linux-trace-devel@archiver.kernel.org>; Fri,  8 Oct 2021 04:29:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231658AbhJHEbI (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 8 Oct 2021 00:31:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51840 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230014AbhJHEbH (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 8 Oct 2021 00:31:07 -0400
Received: from mail-ed1-x52f.google.com (mail-ed1-x52f.google.com [IPv6:2a00:1450:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C550BC061570
        for <linux-trace-devel@vger.kernel.org>; Thu,  7 Oct 2021 21:29:12 -0700 (PDT)
Received: by mail-ed1-x52f.google.com with SMTP id d3so3940433edp.3
        for <linux-trace-devel@vger.kernel.org>; Thu, 07 Oct 2021 21:29:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=NTWu+vFpsDeNnJuppD5tCV7NXhkyq/DnWG49oEjNH0g=;
        b=eSDMW5wX3l8zByxv9S8yUDxGcD0Ve2N7lhjPT26f/JjcDqmGWFMI6SKYWXltFw2Biq
         EV9q3Ewrc8X1CNxTS8E+cVZ+IqYkqBKem4wsumll25rcrOsXTACjj+KUkdDQGQyue8zY
         7tn3G0m1O8UhG2Kmbc8yaThQtrQRFkXn6JzlUsBJr5jNwnqL4vEbaZPwGrYDn3DV58ZF
         r5mRm6p3vw5j6W2H63b+r5jl8YvyAdszWr540N3kBImqulfOF4rEcWOxUPO9cvDefLVc
         rRy/T4GSqfFhLymplJrUHNoOgqkW9r7kLnYK6S+tDJxR6QBOUpJhTgmwmJt0PokRMVHT
         CO7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=NTWu+vFpsDeNnJuppD5tCV7NXhkyq/DnWG49oEjNH0g=;
        b=A7NhLjpl6ziSn0rt7uG/PHX6QPwfKii92iRbV+3caS7+KosldFvZnjrFf++RrL24I3
         7IfALFF9BonHYqC3TLUGGqRLKiIyGDDdnUJ/+f0gQ/VPzR7SZ0QvdFjCu7sz1VLAUf0Y
         RdPtGzuEIbNOS8EHS1mNQNIDCv//mQm6chcgd0iLei9MBqPCtpmDhHShz4+KMYeV/4Th
         ToRz19zm7M6tRyM7Fw/OPUywgDTOo9tMKPQKoWbVo4Pg8ZW7boOxMUzUczjaQ39O/Ejl
         z/tX6kvISs8ekBA5kirkmsVyg6ca5ECwKfqhNd+0sLITvugRgyJoZiIwaONQAqPcVqa3
         2AUg==
X-Gm-Message-State: AOAM532lBlKfkdzbCbhDNWhuiVElW3cBN19slswGgdNNlL8nUcIakxue
        81McbR+H0+ShpB2054zk72j0aTPKMHrtLQ==
X-Google-Smtp-Source: ABdhPJy4GK1oxrurSxNgfBrP4B7Ik93aIJwCxmvbGZO/HIkuupYj9LP1xoihWUCds0M4J/DhnODobg==
X-Received: by 2002:a17:907:2bec:: with SMTP id gv44mr1261549ejc.523.1633667351362;
        Thu, 07 Oct 2021 21:29:11 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id j11sm456662ejt.114.2021.10.07.21.29.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Oct 2021 21:29:10 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v3 0/4] trace-cmd documentation update for v7 files
Date:   Fri,  8 Oct 2021 07:29:05 +0300
Message-Id: <20211008042909.979877-1-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Added documentation of trace file version 7.

This patch-set depends on "[PATCH v3 00/10] trace-cmd dump - v7 update",
should be applied on top of it:
 https://lore.kernel.org/linux-trace-devel/20211008042701.979075-1-tz.stoyanov@gmail.com/
  
v3 changes:
 - Rebased on top of the latest master.
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

