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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4D4C9C433FE
	for <linux-trace-devel@archiver.kernel.org>; Fri, 11 Dec 2020 15:49:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EF8AB23329
	for <linux-trace-devel@archiver.kernel.org>; Fri, 11 Dec 2020 15:49:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390947AbgLKPI5 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 11 Dec 2020 10:08:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50770 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2391033AbgLKPIv (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 11 Dec 2020 10:08:51 -0500
Received: from mail-wm1-x342.google.com (mail-wm1-x342.google.com [IPv6:2a00:1450:4864:20::342])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 32DDFC0613D3
        for <linux-trace-devel@vger.kernel.org>; Fri, 11 Dec 2020 07:08:11 -0800 (PST)
Received: by mail-wm1-x342.google.com with SMTP id q75so8883795wme.2
        for <linux-trace-devel@vger.kernel.org>; Fri, 11 Dec 2020 07:08:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=JZy3S9KYXoyelUtnHyD2k8tW1N/cWWOYLtUTEJoHam0=;
        b=nU6TGvLMhM/D9a1n0Y1LOAriY1m3SkMKD3Gv3bT1mPVW+DA18XQ3LTTX/6lwstKlrc
         zdh3ro9Zfdv3SpcJQIyrvOPjkFTargfObR5CBoRJBJqV5DoLA82/ONYLhk9Fbdf8SJIE
         s9/Oqr4hKvAq7Tn2DUrAbSW6Rg6BWrMaPPXq38JwWyUiXdNWHiBeYvWWRFByynPP3h4Z
         X//6SzByS+sYATUSuUAyhH1HKDAZqTaU/cVQYOTUs7WZAoqWGpoK335OHBsU0JYL1Q0K
         dWFoXySwy+m+FkQ2oW7eA9r5+nDFKJzUfMJLlB7y/L78cKNYmW3My0KCtypzjz8Mnygl
         tWGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=JZy3S9KYXoyelUtnHyD2k8tW1N/cWWOYLtUTEJoHam0=;
        b=LK4dN+KgTpIvs0saqCraSotyUU3IwVc0LY0NAKmcuIvyD/W4tWw47cdiVICo3ZrY/s
         EYrTJQqFYrnriu4MfXekz0YdwXyKTXyQ3BxmDidIv07q+JhDK/IUBdz5XwxQBpmAvOUY
         oFgb9WO8EaA6OC+fpi1RQ6qaEF/QtXvLfeLzJ3VY6UuWfNukwOou9KF3obHTlfHsgioE
         qKU1O7C0vfmfBr0jL45MUup/NXn3qUCauS8Ku9NGycUhdbwK3kHOgdUBwf5yhT2Mgaho
         hoVGLFTYh714b/K2WiPSXPDwhBudiCYJ8I5A51DG3O/7YyGNg+4IK6qWei9rLk2xYxSF
         XqRg==
X-Gm-Message-State: AOAM533ebdA52ziZustsRydPO17nwahqeo3tb+WL6/4PqhfjzQN5fxCe
        RxDHHgZ1yQ9QrZ1Ehdv+fVzEPbvDMmo=
X-Google-Smtp-Source: ABdhPJx71hvDzeWcUyB0umFj9XckuMjEyUQsEC2Mpf53ZtfVn68Hhuz1Zaq8KamCck3XlebkyInJwg==
X-Received: by 2002:a1c:4d0c:: with SMTP id o12mr14447240wmh.134.1607699289950;
        Fri, 11 Dec 2020 07:08:09 -0800 (PST)
Received: from localhost.localdomain ([95.87.199.104])
        by smtp.gmail.com with ESMTPSA id w17sm15620948wru.82.2020.12.11.07.08.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 11 Dec 2020 07:08:09 -0800 (PST)
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org,
        "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Subject: [PATCH v7 00/32] Start KernelShark v2 transformation
Date:   Fri, 11 Dec 2020 17:07:24 +0200
Message-Id: <20201211150756.577366-1-y.karadz@gmail.com>
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

Changes in v7:
 * Patches 1-5 are new, but these are only infrastructureal changes
   that have no functional effects on the API.
   - License info is added.
   - README is updated.
   - KernelShark now builds and links against the stand-alone versions
     of libtraceevent and libtracefs.

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

Yordan Karadzhov (VMware) (31):
  kernel-shark: Add license information
  kernel-shark: Change the CMake minimum version required
  kernel-shark: Use libtraceevent and libtracefs
  kernel-shark: Update README
  kernel-shark: Define build target for JSONC
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

 .github/workflows/main.yml       |   61 +
 CMakeLists.txt                   |   25 +-
 Documentation/doxygen/dox_config |    1 +
 LICENSES/GPL-2.0                 |  359 +++
 LICENSES/LGPL-2.1                |  503 +++
 README                           |  129 +-
 build/FindJSONC.cmake            |   70 +-
 build/FindTraceCmd.cmake         |   53 +-
 build/FindTraceEvent.cmake       |   75 +
 build/FindTraceFS.cmake          |   75 +
 build/cmake_clean.sh             |    4 +
 build/deff.h.cmake               |   15 +-
 examples/CMakeLists.txt          |   34 +-
 examples/configio.c              |   20 +-
 examples/datafilter.c            |   67 +-
 examples/datahisto.c             |   38 +-
 examples/dataload.c              |   28 +-
 examples/multibufferload.c       |   53 +
 src/CMakeLists.txt               |   18 +-
 src/libkshark-collection.c       |  121 +-
 src/libkshark-configio.c         | 1208 +++++--
 src/libkshark-hash.c             |  239 ++
 src/libkshark-model.c            |  154 +-
 src/libkshark-model.h            |   55 +-
 src/libkshark-plot.c             |  317 +-
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
 35 files changed, 13177 insertions(+), 1992 deletions(-)
 create mode 100644 .github/workflows/main.yml
 create mode 100644 LICENSES/GPL-2.0
 create mode 100644 LICENSES/LGPL-2.1
 create mode 100644 build/FindTraceEvent.cmake
 create mode 100644 build/FindTraceFS.cmake
 create mode 100644 examples/multibufferload.c
 create mode 100644 src/libkshark-hash.c
 create mode 100644 src/libkshark-tepdata.c
 create mode 100644 src/libkshark-tepdata.h
 create mode 100644 src/stb_truetype.h
 create mode 100644 tests/CMakeLists.txt
 create mode 100644 tests/libkshark-tests.cpp

-- 
2.25.1

