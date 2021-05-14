Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3EC7DC433ED
	for <linux-trace-devel@archiver.kernel.org>; Fri, 14 May 2021 12:18:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1B3996144C
	for <linux-trace-devel@archiver.kernel.org>; Fri, 14 May 2021 12:18:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232862AbhENMTy (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 14 May 2021 08:19:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51290 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232354AbhENMTu (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 14 May 2021 08:19:50 -0400
Received: from mail-ed1-x531.google.com (mail-ed1-x531.google.com [IPv6:2a00:1450:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A9B5BC061574
        for <linux-trace-devel@vger.kernel.org>; Fri, 14 May 2021 05:18:38 -0700 (PDT)
Received: by mail-ed1-x531.google.com with SMTP id df21so7229551edb.3
        for <linux-trace-devel@vger.kernel.org>; Fri, 14 May 2021 05:18:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=BUMkutgzxELnUXAXLh3E1lliouPKdjUuTnOtDBagM7M=;
        b=vI/Ya5eTVT6HhPnuOKdDB7SC4K88SqZ0Os3xXP6uENRjFmZ/YH1siog0iocGvTjDeC
         zl/dVAvdZ+ACdxJqU+VwWnoAr75iqQDHaajuVD+rWQ675ELZ59EFomiZxWHakp6lEWQB
         Z5BbUOLLHIdzwc2G3nYkBeCS50WdoZUzHD6JylFc6sojHXtPN2YY6DYi9CPXC6mpQ6gE
         m2TbQBtnIiWuux5m5KuPFTP14fAFuDtxeuCfaJXfyKlVaHFEugHLNFXdwoYXD/PQQpBY
         oJ4cbwuBk2sLnKl4BYWntvyet7Oh/ctFjz4yZdodu12kpwRkXjbj196/d0qlTwHTbrAw
         61/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=BUMkutgzxELnUXAXLh3E1lliouPKdjUuTnOtDBagM7M=;
        b=LQ71lb15KCdZb7C1gIRfjSsVPlhr/9ERAQIMTsQgXxOA1Kl3yv9vqLGgqiZz+9tfmg
         TDjHXW7+kZuHaN5HR575ykioKNkiZpEoKWexrZrQanxjYP3LuVYd2jwjKVoxNxPCYnJx
         cVWAg/kPFedF77j+Q/FP4F3EJFaAH7CYw3qoixXYi8fNQGK/R6R2u5/q7plGUqaNEZbB
         F3n9sxo2j9UR8DJJpNFrM+m5VNpaNbE1LCcbEnt18vmD3DfmgIUBvvIXdfSDObc/MDb9
         B2kHvoNkWsClfvUFh3fH+4XX9G5xFoI5F6KE5j6sZm6RQUCZ8fg9vCm7XSvEiNrkPNqz
         2Q1Q==
X-Gm-Message-State: AOAM531KbKLaT/kJTNOPEGznF+bNHD+nAV6GbFDVn0gOUXzI+o14hlBT
        2C+TU5/+OADcMp3KEzrMLpLFRU10ipk=
X-Google-Smtp-Source: ABdhPJwB/zARHqVTmhv/TIWV5YIwpnlpp/iCNNkS95ylcWs4T99KXoKcoe3olZK8R1yhIqvTMY++1g==
X-Received: by 2002:aa7:dd57:: with SMTP id o23mr17835260edw.98.1620994717179;
        Fri, 14 May 2021 05:18:37 -0700 (PDT)
Received: from localhost.localdomain ([84.40.73.176])
        by smtp.gmail.com with ESMTPSA id cr21sm3435157ejc.2.2021.05.14.05.18.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 14 May 2021 05:18:36 -0700 (PDT)
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
To:     linux-trace-devel@vger.kernel.org
Cc:     "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Subject: [PATCH 0/7] Final fixes before KS 2.0
Date:   Fri, 14 May 2021 15:18:19 +0300
Message-Id: <20210514121826.161749-1-y.karadz@gmail.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Yordan Karadzhov (VMware) (7):
  kernel-shark: Preserve markers when appending data
  kernel-shark: Preserve open graphs when appending data
  kernel-shark: Clear before loading new session
  kernel-shark: Better handling of plugins when appending data file
  kernel-shark: Do draw the combo point of the mark
  kernel-shark: Check if "trace_seq" was destroyed before using it
  kernel-shark: Quiet the warning printing from libtraceevent

 src/KsDualMarker.hpp    |  6 ++++++
 src/KsGLWidget.cpp      | 40 ++++++++++++++++++++++++++--------------
 src/KsGLWidget.hpp      |  4 +++-
 src/KsMainWindow.cpp    | 31 ++++++++++++++++++++++++++-----
 src/KsPlotTools.cpp     |  3 +++
 src/KsSession.cpp       |  1 +
 src/KsTraceGraph.cpp    | 10 +++++++---
 src/KsTraceGraph.hpp    |  2 +-
 src/KsUtils.cpp         |  4 ++--
 src/libkshark-tepdata.c | 16 +++++++++++++++-
 10 files changed, 90 insertions(+), 27 deletions(-)

-- 
2.27.0

