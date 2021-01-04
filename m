Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9F44CC433DB
	for <linux-trace-devel@archiver.kernel.org>; Mon,  4 Jan 2021 17:48:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 66CA6206CB
	for <linux-trace-devel@archiver.kernel.org>; Mon,  4 Jan 2021 17:48:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725921AbhADRsS (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 4 Jan 2021 12:48:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34242 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725889AbhADRsR (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 4 Jan 2021 12:48:17 -0500
Received: from mail-ed1-x529.google.com (mail-ed1-x529.google.com [IPv6:2a00:1450:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 78085C061574
        for <linux-trace-devel@vger.kernel.org>; Mon,  4 Jan 2021 09:47:37 -0800 (PST)
Received: by mail-ed1-x529.google.com with SMTP id r5so28191839eda.12
        for <linux-trace-devel@vger.kernel.org>; Mon, 04 Jan 2021 09:47:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=jO2aqYMzQh9J2VXLd/kXjRu5AU3Rzt2OyrJV6wUvwOg=;
        b=hlcfLkQLqWvUq80GvxvUnNU1bJhJnVlroSAIaWue6SsAOucsXejY7Hp927IN0S8aUq
         MDeRLP843RQBTK74tn82YNjo5EBu0KdHG3rH/68pLbu6ttKQ24tHj/StTWzkJOG8Yl3n
         pZ4yDiE+CPv/tD3B/4oIKU03jK7ESr2AkVypTppGUnaxWYlhGkHN9PYXbEOuUXDgPZRj
         +xAdTj2aIj1VaRoqDFdvx9XWwqssxi6GvW/m0N8ciSeGpUxOMXpUdoIe7asd+i68gizp
         5mgIadhgg0ncHUx5wq6Ya7RoieOtInkxPpI4IHTfZPQs2b9ClqqxZJjs6pla+WC0Gjut
         hfbA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=jO2aqYMzQh9J2VXLd/kXjRu5AU3Rzt2OyrJV6wUvwOg=;
        b=N4Zj1x5nDNb7mtgonE26lwKbTXXkAB5XILqg2gFHjwJ0pmYwjB1j6TPk9Y+8drvBX0
         2ZgWeA7Q8CldUJg32dCzW5JxHmAywHSIllGvcJc3s2+VCAFtvyNlqfg9DHlvb/YWGCxk
         ofskG3eRaRNTAgdYn5I4UDxP2RtK7/11887Kva6/ZDBKdIRqHq36QCNZxEbKldVSY1Ov
         mpcWXrRZ60oGx0bDd+staLW9i5op574ruRKtz5ksvgRGLccNHtvQfq3WWmKVUu1CCXRB
         opswQhR/TC9U8M75APskrlHlgj3AEy8xJAB6I/KR2uiFUlD+WWl47PlRSSA0axZKwhAL
         tU2g==
X-Gm-Message-State: AOAM531ZPUa4AlxXftd1Gl2Hyni93vxTNZ5wqhu7y6vKXwDnHUryIzsA
        DHf0TCNcYSroiOwXIsIFSPs=
X-Google-Smtp-Source: ABdhPJwwjquhotT6eN9L3/gq0xu0VoodMJ/y+4Jl4ZOe2/ixXXWVNuxjcZrqhfMWVKxNgRlc6aLkww==
X-Received: by 2002:a50:fb85:: with SMTP id e5mr71210734edq.153.1609782455936;
        Mon, 04 Jan 2021 09:47:35 -0800 (PST)
Received: from localhost.localdomain ([95.87.199.238])
        by smtp.gmail.com with ESMTPSA id l14sm44107750edq.35.2021.01.04.09.47.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 04 Jan 2021 09:47:35 -0800 (PST)
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org,
        "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Subject: [PATCH v8 00/44] Start KernelShark v2 transformation
Date:   Mon,  4 Jan 2021 19:46:40 +0200
Message-Id: <20210104174724.70404-1-y.karadz@gmail.com>
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

Changes in v8:
 * In particular patch 6 splits the installation of the project in two
   components. This can be used to create two packages. One for the GUI
   and one "devel" package installing the headers. This patch are inspired
   by the talk "Deep CMake For Library Authors" presented at CppCon 2019
   by Craig Scott.
   https://crascit.com/2019/10/16/cppcon-2019-deep-cmake-for-library-authors/

 * Patches 35-44 has been sent already, but as part of a separated
   patch-set.

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

Yordan Karadzhov (VMware) (43):
  kernel-shark: Adopt trace-cmd API changes
  kernel-shark: Use libtraceevent and libtracefs
  kernel-shark: Add license information
  kernel-shark: Change the CMake minimum version required
  kernel-shark: Change default libraries install location
  kernel-shark: Split the installation in two components
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
  kernel-shark: Add basic infrastructure for testing
  kernel-shark: Integrate streams with KsPlotTools
  kernel-shark: Add getStreamColorTable()
  kernel-shark: Redefine the args of KsPlot::getColor()
  kernel-shark: Add TextBox class to KsPlot namespace
  kernel-shark: Consistent method naming in KsPlotTools
  kernel-shark: Make the label part of the graph
  kernel-shark: Remove the hard-coded Idle PID
  kernel-shark: Add class Polyline to KsPlot namespace
  kernel-shark: Add VirtBridge and VirtGap classes
  kernel-shark: Add double click interface to PlotObject

 .github/workflows/main.yml       |   63 +
 CMakeLists.txt                   |   55 +-
 Documentation/doxygen/dox_config |    1 +
 LICENSES/GPL-2.0                 |  359 +++
 LICENSES/LGPL-2.1                |  503 +++
 README                           |  129 +-
 build/FindJSONC.cmake            |   70 +-
 build/FindTraceCmd.cmake         |  138 +-
 build/FindTraceEvent.cmake       |   76 +
 build/FindTraceFS.cmake          |   76 +
 build/cmake_clean.sh             |    4 +
 build/cmake_uninstall.sh         |   23 +-
 build/deff.h.cmake               |   15 +-
 build/install_gui.sh             |    1 +
 build/install_libkshark-devel.sh |    1 +
 examples/CMakeLists.txt          |   34 +-
 examples/configio.c              |   20 +-
 examples/datafilter.c            |   67 +-
 examples/datahisto.c             |   38 +-
 examples/dataload.c              |   28 +-
 examples/multibufferload.c       |   53 +
 src/CMakeLists.txt               |   70 +-
 src/KsPlotTools.cpp              |  412 ++-
 src/KsPlotTools.hpp              |  199 +-
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
 src/plugins/CMakeLists.txt       |    3 +-
 src/plugins/sched_events.c       |    4 +-
 src/stb_truetype.h               | 5011 ++++++++++++++++++++++++++++++
 tests/CMakeLists.txt             |   14 +
 tests/libkshark-tests.cpp        |   48 +
 42 files changed, 13839 insertions(+), 2144 deletions(-)
 create mode 100644 .github/workflows/main.yml
 create mode 100644 LICENSES/GPL-2.0
 create mode 100644 LICENSES/LGPL-2.1
 create mode 100644 build/FindTraceEvent.cmake
 create mode 100644 build/FindTraceFS.cmake
 create mode 100755 build/install_gui.sh
 create mode 100755 build/install_libkshark-devel.sh
 create mode 100644 examples/multibufferload.c
 create mode 100644 src/libkshark-hash.c
 create mode 100644 src/libkshark-tepdata.c
 create mode 100644 src/libkshark-tepdata.h
 create mode 100644 src/stb_truetype.h
 create mode 100644 tests/CMakeLists.txt
 create mode 100644 tests/libkshark-tests.cpp

-- 
2.25.1

