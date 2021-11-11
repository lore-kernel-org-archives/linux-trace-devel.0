Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DF474C433F5
	for <linux-trace-devel@archiver.kernel.org>; Thu, 11 Nov 2021 15:12:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BC208610D0
	for <linux-trace-devel@archiver.kernel.org>; Thu, 11 Nov 2021 15:12:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234031AbhKKPPs (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 11 Nov 2021 10:15:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38282 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231739AbhKKPPn (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 11 Nov 2021 10:15:43 -0500
Received: from mail-ed1-x536.google.com (mail-ed1-x536.google.com [IPv6:2a00:1450:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3DFDBC061766
        for <linux-trace-devel@vger.kernel.org>; Thu, 11 Nov 2021 07:12:54 -0800 (PST)
Received: by mail-ed1-x536.google.com with SMTP id x15so25523977edv.1
        for <linux-trace-devel@vger.kernel.org>; Thu, 11 Nov 2021 07:12:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=802huCS/I/lxVv4KYm+t4t8lT7egi7fBax57TDVSE+o=;
        b=JgiRNcDx1mkyIGaDs2Gw9DJwYp1dQ6mIHxcOAU008nDBqUPnD/GUgAGVKHfkmh6WIk
         Mw1jOXLl+WfQpnZasU0foA2WxAO/5SQPf2FehGOn+w68x7RP8bqXqaAnIf5AkPTqdjuf
         OHnvUjAAWginnWVnkUw4EYo+5dmoo5SBQ8QbqOdFfW5JWPV3XpyYBYA7WeY2dyfE+AAK
         Ze0dzais4iyC/Pk0mw6gjRGlli4uWKWYe/2VFLh2TKqioI+2WTAHhBl8nuj154I6Lzp4
         hBVuukoZb+MhtVvl0FD9BMwGS5KuwOP1V7n/FfRtomxfy+UKqn5eSI7XOuEZ/ePs4FVK
         ILLA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=802huCS/I/lxVv4KYm+t4t8lT7egi7fBax57TDVSE+o=;
        b=LdJYdIWTm+i9VOct4qnNFm216LW/9URnBl/ocmzUm89BI714+rezh5xTdOEvP+E+GV
         siTrUxNqqpOAmipgWkI6nRoPfut5PkPXiuFTH2dfab1GSZaznThMMqcbXB9tFlGILb6d
         X64gt2sCAUHmbCBs02DoZjHBLNdMLZWb1JWL3DH44NsTtx3Qs3b4jNBf9ibn92QOUc+B
         3FF/Eq5lM+Z2hinpBeJqlGYC3jD1NPO6cfKdfKvxTeIPPT97KTU7Gqij13MxOId7KkvA
         0VnqBWbBSccT5aK+lnhKA6uD5OKMJ7OcjQrZ8vFpWxgIcTv3RRzVWleeOJTl/iNPYyiZ
         d8YA==
X-Gm-Message-State: AOAM532HlgR3Dvqog62C36gyrPh9W3GjnZVFnheOvOd8C+PocC/ddpEL
        v4sAIknhCwmaQCqbsAA1M/DlejOEQke1Fg==
X-Google-Smtp-Source: ABdhPJxOXEiE4MWU/98Kz6ZBKG/lJpX9Mi2z0M97/SdJq4t/lnszbiYpNljFwFPh63OcY7O7KtQxRA==
X-Received: by 2002:a17:906:dc90:: with SMTP id cs16mr10073801ejc.432.1636643572791;
        Thu, 11 Nov 2021 07:12:52 -0800 (PST)
Received: from oberon.zico.biz.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id q2sm1443375eje.118.2021.11.11.07.12.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 Nov 2021 07:12:52 -0800 (PST)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v4 00/10] trace-cmd dump - v7 update
Date:   Thu, 11 Nov 2021 17:12:40 +0200
Message-Id: <20211111151250.87023-1-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.33.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Updated the "trace-cmd dump" subcommand to work with trace files version 7.

This patch-set depends on:
 "trace-cmd fixes and clean-ups" patch set.
 "Refactor APIs for creating output handler" patch set.
 "Refactor the logic for writing trace data in the file" patch set.
 "Trace file version 7 - sections" patch set.
 "Trace file version 7 - compression" patch set.
 "trace-cmd convert" patch set.

v4 changes:
 - Rebased on top of the latest master.
v3 changes:
 - Rebased on top of the latest master.
v2 changes:
 - fixed issues of split and convert commands with some corner cases

Tzvetomir Stoyanov (VMware) (10):
  trace-cmd dump: Add helpers for processing trace file version 7
  trace-cmd dump: Print compression header
  trace-cmd dump: Add helpers for processing trace file sections
  trace-cmd dump: Read recursively all options sections
  trace-cmd dump: Read extended BUFFER option
  trace-cmd dump: Dump sections
  trace-cmd dump: Dump trace file version 7
  trace-cmd dump: Dump sections content
  trace-cmd dump: Add new argument --sections
  trace-cmd dump: Align better the output of flyrecord dump

 tracecmd/trace-dump.c | 458 +++++++++++++++++++++++++++++++++++++-----
 1 file changed, 413 insertions(+), 45 deletions(-)

-- 
2.33.1

