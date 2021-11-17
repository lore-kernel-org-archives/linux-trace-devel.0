Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 16643C433EF
	for <linux-trace-devel@archiver.kernel.org>; Wed, 17 Nov 2021 15:41:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id ECB3B613D3
	for <linux-trace-devel@archiver.kernel.org>; Wed, 17 Nov 2021 15:41:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238587AbhKQPoN (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 17 Nov 2021 10:44:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45424 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238532AbhKQPoE (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 17 Nov 2021 10:44:04 -0500
Received: from mail-wr1-x42b.google.com (mail-wr1-x42b.google.com [IPv6:2a00:1450:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 70B5DC061764
        for <linux-trace-devel@vger.kernel.org>; Wed, 17 Nov 2021 07:41:05 -0800 (PST)
Received: by mail-wr1-x42b.google.com with SMTP id c4so5512951wrd.9
        for <linux-trace-devel@vger.kernel.org>; Wed, 17 Nov 2021 07:41:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=K0MkAnHIILzdnEgkMLya9JI5XofaA+MeHsShnWw2FWs=;
        b=X/TOmL/gPOw8rH/wwE+YHCVk3l5GD2S2G3JSy/2PfgO0d+LDbItgLeCVIT9yrhRtED
         P6GbCFFsod9KujzpBE+8EPDqMLRHdJTY1FRvEj7JruQTujsexESiK4cF3g80w2gKJcBS
         FJHyv3++5xnZ9mCPPJDiSZ+0TY5L/tEn8SAOxv49CaZktIijIQ8EIdaVZObIEcRHLkzZ
         3mOo5UrWDTDOC48imxH10kCuL8bK0t7BgaoPQtwZAdZOw8taLvUFlD8bUXN8QB7q4Dvh
         +jeaj826+ObHUg/gHcb8U+htEgbgrznt/FOZjLWNbf3HZ7LcqRoPESJdqIJzA6Ntvr5e
         t2nA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=K0MkAnHIILzdnEgkMLya9JI5XofaA+MeHsShnWw2FWs=;
        b=4kiFqKKbiZi7vAqPT2LY7bzCu+rZNr8mfrS8xbPfyw00lw6ZqxbHbdoIlirrWHGQD8
         3xru9+dTxl4hXPrqWZQkg7F95m6RsIBzkS86/zzpcDwmg7DfzkmPKfEPQNGPeP5/nrjR
         f9CvanrU/RipO4QADbjfzY3S6DSkSzOirpLnIkbFx10nRakvF6kyIKXnbuKj2sb/Ij7E
         YBO6osD404dsaL6mA0atjDzMrH8UOSf2twd6rMMmQmkT15VKqrZ0AY9u0QlWtPK5sRfP
         athsN96Mvv5Ir7qB6dzCUqQ9Mh1nq+q7w5JHMKfjbAlI55tVreO2saO3ErEvBul/MYd8
         8UYg==
X-Gm-Message-State: AOAM530F1IeQyqcGFQ/Kvw6u73T1/lDbvbs0D5GjnZ/7xizC+YcNdCKZ
        arUKrlhTesHgZhU8LMHbAfSNCxdo5TbkUA==
X-Google-Smtp-Source: ABdhPJzcDmRXVGCNmJDPO1ailpkWQcEJG2UTvBrV5jTuLtbdYs/iwV1g9XP74SxAcblMK2toRI2LiQ==
X-Received: by 2002:adf:e54a:: with SMTP id z10mr21724385wrm.328.1637163664050;
        Wed, 17 Nov 2021 07:41:04 -0800 (PST)
Received: from oberon.zico.biz.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id d7sm185759wrw.87.2021.11.17.07.41.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 Nov 2021 07:41:03 -0800 (PST)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [RFC PATCH 0/3] Introduce configurable ring buffer page size
Date:   Wed, 17 Nov 2021 17:40:58 +0200
Message-Id: <20211117154101.38659-1-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.33.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Tzvetomir Stoyanov (VMware)" <tstoyanov@vmware.com>

Currently the size of one buffer page is global for all buffers and it
is hard coded to one system page. The patch set introduces configurable
ring buffer page size, per ring buffer. A new user space interface is
introduced, which allows to change the page size of the ftrace buffer, per
ftrace instance.

Tzvetomir Stoyanov (VMware) (3):
  [RFC] trace: Page size per ring buffer
  [RFC] trace: Add interface for configuring trace ring buffer size
  [WiP] trace: Set new size of the ring buffer page

 include/linux/ring_buffer.h |   5 +-
 kernel/trace/ring_buffer.c  | 251 +++++++++++++++++++++++++++---------
 kernel/trace/trace.c        |  47 +++++++
 kernel/trace/trace_events.c |  71 ++++++++--
 4 files changed, 304 insertions(+), 70 deletions(-)

-- 
2.31.1

