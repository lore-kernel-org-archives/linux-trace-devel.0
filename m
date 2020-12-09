Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0265CC433FE
	for <linux-trace-devel@archiver.kernel.org>; Wed,  9 Dec 2020 13:42:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A48B623AC4
	for <linux-trace-devel@archiver.kernel.org>; Wed,  9 Dec 2020 13:42:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732065AbgLINm6 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 9 Dec 2020 08:42:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57414 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732435AbgLINm6 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 9 Dec 2020 08:42:58 -0500
Received: from mail-wr1-x444.google.com (mail-wr1-x444.google.com [IPv6:2a00:1450:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A6384C0613CF
        for <linux-trace-devel@vger.kernel.org>; Wed,  9 Dec 2020 05:42:16 -0800 (PST)
Received: by mail-wr1-x444.google.com with SMTP id a12so1785839wrv.8
        for <linux-trace-devel@vger.kernel.org>; Wed, 09 Dec 2020 05:42:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=00rq8Fgi70k8BFI+r8RFVS9lYWma+2mWPJgX6/TliD4=;
        b=NvYX2Q/odbLJYlB+nZbCyu3fh30JwfNZpVyxF2HdXDMoJvzRO5ibNOIjP9pBTRUdIb
         +gCAoev0RqDsaSBEqyKG+cre5xXbeHRjp5eqaoNeL2buSa7f0FCf+9B/vBOCwO4emevh
         rHaaw/MjXX9fBTuqLgIPlT6t21jdgbEkC5k2mtWNMtbPzw+wqtSxz33WR7M5Kkj+enRm
         4FQccZRPwK4BJmkpDg2Ix1Vz6xSClfEF3Zm5CuwRRhFZkKmfcrpQsiDzxmT6AqTTBfkb
         NF225nkLn5VtYZ3OGh7mgFnm8p9NRB+UgG75ujbXSVVTbFQIvX8d+AKIWhBDYk+dAMtG
         QZkw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=00rq8Fgi70k8BFI+r8RFVS9lYWma+2mWPJgX6/TliD4=;
        b=AeOTZ8USgBW9GN6BHd3tLTWvE9R/2oW0KxxBgxQLEhs8t8xPmOXcqLvEu4aHoI9SpL
         709iQrA1tL0y5LiHrNss+K74gqpTCJ94Kso6jUU/fGFOdcdmbGjkLNv43yia8vtMa8Jq
         2Hc4mAtad2QTlJKQtJ8lcaBcMxWYqL+QcOtPnKmsH8q4MTiF5aUdrKIo6N4IWnMCFaVY
         PNJ1u7H5bXK6MRChiwSFcd9/dclF6sXelBqTOKe/DV/vteofyy/u09fGMBZS8WaTEdfU
         QDOxwqpiW679dTxU/e401HR9QeKEpDR0BNzIMVyDr0GAIJjGGjUTueKsiE4tTFqeEFLx
         VOmQ==
X-Gm-Message-State: AOAM532RAL6aU8DNuFS0y9L8oDaoJq5j4LgITjh6tU7gqm2ygJ1dLatv
        d4MNAOeB3pLh7gIGBepYQfLrxz+pbis=
X-Google-Smtp-Source: ABdhPJwJRwz82T+eqepjvDAZYKc6niv2loXdCpnl8WVpINUtqs7uREfGpU4mWAZa+4dCnG/v+YfsNw==
X-Received: by 2002:a5d:68ce:: with SMTP id p14mr2792329wrw.386.1607521335403;
        Wed, 09 Dec 2020 05:42:15 -0800 (PST)
Received: from localhost.localdomain ([95.87.199.104])
        by smtp.gmail.com with ESMTPSA id q143sm3871071wme.28.2020.12.09.05.42.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Dec 2020 05:42:14 -0800 (PST)
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org,
        "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Subject: [PATCH v6 00/27] Start KernelShark v2 transformation
Date:   Wed,  9 Dec 2020 15:41:36 +0200
Message-Id: <20201209134203.428068-1-y.karadz@gmail.com>
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

Steven,
I believe all patches in this set are ready to move upstream.

Changes in v6:
 * The patches from the "OpenGL wrapper" patch-set (already reviewed by
   Steven) have been added here (patches 21-24).

 * Patches 25-27 are new, but these are only infrastructureal changes
   that have no functional effects on the API.


Changes in v5:
 * Only minor modifications addressing issues pointed out by Steven in
   his reviews of v4.

Changes in v4:
 * The integer data format identifier is replaced with a string value
   that gets registered by the readout plugin.

 * Plus several small modifications addressing the issues pointed out
   by Steven.


Changes in v3.
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


Changes in v2:
 * Tried to address review comments for "kernel-shark: Introduce libkshark-hash"

 * The huge patch "kernel-shark: Integrate the stream definitions with
the C API" in the previous version is now split into 8 smaller patches.
The last of these 8 new patches (kernel-shark: Complete the stream
integration) is still a bit entangled. I can try to further break this
patch in future versions of the patch-set, if this is needed.

Yordan Karadzhov (1):
  kernel-shark: Add "github Actions" workflow

Yordan Karadzhov (VMware) (26):
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
  kernel-shark: Add support for drawing text
  kernel-shark: Make GLUT optional dependency
  kernel-shark: Add ksplot_draw_polyline()
  kernel-shark: Optimize ksplot_draw_polygon()
  kernel-shark: Do not use the ARRAY_SIZE macro
  kernel-shark: Add basic infrastructure for testing

 .github/workflows/main.yml       |   51 +
 CMakeLists.txt                   |   13 +-
 Documentation/doxygen/dox_config |    1 +
 build/cmake_clean.sh             |    4 +
 build/deff.h.cmake               |   15 +-
 examples/CMakeLists.txt          |   34 +-
 examples/configio.c              |   20 +-
 examples/datafilter.c            |   67 +-
 examples/datahisto.c             |   38 +-
 examples/dataload.c              |   28 +-
 examples/multibufferload.c       |   53 +
 src/CMakeLists.txt               |   12 +-
 src/libkshark-collection.c       |  121 +-
 src/libkshark-configio.c         | 1208 +++++--
 src/libkshark-hash.c             |  239 ++
 src/libkshark-model.c            |  154 +-
 src/libkshark-model.h            |   55 +-
 src/libkshark-plot.c             |  315 +-
 src/libkshark-plot.h             |   73 +
 src/libkshark-plugin.c           |  658 +++-
 src/libkshark-plugin.h           |  294 +-
 src/libkshark-tepdata.c          | 1914 ++++++++++++
 src/libkshark-tepdata.h          |  112 +
 src/libkshark.c                  | 2619 +++++++++-------
 src/libkshark.h                  |  704 ++++-
 src/stb_truetype.h               | 5011 ++++++++++++++++++++++++++++++
 tests/CMakeLists.txt             |   14 +
 tests/libkshark-tests.cpp        |   48 +
 28 files changed, 12018 insertions(+), 1857 deletions(-)
 create mode 100644 .github/workflows/main.yml
 create mode 100644 examples/multibufferload.c
 create mode 100644 src/libkshark-hash.c
 create mode 100644 src/libkshark-tepdata.c
 create mode 100644 src/libkshark-tepdata.h
 create mode 100644 src/stb_truetype.h
 create mode 100644 tests/CMakeLists.txt
 create mode 100644 tests/libkshark-tests.cpp

-- 
2.25.1

