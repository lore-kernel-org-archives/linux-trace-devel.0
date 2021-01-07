Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E31CAC433DB
	for <linux-trace-devel@archiver.kernel.org>; Thu,  7 Jan 2021 08:33:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AD04220738
	for <linux-trace-devel@archiver.kernel.org>; Thu,  7 Jan 2021 08:33:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726953AbhAGIde (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 7 Jan 2021 03:33:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56974 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725900AbhAGIde (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 7 Jan 2021 03:33:34 -0500
Received: from mail-wr1-x429.google.com (mail-wr1-x429.google.com [IPv6:2a00:1450:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C6A52C0612F4
        for <linux-trace-devel@vger.kernel.org>; Thu,  7 Jan 2021 00:32:53 -0800 (PST)
Received: by mail-wr1-x429.google.com with SMTP id r3so4780771wrt.2
        for <linux-trace-devel@vger.kernel.org>; Thu, 07 Jan 2021 00:32:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=EiLp5/uOCOOMK/clK0CABACjEAsRQBbSq6uRVCfwIfU=;
        b=lzI85horvxWB/cu1OCrITlB52vTzj5h/Zowxrxgetf26m7GjOSugGhu58EB6jTQVWH
         N8tInJSP3/Q2EsFuW1lL4wmT+KdnVoKdTkPYbOk15maL+1Q9VFSk8KuFJQ8wXR55JBNZ
         Ieb/35vacCJn3446Od28O8+F/B9TqMz/fa/WKdll4EZ0Z3jTyox+rP0cjWR1np81mQuo
         m3k/9a4se6OP0OQMLBieCrLBIUZbCRZxmPSSQdOlnkPlu/aqyXcVTJr7Z4Gk4GKM8qlN
         tnBm9bkjGdJGYmHdJqCdOznnWJQB9+uvuTBenJ190WGcp6NdGfMQTN3xWhOmiNMyc191
         uE4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=EiLp5/uOCOOMK/clK0CABACjEAsRQBbSq6uRVCfwIfU=;
        b=DFd8HdeeCLrL6Jj5c/Caj5kLnw9xOSCVIlpfeWOHWXDU/ZDqJiCs5XFW1UJXTu4T9t
         kpQR07YpXtSuY2yaa3VlYrGJNFaJN/pH6SvsJY3riXhIFzs1N4MkXwDdcS/wpnOF9CyM
         FCi7GMxreRmkSoMrgywzxndmMqMf0UkP7dGJ2vwcempH/kXbDrR4fSyOA2bbSLuTb8b/
         WbV1RJrqjXBIsyXvN4XIZffuSTlOLooSuGbOqy6NYYShWWkfbsILJJIIKBDQWNARGHuw
         EP9cumbXL3IEk3KPsklao7dHoB11KiJR8EdRJ7sqnHpZ1XGcVyhHTkTdspa78ZoIN3dM
         ShHw==
X-Gm-Message-State: AOAM5321aJwidb44p+wJ1aG/nv8EgedSZK4p4zQOt4fx84GRuKsIivqj
        EST2s0TdHBER4Izgnf9OWJA=
X-Google-Smtp-Source: ABdhPJwBNWdj+J5mZBaeXeAkM0qw5+jEAFzICL8UOnaoRvTBkAvR0vGOWV8UK1eLSAkyNCtIYGwkxA==
X-Received: by 2002:adf:fb52:: with SMTP id c18mr7718460wrs.186.1610008372494;
        Thu, 07 Jan 2021 00:32:52 -0800 (PST)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id v20sm7293867wra.19.2021.01.07.00.32.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Jan 2021 00:32:51 -0800 (PST)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH 0/6] New libtracefs APIs
Date:   Thu,  7 Jan 2021 10:32:44 +0200
Message-Id: <20210107083250.16295-1-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Added new APIs to tracefs library and updated man pages and unit tests:
  tracefs_instance_file_read_int();
  tracefs_instance_file_open();
  tracefs_trace_is_on();
  tracefs_trace_on();
  tracefs_trace_off();
  tracefs_trace_on_fd();
  tracefs_trace_off_fd();

The main motivation is to cover trace-cmd use cases of tracefs library.
These APIs are the first step in that direction.

Tzvetomir Stoyanov (VMware) (6):
  libtracefs: New APIs for opening and reading ftrace files
  libtracefs: New APIs for enable / disable tracing
  libtracefs: Documentation for the new APIs for opening and reading
    ftrace files
  libtracefs: Documentation for enable / disable tracing APIs
  libtracefs: Unit tests for the new APIs for opening and reading ftrace
    files
  libtracefs: Unit tests for enable / disable tracing APIs

 Documentation/libtracefs-instances-files.txt |  47 +++++-
 Documentation/libtracefs-traceon.txt         | 143 +++++++++++++++++++
 include/tracefs.h                            |  12 +-
 src/Makefile                                 |   1 +
 src/tracefs-instance.c                       |  59 +++++++-
 src/tracefs-tools.c                          | 123 ++++++++++++++++
 utest/tracefs-utest.c                        | 131 +++++++++++++++++
 7 files changed, 509 insertions(+), 7 deletions(-)
 create mode 100644 Documentation/libtracefs-traceon.txt
 create mode 100644 src/tracefs-tools.c

-- 
2.29.2

