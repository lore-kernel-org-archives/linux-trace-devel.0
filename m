Return-Path: <SRS0=Ara6=2J=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C1C49C43603
	for <linux-trace-devel@archiver.kernel.org>; Thu, 19 Dec 2019 11:35:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9246F20716
	for <linux-trace-devel@archiver.kernel.org>; Thu, 19 Dec 2019 11:35:08 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="S0tzHW3c"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726742AbfLSLfI (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 19 Dec 2019 06:35:08 -0500
Received: from mail-lj1-f193.google.com ([209.85.208.193]:36896 "EHLO
        mail-lj1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726656AbfLSLfI (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 19 Dec 2019 06:35:08 -0500
Received: by mail-lj1-f193.google.com with SMTP id u17so5851898lja.4
        for <linux-trace-devel@vger.kernel.org>; Thu, 19 Dec 2019 03:35:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=gDoq8Jbbp5cnbjUsvppqD2sD+Jzd0q9s12cJkZLt2RM=;
        b=S0tzHW3cD7EX9x1b3Vr7XL71tzDquG1frqJ5WUQCnqqEao2yY9lRPyQDJlXSKjMdM0
         7oqFDRn+NuD07KYFpdBHpLEf8FnCupYL6RFz0IaKdcutqX9yisM8o/fFDozOpL8EXx37
         Mn4Wl8g9EEGY6cUHuyJpHRpApqMD7zh97axd0cwIPZfkVizJzixtWw+AepGcLmeCxb82
         ucJMBAVLyT38DME0YaPtyuqpx2IUEs21tVEWZwFCzxwCUK0HmxV2j28Ljvf4BoB1f4sO
         UKQjDkoTrtPFWZhL2MEpxVI4ZMbojcfqSX90Kyxq6hMX53dgld/D9zA9m1iCsNrjXBkV
         pytw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=gDoq8Jbbp5cnbjUsvppqD2sD+Jzd0q9s12cJkZLt2RM=;
        b=iSY0mAAnMoeu6WZN39lO73mY/FnEYWGRla09K+Xrq2d8OVj6dwQnZR2NzC74eG8kpK
         3KReMtCJss2SQNij1r6Bdl0dj0f+45r0LRpIVp/0Azv99sxU80S1fHzxh+stgLtHJQat
         Ov8CUR84HzTLdtWxRh0NUNE5gzfwFCg48J0M+fPEvCFBynfEIQ9aKuVZsBX9UNW260Pl
         vLpwiE3Sj0U8iZxU8N+dgjaOlg+InUWPbAYE+hYtWWQ0qEEUnACo/1mE64v4M9Mw28Hh
         fceGtmgdkFmjO7ei0B0pLZaHDVuIn9j+4qROduPHYIMTghB9+wqhJ4RMSAqOES/yQcSX
         y7iw==
X-Gm-Message-State: APjAAAUgT2Abm9Kzj7kiUGp/2CYbp4two5GF8hgQBWsFF2Z8ovOwctXu
        7aA8SB5QJB+omSGFegNwdGtAUUg+lP0=
X-Google-Smtp-Source: APXvYqz+1abLggsP8i6bkl6OPQ/78aal+TveGU+KwOJDwAStAxt4aPUmJo2LGrm3nAKU1yEGXnSR3Q==
X-Received: by 2002:a2e:99c3:: with SMTP id l3mr5614456ljj.250.1576755306188;
        Thu, 19 Dec 2019 03:35:06 -0800 (PST)
Received: from oberon.eng.vmware.com ([146.247.46.5])
        by smtp.gmail.com with ESMTPSA id d4sm2437022lfn.42.2019.12.19.03.35.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 Dec 2019 03:35:05 -0800 (PST)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH 0/6] tracefs libraray
Date:   Thu, 19 Dec 2019 13:34:56 +0200
Message-Id: <20191219113502.28964-1-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.23.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Add a skeleton for new library: libtracefs, providing APIs
for accessing files from tracefs. The library files are added in
 lib/tracefs
 include/tracefs
It is built and installed by trace-cmd targets
  make libs 
  make install_libs

Tzvetomir Stoyanov (VMware) (6):
  trace-cmd: Introduce libtracefs library
  kernel-shark: Use new tracefs library
  trace-cmd: New libtracefs API tracefs_write_file()
  trace-cmd: New libtracefs APIs for ftrace instances
  trace-cmd,kernel-shark: New libtracefs APIs for ftrace events and
    systems
  trace-cmd,kernel-shark: New libtracefs APIs for loading ftrace events

 Makefile                              |  27 +-
 include/trace-cmd/trace-cmd.h         |  21 -
 include/tracefs/tracefs.h             |  58 +++
 kernel-shark/CMakeLists.txt           |   3 +-
 kernel-shark/build/FindTraceCmd.cmake |  30 ++
 kernel-shark/src/CMakeLists.txt       |   2 +
 kernel-shark/src/KsCaptureDialog.cpp  |   4 +-
 kernel-shark/src/libkshark.h          |   1 +
 lib/trace-cmd/trace-input.c           |  95 ----
 lib/trace-cmd/trace-output.c          |   3 +-
 lib/trace-cmd/trace-recorder.c        |   7 +-
 lib/trace-cmd/trace-util.c            | 629 ------------------------
 lib/tracefs/Makefile                  |  48 ++
 lib/tracefs/include/tracefs-local.h   |  13 +
 lib/tracefs/tracefs-events.c          | 657 ++++++++++++++++++++++++++
 lib/tracefs/tracefs-instance.c        | 233 +++++++++
 lib/tracefs/tracefs-utils.c           | 261 ++++++++++
 tracecmd/Makefile                     |   2 +-
 tracecmd/include/trace-local.h        |   5 +-
 tracecmd/trace-check-events.c         |   5 +-
 tracecmd/trace-list.c                 |  21 +-
 tracecmd/trace-record.c               | 413 ++++++----------
 tracecmd/trace-show.c                 |   7 +-
 tracecmd/trace-snapshot.c             |   9 +-
 tracecmd/trace-stack.c                |   9 +-
 tracecmd/trace-stat.c                 |  38 +-
 26 files changed, 1540 insertions(+), 1061 deletions(-)
 create mode 100644 include/tracefs/tracefs.h
 create mode 100644 lib/tracefs/Makefile
 create mode 100644 lib/tracefs/include/tracefs-local.h
 create mode 100644 lib/tracefs/tracefs-events.c
 create mode 100644 lib/tracefs/tracefs-instance.c
 create mode 100644 lib/tracefs/tracefs-utils.c

-- 
2.23.0

