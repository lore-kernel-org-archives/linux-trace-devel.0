Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 01769C433EF
	for <linux-trace-devel@archiver.kernel.org>; Mon,  1 Nov 2021 09:09:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D8E54610A2
	for <linux-trace-devel@archiver.kernel.org>; Mon,  1 Nov 2021 09:09:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231693AbhKAJLl (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 1 Nov 2021 05:11:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40484 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231223AbhKAJLl (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 1 Nov 2021 05:11:41 -0400
Received: from mail-ed1-x536.google.com (mail-ed1-x536.google.com [IPv6:2a00:1450:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A23CC061714
        for <linux-trace-devel@vger.kernel.org>; Mon,  1 Nov 2021 02:09:08 -0700 (PDT)
Received: by mail-ed1-x536.google.com with SMTP id m14so9146246edd.0
        for <linux-trace-devel@vger.kernel.org>; Mon, 01 Nov 2021 02:09:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=AN95UIW2u2BZzCqohHyNtX4qvS4WiIcBLpJcdR0A7SI=;
        b=YnSn9GDFrIs8INL/7wSIMOox+azycy+w1mdF1wOsKMPmh+doiDjnFyIon+BZA9k59M
         Ntffc66JFqOgFqCfz45z30ef693+yb+j+EC1r2kyu3chR17sLZWI0sKXcRW7K95+CwhA
         WKGnpCJr5VQ90FB7njM6XeG6c9GOCd4W5lkOb9M7pAnq8bCBqgFIsPf+kHncMP5YIMNM
         3+LlRNu5UEoRmyBU5Hv0Kl0Y1tRxmygwmzuofry25M/5H65ziEN8LMIM2LypWh+nYlz6
         7Chv4NPUu776UKg4ZwDyZt/N1SklO76riFNAoX9GNfSCWTPRkdM/p5PMWFK788iLXQzj
         Iv8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=AN95UIW2u2BZzCqohHyNtX4qvS4WiIcBLpJcdR0A7SI=;
        b=V8L84unWR0swAUcwgUqpy2ugrjXg1JPeFVPoRIla5Lv0Uci1xIpJ3H72MWoS76tn7W
         mFvKrIsPQZ8tbzvYbx6OgG1vOLSrCRLCSFTtVbY6Rr8BG/FswCARXEbc6jb7kxt90Opt
         KmHyUglJOuaTEfgqfjgJqp7pStMxL54cPp9oCEyHFuGEjqbYidwRQgI883Zi2IM4/pyl
         nis6xbWeBnPAp+BvQRrvIBYOmUP4v/WVvhfTBhyz/j8GT4+OEptapx8pguGKP3qVL0v1
         PK42kjaE0IS+uQbDBtSqNyMdDrPDxsLrQn8yYZyVr5KqH7PpTlHC0RfSu6/bBXnUGRy3
         bu6A==
X-Gm-Message-State: AOAM530nwzEysrRp7/hE+EaxNdU/vuo3Dt4dwc6W0JbZ3d13R9mjlInk
        fwNCN30xJss+h+Hk7eoGWQA=
X-Google-Smtp-Source: ABdhPJzza1CITqGqDe3cEG1BLH0RVDh16HTPS4RAw1oRREtEgx9DXCrFG2PwiaiAcmE0ZEG9fR+2PA==
X-Received: by 2002:a17:907:76d3:: with SMTP id kf19mr12835215ejc.481.1635757746864;
        Mon, 01 Nov 2021 02:09:06 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id i8sm9873222edc.10.2021.11.01.02.09.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Nov 2021 02:09:06 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org, y.karadz@gmail.com
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v2 00/12] libtracefs dynamic events support
Date:   Mon,  1 Nov 2021 11:08:52 +0200
Message-Id: <20211101090904.81454-1-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

The libtracefs logic that works with ftrace dynamic events is unified and
capsulated into internal APIs. This change makes the code more consistent
and reusable. Also, adding future libtracefs support for uprobes and
eprobes dynamic events is simplified.
The existing library APIs for kprobes and synthetic events are reimplemented
using the new dynamic events helpers.

Suggested-by: Yordan Karadzhov (VMware) <y.karadz@gmail.com>

v2 changes:
 - Removed triple pointer from the APIs.
 - Reimplement dynamic events parsing using strtok_r instead of strchr.
 - Coding style fixes.

Tzvetomir Stoyanov (VMware) (12):
  libtracefs: Add new internal APIs for dynamic events
  libtracefs: Rename tracefs_get_kprobes API
  libtracefs: New kprobes APIs
  libtracefs: Remove redundant kprobes APIs
  libtracefs: Reimplement tracefs_kprobes_get API
  libtracefs: Change tracefs_kprobe_info API
  libtracefs: Reimplement kprobe raw APIs
  libtracefs: Extend kprobes unit test
  libtracefs: Update kprobes man pages
  libtracefs: Rename tracefs_synth_init API
  libtracefs: Use the internal dynamic events API when creating
    synthetic events
  libtracefs: Document tracefs_dynevent_list_free() API

 Documentation/libtracefs-kprobes.txt | 131 ++++---
 Documentation/libtracefs-synth.txt   |  20 +-
 Documentation/libtracefs-synth2.txt  |  10 +-
 Documentation/libtracefs-utils.txt   |   6 +-
 Documentation/libtracefs.txt         |  12 +
 include/tracefs-local.h              |  35 ++
 include/tracefs.h                    |  38 +-
 src/Makefile                         |   1 +
 src/tracefs-dynevents.c              | 492 ++++++++++++++++++++++++++
 src/tracefs-hist.c                   | 110 +++---
 src/tracefs-kprobes.c                | 508 +++++++++++++--------------
 src/tracefs-sqlhist.c                |   6 +-
 utest/tracefs-utest.c                | 408 ++++++++++++---------
 13 files changed, 1187 insertions(+), 590 deletions(-)
 create mode 100644 src/tracefs-dynevents.c

-- 
2.31.1

