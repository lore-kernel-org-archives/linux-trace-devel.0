Return-Path: <SRS0=JRVv=X5=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 46E2DC4360C
	for <linux-trace-devel@archiver.kernel.org>; Fri,  4 Oct 2019 15:07:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 18E55207FF
	for <linux-trace-devel@archiver.kernel.org>; Fri,  4 Oct 2019 15:07:12 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="o1vyKRjd"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389320AbfJDPHL (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 4 Oct 2019 11:07:11 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:45216 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388802AbfJDPHL (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 4 Oct 2019 11:07:11 -0400
Received: by mail-wr1-f66.google.com with SMTP id r5so7594919wrm.12
        for <linux-trace-devel@vger.kernel.org>; Fri, 04 Oct 2019 08:07:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=ueIrc9mDmGeOJ67ZI9Dngy6Cs+jNOUiKrBFCqRILJ4w=;
        b=o1vyKRjdzLcfoM+VoRYL7fZttuoLD44dJVs+VA2KJMmqxoB3HiS3MaWdybPDN8D284
         gdP0X20wHY8mz5tjz1r28tNgdDcLitcC10Lxww2QgMYPU9xZknygy8mfCANrE8oabqIk
         Zo4du11idL0ydA9XIKjImTb49yjbWqSAHtHdtfLlFuc3iC8N+jxD1qgdDqib7jz3pAB3
         c0xspiQlc7s6Yz7hsb6THYv0q14U2rH/CST7Jww27igh/T+5TbYZLqiMTIykJmp++56l
         ljE7I+xCCu+FKMpu+6vtg5zzXUD7Jbd5XtJKm7IDf6pMjMy/QKNCIdEn0PBvhNvpb+Rg
         /B9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=ueIrc9mDmGeOJ67ZI9Dngy6Cs+jNOUiKrBFCqRILJ4w=;
        b=QRUmkRIV5f1eaIYvysXZQTEBfdsp+DkPsga2ON0y7DDX48FbNCUdm0Y5oUdnUUoa02
         VfUkZh1Yf3ChkHMCYBJUurXvt4hFfnO1Jl3QPx0l6einNn77tuWcsvTRoF2wE54v8o3p
         WjiraBHbWTH0U5E1E5u4zSNiQzMjW2Gnn5th/yqFrsczqHs2Fu68AM9YxxAMRh33qON9
         tosd52GyLEHXI34JYGmwCH64XMrOnRWasVM6j2Gq2bDfS+lNZS5SVPpcBKE6cPtgkWJb
         b9z8ynFRpYOqC5i1iMkR9X7NeInL0qlZntzPC/lT3QwL5dKB606oLdUnrLIYx9Frfur8
         /4Vg==
X-Gm-Message-State: APjAAAWSdMkA6ObqkGuRkQ/SR+kT7RgKhqxT7O1s7ta9EnY4bJ4z4Vvh
        7C8DlJhopX85jz/I/e6OeH/bwO1W
X-Google-Smtp-Source: APXvYqyVCZPOhE/UoidXzxzr+6CWsU7yWDw3kH06tbC7YZa0PV4sKsg7ahpdETjGSWS5XWF9rBlxZg==
X-Received: by 2002:adf:fb11:: with SMTP id c17mr12820431wrr.0.1570201629898;
        Fri, 04 Oct 2019 08:07:09 -0700 (PDT)
Received: from oberon.eng.vmware.com ([146.247.46.5])
        by smtp.gmail.com with ESMTPSA id a7sm12291471wra.43.2019.10.04.08.07.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 04 Oct 2019 08:07:08 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v5 0/2] Remove redundant trace-cmd plugin handling logic
Date:   Fri,  4 Oct 2019 18:07:04 +0300
Message-Id: <20191004150706.7957-1-tz.stoyanov@gmail.com>
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

All existing plugins are moved from plugins/ to lib/traceevent/plugins
directory, as all of them are designed to be used with the traceevent
library.

An initial infrastructure for trace-cmd specific plugins is added - 
new lib/trace-cmd/plugins directory and an initial set of APIs
for working with trace-cmd plugins.

[
  changes:
   - Removed accepted patches from the patch set.
   - Moved logic which loads traceevent development
     plugins from libtraceevent to trace-cmd application.
]

Tzvetomir Stoyanov (VMware) (2):
  trace-cmd: Load libtraceevent plugins from build folder, if exists.
  trace-cmd: Add initial infrastructure for trace-cmd specific plugins.

 .gitignore                       |   1 +
 Makefile                         |  40 +++-
 include/trace-cmd/trace-cmd.h    |  42 +++++
 include/traceevent/event-parse.h |   3 +
 lib/trace-cmd/Makefile           |   1 +
 lib/trace-cmd/plugins/Makefile   |  58 ++++++
 lib/trace-cmd/trace-input.c      |   7 +-
 lib/trace-cmd/trace-plugin.c     | 313 +++++++++++++++++++++++++++++++
 lib/trace-cmd/trace-util.c       |  46 +++++
 lib/traceevent/event-plugin.c    |  38 ++++
 tracecmd/trace-check-events.c    |   7 +-
 tracecmd/trace-list.c            |  14 +-
 12 files changed, 538 insertions(+), 32 deletions(-)
 create mode 100644 lib/trace-cmd/plugins/Makefile
 create mode 100644 lib/trace-cmd/trace-plugin.c

-- 
2.21.0

