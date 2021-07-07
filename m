Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4C206C07E95
	for <linux-trace-devel@archiver.kernel.org>; Wed,  7 Jul 2021 13:22:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2C9DC61C5B
	for <linux-trace-devel@archiver.kernel.org>; Wed,  7 Jul 2021 13:22:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231438AbhGGNYu (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 7 Jul 2021 09:24:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53606 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229757AbhGGNYu (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 7 Jul 2021 09:24:50 -0400
Received: from mail-ej1-x633.google.com (mail-ej1-x633.google.com [IPv6:2a00:1450:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED644C061574
        for <linux-trace-devel@vger.kernel.org>; Wed,  7 Jul 2021 06:22:09 -0700 (PDT)
Received: by mail-ej1-x633.google.com with SMTP id o5so3248190ejy.7
        for <linux-trace-devel@vger.kernel.org>; Wed, 07 Jul 2021 06:22:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Qc/fQg/xQRpe9myaMn2Bj70Q6Dbk/eQGsvJdYtqMVy0=;
        b=gifaJDkzk3h9lXRd7ZjfQgkfASnwHeAS3Gu1FYXBkP5ZnutskppPQVIuU6xNYcAW9G
         A8VoPgnXI+FxaUpSCjjZG3AG9vCJ70WRISNL1NEByRD1rBj30WmYATEsE7c51IkxsTbj
         okb6IY1l0gJdZM0JogfgF6rdE4FDr4amK3ChrYt8FipPzC7oqG2iYxprS8TvzHxTGQmY
         8PywO0CAOUThFu98/vNF2DaZ6JuZRd9s1bksUvA+WhuCEysn+GCyTMBaJLnln08JR8LB
         UkfhHNKdWdAJSZy3ToB+hK/MUfUqjPReu1FI3SEBj9RJbZkOxPu/G8Bx9PYCUTE3BYnu
         qL9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Qc/fQg/xQRpe9myaMn2Bj70Q6Dbk/eQGsvJdYtqMVy0=;
        b=QOTzmau73Y0nUzxWcmbnJsUXkoVbSTfjHJQsbNjNxmBgh7nWGERpEwg6MeMg3GyS/W
         t9nwheCngj7zPJsnTLn7wNsaTGjsCHizSZjjie7t/FB9//odndxwwQ2Te9BppfDoCoQ1
         B6IA70sfciuu469SPmGxV+QVS1ne93abx0b7P/L4OQ+uowna6nT2x+UyelDApsTjU0um
         Ehs79vtO/Ts7q6OHKl+SkceFW8Qb7keDotvFRk4qnHsNVvH3fqOwg+FrbiAmGoEzU/zq
         4EV8fAOCfV1VUa9mZWJhur8IJrOzMrrQ9fQxoeWwzwinjU+/dpa0nyS5gdRMAeIYiGC4
         fFOw==
X-Gm-Message-State: AOAM533MUeeW39s4zlvqrgtRTTdUC9dJay1Ph/1Bk+/He9eni5PsIL/j
        wqGJzh+TazkB9au8Dq5MBm3jJp1t+m8=
X-Google-Smtp-Source: ABdhPJyDRJgplwwJiCdPKv+TUsVgglOGPPvSTwWlQkN0Fjpo1TkQ6FajsZJ9EUfa+g1g0pIF1y+5xg==
X-Received: by 2002:a17:906:d8cf:: with SMTP id re15mr24313022ejb.410.1625664128432;
        Wed, 07 Jul 2021 06:22:08 -0700 (PDT)
Received: from localhost.localdomain ([84.40.73.10])
        by smtp.gmail.com with ESMTPSA id eb9sm7064881ejc.32.2021.07.07.06.22.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 Jul 2021 06:22:08 -0700 (PDT)
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
To:     linux-trace-devel@vger.kernel.org
Cc:     "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Subject: [PATCH v4 00/11] Build trace-cruncher as Python pakage
Date:   Wed,  7 Jul 2021 16:21:46 +0300
Message-Id: <20210707132158.68520-1-y.karadz@gmail.com>
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

Major changes in v4:
 - More robust signal handling in iterate_trace() (PATCH 02/11). 

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
  trace-cruncher: Add ftracepy example
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
 src/ftracepy-utils.c                          | 1869 +++++++++++++++++
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
 37 files changed, 4469 insertions(+), 1544 deletions(-)
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

