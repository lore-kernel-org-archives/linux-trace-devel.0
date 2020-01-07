Return-Path: <SRS0=g3Xf=24=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7B7F3C33C8C
	for <linux-trace-devel@archiver.kernel.org>; Tue,  7 Jan 2020 17:03:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4E2BC208C4
	for <linux-trace-devel@archiver.kernel.org>; Tue,  7 Jan 2020 17:03:50 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="WvYsy3KJ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728409AbgAGRDu (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 7 Jan 2020 12:03:50 -0500
Received: from mail-lj1-f175.google.com ([209.85.208.175]:37097 "EHLO
        mail-lj1-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728389AbgAGRDt (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 7 Jan 2020 12:03:49 -0500
Received: by mail-lj1-f175.google.com with SMTP id o13so338388ljg.4
        for <linux-trace-devel@vger.kernel.org>; Tue, 07 Jan 2020 09:03:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=657FRN3PoQJhjswUSMhjSDhKJwbqXC/PTCmdDR1lNbw=;
        b=WvYsy3KJcsFVq9yyV05gkCIvg+kZ7QuUWscjcSjfL1nfsX1A/DLqreWpqgu1e4F9jR
         6tblSEc+9lOROCw8ZbEXuHaCxpP7tmA7AUrqcpLZeROZMXfUgGC9DyTjo8G22dnlRQ31
         d4LRspuMNkWIS/oe+T4Ql19eD+rNsroZZ30VlQEWAeXwkJGQHhk2QVESWA4zRTrnq7oQ
         JJykKVTxobXmwhFT5pEpb2dP89TzJ5gKGYo8Esy71RQBsHh/esqP9Lvz8SeMhlGjTYfK
         OvljPSRhl4IrkQDzP25kWYIo/F6Z+2Px3cCLe77e+LK+WvktOBvyABzbXHkuZpXxxZx6
         EBaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=657FRN3PoQJhjswUSMhjSDhKJwbqXC/PTCmdDR1lNbw=;
        b=Rev3y0tB5uwnoJU0pI/ZscUwy+mK6cK9Ndj+Gpgg1qlaoaeXeGIFPneys9SoPAP0jg
         sj8wQsTlxeI0e+++JESkHnlkO9sDndyEWfabPwY8a27pVRpXuCU4qKSaA5watKEB7iNL
         +KaVEo74sjTW/NGfExLsxekjgP1sjgY3ymMu5SJA5P2ibiWLMpU8Ex7ykRViVyqTbtD8
         XnZBVwRo0lIhuF7+NHNMr6jvjzIX55jovYpkMzBMT425f3XrMWHH5JkskSJx2aRlaefy
         47RjBajtJqNF2eCwhGL+yp2eGhB25PKjn6c6NOaa5hmDI8xz4tGXX6llAQiRTsi04NPa
         7s7A==
X-Gm-Message-State: APjAAAXtXRYthX4ODSFsn0f5/A9uFUv0tAdDZGLBIpoIlRFRU9HZi97d
        gyu5DZf6yxRqD5a42i3sWQMdr02C
X-Google-Smtp-Source: APXvYqyp5NV+VCuArwsakje6nb1HGKAEQHiBkdKEkZqMm3ZaFY/scJDVGEJAMbYNVVpD1SZNXfsvAQ==
X-Received: by 2002:a2e:9716:: with SMTP id r22mr284490lji.224.1578416626172;
        Tue, 07 Jan 2020 09:03:46 -0800 (PST)
Received: from mamba.eng.vmware.com ([146.247.46.5])
        by smtp.gmail.com with ESMTPSA id d16sm140605lfa.16.2020.01.07.09.03.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Jan 2020 09:03:45 -0800 (PST)
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
To:     linux-trace-devel@vger.kernel.org
Cc:     rostedt@goodmis.org, Douglas.Raillard@arm.com,
        Valentin.Schneider@arm.com, nd@arm.com,
        "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Subject: [PATCH v2 00/12]  Build trace-cruncher as Python pakage
Date:   Tue,  7 Jan 2020 19:03:00 +0200
Message-Id: <20200107170312.27116-1-y.karadz@gmail.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

This patch-set is an attempt to restructure the project and to make it
build as a native Python package. Although it looks like a complete
rewrite, this is essentially just a switching from using Cython to using
directly the C API of Python. Cython is still being used but only for
the implementation of the NumPy data wrapper. The new building procedure
is very simple and intuitive. The appropriate versions of trace-cmd and
KernelShark libraries are automatically download, patch and build. These
third-party libraries are installed as part of trace-cruncher itself and
do not interfere with any existing system-wide installations of trace-cmd
and KernelShark.

All patches are available at:
https://github.com/vmware/trace-cruncher/tree/refactoring_WIP (branch
"refactoring_WIP")

v2 changes:
  - Trying to address the building issues reported by Douglas Raillard in 
    particular the missing header file and the problem of linking with
    libkshark.so.X.Y.Z
  - Douglas suggested to use venv in order to avoid the patched versions
    of the third-party libraries to pollut the system-wide locations.
    Here I am suggesting a different solution that allows to make those
    third-party libraries part of the package itself. Not sure which of
    the two solution is the best. It will be great if we can have a
    discussion.
  - All obsoleted source files are removed and the README file is updated
    to describe the new building procedure.



Yordan Karadzhov (VMware) (12):
  trace-cruncher: Refactor the part of the interface that relies on
    libkshark
  trace-cruncher: Refactor the part of the interface that relies on
    libtraceevent
  trace-cruncher: Refactor NumPy based data wrapper
  trace-cruncher: Add "utils"
  trace-cruncher: Adapt sched_wakeup.py to use the new module
  trace-cruncher: Add Makefile
  trace-cruncher: Adapt gpareto_fit.py to use the new module
  trace-cruncher: Adapt page_faults.py to use the new module
  trace-cruncher: Automate the third-party build
  Update README.md
  trace-cruncher: Remove all leftover files.
  trace-cruncher: Improve Makefile Provide more robust and better
    looking build process.

 ...-_DEVEL-_LIBS-and-_RPATH_TO_ORIGIN-b.patch | 160 ++++++++
 0001-kernel-shark-Add-_DEVEL-build-flag.patch |  90 -----
 0002-kernel-shark-Add-reg_pid-plugin.patch    |   8 +-
 Makefile                                      |  36 ++
 README.md                                     |  50 +--
 clean.sh                                      |   6 -
 examples/gpareto_fit.py                       |  35 +-
 examples/ksharksetup.py                       |  24 --
 examples/page_faults.py                       |  64 ++--
 examples/sched_wakeup.py                      |  30 +-
 install_third_party.sh                        |  39 ++
 libkshark-py.c                                | 224 -----------
 libkshark_wrapper.pyx                         | 361 ------------------
 np_setup.py                                   |  90 -----
 setup.py                                      |  68 ++++
 src/common.h                                  |  20 +
 src/datawrapper.pyx                           | 201 ++++++++++
 src/ftracepy.c                                | 233 +++++++++++
 src/ksharkpy.c                                | 269 +++++++++++++
 src/trace2matrix.c                            |  29 ++
 tracecruncher/__init__.py                     |   4 +
 tracecruncher/utils.py                        |  54 +++
 22 files changed, 1188 insertions(+), 907 deletions(-)
 create mode 100644 0001-kernel-shark-Add-_DEVEL-_LIBS-and-_RPATH_TO_ORIGIN-b.patch
 delete mode 100644 0001-kernel-shark-Add-_DEVEL-build-flag.patch
 create mode 100644 Makefile
 delete mode 100755 clean.sh
 delete mode 100644 examples/ksharksetup.py
 create mode 100755 install_third_party.sh
 delete mode 100644 libkshark-py.c
 delete mode 100644 libkshark_wrapper.pyx
 delete mode 100755 np_setup.py
 create mode 100644 setup.py
 create mode 100644 src/common.h
 create mode 100644 src/datawrapper.pyx
 create mode 100644 src/ftracepy.c
 create mode 100644 src/ksharkpy.c
 create mode 100644 src/trace2matrix.c
 create mode 100644 tracecruncher/__init__.py
 create mode 100644 tracecruncher/utils.py

-- 
2.20.1

