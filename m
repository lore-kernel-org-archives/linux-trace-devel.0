Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 321FCC433F5
	for <linux-trace-devel@archiver.kernel.org>; Mon, 13 Sep 2021 12:53:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 172CC6103B
	for <linux-trace-devel@archiver.kernel.org>; Mon, 13 Sep 2021 12:53:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235037AbhIMMym (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 13 Sep 2021 08:54:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52378 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235976AbhIMMyl (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 13 Sep 2021 08:54:41 -0400
Received: from mail-wm1-x330.google.com (mail-wm1-x330.google.com [IPv6:2a00:1450:4864:20::330])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D5F18C061760
        for <linux-trace-devel@vger.kernel.org>; Mon, 13 Sep 2021 05:53:25 -0700 (PDT)
Received: by mail-wm1-x330.google.com with SMTP id 140so3157164wma.0
        for <linux-trace-devel@vger.kernel.org>; Mon, 13 Sep 2021 05:53:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=KOIjXBKUfGTbC/mp/XYapaTz16mHI7e5VHKWIblobzY=;
        b=MYJAMBVLVxNiKC0NvUuhU5cJqe2wWvi+2gjiIKTLp5tvbdx6KRXn1d/RE3pUs7zslL
         97rteFEhStwjOSJl5k/7sjKtkdfrc8PfB+vtokJHUCIEgtkfPViku5NzHhMFqDPVa+tM
         hvWvLNlcfqhM/zuM9lzRxibr6bGA8Mh7q78qjnzpM6yQpFh7sQ1PBjwqpNGtqOHmKkK1
         w23ytg92AtLl2a9dchNDVyR5vo4H8cob+xgcqDYWBxD4C2BuJEKwQrf+9i8DBZzBjXSG
         ecC6UdHHdP57Tm2+kJ2zWq1uSmV8XjxXr4/Yt1noq3o2rWs2w8MazgCq3IW0dPF++Ggj
         w3dg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=KOIjXBKUfGTbC/mp/XYapaTz16mHI7e5VHKWIblobzY=;
        b=U2A/aR3GjuZsODzXRfb0N96YVNe2C/vbVyb2mDGkP23pDGt4BX72lKk4HjZCSEuPsH
         ZmYO2rbz/IF2wh2W3U+Q1tReIIFIo/n/iSZZ5JuGIRogqfIUDviXzVHasVuXnTwgldsu
         El7BJ5ryNrqn40kickfaKYX+bsQ690hPf9o1nGcMl0yH/0iMONy1A+ItGBg6VYm6xghr
         HRBQ0+rbFhn+DOWTtl9eNEcW3cC80gOHt74TzFfuz8r9tazVBAwtCQ/YWGI8jDIjARB1
         tqMHbVYEDkTCqcdOLfypfy/3FU64ZTMvFUhxkLEQYuu+GKsU7hpCFmBaLBO80HxTYdF+
         JjSw==
X-Gm-Message-State: AOAM530/7Ira6CzuJ8oeHBoxOe+nxpHg9yxktjogxTEPAsy1bbkpzKld
        daUyvCYUv0tHPtJhURL7O4XA/QLd5h8=
X-Google-Smtp-Source: ABdhPJyZvq/W/f4KOT+wAJkvcuGf79E8ArYqO8JlqXGNamym8lFRev0ztoefQkneTYPNlrgU9t3H+A==
X-Received: by 2002:a05:600c:22ca:: with SMTP id 10mr10870056wmg.170.1631537604536;
        Mon, 13 Sep 2021 05:53:24 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id u8sm7280552wmq.45.2021.09.13.05.53.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Sep 2021 05:53:24 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH 0/4] trace-cmd documentation update for v7 files
Date:   Mon, 13 Sep 2021 15:53:18 +0300
Message-Id: <20210913125322.3682097-1-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Added documentation of trace file version 7.

This patch-set depends on "[PATCH 00/10] trace-cmd dump - v7 update",
should be applied on top of it:
 https://lore.kernel.org/linux-trace-devel/20210913125039.3680986-1-tz.stoyanov@gmail.com/

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

