Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E68FDC48BE5
	for <linux-trace-devel@archiver.kernel.org>; Fri, 11 Jun 2021 11:41:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CF6F3613CD
	for <linux-trace-devel@archiver.kernel.org>; Fri, 11 Jun 2021 11:41:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231308AbhFKLnT (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 11 Jun 2021 07:43:19 -0400
Received: from mail-wr1-f44.google.com ([209.85.221.44]:40758 "EHLO
        mail-wr1-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231289AbhFKLnR (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 11 Jun 2021 07:43:17 -0400
Received: by mail-wr1-f44.google.com with SMTP id y7so5714641wrh.7
        for <linux-trace-devel@vger.kernel.org>; Fri, 11 Jun 2021 04:41:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=4vsXUPg9mxAYPeyC5Vzx4iuMl9aOV53paVCHDR0DZ4Y=;
        b=fnFcBFPjORyG+OmlcLSxyDd6RapHlPdffGp1obLsbdB+fOCWxoDi4SkcgRuKZK7+bD
         3DiAIlfcWQz7Y1zGLEqETA/NaTF1JRibtlbQN1iqZMxjPulaK8v8O0f4ss1x7ctBU8TL
         wE43FMbiUxG+6zpa4LrKpPLu78lzq6Y50ZcmZHM4AA/bYa5Ur8KEOCOJm/SfJIej++GW
         MyUE1zxBMikMbUm5kgeLaCyJn/XnlcxQXJaIg2++WnDyp5zNzNem2IOrCwsEgE71E4NA
         jpuGz9DdZrMZkTK/x+9nB4tG+roYF3J6+5YPF12ggZCR6ufy/5ZlQZAVfD4YXoq/fAb9
         MajA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=4vsXUPg9mxAYPeyC5Vzx4iuMl9aOV53paVCHDR0DZ4Y=;
        b=d7+LAFL+6El5xKfQFrTlnoFEa7XuSazvaOLmCVm10Ay32LseG9n8UYKNOPpQQ2EW+j
         nId2ZkeQyrrUsEEhZC7hfcFRE7b2QAucJRwjfVZ8g7C+y1Y5d9mVn3nqkdgkIvZn04k1
         nVo83AZuWHDOGM4dFL9ITbjLL8rsLC/96mgQCOfnJ/FEfmEg4CVFc4o866GGI8m0B5id
         LfNA9ALKGgz2iWHQueX3xLre/Wp73a1TPHN46xqqpTnzjEvc+jJG0O1IayRGxNDVkK9r
         lkeK9u2iNoNAYf1QMixAyq6NaIR2N0ohYDCJ397O7A6+19N5vSd8NtcuLdOXY7yfBaLl
         JPzA==
X-Gm-Message-State: AOAM532twDio8iY6IYVmUiwxcadG0yzmiDNQCbt/F4qbTejsHrJZ2NhC
        TNDcOsjQGOaKVNMklBQxzInc+YSrvc0=
X-Google-Smtp-Source: ABdhPJwcF040fZre2oDaMPio8y/ozZQoxd07/29qV5H45hY1JoIdjHcB7AZQFO95rJeTsXLo1LW+vg==
X-Received: by 2002:a05:6000:154e:: with SMTP id 14mr3619204wry.305.1623411609208;
        Fri, 11 Jun 2021 04:40:09 -0700 (PDT)
Received: from localhost.localdomain ([84.40.73.164])
        by smtp.gmail.com with ESMTPSA id c7sm6856464wrs.23.2021.06.11.04.40.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 11 Jun 2021 04:40:08 -0700 (PDT)
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
To:     linux-trace-devel@vger.kernel.org
Cc:     "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Subject: [PATCH v2 0/9] Build trace-cruncher as Python pakage
Date:   Fri, 11 Jun 2021 14:39:49 +0300
Message-Id: <20210611113958.38142-1-y.karadz@gmail.com>
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

Changes in v2:
 - Addressing the comments made by Steven in his review.

 - Start using the libtracefs APIs for enable/disable events.

 - Add functionalities for enable/disable event filters.

Yordan Karadzhov (VMware) (9):
  trace-cruncher: Refactor the part that wraps ftrace
  trace-cruncher: Refactor the part that wraps libkshark
  trace-cruncher: Add "utils"
  trace-cruncher: Refactor the examples
  trace-cruncher: Add Makefile
  trace-cruncher: Update README.md
  trace-cruncher: Remove all leftover files.
  trace-cruncher: Add testing
  trace-cruncher: Add github workflow for CI testing

 .github/workflows/main.yml                    |   58 +
 0001-kernel-shark-Add-_DEVEL-build-flag.patch |   90 -
 0002-kernel-shark-Add-reg_pid-plugin.patch    |  231 ---
 Makefile                                      |   33 +
 README.md                                     |   84 +-
 clean.sh                                      |    6 -
 examples/gpareto_fit.py                       |  328 ----
 examples/ksharksetup.py                       |   24 -
 examples/page_faults.py                       |  120 --
 examples/sched_wakeup.py                      |   70 +-
 libkshark-py.c                                |  224 ---
 libkshark_wrapper.pyx                         |  361 ----
 np_setup.py                                   |   90 -
 setup.py                                      |   81 +
 src/common.h                                  |  105 +
 src/ftracepy-utils.c                          | 1712 +++++++++++++++++
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
 tests/1_unit/test_01_ftracepy_unit.py         |  495 +++++
 tests/1_unit/test_02_datawrapper_unit.py      |   41 +
 tests/1_unit/test_03_ksharkpy_unit.py         |   72 +
 tests/2_integration/__init__.py               |    0
 .../test_01_ftracepy_integration.py           |  113 ++
 .../test_03_ksharkpy_integration.py           |   25 +
 tests/__init__.py                             |    0
 tracecruncher/__init__.py                     |    0
 tracecruncher/ft_utils.py                     |   28 +
 tracecruncher/ks_utils.py                     |  227 +++
 36 files changed, 4325 insertions(+), 1544 deletions(-)
 create mode 100644 .github/workflows/main.yml
 delete mode 100644 0001-kernel-shark-Add-_DEVEL-build-flag.patch
 delete mode 100644 0002-kernel-shark-Add-reg_pid-plugin.patch
 create mode 100644 Makefile
 delete mode 100755 clean.sh
 delete mode 100755 examples/gpareto_fit.py
 delete mode 100644 examples/ksharksetup.py
 delete mode 100755 examples/page_faults.py
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

