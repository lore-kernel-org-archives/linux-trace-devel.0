Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D5104C2D0A3
	for <linux-trace-devel@archiver.kernel.org>; Thu, 12 Nov 2020 14:24:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7015E22248
	for <linux-trace-devel@archiver.kernel.org>; Thu, 12 Nov 2020 14:24:12 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="rI2dVopn"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727796AbgKLOYM (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 12 Nov 2020 09:24:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58280 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727035AbgKLOYL (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 12 Nov 2020 09:24:11 -0500
Received: from mail-wr1-x441.google.com (mail-wr1-x441.google.com [IPv6:2a00:1450:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 65C8CC0613D1
        for <linux-trace-devel@vger.kernel.org>; Thu, 12 Nov 2020 06:24:11 -0800 (PST)
Received: by mail-wr1-x441.google.com with SMTP id o15so6189622wru.6
        for <linux-trace-devel@vger.kernel.org>; Thu, 12 Nov 2020 06:24:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=vga0nw5/NngUig6SHDxPeML0ipEhiNtipohKPL+jLWc=;
        b=rI2dVopnnXHqxJ0sT/UpUUjI+u3c59c6CC1unT8qhpcLrqPWa7MNOxoeXPfMY+0niU
         rJtXhpL9QW20ZXlDzeOo80VlwJPNYbtLLg3nVbBqSVMhCnZvQUqApnhMvPAhNL9UfxkM
         1EBuMUOgHHdOzmYDUcWDQI7GADTWu6+0lc1bLDYZ582d4RBbFzTqYS9MnK4OyUv/IgGC
         j8Va6bXR8xkzAvFqcaiMIrDu5GO40WAWaegiMWMSdJwuEWZbyL6+DDcQFSsVq0e+pHcV
         2lWCP1fbkcGVZmvtKOFB6eWVSKXaGZZungyAJDteMu91PJlR6fLkGQQu8Lpf9wP/EqBW
         ta1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=vga0nw5/NngUig6SHDxPeML0ipEhiNtipohKPL+jLWc=;
        b=lSTtO1XjAwaR1X+kQIUsHxPJonmVID6eDSLaGhqihsTLlgsimNwiA4ngWLSr3qpAYE
         Yb3n8cpHzqc2czvf5FB5/055YWCYcv7LD2m1UT0hgGTTH+44dFN2xuxUMclEma4YgCY6
         KbBX/tVTG+nSai5nDhkQ1peiv9aFSQPgY2IODYJV6Uiq5ZnWmWaGqQKcW5cUAKfBdEZ5
         MYrMRSTfTbFX4aiioZ5zc9E9tjUn40/Q62d5+Rxtw739qgfw3SaXti7pa68pxVsGMgF4
         yi60fzKbmnC4IfH+f7sDE4GtKkWftZIgT5J0u9Mh4s1wpmqB+JUB82FvR5RYQooTVJim
         xqSQ==
X-Gm-Message-State: AOAM532lcDhvC5d1KbxyPgsIJQ3lnbLbtkadXIe+ZNv22a64750YNVP4
        9x/ZvJ52qK7BJ6apM9g9iQg=
X-Google-Smtp-Source: ABdhPJwTmyAiD+jB0v6ACDvpky8lpd7M9QZmNtX/9Pdyi0r2JG2Q8n5VggAJ9sqPybYC9XfedoGSKQ==
X-Received: by 2002:adf:e5c4:: with SMTP id a4mr38388779wrn.56.1605191050209;
        Thu, 12 Nov 2020 06:24:10 -0800 (PST)
Received: from localhost.localdomain ([95.87.199.214])
        by smtp.gmail.com with ESMTPSA id h15sm6950685wrw.15.2020.11.12.06.24.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Nov 2020 06:24:09 -0800 (PST)
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org,
        "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Subject: [PATCH v3 00/20] Start KernelShark v2 transformation
Date:   Thu, 12 Nov 2020 16:23:38 +0200
Message-Id: <20201112142358.36821-1-y.karadz@gmail.com>
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
 examples/dataload.c        |   21 +-
 examples/multibufferload.c |   60 +
 src/CMakeLists.txt         |    4 +-
 src/libkshark-collection.c |  121 +-
 src/libkshark-configio.c   | 1192 +++++++++++++---
 src/libkshark-hash.c       |  239 ++++
 src/libkshark-model.c      |  154 ++-
 src/libkshark-model.h      |   55 +-
 src/libkshark-plugin.c     |  623 +++++++--
 src/libkshark-plugin.h     |  283 +++-
 src/libkshark-tepdata.c    | 1890 ++++++++++++++++++++++++++
 src/libkshark-tepdata.h    |  102 ++
 src/libkshark.c            | 2633 ++++++++++++++++++++----------------
 src/libkshark.h            |  714 ++++++++--
 20 files changed, 6458 insertions(+), 1816 deletions(-)
 create mode 100644 examples/multibufferload.c
 create mode 100644 src/libkshark-hash.c
 create mode 100644 src/libkshark-tepdata.c
 create mode 100644 src/libkshark-tepdata.h

-- 
2.25.1

