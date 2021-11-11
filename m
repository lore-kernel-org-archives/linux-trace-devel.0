Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B2734C433EF
	for <linux-trace-devel@archiver.kernel.org>; Thu, 11 Nov 2021 15:13:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 97BDC603E9
	for <linux-trace-devel@archiver.kernel.org>; Thu, 11 Nov 2021 15:13:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234036AbhKKPQH (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 11 Nov 2021 10:16:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38388 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233945AbhKKPQH (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 11 Nov 2021 10:16:07 -0500
Received: from mail-ed1-x536.google.com (mail-ed1-x536.google.com [IPv6:2a00:1450:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E3268C061766
        for <linux-trace-devel@vger.kernel.org>; Thu, 11 Nov 2021 07:13:17 -0800 (PST)
Received: by mail-ed1-x536.google.com with SMTP id m14so25756873edd.0
        for <linux-trace-devel@vger.kernel.org>; Thu, 11 Nov 2021 07:13:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=IsTpJSFptwQKHCJk+UunaE4cDqSToky7gG2+AQsD+So=;
        b=ipuV1RM1Iz51tWXo6oEfvpZFcgdbyPNmtYtn5CAoqTgIde6mJWSOfTk2USp95cVfO4
         106qkG9L6WGtdQkXVVNq/ZJYQH5dGOBggBtYA5ny5Y1c3e+CwCl3DtrTGXrZRvMuwJdE
         iEqEoGEz8nhlu3Qrvfg2aW+XhVIWvT0W6jEVWcefMy4ywMf9qJSE1Jl88jydOYKaRKEx
         02Tk/4Hru/TeX5kc+M81ZWsQD69csb3+1h3conK+AxRt5OfGddiHqUzV16z5OeoiQQqq
         A5WAHgRJQotPIe+xVhHZW1dUTfaaNVybIwocfzijLAXr+9pX1HlSOyUKYTynPaiC1WMc
         zwZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=IsTpJSFptwQKHCJk+UunaE4cDqSToky7gG2+AQsD+So=;
        b=Ck8DQAMVVOshvQEj92b54OXaaVGUwTOygEjow6kmhvqQYTKXPmPgTd9hCIxLtmwGEi
         7xBDTLuWdrDioP6e18k8nl+tZ3ieCvjZJeDVU+vdT8KQxmaIB5VEg5QfRd8YqERFM+1E
         CG41H3WKikCvR/EkSe3jUxBfcEKitrNz6HT+5rRPds/yiZWR/4Djqcu+B4/e/H5KNaMB
         zVloFC4YT5jqwT8en2bTAeMckoynX64BGHh4AA52op1Lrg7qaB3GjASaauCplGLLsbOK
         h5hlASZTdgrJaO67y39/+nhdLDHiR8bbhWdILElPFEPrAdV9gcVtWj8Vz77cRq935/GM
         dkMA==
X-Gm-Message-State: AOAM532ExcMFvb7UFsDapxv8/wwEGt+u7kZt+ajEydMLkhCjWeGIuJlq
        zaZqcqtVKVetawrh/5U5Cd8=
X-Google-Smtp-Source: ABdhPJyU/P8LWs9jyJ8Pg0a3v0L2wL0wqz0jq3T7zgpNpgYLNPbWWMRI/hUUauu2H9Wj6dUeoeyuFg==
X-Received: by 2002:a17:906:5343:: with SMTP id j3mr10329300ejo.538.1636643596456;
        Thu, 11 Nov 2021 07:13:16 -0800 (PST)
Received: from oberon.zico.biz.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id gb3sm1545093ejc.81.2021.11.11.07.13.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 Nov 2021 07:13:16 -0800 (PST)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v4 0/4] trace-cmd documentation update for v7 files
Date:   Thu, 11 Nov 2021 17:13:10 +0200
Message-Id: <20211111151314.87148-1-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.33.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Added documentation of trace file version 7.

This patch-set depends on
 "trace-cmd fixes and clean-ups" patch set.
 "Refactor APIs for creating output handler" patch set.
 "Refactor the logic for writing trace data in the file" patch set.
 "Trace file version 7 - sections" patch set.
 "Trace file version 7 - compression" patch set.
 "trace-cmd convert" patch set.
 "trace-cmd dump - v7 update" patch set.

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
 .../trace-cmd/trace-cmd.dat.v7.5.txt          | 442 ++++++++++++++++++
 tracecmd/trace-cmd.bash                       |  37 ++
 6 files changed, 564 insertions(+), 6 deletions(-)
 create mode 100644 Documentation/trace-cmd/trace-cmd-convert.1.txt
 rename Documentation/trace-cmd/{trace-cmd.dat.5.txt => trace-cmd.dat.v6.5.txt} (98%)
 create mode 100644 Documentation/trace-cmd/trace-cmd.dat.v7.5.txt

-- 
2.33.1

