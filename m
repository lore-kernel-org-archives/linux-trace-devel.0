Return-Path: <SRS0=wXUw=2C=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1ACD6C43603
	for <linux-trace-devel@archiver.kernel.org>; Thu, 12 Dec 2019 09:03:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D5DF92464B
	for <linux-trace-devel@archiver.kernel.org>; Thu, 12 Dec 2019 09:02:59 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="GRy/E59M"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728147AbfLLJC7 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 12 Dec 2019 04:02:59 -0500
Received: from mail-lj1-f169.google.com ([209.85.208.169]:41875 "EHLO
        mail-lj1-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728110AbfLLJC7 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 12 Dec 2019 04:02:59 -0500
Received: by mail-lj1-f169.google.com with SMTP id h23so1373835ljc.8
        for <linux-trace-devel@vger.kernel.org>; Thu, 12 Dec 2019 01:02:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=iMu++V+R7D2ZQ87NWGQbLQse8zsk4zjLz9rb6Zf9OpY=;
        b=GRy/E59MgTOpKnmjaeuhp4UHPKYFqW0AbPhY9kYVzfX8hvyfb5Mv15yJuhMyQaQCip
         8BDHPVKmgkqZfya495nGT0V1hJiPyoi8JvzLVFdBdonC5/toVTcGegdV8L6hmxNedW5I
         AIBZpoxy1nvpchdMo9zHz6NxYJ1fpizPqOt2Y6QpUu1Vcs+qE+nulQCMRfCGDkeeI4o3
         DkJw27j5Ak+LbJ15elok7LSUt3xQEpm0kvMX2eVAa4O5Rre7hd2J7LIHrsv1v2YuitUF
         /aHI63af1Pa3NXBs2cKjSFve4Nr7WLJxP2w3fB8/BiwAH5Bmu4swLPSywDkhpuijcvGR
         eQAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=iMu++V+R7D2ZQ87NWGQbLQse8zsk4zjLz9rb6Zf9OpY=;
        b=Vt9qSzvET7u6tHqTW1kReR61XCHQw2Xnd+yT3xan23IBKgAEb2KQukG1hprTuT32XY
         Qo2VIfXVbO/zDjLT10AtvQepXc/hB7Sk0DD2HIgD6HjX/tGmSdxyHqaeoDMr/6CtfeZE
         3i0NjbkvSwFIwJ/JtfYtC36z4Gg6oC9LICVEl0SsmXRWha8w5mlw/sRz71zT5vKL/L92
         kN/mJh55mtBd2M/ZV8Cgm+dTn3ymIn5pcc/buaXHR/9CjeDGP76QgxRtBtKus5l+8D5c
         kyFn91Q9bs6k+2KN4DIjj315zm4BZNc6/HSc9tsHJIsaJK1Z+mF8wnr5zraigWrCHnNA
         JOyw==
X-Gm-Message-State: APjAAAWJnYwtsZlQP3aAMsvGyelmKH2787CcImyEeUt7jh5XIAW52GJ6
        9T5PeYJZ5zP9vqgahhEDw1+69NAF
X-Google-Smtp-Source: APXvYqwpWClwEDJh81dtIGb7kr2XnOmIFjtVpga+IS3FfLcFDBh3kZ3jNspnq002AT3hS6ZsulWJTQ==
X-Received: by 2002:a2e:b007:: with SMTP id y7mr5169956ljk.215.1576141377091;
        Thu, 12 Dec 2019 01:02:57 -0800 (PST)
Received: from mamba.eng.vmware.com ([146.247.46.5])
        by smtp.gmail.com with ESMTPSA id u16sm2849908lfi.36.2019.12.12.01.02.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Dec 2019 01:02:56 -0800 (PST)
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
To:     linux-trace-devel@vger.kernel.org
Cc:     rostedt@goodmis.org, Valentin.Schneider@arm.com,
        douglas.raillard@arm.com,
        "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Subject: [PATCH 0/5] Build trace-cruncher as Python pakage
Date:   Thu, 12 Dec 2019 11:02:27 +0200
Message-Id: <20191212090232.24236-1-y.karadz@gmail.com>
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
the implementation of the NumPy data wrapper. The new package has its
own stand-alone build system (very primitive for the moment) that is
completely decoupled from the existing build system used by tracecruncher.
In order to build and install the new package do:

sudo python setup.py install --record files.txt

The patch-set does not  remove the old implementation yet. This will
happen in another successive patch-set.

Please review as careful as possible!

Yordan Karadzhov (VMware) (5):
  Refactor the part of the interface that relies on libkshark
  Refactor the part of the interface that relies on libtraceevent
  Refactor NumPy based data wrapper
  Add "utils"
  Adapt the sched_wakeup.py example script to use the new tracecruncher
    module

 examples/sched_wakeup.py  |  30 ++---
 setup.py                  |  61 +++++++++
 src/common.h              |  20 +++
 src/datawrapper.pyx       | 201 ++++++++++++++++++++++++++++
 src/ftracepy.c            | 234 +++++++++++++++++++++++++++++++++
 src/ksharkpy.c            | 268 ++++++++++++++++++++++++++++++++++++++
 src/trace2matrix.c        |  29 +++++
 tracecruncher/__init__.py |   0
 tracecruncher/utils.py    |  54 ++++++++
 9 files changed, 882 insertions(+), 15 deletions(-)
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

