Return-Path: <SRS0=UiB3=23=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EF8E1C33C8C
	for <linux-trace-devel@archiver.kernel.org>; Mon,  6 Jan 2020 15:41:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BF69020731
	for <linux-trace-devel@archiver.kernel.org>; Mon,  6 Jan 2020 15:41:03 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="FA2+e/cs"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726454AbgAFPlD (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 6 Jan 2020 10:41:03 -0500
Received: from mail-lj1-f193.google.com ([209.85.208.193]:40801 "EHLO
        mail-lj1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726296AbgAFPlD (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 6 Jan 2020 10:41:03 -0500
Received: by mail-lj1-f193.google.com with SMTP id u1so51343783ljk.7
        for <linux-trace-devel@vger.kernel.org>; Mon, 06 Jan 2020 07:41:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=As8YeEiS5XexKC+s2Jer4Ug4dJFzwrMQig18s2p2bcc=;
        b=FA2+e/cs7FW7aY08Zgywimdb3hvtA4J3uHSXDaa3/kTbyRT9llq3sUa9uq6PuSduaA
         UNG2uWoxZMzI9a7WbrMYtk6JRDxSTlwVc9GbRjTLEvGQ8zpdErE1YVZrJm1ITOYndToy
         ZrqKuupR18NpPM75bKNEKs9KWzQSsLzDyLt5O8LZhZJfoiJCSiWtmKgEaBGrBR/8klRI
         nXrIUVtcn10ucTO1jjTHfpDVmkQK8JOBybYrf3juFe/XG0PxFB6uiIospjgtiR61BcQi
         iLPJo+cdsFIdNG19EB8AFzFZ3O/sjWgVhvP0VpqAYkgrWjCjWoALQWwGQ96HcQEFO8vv
         nO1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=As8YeEiS5XexKC+s2Jer4Ug4dJFzwrMQig18s2p2bcc=;
        b=m0Lha5cbgD/yo83jyIu1TkvIOuP6WdQK8CdtXRno3t5Z6P6WIpk7yW0fiBO0HzEgU/
         p0xBdY/x0A3gUagm4hXDigq44d0r4CzuQUn7f/DDcQVdWWp/Frmg5mgNJsmNt4RaJXkJ
         XLgOr/J4BlnHDJ+3zF0X4BGqWKxNJ+dFnP3zJ7UXSPU1sVRy4gmSxzyjx6wvD5WldoH9
         4Rl3vEn98xeYE8en5knhYpg0bBuHYTO7mZUY65njAXI8f3PKjHlAG6b4zV+VjH4ugZ8g
         vcg8l4uGXLdcLqJ4owxbT4wb6+ax7oKKh1ieBZ3PHEcsnJPQhThxxgIB5d26Hwyh07Ld
         2vwg==
X-Gm-Message-State: APjAAAU+tnuegYdKD8rFPTavR1s3+VYXMy1X8l4NMH6MR9GDzyWHMbKj
        VJsJh98/XeDVnRFmyFfU66pMqo8Xq0M=
X-Google-Smtp-Source: APXvYqxj0YvRdeKPjF0RL8wPbSJMz8f+wVCNSsyJHmFjT0TYp/TnJIR2ydpdBarg6wy/+13Z4QNBnw==
X-Received: by 2002:a2e:8954:: with SMTP id b20mr45495645ljk.27.1578325261121;
        Mon, 06 Jan 2020 07:41:01 -0800 (PST)
Received: from oberon.eng.vmware.com ([146.247.46.5])
        by smtp.gmail.com with ESMTPSA id u25sm29257677lfk.46.2020.01.06.07.40.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Jan 2020 07:41:00 -0800 (PST)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v2 0/5] tracefs library
Date:   Mon,  6 Jan 2020 17:40:53 +0200
Message-Id: <20200106154058.60660-1-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.24.1
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

[
 v2 changes:
  - Fix copyright of the newly created files
  - Remove tracefs_write_file() API, add it as a local helper function 
]

Tzvetomir Stoyanov (VMware) (5):
  trace-cmd: Introduce libtracefs library
  kernel-shark: Use new tracefs library
  trace-cmd: New libtracefs APIs for ftrace instances
  trace-cmd,kernel-shark: New libtracefs APIs for ftrace events and
    systems
  trace-cmd,kernel-shark: New libtracefs APIs for loading ftrace events

 Makefile                              |  27 +-
 include/trace-cmd/trace-cmd.h         |  21 -
 include/tracefs/tracefs.h             |  56 +++
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
 lib/tracefs/tracefs-events.c          | 661 ++++++++++++++++++++++++++
 lib/tracefs/tracefs-instance.c        | 267 +++++++++++
 lib/tracefs/tracefs-utils.c           | 226 +++++++++
 tracecmd/Makefile                     |   2 +-
 tracecmd/include/trace-local.h        |   5 +-
 tracecmd/trace-check-events.c         |   5 +-
 tracecmd/trace-list.c                 |  21 +-
 tracecmd/trace-record.c               | 373 ++++++---------
 tracecmd/trace-show.c                 |   7 +-
 tracecmd/trace-snapshot.c             |   9 +-
 tracecmd/trace-stack.c                |   9 +-
 tracecmd/trace-stat.c                 |  38 +-
 26 files changed, 1531 insertions(+), 1031 deletions(-)
 create mode 100644 include/tracefs/tracefs.h
 create mode 100644 lib/tracefs/Makefile
 create mode 100644 lib/tracefs/include/tracefs-local.h
 create mode 100644 lib/tracefs/tracefs-events.c
 create mode 100644 lib/tracefs/tracefs-instance.c
 create mode 100644 lib/tracefs/tracefs-utils.c

-- 
2.24.1

