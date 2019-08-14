Return-Path: <SRS0=RHP/=WK=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B1D1AC0650F
	for <linux-trace-devel@archiver.kernel.org>; Wed, 14 Aug 2019 08:47:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 845012083B
	for <linux-trace-devel@archiver.kernel.org>; Wed, 14 Aug 2019 08:47:17 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="sghBSMek"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725928AbfHNIrR (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 14 Aug 2019 04:47:17 -0400
Received: from mail-wm1-f68.google.com ([209.85.128.68]:40956 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725265AbfHNIrR (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 14 Aug 2019 04:47:17 -0400
Received: by mail-wm1-f68.google.com with SMTP id v19so3708347wmj.5
        for <linux-trace-devel@vger.kernel.org>; Wed, 14 Aug 2019 01:47:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=qaXXXVUvGPr9B1coUrS8IvzFlGwXXhQyquODAY58DNM=;
        b=sghBSMekvDxryGFG8qwMQzVmCK/LV0GCBxWZsfs/NT2cA3gmf+wpFOCtvdMSBpRh4u
         h+ADgmZzbjA0cCgugUHbAnIpWxqUdWnwJoS5aAOBhefgS8LXW4OtPS4nO9UeJa6jT6DB
         IEVcd56Hend5rK0SH94QuUtmxBGyk/R0CsCejQQ5WfV5mv6f13LZOOXtxWVSwVZivb5E
         PzxPEBpaW96G2PkuE28H5nFY6XVVA6gcCBbX7M22C+rUZ41zg1wrWIy533MiXTU8PjaE
         9gGVB3RXH7ORg/r7SRg1HhN99afpuY7SC+VRU3jPQdeRsCDIh0gc0WRIefc0DM9/RRfG
         MuiA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=qaXXXVUvGPr9B1coUrS8IvzFlGwXXhQyquODAY58DNM=;
        b=FtSr9TrYKD6Z3RCYRUdyGDd8qL/z+9Xh0emlewP8T+5LsKQS1c0PpYGzZirpJpySBO
         BvXPts+XEvyDJ7ZU//Vfl2KYCqUx097dxXiVPKIQTdtt/IyuMlb+wJ398xfsfdcJctb8
         o/L6gnrNm6Apav8PkUS0Vmwv0LsCiDM9fMetpLwWh9quijspwhwJmZPP6HPiYikQ5EvD
         Q3zgchIqvv78+SDiD8znimj+YV5ALJQmwv7N/HXVnW1/HlpP/Gq5bgqv5sWi6xt6GYVv
         GgKXnegHg/exf6xXYGnz+neBBL1vXQcqxYXe7BsPVW0hsDTcrSs+PwcJsnHCLaiRr8b8
         iKnQ==
X-Gm-Message-State: APjAAAXAWLupr2fv7FbEBYMOxxrO7ukPYgSIozJMblOZYKekfoDKqpAo
        DvO9bG8PKAqaE4AgT5Tp5QguTnVutm8=
X-Google-Smtp-Source: APXvYqyZEh3S4/mVE51Qf8LihXLarDy0AZbYX6dcgCwsv+tvMbmtAXyU6si+wmD561rtfxgOR6hFcw==
X-Received: by 2002:a7b:c947:: with SMTP id i7mr7471347wml.77.1565772435234;
        Wed, 14 Aug 2019 01:47:15 -0700 (PDT)
Received: from oberon.eng.vmware.com ([146.247.46.5])
        by smtp.gmail.com with ESMTPSA id c19sm2897481wml.13.2019.08.14.01.47.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Aug 2019 01:47:14 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v2 0/8] Separate trace-cmd and libtracecmd code
Date:   Wed, 14 Aug 2019 11:47:00 +0300
Message-Id: <20190814084712.28188-1-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

libtracecmd is a library, containing functions that can be
used without the trace-cmd application. However, some of the
functions declared as libtracecmd APIs in trace-cmd.h
depend on trace-cmd context. That causes a problem when
other application uses the library. The problem can be
observed when running kerneshark and there is a python
module, loaded by the python plugin - there is a bunch
of warnings.
To resolve the problem, implementations of all trace-cmd
independent functions are moved into libtracecmd. All
libtracecmd functions, that depend on trace-cmd context
are removed from the library and from trace-cmd.h file.

[
  v2 changes:
   - Added a new patch: 
        Move trace-cmd-local.h from the application to the library.
   - Remove trace-output.c dependency of version.h. Moved FILE_VERSION_STRING
     define from top Makefile to trace-cmd-local.h.
]

Tzvetomir Stoyanov (VMware) (8):
  trace-cmd: Move trace-cmd-local.h from the application to the library
  trace-cmd: Move trace-output.c into the library code
  trace-cmd: Move trace-msg.c into the library.
  trace-cmd: Move trace-cmd global variable "quiet" to libtracecmd
  trace-cmd: Move trace-cmd global variable "debug" to libtracecmd
  trace-cmd: Move plog() function to libtracecmd.
  trace-cmd: Move trace-cmd APIs from trace-cmd.h to trace-local.h
  trace-cmd: Move tracecmd_stack_tracer_status() function to libtracecmd

 Makefile                                      |   3 -
 include/trace-cmd/trace-cmd.h                 |  19 +-
 .../include => include/trace-cmd}/trace-msg.h |   3 -
 include/version.h                             |   5 -
 lib/trace-cmd/Makefile                        |   2 +
 .../trace-cmd}/include/trace-cmd-local.h      |   7 +-
 {tracecmd => lib/trace-cmd}/trace-msg.c       |   4 +-
 {tracecmd => lib/trace-cmd}/trace-output.c    |   5 +-
 lib/trace-cmd/trace-util.c                    | 162 ++++++++++++++++++
 tracecmd/Makefile                             |   2 -
 tracecmd/include/trace-local.h                |  14 +-
 tracecmd/trace-cmd.c                          |   3 -
 tracecmd/trace-list.c                         |   2 +-
 tracecmd/trace-listen.c                       |  77 ++-------
 tracecmd/trace-read.c                         |   8 +-
 tracecmd/trace-record.c                       |   8 +-
 tracecmd/trace-stack.c                        |  56 +-----
 17 files changed, 218 insertions(+), 162 deletions(-)
 rename {tracecmd/include => include/trace-cmd}/trace-msg.h (79%)
 rename {tracecmd => lib/trace-cmd}/include/trace-cmd-local.h (83%)
 rename {tracecmd => lib/trace-cmd}/trace-msg.c (99%)
 rename {tracecmd => lib/trace-cmd}/trace-output.c (99%)

-- 
2.21.0

