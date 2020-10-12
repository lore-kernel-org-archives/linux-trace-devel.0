Return-Path: <SRS0=H9Ya=DT=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D5181C433E7
	for <linux-trace-devel@archiver.kernel.org>; Mon, 12 Oct 2020 14:03:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9DC5F2074D
	for <linux-trace-devel@archiver.kernel.org>; Mon, 12 Oct 2020 14:03:27 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="VKfOtRUN"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730556AbgJLNgw (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 12 Oct 2020 09:36:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58538 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730850AbgJLNfs (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 12 Oct 2020 09:35:48 -0400
Received: from mail-wr1-x42c.google.com (mail-wr1-x42c.google.com [IPv6:2a00:1450:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB099C0613D1
        for <linux-trace-devel@vger.kernel.org>; Mon, 12 Oct 2020 06:35:47 -0700 (PDT)
Received: by mail-wr1-x42c.google.com with SMTP id g12so19212751wrp.10
        for <linux-trace-devel@vger.kernel.org>; Mon, 12 Oct 2020 06:35:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=xFbxRmZ9J+MsVek7xmGJcKnoh+9xSOpqnIscGXKz9Ns=;
        b=VKfOtRUNqOQYwtadveHvD22Z7fBQzyQUhM6TVfRBR/D+j0W5f2dMG1aA9RPewUGqAF
         xf4BaVTrhsZ2y3t828BdsC+rCpS7CaKGDfbIPIdVw6gZ99NaeOfFg6awPa/7ybHvF7dp
         c2EcB+Ejmr9u4HCRBb9F0Gv+1CxRKh7Os4vq+FvM+4D5jA0WU1eXOt1xav9QUY1ATSWP
         mLAe8h3gxWhumxjr+2MjbpBTLIgeKsbOzJvvmiNuEV0ql0QHhToOX3ElLI35uxP5iNl6
         ZSzDqWBwMRi7MtQCd6mkzi31X3a1tFPqZ2dUJTeNlfpEBPmEI/UmY2ErId3ElZQ05Y/b
         Czrg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=xFbxRmZ9J+MsVek7xmGJcKnoh+9xSOpqnIscGXKz9Ns=;
        b=S7qi3Jh6aq5QhgGNZz2EK9Zuwdm50HBF/rNH8BYBtJPNPc7BexieDLqaOYV0HwD75L
         +UgYK4ISds2763Jzo/DgPlHRaCRKh+2dq/mnwCrqourlWsCl8ikvcGl8WstbI2+Lvmor
         SSIFcIT9paH79T3KGQcJT9FyaiR8dO/PdA0pzCR3bfHJ2arcw7DNbyWEMCkmR6yBl4RF
         DNKTo8160g24Y6D5vM6fTd6z2qN0zXSLb3iFsOU90jDwYGasRUipgbyKURNk8txeDF4L
         5XZLTpimCKke0j8+Z9YwSM/y9ikZ9r/Ega2mm72xe0NhQwz6uEKB0ljsmWZMrotBldw5
         T8NA==
X-Gm-Message-State: AOAM532aQ/cuO2LNAfSONWnmkunSSbOjsDvdZsBcVesEERqr1LMqj3VV
        BDpzbRcMtTBy5zQG6xE++Nc=
X-Google-Smtp-Source: ABdhPJy5bdjmGC56gKjVNW/leA4zMXErpuslpIIfX/OpKW2FfsEID+gYNKJbn/rlEWjUpxCF6wPCpw==
X-Received: by 2002:adf:9461:: with SMTP id 88mr30305059wrq.307.1602509746667;
        Mon, 12 Oct 2020 06:35:46 -0700 (PDT)
Received: from localhost.localdomain ([84.40.93.41])
        by smtp.gmail.com with ESMTPSA id k5sm23145388wmb.19.2020.10.12.06.35.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Oct 2020 06:35:45 -0700 (PDT)
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org,
        "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Subject: [PATCH v2 00/20] Start KernelShark v2 transformation
Date:   Mon, 12 Oct 2020 16:35:03 +0300
Message-Id: <20201012133523.469040-1-y.karadz@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

In this patch-set we are starting the introduction of the changes
in the C API of libkshark. The goal of this transformation is to
turn KernelShark into a general purpose toolkit for analysis of
tracing data that is no longer strongly coupled to the Ftrace/trace-cmd
data format. At the end of the transformation KernelShark will be able
to merge and simultaneously visualize data from different tracers,
recorded in different data formats. It will also significantly extend
the possibilities for user customization.

This  patch-set transforms the way KernelShark processes the raw tracing
data. Later, in a consecutive patch-sets we will introduce the changes
in the visualization instruments and in the KernelShark GUI itself.

Changes is v2:
 * Tried to address review comments for "kernel-shark: Introduce libkshark-hash"

 * The huge patch "kernel-shark: Integrate the stream definitions with
the C API" in the previous version is now split into 8 smaller patches.
The last of these 8 new patches (kernel-shark: Complete the stream
integration) is still a bit entangled. I can try to further break this
patch in future versions of the patch-set, if this is needed.


Steven,
Please review very carefully patches:
  kernel-shark: Introduce Data streams
  kernel-shark: Add basic methods for Data streams
  kernel-shark: Add stream interface for trace-cmd data
  kernel-shark: Start using data streams
  kernel-shark: Provide merging of multiple data streams
  kernel-shark: Add methods for time calibration

Please review VERY carefully patche:
  kernel-shark: Redesign the plugin interface

You may treat this one as a complete rewrite. Also it may be useful
to see how the redesigned code is being used in the new version of
the sched_events plugin here:
https://github.com/yordan-karadzhov/kernel-shark-v2.beta/blob/master/src/plugins/sched_events.c
https://github.com/yordan-karadzhov/kernel-shark-v2.beta/blob/master/src/plugins/SchedEvents.cpp

Thanks!
Yordan


Yordan Karadzhov (VMware) (20):
  kernel-shark: Start introducing KernelShark 2.0
  kernel-shark: Use only signed types in kshark_entry
  kernel-shark: Introduce libkshark-hash
  kernel-shark: Introduce Data streams
  kernel-shark: Add stream_id to kshark_entry
  kernel-shark: Rename static methods in libkshark
  kernel-shark: Add basic methods for Data streams
  kernel-shark: Housekeeping before implementing stream interface
  kernel-shark: Add stream interface for trace-cmd data
  kernel-shark: Start using data streams
  kernel-shark: Remove dead code
  kernel-shark: Redesign the plugin interface
  kernel-shark: Complete the stream integration
  kernel-shark: Provide merging of multiple data streams
  kernel-shark: Integrate the stream definitions with data model
  kernel-shark: Use only signed types for model defs
  kernel-shark: Add ksmodel_get_bin()
  kernel-shark: Protect ksmodel_set_in_range_bining()
  kernel-shark: Add methods for time calibration
  kernel-shark: Integrate streams with libkshark-configio

 CMakeLists.txt             |   10 +-
 build/deff.h.cmake         |   14 +-
 examples/CMakeLists.txt    |   34 +-
 examples/configio.c        |   20 +-
 examples/datafilter.c      |   67 +-
 examples/datahisto.c       |   38 +-
 examples/dataload.c        |   21 +-
 examples/multibufferload.c |   60 +
 src/CMakeLists.txt         |    7 +-
 src/libkshark-collection.c |  121 +-
 src/libkshark-configio.c   | 1173 +++++++++++++++---
 src/libkshark-hash.c       |  239 ++++
 src/libkshark-model.c      |  154 ++-
 src/libkshark-model.h      |   55 +-
 src/libkshark-plugin.c     |  597 ++++++++--
 src/libkshark-plugin.h     |  279 +++--
 src/libkshark-tepdata.c    | 1754 +++++++++++++++++++++++++++
 src/libkshark-tepdata.h    |  100 ++
 src/libkshark.c            | 2302 +++++++++++++++++-------------------
 src/libkshark.h            |  779 ++++++++++--
 20 files changed, 5908 insertions(+), 1916 deletions(-)
 create mode 100644 examples/multibufferload.c
 create mode 100644 src/libkshark-hash.c
 create mode 100644 src/libkshark-tepdata.c
 create mode 100644 src/libkshark-tepdata.h

-- 
2.25.1

