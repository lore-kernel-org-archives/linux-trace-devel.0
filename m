Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 69BEDC433F5
	for <linux-trace-devel@archiver.kernel.org>; Fri, 10 Dec 2021 11:07:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232014AbhLJLKw (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 10 Dec 2021 06:10:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37398 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231253AbhLJLKw (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 10 Dec 2021 06:10:52 -0500
Received: from mail-ed1-x536.google.com (mail-ed1-x536.google.com [IPv6:2a00:1450:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 719F2C061746
        for <linux-trace-devel@vger.kernel.org>; Fri, 10 Dec 2021 03:07:17 -0800 (PST)
Received: by mail-ed1-x536.google.com with SMTP id l25so28950031eda.11
        for <linux-trace-devel@vger.kernel.org>; Fri, 10 Dec 2021 03:07:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=umh05rtjFSBc1m9bDVUylyBtCt5+DX74zfzrQwZV+Tc=;
        b=KtDBioa7Y21os7eno8c7Na1gqzKvL2Lzb55LznyyLA2honVIqs1pRZLcxnw/Hpjzso
         abNcwtmSUAd4pmHKMpGYBFUfUxUf+N6j73PJkdvr0R4B2x8Px3nrLIPdFCUrKO7+SUKc
         j5flohFrJM/NMCbhOk/dhUaARVwMgU3jP9xW6H8pCKOqqM7/yVRJTZJH1vwINr/LKvMs
         8/kV0bQKYhuc1d8vw2lmnhn0ss3qB61X/b5YPTCc5G2kcj5grVkn8QsTSaLlIA+FVw7K
         v2fqz+X3ezqqpISrNa4/TkdCtsNlbg4W8PgyXixavSeEOcnxozyuLqznlKe5qZMmU9Kq
         e89w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=umh05rtjFSBc1m9bDVUylyBtCt5+DX74zfzrQwZV+Tc=;
        b=gCcJsO+atCquX/kJPs5+XflhXZU+WGPTkg1lbRJQsVdcpjWKk9e0lg6w3UtYrEOCy9
         CH4/vWetZTdOablFm+KfemsCUIk5yly4p3ZS9eMYzxi7Ed4rT7GouUW7c7y2HkFpYCD3
         UScs2zOauJ4CkDrqpd1ZxIcNlld1xW7DoBz/Aj/8ZJJlTjUR7vn0zSnzT2uWQDSHu389
         t90hkxNipDasLU8Ug0vufZI3FS5AX1Tl84cGm8AEVmM/tPR/GXvrX6khApCzfeVk8sh7
         ew2bvaXg/mo3NJ3UcQtDAIxZCugjEMMhJfiv02+m/Hb74zlfHku1+I/5t2tdldFfHOn1
         pb9w==
X-Gm-Message-State: AOAM5322jySXEjIzmBbm+1xQQb+KUt+C/O1KI2mxdhtkOFB+dv21/pGK
        Oxq/1aBYD193rhTcDO12n2w5vUhZCnY=
X-Google-Smtp-Source: ABdhPJxG3puJ6/IlA9DpqVSDInuTsgushBAmXZeURkmgjK8Jhz5D45i6WI3A77Xp99BAYT/oO2QImg==
X-Received: by 2002:a17:907:720b:: with SMTP id dr11mr23605476ejc.93.1639134435996;
        Fri, 10 Dec 2021 03:07:15 -0800 (PST)
Received: from oberon.zico.biz.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id w5sm1299236edc.58.2021.12.10.03.07.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Dec 2021 03:07:15 -0800 (PST)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v6 0/4] trace-cmd documentation update for v7 files
Date:   Fri, 10 Dec 2021 13:07:10 +0200
Message-Id: <20211210110714.99067-1-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.33.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Added documentation of trace file version 7.

This patch-set depends on
 "[PATCH v6 00/11] trace-cmd dump - v7 update"
 https://lore.kernel.org/linux-trace-devel/20211210110511.98856-1-tz.stoyanov@gmail.com/

v6 changes:
 - Rebased on top of the latest master. 
v5 changes:
 - Rebased on top of the latest master. 
v4 changes:
 - Rebased on top of the latest master.  
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
2.33.1

