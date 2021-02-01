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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4389CC433E6
	for <linux-trace-devel@archiver.kernel.org>; Mon,  1 Feb 2021 17:25:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 10B4D64EAA
	for <linux-trace-devel@archiver.kernel.org>; Mon,  1 Feb 2021 17:25:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230171AbhBARY7 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 1 Feb 2021 12:24:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38198 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230470AbhBARYx (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 1 Feb 2021 12:24:53 -0500
Received: from mail-ej1-x630.google.com (mail-ej1-x630.google.com [IPv6:2a00:1450:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 48F64C061573
        for <linux-trace-devel@vger.kernel.org>; Mon,  1 Feb 2021 09:24:13 -0800 (PST)
Received: by mail-ej1-x630.google.com with SMTP id y9so4026674ejp.10
        for <linux-trace-devel@vger.kernel.org>; Mon, 01 Feb 2021 09:24:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=2BGHrj1rDsuy/4X1kMcjLVKbp7ujQnlHDJKl9ueAmE0=;
        b=j99ykR3N3n+0ZcnUY0bF5/5A0ewZQVjCsdgi3qhyrAC7GCnl9YYDzuxeAGCHUDjfYV
         qQEfnlKWagMiWIPe45euZ166QdL547rEmSfh7veiAGflGVDzKTuddLhj5xpwyq8sg7pz
         GTJHbsFM9yS0cofVTnjpai0pmdMvOIN7j/Hy994Yjr3TRYjn9zCuFz8aklzBPWchXJyO
         iOfqApgQk6+0rdqH6CjCcELisChkbvmHAiHHUx9xGWUO84GOT1dqhUQbTCI4McEdamWG
         iIdQbues0zX22J65RuZeAg1bTCvhX2a8QGkPGLI/tqzBoYVbGApGoS/Z2mw09mSZa8Lf
         btgw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=2BGHrj1rDsuy/4X1kMcjLVKbp7ujQnlHDJKl9ueAmE0=;
        b=diw93/ddsBrm6aCyfS+a06TQSxcflXeiQHoGGpBMYuFjHMp6FRZhzIvM7jDp0dUdDO
         UFMGVDgZnPgGcKecRtdZJxT8yjsL6lDvafGAy+aVsjWNq7+6t0YfUQZs++BPcVTBf46p
         4BIVX8UTdlan2BoqYrGjPFm8iHNHWt1+mD6kF3lWbWRbNXF1hDhkJHrc7nQvjxJRZdYX
         OBRYZomn8RlOgyb+vnAMgsD1Z83tGLOtdwUsEcinWq4v3mKQ0KtuZkRtFmzNia55MgbM
         Ri8ijdXN3WltkTraYgOT3WPYjagXlUUbR5C6zWGbPXedXE1R6mk51+tvqQw/0RVab9wl
         zZRA==
X-Gm-Message-State: AOAM531GJdWrqo9qW3Td9nDPkVfPrWrhe7jmR5jK5P9fwiBP6JA8T5Xd
        KcFprcyK+NWEcY+E8AHergUDn5cT8hs=
X-Google-Smtp-Source: ABdhPJwxYVjZF+myjrD1Rs/XzNJeXkAo+pVl8Fe1ey12u3dFmDd2EciOIctGKHcj0fVGHd6XRICMaQ==
X-Received: by 2002:a17:906:9bcd:: with SMTP id de13mr6633288ejc.245.1612200252080;
        Mon, 01 Feb 2021 09:24:12 -0800 (PST)
Received: from localhost.localdomain ([95.87.199.218])
        by smtp.gmail.com with ESMTPSA id bm9sm8312446ejb.14.2021.02.01.09.24.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Feb 2021 09:24:11 -0800 (PST)
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org,
        "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Subject: [PATCH 00/24] Complete the KernelShark v2 transformation
Date:   Mon,  1 Feb 2021 19:23:34 +0200
Message-Id: <20210201172358.175407-1-y.karadz@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

With this patch-set we complete the destructive part of the transformation
of KernelShark towards v2 and the GUI is finally fully functional again.

Yordan Karadzhov (VMware) (24):
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

 .github/workflows/main.yml    |    8 +
 CMakeLists.txt                |   24 +-
 build/cmake_clean.sh          |    3 +-
 build/deff.h.cmake            |    6 +
 examples/CMakeLists.txt       |   30 +-
 examples/dataplot.cpp         |   88 ++-
 examples/widgetdemo.cpp       |   65 +-
 src/CMakeLists.txt            |    4 +-
 src/KsAdvFilteringDialog.cpp  |  200 ++++--
 src/KsAdvFilteringDialog.hpp  |   16 +-
 src/KsCaptureDialog.cpp       |   90 +--
 src/KsCaptureDialog.hpp       |    4 +-
 src/KsDualMarker.cpp          |   23 +-
 src/KsDualMarker.hpp          |   16 +-
 src/KsGLWidget.cpp            |  718 +++++++++++++-------
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
 src/plugins/CMakeLists.txt    |   31 +-
 src/plugins/MissedEvents.cpp  |  105 ++-
 src/plugins/SchedEvents.cpp   |   58 +-
 src/plugins/missed_events.c   |   25 +-
 src/plugins/missed_events.h   |    4 +-
 src/plugins/sched_events.c    |    7 +
 src/plugins/sched_events.h    |    3 +
 tests/CMakeLists.txt          |   38 +-
 tests/get_test_data.sh        |   21 +
 tests/libkshark-gui-tests.cpp |  313 +++++++++
 tests/libkshark-tests.cpp     |  308 ++++++++-
 tests/test-input.c            |  134 ++++
 tests/test-input_ctrl.c       |  140 ++++
 tests/test-plugin_dpi.c       |   26 +
 tests/test-plugin_dpi_ctrl.c  |   32 +
 tests/test-plugin_dpi_err.c   |   26 +
 55 files changed, 5571 insertions(+), 1899 deletions(-)
 create mode 100755 tests/get_test_data.sh
 create mode 100644 tests/libkshark-gui-tests.cpp
 create mode 100644 tests/test-input.c
 create mode 100644 tests/test-input_ctrl.c
 create mode 100644 tests/test-plugin_dpi.c
 create mode 100644 tests/test-plugin_dpi_ctrl.c
 create mode 100644 tests/test-plugin_dpi_err.c

-- 
2.25.1

