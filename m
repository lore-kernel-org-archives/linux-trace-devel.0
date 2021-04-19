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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 74F75C433B4
	for <linux-trace-devel@archiver.kernel.org>; Mon, 19 Apr 2021 13:01:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4BD5A611F0
	for <linux-trace-devel@archiver.kernel.org>; Mon, 19 Apr 2021 13:01:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237570AbhDSNCZ (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 19 Apr 2021 09:02:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54684 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239320AbhDSNCX (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 19 Apr 2021 09:02:23 -0400
Received: from mail-wr1-x42d.google.com (mail-wr1-x42d.google.com [IPv6:2a00:1450:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E1051C06138D
        for <linux-trace-devel@vger.kernel.org>; Mon, 19 Apr 2021 06:01:53 -0700 (PDT)
Received: by mail-wr1-x42d.google.com with SMTP id w4so30229207wrt.5
        for <linux-trace-devel@vger.kernel.org>; Mon, 19 Apr 2021 06:01:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=wiJhvvs17Chn0iL5y6G0v0NCek0L0sOCj9orJ/0kgWI=;
        b=V4u4avlpGV6FhMXqXnvTbsjTZaWyf0F2ozm8Hm3vftl4f3mX+ULf/9RUMI1IB7hha+
         gSrL24zkS423ET9Ni2zvUNaPIvj7ioItSk6F9o0SbNQuoBex0hJzV/8IMyArP1b6izLQ
         ysl8dgpYHmIi/DI/rSwy3cr4YKRBpl0QwrhKDwINEvYv9S63PGyloY4+3iN2chhTua8b
         r0OkFjZOkaqtcaLBdu0P2AA+W874iE5ZAJhmpsSd2eLiDG1DE0LtDBteowmkCFeKJ/9Q
         uQtNHa4XzaBEOnEo4ljbS3bdoFg+enSUAA4Ybx/X48MiBinZQnDtDt4v+EYlZ9WiId2N
         n0VA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=wiJhvvs17Chn0iL5y6G0v0NCek0L0sOCj9orJ/0kgWI=;
        b=KyxTZdlNw/PLxslCTDaXR4PmttH7+C9cHXU7K60njZGFCzqG0OUdYdSVRqCsQWadDD
         YKnKxqBjXPwqQAcmiKxr99pXFhmzr030v5lQvJh+cHmzyuBNOsN25PzwPcMSPDuLihqL
         zaFi8b3a/4kK3F0BCs4j/SJhE3Jhe4ZmE9/o5p6B5yrwvGfk4A8a/jhRb7q4TuWg+cft
         CigIVGgDylGGQUFdqBX95wmB5km79lD7ZtXf2QVycQ26BCMqZlbAlV6C21Odv1X9sYrd
         6ut25ccIsA35jsYElbwxZ9iF9ZF5YclkOttifxMvs/iqNJJ5dnYSrMOnI9hDdA/9Wvwp
         1Uxg==
X-Gm-Message-State: AOAM532ZXEYnpaVG7+vUubkv3en57saZyZ8yiVpfVBo127cfFhma69ln
        AOjrd49A77FLScnyMhGfvPdF63H23U8=
X-Google-Smtp-Source: ABdhPJybyH8RJ+UISBGR3Aj+qDSbTq4s+oPigXCvNMZRKtUC+45kMU6r2OHmrCpSsuz7y0LqC8ch+g==
X-Received: by 2002:a5d:4fc7:: with SMTP id h7mr14442102wrw.23.1618837312421;
        Mon, 19 Apr 2021 06:01:52 -0700 (PDT)
Received: from bucy.vmware.com ([84.40.93.28])
        by smtp.gmail.com with ESMTPSA id v7sm23164196wrs.2.2021.04.19.06.01.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Apr 2021 06:01:51 -0700 (PDT)
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
To:     linux-trace-devel@vger.kernel.org
Cc:     "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Subject: [PATCH 0/9] Build trace-cruncher as Python pakage
Date:   Mon, 19 Apr 2021 16:01:31 +0300
Message-Id: <20210419130140.59140-1-y.karadz@gmail.com>
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
 0001-kernel-shark-Add-_DEVEL-build-flag.patch |   90 --
 0002-kernel-shark-Add-reg_pid-plugin.patch    |  231 ---
 Makefile                                      |   33 +
 README.md                                     |   84 +-
 clean.sh                                      |    6 -
 examples/gpareto_fit.py                       |  328 ----
 examples/ksharksetup.py                       |   24 -
 examples/page_faults.py                       |  120 --
 examples/sched_wakeup.py                      |   70 +-
 libkshark-py.c                                |  224 ---
 libkshark_wrapper.pyx                         |  361 -----
 np_setup.py                                   |   90 --
 setup.py                                      |   81 +
 src/common.h                                  |  100 ++
 src/ftracepy-utils.c                          | 1367 +++++++++++++++++
 src/ftracepy-utils.h                          |  127 ++
 src/ftracepy.c                                |  262 ++++
 src/ksharkpy-utils.c                          |  411 +++++
 src/ksharkpy-utils.h                          |   41 +
 src/ksharkpy.c                                |   94 ++
 src/npdatawrapper.pyx                         |  203 +++
 src/trace2matrix.c                            |   40 +
 tests/0_get_data/__init__.py                  |    0
 tests/0_get_data/test_get_data.py             |   26 +
 tests/1_unit/__init__.py                      |    0
 tests/1_unit/test_01_ftracepy_unit.py         |  454 ++++++
 tests/1_unit/test_02_datawrapper_unit.py      |   41 +
 tests/1_unit/test_03_ksharkpy_unit.py         |   72 +
 tests/2_integration/__init__.py               |    0
 .../test_01_ftracepy_integration.py           |  113 ++
 .../test_03_ksharkpy_integration.py           |   25 +
 tests/__init__.py                             |    0
 tracecruncher/__init__.py                     |    0
 tracecruncher/ft_utils.py                     |   28 +
 tracecruncher/ks_utils.py                     |  227 +++
 36 files changed, 3887 insertions(+), 1544 deletions(-)
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

