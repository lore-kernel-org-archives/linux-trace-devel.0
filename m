Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 92555C433FE
	for <linux-trace-devel@archiver.kernel.org>; Wed, 19 Jan 2022 08:32:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350982AbiASIcY (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 19 Jan 2022 03:32:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47448 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352498AbiASIcX (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 19 Jan 2022 03:32:23 -0500
Received: from mail-ed1-x529.google.com (mail-ed1-x529.google.com [IPv6:2a00:1450:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B978C06173E
        for <linux-trace-devel@vger.kernel.org>; Wed, 19 Jan 2022 00:32:23 -0800 (PST)
Received: by mail-ed1-x529.google.com with SMTP id m4so7559975edb.10
        for <linux-trace-devel@vger.kernel.org>; Wed, 19 Jan 2022 00:32:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=eFRcVuRnj9PLGIrkAsT0aj5HuvOSomDUcfdPQn2vMMo=;
        b=AHLXUpCGIKBJjf1aDSaIUBjq9feIk6jjBf1UUnC59gXO+OaxjeqZnqcFwE2QMa8pLO
         fMdfhCkbd9AKCKIitrOeyvTM7SWJ4PCfD81Kxk96rn+J88QrjIa7c6mhDMg8b0pDyA7+
         AX79d1E8Wp7b8j5alVZHGCXnbWsNRJFv0fTgSQ5I29PXjLUoHWwG0S522rgOgJi5a9uJ
         w6L63A58Ee0tCsjOlStxmgFUPQ6WRyQXaRyiPUCUpHp32GeXoSmnfEH4ufPn+HkmMHCo
         gmaXXD0zyn60E3xm4GPEZ6xhxeiBduVdXuXUP15bQLY8Clzaw70E7Md5UYc+blmg1s9O
         LLkg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=eFRcVuRnj9PLGIrkAsT0aj5HuvOSomDUcfdPQn2vMMo=;
        b=0mawo+pefv828FMtqyqWHxSDTpNBFHjGU30dbYbvCjdDxOkxPKoNlj9+Mz6+D/kUTj
         mq7qAwKL6egaqvpXME7Kpvo5zbX2ip8Ciz+W+d4MybEiwvZoYtsA/MzCMghKiWkPiQa+
         4gHJpsJa1QAbAx2fslz6iPj+PZUDmdYNUY0POmomdNWIiru03ZhtTZMCXydA+oWWnE1K
         uzgMyMhKliN6gzplbcEvT4XjX0ykpJCdusyytQDXv5Vx+GVABGQ9TxHXoNKYyFRBMoww
         LFPS1ALIPTKJf+yyizznJJ8OrRs+MS39nFVKaIacu1fErhnSjZkFRa3X8J2QUIPzxYvK
         V/Ew==
X-Gm-Message-State: AOAM530t/3vDxu4DrGCep5kEVeUOxIN6ZV0PrUnqHM7lP/EPPB2+lNLz
        KEPtdlLdUMKwsQ30LGVGX7JP8GfY/Zs=
X-Google-Smtp-Source: ABdhPJy8kfJ6rEUptsl0TMrbPctR580/h66K+dZinJmtslLl7mr0j4ofubuJOL1pBxRB0iHrB9L1cQ==
X-Received: by 2002:a17:907:1c91:: with SMTP id nb17mr23037478ejc.712.1642581141645;
        Wed, 19 Jan 2022 00:32:21 -0800 (PST)
Received: from oberon.zico.biz.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id z6sm875969edb.58.2022.01.19.00.32.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Jan 2022 00:32:21 -0800 (PST)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v7 0/4] trace-cmd documentation update for v7 files
Date:   Wed, 19 Jan 2022 10:32:15 +0200
Message-Id: <20220119083219.246347-1-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Added documentation of trace file version 7.

This patch-set depends on
 "[PATCH v7 00/11] trace-cmd dump - v7 update"
 https://lore.kernel.org/linux-trace-devel/20220119083019.246153-1-tz.stoyanov@gmail.com/

v7 changes:
 - Documentation update.
 - Rebase.
v6 changes:
 - Rebased on top of the latest master. 
v5 changes:
 - Rebased on top of the latest master. 
v4 changes:
 - Rebased on top of the latest master.  
v3 changes:
 - Rebased on top of the latest master.
v2 changes:
 - fixed issues of split and convert commands with some corner cases

Tzvetomir Stoyanov (VMware) (4):
  trace-cmd: Update bash completion
  tarce-cmd: Man page for "trace-cmd convert"
  tarce-cmd: Update record man page
  trace-cmd: Document trace file version 7

 .../trace-cmd/trace-cmd-convert.1.txt         |  65 +++
 .../trace-cmd/trace-cmd-record.1.txt          |  13 +
 Documentation/trace-cmd/trace-cmd.1.txt       |   4 +-
 ...e-cmd.dat.5.txt => trace-cmd.dat.v6.5.txt} |   9 +-
 .../trace-cmd/trace-cmd.dat.v7.5.txt          | 450 ++++++++++++++++++
 tracecmd/trace-cmd.bash                       |  37 ++
 6 files changed, 572 insertions(+), 6 deletions(-)
 create mode 100644 Documentation/trace-cmd/trace-cmd-convert.1.txt
 rename Documentation/trace-cmd/{trace-cmd.dat.5.txt => trace-cmd.dat.v6.5.txt} (98%)
 create mode 100644 Documentation/trace-cmd/trace-cmd.dat.v7.5.txt

-- 
2.34.1

