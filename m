Return-Path: <SRS0=W4op=VX=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 50A78C7618B
	for <linux-trace-devel@archiver.kernel.org>; Fri, 26 Jul 2019 12:43:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2466E21951
	for <linux-trace-devel@archiver.kernel.org>; Fri, 26 Jul 2019 12:43:13 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="reyvyV1l"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726408AbfGZMnM (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 26 Jul 2019 08:43:12 -0400
Received: from mail-wr1-f43.google.com ([209.85.221.43]:34309 "EHLO
        mail-wr1-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726277AbfGZMnM (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 26 Jul 2019 08:43:12 -0400
Received: by mail-wr1-f43.google.com with SMTP id 31so54354543wrm.1
        for <linux-trace-devel@vger.kernel.org>; Fri, 26 Jul 2019 05:43:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=/QKogfKmCC1Yjb5kJxCy5p+SP1RAhELtRXtJ97FAnQ4=;
        b=reyvyV1li0aROB+R1tBNLuGUIolQRK4FHoIgfUH+8VrlLupx9ZVa3kV62F9dsF3+WT
         wn2Pd0s8bOsGsOPjmdBMaRenzd2yu8NUz4qB8yjLRqptOO0SG2zSRJL3roTa6VXys5Wr
         Jo+Zv2wdpKQZNUrPGdQU5TASOQCXOgLsVyPZUUaDGBKW9thstRCiibuiJo0aqMtuWrUC
         Yfo56W11YTdLQH5LQ9mJ6UWdLwAG4XQUeksByiPkjPe9CnDOWJTJNLzXUsc3kDQh4ke1
         cXJ8yQyTnzSPgLJK7GvP2GPEGB8m3LjQil8cgL0KkFn+s43/r0RWlNcZ7hlQME4v5vIL
         jQag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=/QKogfKmCC1Yjb5kJxCy5p+SP1RAhELtRXtJ97FAnQ4=;
        b=SthdvnDJeNE6Hwn5DG8b/0zajhtjEAEFF1OE38g9nYmC//hy5ikleE+mbwzJCOSCIs
         lr6an4mOdAzzufc1BwGUR7tmOqZbdtLk9fh7Az3It85sAZ08Gtyy0x4UXmLRCIsud1Ly
         XQRKzuFnAQPLNHbbtgJ1AQ7Xz0knXz/JNkM0PIiRoiKi51ryO6W1baRXjbV4VCsnYetJ
         xBoOSDIhGgly3W4J4oLhDxd3NKi4mS1pWwk1rsnh85ry9mM+P6elbqJ0G+JQEgu4qJBb
         NXmxV8BXjE04fh7ZfshFDdQT3dKj/gyWBDfCNKzL75UDkczvqGa98fgFwQ/pbLL4mO+T
         WMhg==
X-Gm-Message-State: APjAAAWSaO64uVX43qNYL2A287m7UfQXZhBMJHWcPooH+by3EUqk9to3
        fJwNtX+lbvWoKb0p5fjZbMbpQlX9aVA=
X-Google-Smtp-Source: APXvYqwVReGLOfJduvs03l5Nj3pxCLzPB3SZsaJ/ihwxsWLeMwMWCvT7RkUKdZJwfqelFtd883qyeQ==
X-Received: by 2002:a5d:43c9:: with SMTP id v9mr28903422wrr.70.1564144990436;
        Fri, 26 Jul 2019 05:43:10 -0700 (PDT)
Received: from oberon.eng.vmware.com ([146.247.46.5])
        by smtp.gmail.com with ESMTPSA id o26sm105565833wro.53.2019.07.26.05.43.09
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Fri, 26 Jul 2019 05:43:09 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH 0/3] Remove redundant trace-cmd plugin handling logic
Date:   Fri, 26 Jul 2019 15:43:05 +0300
Message-Id: <20190726124308.18735-1-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Currently there are no trace-cmd related plugins, all of them
are designed to be used with libtraceeevnt. As both libtraceevent
and trace-cmd have logic for managing plugins, the one in trace-cmd
is redundant. Those redundant code is removed and replaced with calls
to libtraceeevnt plugin APIs. When trace-cmd has to load any plugins,
it uses libtraceeevnt to do the job.

Tzvetomir Stoyanov (VMware) (2):
  trace-cmd: Move kernel_stack event handler to "function" plugin.
  trace-cmd: Move plugin options from trace-cmd to libtraceevent.
  trace-cmd: Remove trace-cmd plugin handling routines

 include/trace-cmd/trace-cmd.h    |  24 -
 include/traceevent/event-parse.h |   8 +
 kernel-shark/src/libkshark.c     |   4 +-
 lib/trace-cmd/trace-ftrace.c     |  56 +--
 lib/trace-cmd/trace-input.c      |   9 +-
 lib/trace-cmd/trace-util.c       | 752 +------------------------------
 lib/traceevent/event-plugin.c    | 192 +++++++-
 plugins/plugin_function.c        |  45 +-
 plugins/plugin_python.c          |   9 +-
 tracecmd/trace-check-events.c    |  10 +-
 tracecmd/trace-list.c            |  23 +-
 tracecmd/trace-read.c            |   2 +-
 12 files changed, 278 insertions(+), 856 deletions(-)

-- 
2.21.0

