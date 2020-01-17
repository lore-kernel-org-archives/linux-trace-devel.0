Return-Path: <SRS0=5V0s=3G=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 96599C33CB1
	for <linux-trace-devel@archiver.kernel.org>; Fri, 17 Jan 2020 13:55:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 67692206E6
	for <linux-trace-devel@archiver.kernel.org>; Fri, 17 Jan 2020 13:55:50 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="YfvtSZsm"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726688AbgAQNzu (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 17 Jan 2020 08:55:50 -0500
Received: from mail-lj1-f194.google.com ([209.85.208.194]:38427 "EHLO
        mail-lj1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726885AbgAQNzt (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 17 Jan 2020 08:55:49 -0500
Received: by mail-lj1-f194.google.com with SMTP id w1so26584449ljh.5
        for <linux-trace-devel@vger.kernel.org>; Fri, 17 Jan 2020 05:55:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=DjpzFucbe4yRQVV5s7Zlrrp9y31RCwfJFR4eiCDDPpA=;
        b=YfvtSZsm649jda6A4Ku8/LeQiABXxoDDxM9uahp1LjKvoOEJUGvuot/lyzbCGI86FP
         Cc4trmeRhDD/KhTf8qOvIpYn5DONAgQyXYddMoyfMduNF4NFg5HGmQYG4zDp3TA/gnwB
         eEaFBhcsDM8YRenjOn4Z5Hnd8tse369VnkddU+VPTQKQG9DD6szpwm4ErbWkBer7e/1v
         kSrDCVUSPp5TOKYwgRg03d07lvQQNygGn3Curt1x+Ip4ytVaPW33eU5xM4tOIPt48Bv3
         cWw8Y9C/Hrw7ETcA0VL7W98xplHBwhhHtr5O9im7bFCFEpj2v5n5tmJKVVAiNBboVBc7
         MrpA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=DjpzFucbe4yRQVV5s7Zlrrp9y31RCwfJFR4eiCDDPpA=;
        b=oz7lq9zpsYK4jEt4vhKgkSLHgXNAsgTxx/UDoDaNmDtMUSFy6b5dXzpU6fUgxB+y5A
         TxNhZSZhE/v1+nDauSfLo3kZVWMCNtAvhp6Gn4JvJCrRKK/zYXLU62GJ8nWEK2ndMwHf
         ErnXpjQga/DCXzzxmvRnuFegQmyEFnYmQNhVQJRTnoy4x5YJZN7Wh+fnuKhXtEVMqLVA
         dFXYwQoMa3iTCoY28r7FwwNNSEdRzebED+8SJUDtqapyJXuwvG8TDZ788ogX9hNel5/8
         jTm2ulZVjzmVzXnd6z8fZu1tzmBEWcfmUQaJtURgdYWv3ZAifA5Y8C/TXo7vA3xbxpzy
         2mqA==
X-Gm-Message-State: APjAAAVXHtq1x1YzaxLXuUXSUICxsg2ZdLlfpgz+nVS5yKxAYq5ymaIm
        uXm+VSaUQCqLGtNzhx32xMIgOLdU
X-Google-Smtp-Source: APXvYqzcZzQG0td1Yf+UqK9CCJkrKZSo/LQBi9iHuDB+uN9pcOusSvS9S59xEHKntuV0wxIamcRsqA==
X-Received: by 2002:a2e:3a0c:: with SMTP id h12mr5704160lja.200.1579269347365;
        Fri, 17 Jan 2020 05:55:47 -0800 (PST)
Received: from oberon.eng.vmware.com ([146.247.46.5])
        by smtp.gmail.com with ESMTPSA id 21sm12422562ljv.19.2020.01.17.05.55.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Jan 2020 05:55:46 -0800 (PST)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v3 0/5] tracefs library
Date:   Fri, 17 Jan 2020 15:55:39 +0200
Message-Id: <20200117135544.598235-1-tz.stoyanov@gmail.com>
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

A unit test framework is added, as POC patch, to test the APIs
of the library. It requiers CUnit test framework to be installed
on the machine. A new target is added to build the unit test:
  make test

[
 v3 changes:
  - Renamed few APIs, to match the naming convention used commonly
  - Optimized tracefs_iterate_raw_events() API
  - Added unit test infrastructure 
  - Few minor changes

 v2 changes:
  - Fix copyright of the newly created files
  - Remove tracefs_write_file() API, add it as a local helper function 
]

Tzvetomir Stoyanov (VMware) (5):
  trace-cmd,kernel-shark: Introduce libtracefs library
  trace-cmd: New libtracefs APIs for ftrace instances
  trace-cmd,kernel-shark: New libtracefs APIs for ftrace events and
    systems
  trace-cmd,kernel-shark: New libtracefs APIs for loading ftrace events
  trace-cmd: Unit test for libtracefs

 Makefile                              |  38 +-
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
 lib/trace-cmd/trace-util.c            | 629 --------------------------
 lib/tracefs/Makefile                  |  48 ++
 lib/tracefs/include/tracefs-local.h   |  13 +
 lib/tracefs/tracefs-events.c          | 627 +++++++++++++++++++++++++
 lib/tracefs/tracefs-instance.c        | 249 ++++++++++
 lib/tracefs/tracefs-utils.c           | 226 +++++++++
 lib/utest/Makefile                    |  43 ++
 lib/utest/trace-utest.c               |  83 ++++
 lib/utest/trace-utest.h               |  11 +
 lib/utest/tracefs-utest.c             | 132 ++++++
 tracecmd/Makefile                     |   2 +-
 tracecmd/include/trace-local.h        |   5 +-
 tracecmd/trace-check-events.c         |   5 +-
 tracecmd/trace-list.c                 |  21 +-
 tracecmd/trace-record.c               | 487 +++++++-------------
 tracecmd/trace-show.c                 |   7 +-
 tracecmd/trace-snapshot.c             |   9 +-
 tracecmd/trace-stack.c                |   9 +-
 tracecmd/trace-stat.c                 |  38 +-
 30 files changed, 1782 insertions(+), 1124 deletions(-)
 create mode 100644 include/tracefs/tracefs.h
 create mode 100644 lib/tracefs/Makefile
 create mode 100644 lib/tracefs/include/tracefs-local.h
 create mode 100644 lib/tracefs/tracefs-events.c
 create mode 100644 lib/tracefs/tracefs-instance.c
 create mode 100644 lib/tracefs/tracefs-utils.c
 create mode 100644 lib/utest/Makefile
 create mode 100644 lib/utest/trace-utest.c
 create mode 100644 lib/utest/trace-utest.h
 create mode 100644 lib/utest/tracefs-utest.c

-- 
2.24.1

