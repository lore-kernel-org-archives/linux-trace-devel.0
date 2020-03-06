Return-Path: <SRS0=llO+=4X=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4FC70C10DCE
	for <linux-trace-devel@archiver.kernel.org>; Fri,  6 Mar 2020 09:29:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 214C820866
	for <linux-trace-devel@archiver.kernel.org>; Fri,  6 Mar 2020 09:29:08 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="LhfuLFfc"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726185AbgCFJ3H (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 6 Mar 2020 04:29:07 -0500
Received: from mail-lj1-f194.google.com ([209.85.208.194]:37775 "EHLO
        mail-lj1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726010AbgCFJ3H (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 6 Mar 2020 04:29:07 -0500
Received: by mail-lj1-f194.google.com with SMTP id d12so1479282lji.4
        for <linux-trace-devel@vger.kernel.org>; Fri, 06 Mar 2020 01:29:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=ce1dpyS6bVijvfGbOYmoWkrJqf6mhkuki+GYlZze1Xg=;
        b=LhfuLFfcn+CtksHJy6j3uuq0RBGdAu+Ftrbn9qbs2PXwvCeMADnmeXKBAeqF2VFeZO
         IBfMqGpR6JGpMlCn5gcOUPiar5o2X5loSz/7qGCOthkVugYkW9DaNApkmA5wz+5Lg1y5
         E1QpOR8JRXeNG6lJ2ZRQ4cRW9vhvJcCaYVo68hlnq0wrCcBijOTVeNRqmAc9fh2HuPln
         vQ7ayR6YQte9W4uitnnfD85b4tXxSBTySdtVgrOZ73p5TXhfQXre8+QRB+KCDStR+ugC
         KAuLE5W4ihsb+Gem5wbQzERpihQhdaymalms4A85YE4s6dRW9gLivXIRitJbGgqUh86m
         H5Fg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=ce1dpyS6bVijvfGbOYmoWkrJqf6mhkuki+GYlZze1Xg=;
        b=oBk+x9e64RWvDfxW30pszXQIdTycKNWPd6hzPVDgJcXg29jcxVEOZeGDHWOJc3yRHT
         R7ZVDRqIC1Tmd82MY/EagkEqrAHeNxZ4Fz7daHYvT6tFT/KUN5iCyeKRox5jWlTpTc8v
         RH9f86zMsS/1DP8I6SqrEJ3PnqOVTt7zVIFHj1YYfuTiZW9jFuTGGgPWqV6zhPgtM9nx
         Pjg/cO946b/hjtT4HLOuroyaR8cNnW3xUAinIPjUKso24QdxihnBYbmn5ppZU1NY8V3y
         SYPISaR5QgZSqgtb2StgOiww4ifFC/mLG+t3WYqAEh95fXL1du6ags+NjQ8ZX45BFspt
         nrSg==
X-Gm-Message-State: ANhLgQ33pXlyiULJKVLJ57E1fA49NX+kFNENed3fw6M0MoevHTR53wWX
        NJ1c4IRSfexoz/CCO5Nj/ztkyXmk
X-Google-Smtp-Source: ADFU+vuMgeFmnioKlFT+bVp+7By307rqVpaM7erFUjtaUrW0rUWoQ+T4LF2uOjymtt1cbB3n5Q4GnQ==
X-Received: by 2002:a05:651c:2c9:: with SMTP id f9mr1513622ljo.85.1583486945762;
        Fri, 06 Mar 2020 01:29:05 -0800 (PST)
Received: from oberon.eng.vmware.com ([146.247.46.5])
        by smtp.gmail.com with ESMTPSA id r15sm16750159ljh.11.2020.03.06.01.29.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 06 Mar 2020 01:29:04 -0800 (PST)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH 0/2] KernelShark2.0: Use libtracefs APIs to access tracefs
Date:   Fri,  6 Mar 2020 11:29:00 +0200
Message-Id: <20200306092902.48786-1-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Tzvetomir (VMware)  Stoyanov" <tz.stoyanov@gmail.com>

The tracefs library provides APIs for accessing files from tracefs.
The library is part of trace-cmd, it is installed as part of trace-cmd
installation. KernelShark uses some of those APIs and must be linked with
the library

Tzvetomir (VMware)  Stoyanov (2):
  KernelShark2.0: Link KernelShark to libtracefs
  KernelShark2.0: Use libtracefs APIs to access tracefs

 CMakeLists.txt           |  3 ++-
 build/FindTraceCmd.cmake | 28 ++++++++++++++++++++++++++++
 src/CMakeLists.txt       |  2 ++
 src/libkshark-tepdata.c  |  5 +++--
 4 files changed, 35 insertions(+), 3 deletions(-)

-- 
2.24.1

