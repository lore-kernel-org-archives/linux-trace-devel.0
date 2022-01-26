Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3BDB9C2BA4C
	for <linux-trace-devel@archiver.kernel.org>; Wed, 26 Jan 2022 09:53:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230291AbiAZJxn (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 26 Jan 2022 04:53:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49792 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230405AbiAZJxn (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 26 Jan 2022 04:53:43 -0500
Received: from mail-ej1-x62e.google.com (mail-ej1-x62e.google.com [IPv6:2a00:1450:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D2153C06161C
        for <linux-trace-devel@vger.kernel.org>; Wed, 26 Jan 2022 01:53:42 -0800 (PST)
Received: by mail-ej1-x62e.google.com with SMTP id d10so37745680eje.10
        for <linux-trace-devel@vger.kernel.org>; Wed, 26 Jan 2022 01:53:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=7LMO8gZdMOS30HYOSJMP7oIC+UupV5Wwn4ShBYzjG4Y=;
        b=deo8Q/rljj6KPPOxAFr03ggQN0/wqPOSwSbxA9EdxWsWPE3+YzGE0GSkckhgZ7K3cG
         4NDYV8HCjw2Z3AjweLEegfSjWKt6kXq05klv191/vm0dPHPxPmoinvhvnO5VDeKfqzNc
         CjLwIt4QiwJ4Ev4QZCSRAFEK1i9go/hjxII5IeP4opwmWAqUcaCcu7u/2AJn34jz8xbx
         4wHQ0B+V8Ny0y3+gvFHT4B7MBElb5xb1z7vAGfN/f+2JH73kGup8RdGNQWhxvIKdIfsR
         2gJmWfNE2MBD6gY8z0OJdiUcgrtSl7JVsXVnCgnuu7Jb0NyJWnLtlZG3u6N8/aOwYSsq
         HoGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=7LMO8gZdMOS30HYOSJMP7oIC+UupV5Wwn4ShBYzjG4Y=;
        b=7yF4Lk0Zd0Rs4oXllO11RY24CauAM/MbgHx+HCcD+7+dcr20hx0SrRzNnRFuCPprv6
         DKYAXOuFioTJpHIkrliJ/XXqqy6FLCOdRQW8mensSShB8/KPoQNuVjbW0Of+fgO7b0P5
         fvpSNE02jSwI9k76nwKvfIxW0hZRqPfds2j8QXp/TXJQ/4fr2kuSWHg5CEYHJLYO4STT
         nAsDKA9x9u0wXzIq/aazTZVt5sv2bVNVghqVY/6a+t9KdVAKjoOJPFMGDAn6d3NAD7sH
         shkJaH5ftZcyZTWSfvzy9vHIWQ7gOIb7Z3FMbNva+YdE6/KXbSOAFdyq/wCWoPtgC+ht
         pvvQ==
X-Gm-Message-State: AOAM5302yzpGcisFsSyl+H9zBTz8oiA+rSPvj1K7+FPL3PiIhUVlpaW3
        qJ/DpqqBnwebT3b8a/67J2R9bqMRZa0=
X-Google-Smtp-Source: ABdhPJyuCTOEX4gOM0c1F46akn0sfGK/+mFHm1EX1K3YlomaCVhwY92YoNpWIplj4RiqBsyLVQrr8Q==
X-Received: by 2002:a17:907:97c3:: with SMTP id js3mr5786937ejc.117.1643190821471;
        Wed, 26 Jan 2022 01:53:41 -0800 (PST)
Received: from oberon.zico.biz ([151.251.254.11])
        by smtp.gmail.com with ESMTPSA id h19sm3177266edv.90.2022.01.26.01.53.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 Jan 2022 01:53:41 -0800 (PST)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v8 00/11]trace-cmd dump - v7 update
Date:   Wed, 26 Jan 2022 11:53:26 +0200
Message-Id: <20220126095337.570867-1-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Updated the "trace-cmd dump" subcommand to work with trace files version 7.

This patch-set depends on:
 "[PATCH v8 0/9] trace-cmd convert"
 https://lore.kernel.org/linux-trace-devel/20220126095154.570700-1-tz.stoyanov@gmail.com/

v8 changes:
 - Bug fixes.
 - Code cleanups.
 - Rebase.
v7 changes:
 - Bug fixes.
 - Code cleanups.
 - Rebase.
v6 changes:
 - Rebased on top of the latest master.
 - Introduced new metadata strings section.
 - Use 8 bytes for section size.
v5 changes:
 - Rebased on top of the latest master.
v4 changes:
 - Rebased on top of the latest master.
v3 changes:
 - Rebased on top of the latest master.
v2 changes:
 - fixed issues of split and convert commands with some corner cases

Tzvetomir Stoyanov (VMware) (11):
  trace-cmd dump: Add helpers for processing trace file version 7
  trace-cmd dump: Print compression header
  trace-cmd dump: Add helpers for processing trace file sections
  trace-cmd dump: Read recursively all options sections
  trace-cmd dump: Read extended BUFFER option
  trace-cmd dump: Dump sections
  trace-cmd dump: Dump trace file version 7
  trace-cmd dump: Read strings sections from v7 trace files
  trace-cmd dump: Dump sections content
  trace-cmd dump: Add new argument --sections
  trace-cmd dump: Align better the output of flyrecord dump

 tracecmd/trace-dump.c | 580 ++++++++++++++++++++++++++++++++++++++----
 1 file changed, 535 insertions(+), 45 deletions(-)

-- 
2.34.1

