Return-Path: <linux-trace-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 58AC3C001B0
	for <linux-trace-devel@archiver.kernel.org>; Wed,  9 Aug 2023 17:53:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231423AbjHIRxt (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 9 Aug 2023 13:53:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48474 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229456AbjHIRxs (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 9 Aug 2023 13:53:48 -0400
Received: from mail-qv1-xf2f.google.com (mail-qv1-xf2f.google.com [IPv6:2607:f8b0:4864:20::f2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B47F610D2
        for <linux-trace-devel@vger.kernel.org>; Wed,  9 Aug 2023 10:53:47 -0700 (PDT)
Received: by mail-qv1-xf2f.google.com with SMTP id 6a1803df08f44-63d170a649eso471696d6.3
        for <linux-trace-devel@vger.kernel.org>; Wed, 09 Aug 2023 10:53:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1691603626; x=1692208426;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=VIVaZ3PAACn24RVhpmnOfffX9dO6jcjuixC34wKQpt4=;
        b=Upv4CYJISpGLJT63jOaQJ03IH5NhFisA2qf6wow6uSwGEy0Rq6PdP30HNeU1621Px8
         7Z62ZcE8c6G40VBY/F0Rf+mZGgZxM4zG29E9gyOlbORvxsrtJJcPyi/aieqojfu14gUR
         DxzumiRvCBejwxMiLbWwGviAMdr3utUrxC2wxID9v56ng4BZqMaYXyrVmqkd5QYdZdTj
         tGgXg+7dL69vsGQWMQDlQYxkLmMtJel6JNSO2jz344Tjx8weGPWOf0XXSxIznlPe56HH
         dyL4pDlGN9Gj0P8N1XODZJShZaFVWXUcIXLRb1TgfFy3P5l+BhFgo0/PlQlyFuZmDavn
         TDug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691603626; x=1692208426;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=VIVaZ3PAACn24RVhpmnOfffX9dO6jcjuixC34wKQpt4=;
        b=TSHpnLbdZsbIGmrMjwtO36TTMCZ28MpSwcQhddWItYkyJbq0B52bi0KI/AfdgBFU+k
         BZeEa+X34NTHjNw7GlBndquM5MUN62GaLHSRFwLFY7OTufR/RfxjNWF/zkd/n/InFxem
         /MRHg2PLGx9JXMhHD0Z1M0GiaViz6gyiw/uk4+ZTJr03h5LYNhqkayEk9m73grukAJOU
         58757+erX7RxSwsAswI50w59ZfacCDKvEt8S5QjOiDYJDp0zMDMBI6lGHbFdnuxw1Zxb
         37jTKZ1gWWeCGudFRfrIqQwbl3B3hWOLWuogPKCwZlJYAV2fipeSeWQ1rRRcQIOcd22d
         W4hQ==
X-Gm-Message-State: AOJu0YyABIegRp2Ha9J5kDuE8/dNMQ/ieyTa8p+IrP6qwLyFaTsBAUs4
        aqQ2sht3H5fitTwAJjvWNtXCZh7+QEM=
X-Google-Smtp-Source: AGHT+IG8mGCB2Aw7/DfFjWbnywDRtpndsTfV2YweCw7te0tsindrgsp2Kg+93vq51HrtTdX5ssKbUQ==
X-Received: by 2002:a0c:be88:0:b0:63d:b75:c971 with SMTP id n8-20020a0cbe88000000b0063d0b75c971mr3398127qvi.15.1691603626437;
        Wed, 09 Aug 2023 10:53:46 -0700 (PDT)
Received: from 3xKetch.hsd1.ma.comcast.net ([2601:180:8300:500::2409])
        by smtp.gmail.com with ESMTPSA id x4-20020a0c8e84000000b00623839cba8csm4633646qvb.44.2023.08.09.10.53.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Aug 2023 10:53:45 -0700 (PDT)
From:   Stevie Alvarez <stevie.6strings@gmail.com>
To:     linux-trace-devel@vger.kernel.org
Cc:     Stevie Alvarez <stevie.6strings@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Ross Zwisler <zwisler@google.com>
Subject: [PATCH v4 0/5] histograms: Fix memory leak, logic bugs, legibility
Date:   Wed,  9 Aug 2023 13:53:33 -0400
Message-ID: <20230809175340.3066-1-stevie.6strings@gmail.com>
X-Mailer: git-send-email 2.41.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: Stevie Alvarez (Google) <stevie.6strings@gmail.com>

Changes in v4:
 * Reorder enum traceeval_data_type numeric types for algorithmic access.
 * Reorder union traceeval_data numeric fields for legibility.
 * Remove parenthesis from function name in kerneldocs.
 * Optimize logic in type_alloc().
 * Distinguish internal vs public interfaces within include statements.
 * Rework copy_traceeval_data() logic for legibility.
 * Rework comparator return types to fix query and insert bugs.
 * update_entry() frees the entries old values to avoid a memory leak.

Steven, I didn't get around to adding in the cstring field to
traceeval_data, as I wasn't able to completely grasp what you were
looking for. My apologies.

---
v3 discussion: https://lore.kernel.org/linux-trace-devel/20230808180156.GA1300@3xKetch/T/#t

Stevie Alvarez (Google) (5):
  histograms: Initial histograms interface
  histograms: Add traceeval initialize and release
  histograms: Add traceeval compare
  histograms: Add traceeval query
  histograms: Add traceeval insert

 Makefile                 |   2 +-
 include/traceeval-hist.h | 147 +++++++
 include/traceeval-test.h |  16 +
 src/Makefile             |   1 +
 src/histograms.c         | 804 +++++++++++++++++++++++++++++++++++++++
 5 files changed, 969 insertions(+), 1 deletion(-)
 create mode 100644 include/traceeval-hist.h
 create mode 100644 include/traceeval-test.h
 create mode 100644 src/histograms.c

-- 
2.41.0

