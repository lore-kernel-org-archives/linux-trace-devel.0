Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CFCBFC5519F
	for <linux-trace-devel@archiver.kernel.org>; Wed, 18 Nov 2020 14:50:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6AC0E246AA
	for <linux-trace-devel@archiver.kernel.org>; Wed, 18 Nov 2020 14:50:26 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="jDyA8jLs"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727120AbgKROu0 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 18 Nov 2020 09:50:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42182 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727085AbgKROuZ (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 18 Nov 2020 09:50:25 -0500
Received: from mail-wr1-x443.google.com (mail-wr1-x443.google.com [IPv6:2a00:1450:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8BEF2C0613D4
        for <linux-trace-devel@vger.kernel.org>; Wed, 18 Nov 2020 06:50:25 -0800 (PST)
Received: by mail-wr1-x443.google.com with SMTP id d12so2405842wrr.13
        for <linux-trace-devel@vger.kernel.org>; Wed, 18 Nov 2020 06:50:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Y6wwlptoia6aldjGgyHXu4ji/3+5igRGbsndX4pyOGo=;
        b=jDyA8jLste5KpiSpVdFWH51oahAN1oojbyjV8Jnrz1kmoN0v2/LF+ZME14kWVI5Ssv
         21jotJo54JYaioLyqkYEbFQ2Y1K9wJTClDAkEVeWfuIpciCdiIwRepiFXCrCAb3a3/hY
         QrA0WfsPi78ykMZSq1GeyYauWoGfdyhuSAhHMoXqUTKuNoGwLdlHwplznNZohBVurglC
         cRe6bG+UJhJakqZJ0paASgZbinssobzFkkRuy4E8U2LQnBKEdEiik3I+YQFiQ0JW+ym/
         bwoVra+xqkn4M+FJ4UaU314mokNX+WdAaIfjh3jifOD7CFfeOzU8QloBSH1bfIZ46xLf
         lYBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Y6wwlptoia6aldjGgyHXu4ji/3+5igRGbsndX4pyOGo=;
        b=ZGoMrqMM8UhcWb+K4BcKZ4X6zhSg3X5WpJnd7UIUIFXYjeJ4p22JpA9SwxQhozYng1
         WIM5gQPKN84xe2LAIlKr9bqW01nFauQmgrarUD4LnZf5niwyIGvzYiz/JhglKXK4c7Oj
         amuE817ZwLIbs3MunU5ZDG0MlEJmfaV34Zu04GI8PrJTZgNrQQdErAlARRdayZxCAgEY
         BOw2tQlGrzwmf9QNHc08hiDL4H1zpf3P9lOQ7BuDoEjCoutWHIwOgaad2sj+xkPsfyap
         ZD6HpqYBqB0UK4xHw6xi8yyKjZpYlX4EfuRBhpVSplhT7PXir+oRV4kDvfJLbgIDjI3f
         l3WQ==
X-Gm-Message-State: AOAM530K0B//Wg9BSZ3w521h4D62+GhvUPBOatiDgI0SKjP+zaqq9h1H
        tt/CYIrrdiTCkHauK20E2wA=
X-Google-Smtp-Source: ABdhPJzdSXWidt2Iqh501kF9+Bz03Q/2GX8wVO11GgDS+c5rK5d/ePJGw486tZuPC7crzoFX2zwzjQ==
X-Received: by 2002:adf:e80b:: with SMTP id o11mr5180829wrm.409.1605711024288;
        Wed, 18 Nov 2020 06:50:24 -0800 (PST)
Received: from localhost.localdomain ([84.40.93.58])
        by smtp.gmail.com with ESMTPSA id s202sm3926190wme.39.2020.11.18.06.50.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Nov 2020 06:50:23 -0800 (PST)
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org,
        "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Subject: [PATCH v4 00/20] Start KernelShark v2 transformation
Date:   Wed, 18 Nov 2020 16:49:43 +0200
Message-Id: <20201118145003.156542-1-y.karadz@gmail.com>
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

Changes is v4:
 * The integer data format identifier is replaced with a string value 
   that gets registered by the readout plugin.

 * Plus several small modifications addressing the   issues pointed out
   by Steven


Changes is v3.
  This version contains number of small modifications addressing the
  issues pointed out by Steven in his review. However, it also contains
  the following major changes:

   * The session context (kshark_context) holds a pointer to unspecified
     data processing interface (void *interface). This will allow to
     easily introduce new versions of this interface in the future, while
     keeping the interface that we have now for backward compatibility.
     The necessary type checking when using the interface made the helper
     functions wrapping the corresponding methods of the interface
     relatively complicated, so the implementations have been moved from
     the header to the source file.

   * A more sophisticated management of the Data stream descriptors that
     can handle the case when Data streams are constantly added and
     removed has been implemented. The design for this change was
     suggested by Steven in his review.


Changes is v2:
 * Tried to address review comments for "kernel-shark: Introduce libkshark-hash"

 * The huge patch "kernel-shark: Integrate the stream definitions with
the C API" in the previous version is now split into 8 smaller patches.
The last of these 8 new patches (kernel-shark: Complete the stream
integration) is still a bit entangled. I can try to further break this
patch in future versions of the patch-set, if this is needed.


Yordan Karadzhov (VMware) (20):
  kernel-shark: Use only signed types in kshark_entry
  kernel-shark: Add stream_id to kshark_entry
  kernel-shark: Introduce libkshark-hash
  kernel-shark: Introduce Data streams
  kernel-shark: Rename static methods in libkshark
  kernel-shark: Add basic methods for Data streams
  kernel-shark: Housekeeping before implementing stream interface
  kernel-shark: Add stream interface for trace-cmd data
  kernel-shark: Start introducing KernelShark 2.0
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
 examples/dataload.c        |   28 +-
 examples/multibufferload.c |   60 +
 src/CMakeLists.txt         |    4 +-
 src/libkshark-collection.c |  121 +-
 src/libkshark-configio.c   | 1208 ++++++++++++++---
 src/libkshark-hash.c       |  239 ++++
 src/libkshark-model.c      |  154 ++-
 src/libkshark-model.h      |   55 +-
 src/libkshark-plugin.c     |  658 +++++++--
 src/libkshark-plugin.h     |  294 +++-
 src/libkshark-tepdata.c    | 1917 ++++++++++++++++++++++++++
 src/libkshark-tepdata.h    |  113 ++
 src/libkshark.c            | 2616 ++++++++++++++++++++----------------
 src/libkshark.h            |  704 ++++++++--
 20 files changed, 6531 insertions(+), 1823 deletions(-)
 create mode 100644 examples/multibufferload.c
 create mode 100644 src/libkshark-hash.c
 create mode 100644 src/libkshark-tepdata.c
 create mode 100644 src/libkshark-tepdata.h

-- 
2.25.1

