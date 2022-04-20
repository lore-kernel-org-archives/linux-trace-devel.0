Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9038DC433F5
	for <linux-trace-devel@archiver.kernel.org>; Wed, 20 Apr 2022 08:02:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1376595AbiDTIE7 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 20 Apr 2022 04:04:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59620 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1376433AbiDTIE6 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 20 Apr 2022 04:04:58 -0400
Received: from mail-ej1-x636.google.com (mail-ej1-x636.google.com [IPv6:2a00:1450:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E8F753C4B5
        for <linux-trace-devel@vger.kernel.org>; Wed, 20 Apr 2022 01:02:10 -0700 (PDT)
Received: by mail-ej1-x636.google.com with SMTP id bv19so1824642ejb.6
        for <linux-trace-devel@vger.kernel.org>; Wed, 20 Apr 2022 01:02:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=E4V9pHwBzgOcjbZXYy/P3MeSLxGPn06DeXZf3giJZgY=;
        b=G57cZDfVHOdpbNwc42xmaFq+wnMJnBEeBVFZTd3w1j/QbdjUlUvUmh/+YYR4DvJ9bV
         4gpqgf9S/qCKhLf4SCL3x6NBAT8Oj+D7HPqWjj2P1ddlq+ebSOWbtACE0HPiPw3hpFoW
         wC9CZA/QBhho0tBDdhMIY8KuFRvAs0Gari4WiLiGLqcyGfDkk+xU4sNrBAzIB0UBCPHO
         plG6hA3KuiloAATd2e3SHzAkoc49SlbQK0LihoehI67wQhQcAgF6y/NSNanMB49S2tpr
         OcDLILrRHe3Bi8x40sF16mCfXRk0mudPnhI8Q39JfH2tiZu7mM5cq+MkZz54Qr0FkGvw
         P30w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=E4V9pHwBzgOcjbZXYy/P3MeSLxGPn06DeXZf3giJZgY=;
        b=iVts+tPz7Yorz/RfmZWb3c6S4NF4oGn32l30Mn/Y6qTWIr0isPZtoA2bvTqxhWLc9W
         7Na12u5aYJg7XPqOvEOBsPM+XFe0/c2rlOZOjc8lYSNLgTcYPe1/HkcgzYH6MrXp5/AG
         YU6Tf3UN0+zq80NLd314kkRWMS9nLgkBih4WSqqPh7Q4ME4n6w0xlso0Gle1xVRIniR7
         OZrsCCVCzWP+g9PmSJWWetR5rE81CWUibFwKJxCEhZ1y+egl1r3rk6Uh30MrFSdsCPDD
         ix6WebsPM8xSgvuF4mtlsGR2pzGN3p109WwRK1PznYH4iKN66HlX2dwQ2SX9ZzmTzOdO
         tiNA==
X-Gm-Message-State: AOAM530FvDcbQUxj81QuJY0PJCpllR0NHUmLJzH+UirJWWoOaMBtWqfg
        DsPsCqKdomdQfEtd9fEO47H9AUQW4i3cZg==
X-Google-Smtp-Source: ABdhPJzcy3jkQEAZj+UWTdP8DfdH+UeHR/UCgyK6qHlF6y00IIXvOnS6rslpNAGS6tEpzyJK78cENA==
X-Received: by 2002:a17:906:7947:b0:6da:892f:2503 with SMTP id l7-20020a170906794700b006da892f2503mr16972586ejo.710.1650441729342;
        Wed, 20 Apr 2022 01:02:09 -0700 (PDT)
Received: from oberon.zico.biz.com ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id t12-20020a1709067c0c00b006e86db76851sm6393763ejo.193.2022.04.20.01.02.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 Apr 2022 01:02:08 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     y.karadz@gmail.com
Cc:     rostedt@goodmis.org, linux-trace-devel@vger.kernel.org
Subject: [RFC PATCH v3 0/4] trace-cruncher: ftrace uprobes support
Date:   Wed, 20 Apr 2022 11:02:02 +0300
Message-Id: <20220420080206.252356-1-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Ftrace uprobes can be used to create dynamic events for user functions.
Tracing user function can be very useful functionality for trace-cruncher.

v3 changes:
 - Implemented logic for finding the full application name in the C code.
 - Renamed a few internal functions and variable with more specific names.
 - Coding style fixes.

v2 changes:
 - Moved the uprobe C code into the ftrace-utils.c file.
 - Reused internal functions from ftrace-util code.
 - Renamed utrace start and stop to enable and disable, to be consistent
   with the other APIs.
 - Do not call utrace disable in the urtace example, as this logic is
   triggered by the destructor.
 - Changed the logic for allocation of internal dynamic array - double the
   array size on each reallocation, instead of increasing the size with
   hard-coded constant.
 - Added support for running a program with arguments for tracing.
 - Do not run the program for tracing in a separate shell.
 - Coding style fixes and optimizations.

Tzvetomir Stoyanov (VMware) (4):
  trace-cruncher: Logic for resolving address to function name
  trace-cruncher: ftrace uprobe raw API
  trace-cruncher: High level wrappers for ftrace uprobes
  trace-cruncher: Example script for uprobes high level API

 examples/user_trace.py |  39 ++
 setup.py               |   4 +-
 src/ftracepy-utils.c   | 746 +++++++++++++++++++++++++++++++
 src/ftracepy-utils.h   |  21 +
 src/ftracepy.c         |  45 ++
 src/trace-obj-debug.c  | 988 +++++++++++++++++++++++++++++++++++++++++
 src/trace-obj-debug.h  |  54 +++
 7 files changed, 1895 insertions(+), 2 deletions(-)
 create mode 100755 examples/user_trace.py
 create mode 100644 src/trace-obj-debug.c
 create mode 100644 src/trace-obj-debug.h

-- 
2.35.1

