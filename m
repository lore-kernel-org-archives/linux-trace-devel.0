Return-Path: <SRS0=vzsu=RW=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0B5EFC43381
	for <linux-trace-devel@archiver.kernel.org>; Tue, 19 Mar 2019 11:19:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D58AB20828
	for <linux-trace-devel@archiver.kernel.org>; Tue, 19 Mar 2019 11:19:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726717AbfCSLT2 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 19 Mar 2019 07:19:28 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:41637 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725862AbfCSLT2 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 19 Mar 2019 07:19:28 -0400
Received: by mail-wr1-f65.google.com with SMTP id p1so20561792wrs.8
        for <linux-trace-devel@vger.kernel.org>; Tue, 19 Mar 2019 04:19:27 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=GFPdPupatCIyZfETXfPjt/mIWmRu2I7DHq9a5pAiLVU=;
        b=Jnrf275VUetzYvYB76jzd+nogpf+r2mC0MJi7dENh6r7i2RmKN7gup4ULQcSExsiSs
         qAXEjj4UOLTeRD6BFPb0bPspJd+uCqp8mecGxkZhjWC2ipTZhb9zO4cRkYIiZulCRpu3
         8hfjdbYUouN/j7H+5YpRINQl1VXpA5fSxfi5iXF2mpqOHmUucXTIRwDTUxSzQPuZgpaM
         PblHBfNSGD+9g7aWLb7nPC+mNq79/7Gcc9eAkZTHI2OiVK/bANVVJ9BNPEUcP2syLE8k
         E3YFFceZ6MuTb8dSAoZNbPvsr1tpN020k2n9JffLDaPZC5XfK33zHigDyzZEnTt0tQ+d
         ZhXQ==
X-Gm-Message-State: APjAAAUKGyuLh/e/OvvHRhiapWW+3SnAxZulr4DUzkoab++8dLN6wHyC
        mJCBLDrwA4EGHQK61gNT+agMltaa
X-Google-Smtp-Source: APXvYqzSIninvEN3HV0FV7Oec1ipqp6uOT71vX0BqkSxVc+OP6z0yZaO8rXEvK56pBkGXPeiNaYuhg==
X-Received: by 2002:adf:f68d:: with SMTP id v13mr16023965wrp.6.1552994366657;
        Tue, 19 Mar 2019 04:19:26 -0700 (PDT)
Received: from oberon.eng.vmware.com ([146.247.46.5])
        by smtp.gmail.com with ESMTPSA id v12sm3064407wml.29.2019.03.19.04.19.25
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 19 Mar 2019 04:19:25 -0700 (PDT)
From:   Tzvetomir Stoyanov <tstoyanov@vmware.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH 0/3] Few patches, related to libtracevent APIs
Date:   Tue, 19 Mar 2019 13:19:21 +0200
Message-Id: <20190319111924.17443-1-tstoyanov@vmware.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

This patchset introduces new libtracevent APIs, which can be used for
accessing struct tep_handler fields. It also changes the description
of few APIs, to match more closely their logic.
There are also fixes to coding style problems, introduced by previous patches.

Tzvetomir Stoyanov (3):
  tools/lib/traceevent: Change description of few APIs
  tools/lib/traceevent: Coding style fixes
  tools/lib/traceevent: Implement new traceevent APIs for accessing
    struct tep_handler fields

 tools/lib/traceevent/event-parse-api.c   | 190 +++++++++++++++++++----
 tools/lib/traceevent/event-parse-local.h |   2 +
 tools/lib/traceevent/event-parse.c       |   4 +-
 tools/lib/traceevent/event-parse.h       |  12 +-
 tools/lib/traceevent/plugin_kvm.c        |   2 +-
 5 files changed, 173 insertions(+), 37 deletions(-)

-- 
2.20.1

