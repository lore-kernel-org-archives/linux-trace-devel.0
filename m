Return-Path: <SRS0=0fRq=77=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 99899C433E0
	for <linux-trace-devel@archiver.kernel.org>; Thu, 18 Jun 2020 08:53:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 730612166E
	for <linux-trace-devel@archiver.kernel.org>; Thu, 18 Jun 2020 08:53:49 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="U74J8NPy"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728774AbgFRIxp (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 18 Jun 2020 04:53:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59818 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728823AbgFRIxj (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 18 Jun 2020 04:53:39 -0400
Received: from mail-wm1-x333.google.com (mail-wm1-x333.google.com [IPv6:2a00:1450:4864:20::333])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B28C7C06174E
        for <linux-trace-devel@vger.kernel.org>; Thu, 18 Jun 2020 01:53:37 -0700 (PDT)
Received: by mail-wm1-x333.google.com with SMTP id d128so4785606wmc.1
        for <linux-trace-devel@vger.kernel.org>; Thu, 18 Jun 2020 01:53:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=E4SdGtLYJm2mdv9p5jmEvcwW1WOLXPGK7x9a5WUhpcw=;
        b=U74J8NPycPni8fz5wKo5lYN/82L21kCVjDYpN8r4+Xy4Or99MELCx6Yfnj/bv8HT5S
         MipeXgO0Lc054+UBaUnOnPXXyoujVFsgEbIM38kPfzBYOHXcf/ZJzPpKfXqrHp7Tb99+
         uenGGsVdn9u8f2mM9bQgRL3yguk1I6tqgipMNguWmzA9P/zLH6xVa65cEbfROj85L6DV
         nce+rsPoZ58rPDRMaAytQ+Y4yfyfXldM5bzWAqcrd1UwAZuZNwF6vqQAUo4j2L5n16dV
         bXmbIdRCbH/Ey3EqJRRfebPwA57RsDMYCBfdxR0mRDywOa5QkRpiwIaUe2iW0hJVsQsR
         kV4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=E4SdGtLYJm2mdv9p5jmEvcwW1WOLXPGK7x9a5WUhpcw=;
        b=i/l5lYMOX2VSUtCMyedzVv14JEOkRZ5TAJABVdHY120RX4icquuBCDjYDvUaZa6SQ8
         kPnM8sMELazMqfQ+nKwUCuEfbK/rSDYbT/WUqEUV8DQJUzFxCOMYaGF3FPCcGWmzh+md
         XnGOFFwK0bxQWsbUlHNAQOcN5m9czKFI2eezHAL5uwzDq9VcRcXLGkCAked9f+clVSfe
         J3xymvawBN/8mp2K+xDbmxn21btmAzYCmTf+JKw5VTL7wQ4jlnVR43jb5kAo6gnpH7xh
         Ce3MWs+VqEQLu5ZlDMO6WEHn66cl8jsgCDXUJyPGXS1uqDbLQL6PRh6s6EbA78/OdgJy
         eFRg==
X-Gm-Message-State: AOAM533jHkis+Z2irRTvEg/3RKeY2JpQLT/6999k1N/AmQDvF15LOGto
        S/Xfgfe2UoGaNNi23+15SYLo0h3UFVg=
X-Google-Smtp-Source: ABdhPJx0T8ZiwIAlhGg5GSrLVeGE0Vf4wjbyV65FwSTBOFKwICfkyuNqS/d7Qd5B28bSlYEJdXuueQ==
X-Received: by 2002:a1c:188:: with SMTP id 130mr2915455wmb.93.1592470416330;
        Thu, 18 Jun 2020 01:53:36 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id a1sm2808231wmd.28.2020.06.18.01.53.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Jun 2020 01:53:35 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v2 0/2] POC] Add support for uprobes
Date:   Thu, 18 Jun 2020 11:53:31 +0300
Message-Id: <20200618085333.164150-1-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Initial trace-cmd support for ftrace uprobes.

v2 changes:
 Addressed Steven's comments of "trace-cmd: [POC] Add APIs for extracting
 DWARF information from a file" patch

Tzvetomir Stoyanov (VMware) (2):
  trace-cmd: [POC] Add APIs for extracting DWARF information from a file
  trace-cmd: [POC] Add support for uprobes

 Makefile                                |  19 ++
 include/trace-cmd/trace-cmd.h           |  24 ++
 lib/trace-cmd/Makefile                  |  12 +
 lib/trace-cmd/include/trace-cmd-local.h |  13 +
 lib/trace-cmd/trace-obj-debug.c         | 348 +++++++++++++++++++++
 lib/trace-cmd/trace-uprobes.c           | 390 ++++++++++++++++++++++++
 tracecmd/include/trace-local.h          |   2 +
 tracecmd/trace-record.c                 |  79 ++++-
 tracecmd/trace-usage.c                  |   4 +
 9 files changed, 890 insertions(+), 1 deletion(-)
 create mode 100644 lib/trace-cmd/trace-obj-debug.c
 create mode 100644 lib/trace-cmd/trace-uprobes.c

-- 
2.26.2

