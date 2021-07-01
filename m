Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AD355C11F64
	for <linux-trace-devel@archiver.kernel.org>; Thu,  1 Jul 2021 11:14:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7F5BA61450
	for <linux-trace-devel@archiver.kernel.org>; Thu,  1 Jul 2021 11:14:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236125AbhGALRD (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 1 Jul 2021 07:17:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46408 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236040AbhGALRD (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 1 Jul 2021 07:17:03 -0400
Received: from mail-wr1-x433.google.com (mail-wr1-x433.google.com [IPv6:2a00:1450:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D4E2C061756
        for <linux-trace-devel@vger.kernel.org>; Thu,  1 Jul 2021 04:14:32 -0700 (PDT)
Received: by mail-wr1-x433.google.com with SMTP id i8so7773774wrc.0
        for <linux-trace-devel@vger.kernel.org>; Thu, 01 Jul 2021 04:14:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Iovut/IYkteAv5maXfgtP8YozoslDlzZ/84ceBw+/yo=;
        b=CJMCpfey5Hl1KySkrZfGLKVzD0FxoUW2kSe9JxPH+GN4GLUAGpE6Xar3K8Mk1Sb3sO
         /VODEn8rMPL5lUrbphDH1stAjq9dhSYQ+f48S9eNK0Mw+S7xc5SgG3Rx2L4ZO/uCukYn
         2DtGr5mkAfUjRfFGblpDfwoN60nR3E0j5emUvSPCgixwPvZULKZ+I1/0HjPTpEjJCTX+
         NbMT1F44iBc+05ctCfmLdwi3QERDwylJ6RLNH+qOnV0Olq4fV1B8lfEiNdxeNjr0Gowx
         eIHEm0Lm3GQkcsi7/lKKOjVWzkgDADPoQXgGvyi6Vwt4z0XOysK+f9kTKRJKO1D+oOZQ
         rggw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Iovut/IYkteAv5maXfgtP8YozoslDlzZ/84ceBw+/yo=;
        b=jUMJhHxLI4ci/dZt+JPCpAAYIrIs7jeqqqRTiEl6BRczApKMBZXknzsGr3jZKkQGhI
         Vh1ItQM9FNx2oC7dk5/3G7Nfk2DvNmT/YOiIDs/iXmMIJ/4DwbESHFSZffOmlTLbSk7Q
         rlIPGpXnCYMRibTLNAKVxXLXDIC4PC+Y9b643JW3VW0+/jUTIr83r5zMJVZwxlUYkDv+
         Jfe0HXd91aYg37yIYG1nUgq49uf+Y1fNfFNed0npSGA3T7TZ5y+I1Ks+nMaQ3YrQxIo9
         jcPnXEAlq3npff3ecZwqZbhwzHjxVz22jspvkYkNuY8fvDTpRPKerM5BMAkSyA3vMZki
         917g==
X-Gm-Message-State: AOAM530bq48OG6G8r0fhtMhM+cW7q9LzxcE2YkqFlZZA25NiqCctVcC7
        RTKHOVE5A2lU1h4R+YErWGqPz4tf4U8=
X-Google-Smtp-Source: ABdhPJwYH95Bx9KJCUeoFnYNYGhXqjxUqMetcaTRxqpr2wfJy5b+IDo8/ragJi7JoO7AsJ5e2h7RHw==
X-Received: by 2002:adf:de89:: with SMTP id w9mr44160891wrl.375.1625138070719;
        Thu, 01 Jul 2021 04:14:30 -0700 (PDT)
Received: from bucy.eng.vmware.com ([146.247.46.134])
        by smtp.gmail.com with ESMTPSA id o17sm9223009wmh.19.2021.07.01.04.14.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 01 Jul 2021 04:14:30 -0700 (PDT)
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
To:     linux-trace-devel@vger.kernel.org
Cc:     rostedt@goodmis.org, warthog9@eaglescrag.net,
        "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Subject: [PATCH v3 00/11] Build trace-cruncher as Python pakage
Date:   Thu,  1 Jul 2021 14:14:07 +0300
Message-Id: <20210701111418.18386-1-y.karadz@gmail.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

This patch-set restructures the project and makes it build as a native
Python package. Although it looks like a complete rewrite, this is
essentially just a switching from using Cython to using directly the C API
of Python. Cython is still being used but only for the implementation
of the NumPy data wrapper. The functionalities that are wrapping Ftrace
are extended substantially. This is possible due to switching to use of
the recently released libraries: libtraceevent and libtracefs. 

Major changes in v3:
 - More basic methods for tracing are added ([PATCH 02/11] new).
 - Auto-naming of the instances is sypported.
 - Recently implemented new APIs in libtracefs are adopted.
 
Changes in v2:
 - Addressing the comments made by Steven in his review.
 - Start using the libtracefs APIs for enable/disable events.
 - Add functionalities for enable/disable event filters.

Yordan Karadzhov (VMware) (11):
  trace-cruncher: Refactor the part that wraps ftrace
  trace-cruncher: Add basic methods for tracing
  trace-cruncher: Refactor the part that wraps libkshark
  trace-cruncher: Add "utils"
  trace-cruncher: Refactor the examples
  trace-cruncher: Add ftracefy example
  trace-cruncher: Add Makefile
  trace-cruncher: Update README.md
  trace-cruncher: Remove all leftover files.
  trace-cruncher: Add testing
  trace-cruncher: Add github workflow for CI testing

 .github/workflows/main.yml                    |   58 +
 0001-kernel-shark-Add-_DEVEL-build-flag.patch |   90 -
 0002-kernel-shark-Add-reg_pid-plugin.patch    |  231 --
 Makefile                                      |   33 +
 README.md                                     |   84 +-
 clean.sh                                      |    6 -
 examples/gpareto_fit.py                       |  328 ---
 examples/ksharksetup.py                       |   24 -
 examples/page_faults.py                       |  120 --
 examples/sched_wakeup.py                      |   70 +-
 examples/start_tracing.py                     |   20 +
 libkshark-py.c                                |  224 --
 libkshark_wrapper.pyx                         |  361 ----
 np_setup.py                                   |   90 -
 setup.py                                      |   81 +
 src/common.h                                  |  105 +
 src/ftracepy-utils.c                          | 1849 +++++++++++++++++
 src/ftracepy-utils.h                          |  144 ++
 src/ftracepy.c                                |  292 +++
 src/ksharkpy-utils.c                          |  411 ++++
 src/ksharkpy-utils.h                          |   41 +
 src/ksharkpy.c                                |   94 +
 src/npdatawrapper.pyx                         |  203 ++
 src/trace2matrix.c                            |   40 +
 tests/0_get_data/__init__.py                  |    0
 tests/0_get_data/test_get_data.py             |   26 +
 tests/1_unit/__init__.py                      |    0
 tests/1_unit/test_01_ftracepy_unit.py         |  471 +++++
 tests/1_unit/test_02_datawrapper_unit.py      |   41 +
 tests/1_unit/test_03_ksharkpy_unit.py         |   72 +
 tests/2_integration/__init__.py               |    0
 .../test_01_ftracepy_integration.py           |  113 +
 .../test_03_ksharkpy_integration.py           |   25 +
 tests/__init__.py                             |    0
 tracecruncher/__init__.py                     |    0
 tracecruncher/ft_utils.py                     |   19 +
 tracecruncher/ks_utils.py                     |  227 ++
 37 files changed, 4449 insertions(+), 1544 deletions(-)
 create mode 100644 .github/workflows/main.yml
 delete mode 100644 0001-kernel-shark-Add-_DEVEL-build-flag.patch
 delete mode 100644 0002-kernel-shark-Add-reg_pid-plugin.patch
 create mode 100644 Makefile
 delete mode 100755 clean.sh
 delete mode 100755 examples/gpareto_fit.py
 delete mode 100644 examples/ksharksetup.py
 delete mode 100755 examples/page_faults.py
 create mode 100755 examples/start_tracing.py
 delete mode 100644 libkshark-py.c
 delete mode 100644 libkshark_wrapper.pyx
 delete mode 100755 np_setup.py
 create mode 100644 setup.py
 create mode 100644 src/common.h
 create mode 100644 src/ftracepy-utils.c
 create mode 100644 src/ftracepy-utils.h
 create mode 100644 src/ftracepy.c
 create mode 100644 src/ksharkpy-utils.c
 create mode 100644 src/ksharkpy-utils.h
 create mode 100644 src/ksharkpy.c
 create mode 100644 src/npdatawrapper.pyx
 create mode 100644 src/trace2matrix.c
 create mode 100644 tests/0_get_data/__init__.py
 create mode 100755 tests/0_get_data/test_get_data.py
 create mode 100644 tests/1_unit/__init__.py
 create mode 100644 tests/1_unit/test_01_ftracepy_unit.py
 create mode 100755 tests/1_unit/test_02_datawrapper_unit.py
 create mode 100755 tests/1_unit/test_03_ksharkpy_unit.py
 create mode 100644 tests/2_integration/__init__.py
 create mode 100755 tests/2_integration/test_01_ftracepy_integration.py
 create mode 100755 tests/2_integration/test_03_ksharkpy_integration.py
 create mode 100644 tests/__init__.py
 create mode 100644 tracecruncher/__init__.py
 create mode 100644 tracecruncher/ft_utils.py
 create mode 100644 tracecruncher/ks_utils.py

-- 
2.27.0

