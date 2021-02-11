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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 50DD6C433E6
	for <linux-trace-devel@archiver.kernel.org>; Thu, 11 Feb 2021 10:36:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1B11964E9C
	for <linux-trace-devel@archiver.kernel.org>; Thu, 11 Feb 2021 10:36:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230026AbhBKKfo (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 11 Feb 2021 05:35:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45810 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229821AbhBKKdC (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 11 Feb 2021 05:33:02 -0500
Received: from mail-ej1-x62f.google.com (mail-ej1-x62f.google.com [IPv6:2a00:1450:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B34F5C061574
        for <linux-trace-devel@vger.kernel.org>; Thu, 11 Feb 2021 02:32:21 -0800 (PST)
Received: by mail-ej1-x62f.google.com with SMTP id bl23so9273852ejb.5
        for <linux-trace-devel@vger.kernel.org>; Thu, 11 Feb 2021 02:32:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=/z7RqVNueZzf5q8v7nnP207xyOTTao+kxr8gAAWKduI=;
        b=QPZhEOPTUEmK7EM4hClJ/SvSGJqsgSgoVP73Xym03uBQ2UrVTtO+n8p7ndpXth5qSk
         0rnchBf0H9hazOxyDj5iUojEN7w5mrFnj2e442hYSTU3xTYUM+cZ+ICy7+M9V+Ol17V1
         mCkXzA7Xiih4T9wWU09fKotcsAPP2oWYqKmNcQTYhhIQZ/XbGzzFz5Fd2fE+l0wct1YO
         d8ZKVn4kd8MRAjVpEMn8sCrdeaVyhwQnOj5ZgrZtxjs2ks/rPTrcFC8dx++QdqEuES0L
         mu+mTv5j5wx7JBrQ9D2w4dWYlfqoDxMaryXyP3R3zfWTdA+ecTLWf2lVX+M4rPi8aFnJ
         eEeA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=/z7RqVNueZzf5q8v7nnP207xyOTTao+kxr8gAAWKduI=;
        b=LIGi1GC3ebTtM4VTmn7k/9WVYH6M01HrZpJw9Cjq2SNGdXPB4Pps+MKxvbwhWx+glx
         WR5jCLG5zKEWHUYxfWzpc0NYQf7bqC0/A9uaFLhsHFCXDexb7Sh92uRUUIxYB2Cscs9c
         24MrePG9s7MsHUUos6IQXP9mc51bndo/WKM/wTd/CMQo8PJ5edp9Tdeyd+w2TM93XALb
         PW+7CibMEb9V+0o//nsKN9YCs5Y0SonNCxbrShWKVrOvU53wLhqjGbFBljNwOcIydxuK
         4q3GeEOs+Q4TEnL2OUbJKvW0FuAA2m8ElLOFuWUAhSjxTegqHvTitKqk0hhhW3vYsbe/
         NNFQ==
X-Gm-Message-State: AOAM530fs6kNf0CDV1b+8+xlG0Tp3TwGneSJZwvwpvABLKB3epbo0Xdi
        ZC+WzrVOaaIyjiBZOrmdExbL8HddwGs=
X-Google-Smtp-Source: ABdhPJzCkcH9lLeEGFRJNw5IJjOsz84mf82GHQVxwfY5lT+P6J9uWASlmkoM0LDzMhIf9umV4+0MBQ==
X-Received: by 2002:a17:906:2bce:: with SMTP id n14mr7571710ejg.171.1613039540489;
        Thu, 11 Feb 2021 02:32:20 -0800 (PST)
Received: from localhost.localdomain (212-39-89-223.ip.btc-net.bg. [212.39.89.223])
        by smtp.gmail.com with ESMTPSA id bd27sm3514031edb.37.2021.02.11.02.32.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 Feb 2021 02:32:19 -0800 (PST)
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org,
        "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Subject: [PATCH v2 00/27] Complete the KernelShark v2 transformation
Date:   Thu, 11 Feb 2021 12:31:38 +0200
Message-Id: <20210211103205.418588-1-y.karadz@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

With this patch-set we complete the destructive part of the transformation
of KernelShark towards v2 and the GUI is finally fully functional again.

v2 changes:
  * Fixing the bug in patch
    "kernel-shark: Update KsDualMarker and KsGLWidget",
    causing the error "Unable to find FreeSans font".

  * New patches:
    - kernel-shark: Search for font with Cmake at pre-build
    - kernel-shark: Add pkg-config configuration for libkshark
    - kernel-shark: Install libkshark-tepdata.h


Yordan Karadzhov (VMware) (27):
  kernel-shark: Add get_stream_object()
  kernel-shark: Do proper reset in kshark_close_all()
  kernel-shark: Restore the counting of event handlers
  kernel-shark: Fix a misleading comment
  kernel-shark: Count the number of readout interfaces
  kernel-shark: Update KsUtils
  kernel-shark: Update KsModels and KsSearchFSM
  kernel-shark: Add trace data files for CI testing
  kernel-shark: Add plugin tests
  kernel-shark: Add model tests
  kernel-shark: Update KsWidgetsLib
  kernel-shark: Add combo point to Mark
  kernel-shark: Add new methods to KsPlot::Mark
  kernel-shark: Update the plotting example
  kernel-shark: Search for font with Cmake at pre-build
  kernel-shark: Update KsDualMarker and KsGLWidget
  kernel-shark: Update KsTraceGraph and KsQuickContextMenu
  kernel-shark: Update KsTraceViewer
  kernel-shark: Update KsAdvFilteringDialog
  kernel-shark: Update KsCaptureDialog
  kernel-shark: Update KsSession
  kernel-shark: Update MissedEvents plugin
  kernel-shark: Update KsMainWindow and kernelshark.cpp
  kernel-shark: Clickable sched_event plugin shapes
  kernel-shark: Show Task plots from command lime
  kernel-shark: Add pkg-config configuration for libkshark
  kernel-shark: Install libkshark-tepdata.h

 .github/workflows/main.yml    |    9 +
 CMakeLists.txt                |   41 +-
 README                        |    1 +
 build/cmake_clean.sh          |    4 +-
 build/deff.h.cmake            |    9 +
 build/libkshark.pc.cmake      |   10 +
 examples/CMakeLists.txt       |   30 +-
 examples/dataplot.cpp         |   88 ++-
 examples/widgetdemo.cpp       |   65 +-
 src/CMakeLists.txt            |   15 +-
 src/KsAdvFilteringDialog.cpp  |  200 ++++--
 src/KsAdvFilteringDialog.hpp  |   16 +-
 src/KsCaptureDialog.cpp       |   90 +--
 src/KsCaptureDialog.hpp       |    4 +-
 src/KsDualMarker.cpp          |   23 +-
 src/KsDualMarker.hpp          |   16 +-
 src/KsGLWidget.cpp            |  696 +++++++++++++-------
 src/KsGLWidget.hpp            |  187 ++++--
 src/KsMainWindow.cpp          |  786 ++++++++++++++--------
 src/KsMainWindow.hpp          |  108 ++-
 src/KsModels.cpp              |  112 +++-
 src/KsModels.hpp              |   28 +-
 src/KsPlotTools.cpp           |   23 +-
 src/KsPlotTools.hpp           |   27 +-
 src/KsPlugins.hpp             |    5 +
 src/KsQuickContextMenu.cpp    |  151 +++--
 src/KsQuickContextMenu.hpp    |   26 +-
 src/KsSearchFSM.cpp           |   12 +-
 src/KsSession.cpp             |  379 +++++++----
 src/KsSession.hpp             |   33 +-
 src/KsTraceGraph.cpp          |  426 ++++++------
 src/KsTraceGraph.hpp          |   48 +-
 src/KsTraceViewer.cpp         |   57 +-
 src/KsTraceViewer.hpp         |   13 +-
 src/KsUtils.cpp               | 1157 +++++++++++++++++++++++----------
 src/KsUtils.hpp               |  183 ++++--
 src/KsWidgetsLib.cpp          |  695 +++++++++++++++++---
 src/KsWidgetsLib.hpp          |  331 +++++++++-
 src/kernelshark.cpp           |   64 +-
 src/libkshark-plugin.c        |   25 +-
 src/libkshark.c               |   28 +-
 src/plugins/CMakeLists.txt    |   36 +-
 src/plugins/MissedEvents.cpp  |  105 ++-
 src/plugins/SchedEvents.cpp   |   58 +-
 src/plugins/missed_events.c   |   25 +-
 src/plugins/missed_events.h   |    4 +-
 src/plugins/sched_events.c    |    7 +
 src/plugins/sched_events.h    |    3 +
 tests/CMakeLists.txt          |   42 +-
 tests/get_test_data.sh        |   21 +
 tests/libkshark-gui-tests.cpp |  313 +++++++++
 tests/libkshark-tests.cpp     |  317 ++++++++-
 tests/test-input.c            |  134 ++++
 tests/test-input_ctrl.c       |  140 ++++
 tests/test-plugin_dpi.c       |   26 +
 tests/test-plugin_dpi_ctrl.c  |   32 +
 tests/test-plugin_dpi_err.c   |   26 +
 57 files changed, 5608 insertions(+), 1902 deletions(-)
 create mode 100644 build/libkshark.pc.cmake
 create mode 100755 tests/get_test_data.sh
 create mode 100644 tests/libkshark-gui-tests.cpp
 create mode 100644 tests/test-input.c
 create mode 100644 tests/test-input_ctrl.c
 create mode 100644 tests/test-plugin_dpi.c
 create mode 100644 tests/test-plugin_dpi_ctrl.c
 create mode 100644 tests/test-plugin_dpi_err.c

-- 
2.25.1

