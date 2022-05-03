Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6119CC433EF
	for <linux-trace-devel@archiver.kernel.org>; Tue,  3 May 2022 06:49:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229654AbiECGwd (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 3 May 2022 02:52:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41882 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229454AbiECGwd (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 3 May 2022 02:52:33 -0400
Received: from mail-ej1-x62d.google.com (mail-ej1-x62d.google.com [IPv6:2a00:1450:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F21C37031
        for <linux-trace-devel@vger.kernel.org>; Mon,  2 May 2022 23:49:01 -0700 (PDT)
Received: by mail-ej1-x62d.google.com with SMTP id gh6so31717942ejb.0
        for <linux-trace-devel@vger.kernel.org>; Mon, 02 May 2022 23:49:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=pEl2Q4IIZ8M0Nq6g2j5nglH7TGt6D1gyPpc5eGm9KLo=;
        b=G2SWrP+PhynlbOFbpA3z527SFx0BA6nCTImZAY1QCjSawgk3AO5XS5Sd/Wq3rzyUp+
         /P5pXpT27SHgrnk2dfzsfZYYeH5d7cl6npDL5t+NQorQ543lY9Wcl4es80w8A7wjZQ4t
         EpkTrseSGv0SIeFRnSEfgTlmi+FFOd43zxEz0cg0S00ud/UuBltfQ6vLGezhHlghbyVv
         YU6PvJ8m0konvxDwCdpuo4nDgG1rjTlpIfT36/b6wnMLz6w9BNUEr9Y26kq2oi1KZ6QT
         1xFTTVh0J90iguyF85ms5+35FUxsiZCdzjBwUGxWbF/l9a4asKs8VjwZvbiD/aK/OGr0
         QrUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=pEl2Q4IIZ8M0Nq6g2j5nglH7TGt6D1gyPpc5eGm9KLo=;
        b=g/oFaG75YsUmFbXXIw8IodTMJEPQr4ICJ3WeG28QloPDQVjbUdQZ8Cns540QGEG92b
         w0w+jNiDRc5lqFfdRuh4p300txr9Mq4vwvSoJA/H3bSAher1cHF5nssiQrLzC8t9SeA+
         JKJYvvTqmX5NnyHwRcbM9fbiejiH6LE1x+siKhA47RL0K1jfTJFFfzFvNvaLZrfd91g+
         vZAZOpzn55B0MPTZLjmLasEhDcECTxP0oPsGl0X48dr9fn4pyStRXAHPswJMAKjAS640
         EKMdAWc0gMt9mZovnGdbfd4tpXSs82+HV1ZBUaKm/QR0A7nsOUXYg7GFa8zTIG/LS39m
         0zSw==
X-Gm-Message-State: AOAM531ASdcZOXBa2PyGS4L8T7KTAQRqOkzMH8i0T1keAAqE2G1ODzsF
        KfJtKSHAGJt9wMXpy0VlE1acr/fRa2fPVw==
X-Google-Smtp-Source: ABdhPJyO9Aeh+sZ1DdSt8V16UZSS5gcUeyTseBYY23bBCKyyrt29O4M1TtlqLnrldUyFAKDuVub6eg==
X-Received: by 2002:a17:906:dc8a:b0:6e0:94bf:1ec3 with SMTP id cs10-20020a170906dc8a00b006e094bf1ec3mr13926437ejc.447.1651560539960;
        Mon, 02 May 2022 23:48:59 -0700 (PDT)
Received: from oberon.zico.biz.com ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id e26-20020a170906845a00b006f3ef214e6csm4288457ejy.210.2022.05.02.23.48.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 May 2022 23:48:59 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     y.karadz@gmail.com
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH 0/3] trace-cruncher: Small fixes
Date:   Tue,  3 May 2022 09:48:54 +0300
Message-Id: <20220503064857.260937-1-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Fixed problems, found by github CI automatic workflow.

Tzvetomir Stoyanov (VMware) (3):
  trace-cruncher: Add define for bool type
  trace-cruncher: Update github workflows
  trace-cruncher: Add object files to gitignore

 .github/workflows/main.yml | 2 +-
 .gitignore                 | 1 +
 src/trace-obj-debug.c      | 1 +
 3 files changed, 3 insertions(+), 1 deletion(-)

-- 
2.35.1

