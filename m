Return-Path: <SRS0=KH1A=YA=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BD15AECE58C
	for <linux-trace-devel@archiver.kernel.org>; Mon,  7 Oct 2019 11:49:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 93844206C2
	for <linux-trace-devel@archiver.kernel.org>; Mon,  7 Oct 2019 11:49:54 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="t97kh4nb"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727496AbfJGLty (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 7 Oct 2019 07:49:54 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:35015 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727561AbfJGLtx (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 7 Oct 2019 07:49:53 -0400
Received: by mail-wr1-f65.google.com with SMTP id v8so14931439wrt.2
        for <linux-trace-devel@vger.kernel.org>; Mon, 07 Oct 2019 04:49:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Q6LEnI5ph5kMTHZEatPFQYkPOYbaw3wXXAzlFChYuZ4=;
        b=t97kh4nbcNInpsf1zlB32zwBzm5iXG7HWEaaZm8AWqp+rgTMCQr4pvIU1tbN1s5wsL
         yrecwDX0Pv8NaRFPdzFBzb/RBMyCnXeVwT7vmjjlUVahJDvTDeCDIu1kJKZsCIOPm9So
         6MCiPzFvtkEhmOo34GUCy4A4XXiXUgltXTFSqefvjC4yfMXqKOh0rUpsvWfK8H4Cv+Rg
         mhszw+amTrOxzdDxgjdyVWKGEGOWhv3ZPeDCds6qXqm3vyUStGQLLftfLZOCxYB/XW5r
         HOaoe5SJae+gzw12E5VlOE9ZImBTebT52hOwhtv+DVmIfVnwDlmuOe6Km8oE508TVRYx
         i70Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Q6LEnI5ph5kMTHZEatPFQYkPOYbaw3wXXAzlFChYuZ4=;
        b=oOueDVF6GG0qWl6cS2JKJQ3fLSXWafVKQQ3GpeZlEtvA1ObQUYWvxZX2uCbYbmVrXH
         /q2QEwfvThkC+g2GcfWVIdadH9DddfsNyIvHADcXfVTgJDPj6/CitAO9ww6N7adbZm01
         IXrjEKA3Cd68oeR9O6djlfjlpnkV0E4wA/uJJGyIPd9RwZbtoLnVodfzy0DfKtWeQ7SZ
         ZqePlQpTPRG4omjOr+uFFDc13kMbxohdXxiCEMMbYiW9gVlnJyyferZbB6kMavomV4iF
         myVfNHs4LufkLrgEcqwO4sU7e8sHUplaOp4Km5TNrMUbaatQH0xT8McZdXPTajM38WdN
         JeGg==
X-Gm-Message-State: APjAAAVQDas5OhnYv+GhpFX1hMJcjGQJVa4PC0UJ7gjho3w/yUQBItyW
        E3g6Ic6JHLBmug6tup6pMGtEQKaV
X-Google-Smtp-Source: APXvYqziWdLph31k0/hUr/FkfE+VKeuw3mJO8WWKVRDouYWcuTGTl1+2cGiJe/6G3+mkmoiQqad/eQ==
X-Received: by 2002:adf:f307:: with SMTP id i7mr6023290wro.120.1570448989862;
        Mon, 07 Oct 2019 04:49:49 -0700 (PDT)
Received: from oberon.eng.vmware.com ([146.247.46.5])
        by smtp.gmail.com with ESMTPSA id t13sm39350773wra.70.2019.10.07.04.49.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Oct 2019 04:49:48 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v6 0/3] Remove redundant trace-cmd plugin handling logic
Date:   Mon,  7 Oct 2019 14:49:44 +0300
Message-Id: <20191007114947.17104-1-tz.stoyanov@gmail.com>
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

A new libtraceevent API is introduced, which can be used to define
custom plugin directories. It is used by trace-cmd to load development
plugins, if any. 

An initial infrastructure for trace-cmd specific plugins is added - 
new lib/trace-cmd/plugins directory and an initial set of APIs
for working with trace-cmd plugins.

[
  v6 changes:
   - Introduced new libtraceevent API for adding custom plugin directories.

  v5 changes:
   - Removed accepted patches from the patch set.
   - Moved logic which loads traceevent development
     plugins from libtraceevent to trace-cmd application.
]

Tzvetomir Stoyanov (VMware) (3):
  trace-cmd: Introduced new traceevent API, for adding new plugins
    directories.
  trace-cmd: Load libtraceevent plugins from build folder, if exists.
  trace-cmd: Add initial infrastructure for trace-cmd specific plugins.

 .gitignore                         |   1 +
 Makefile                           |  40 +++-
 include/trace-cmd/trace-cmd.h      |  42 ++++
 include/traceevent/event-parse.h   |   7 +
 lib/trace-cmd/Makefile             |   1 +
 lib/trace-cmd/plugins/Makefile     |  58 ++++++
 lib/trace-cmd/trace-input.c        |   7 +-
 lib/trace-cmd/trace-plugin.c       | 313 +++++++++++++++++++++++++++++
 lib/trace-cmd/trace-util.c         |  42 ++++
 lib/traceevent/event-parse-local.h |   5 +-
 lib/traceevent/event-parse.c       |   1 +
 lib/traceevent/event-plugin.c      |  70 +++++++
 tracecmd/trace-check-events.c      |   7 +-
 tracecmd/trace-list.c              |  14 +-
 14 files changed, 575 insertions(+), 33 deletions(-)
 create mode 100644 lib/trace-cmd/plugins/Makefile
 create mode 100644 lib/trace-cmd/trace-plugin.c

-- 
2.21.0

