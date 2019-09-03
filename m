Return-Path: <SRS0=NxYB=W6=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 63E54C3A5A7
	for <linux-trace-devel@archiver.kernel.org>; Tue,  3 Sep 2019 13:34:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3D5F623431
	for <linux-trace-devel@archiver.kernel.org>; Tue,  3 Sep 2019 13:34:49 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="hpm7NHz7"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729083AbfICNet (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 3 Sep 2019 09:34:49 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:41058 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725782AbfICNes (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 3 Sep 2019 09:34:48 -0400
Received: by mail-wr1-f66.google.com with SMTP id j16so17527639wrr.8
        for <linux-trace-devel@vger.kernel.org>; Tue, 03 Sep 2019 06:34:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=7SoqdWd3xhAe3WHxT0F0sRGfGgk4gUkhrNmW2IFMYOM=;
        b=hpm7NHz7PjN59QcLjgBg2Gbr0+jTzPGAXyWc4nFgBC1gyzVCITB2J3Kd1N5WZhcGKu
         A5r8GJR9UXMsBpmV1fXiHvMwV0J8GD/Lg83rWIvSby1Zua1l/Ot463zXJ6yy/qvne0z4
         9IKaFeMIzosxjehzTo4l7LVWN7qk7V0GIidqH4oBzn7WDSR5lm2bRpf0Puno7E4FyFo7
         34iJRROHywaHCBngiRln7kJxrOBbNqSRnMdHRJYnmn1q8EBsF6lwrXpWqctHCnF4YWRG
         3/neybOs4S0LlP/ywvRdz9PzyG0E8wt1F4+muAKSqeqx+wswYxmt0PMZbWM4CCBGPqjC
         qO+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=7SoqdWd3xhAe3WHxT0F0sRGfGgk4gUkhrNmW2IFMYOM=;
        b=YHSMnGQIOfDrp5690UJHHteiVRrMLBRUtgq8NxI/MA2uJyGT5c3BcxtASsRLehHcGs
         NK6pllHTCyY8NE7qVJECFbBs/LC+y+9BYTmH/MjSU3p1h7Es7z9ccvuoOBH0VJYBwPYm
         GFUhaeSwlOxmACKMEs3i/ezR/c+dKtXCaEVrxJ1vtvxS6beumyYvRhJ3MmWMlZkpSs1A
         0WGzVIV6IhlQHSb86vqtgNTMJz/7JRb1m/jXb4ESDVm3XKZgQsjK8XRGkShNLnnv9EXS
         1KYTFBvh+RX7urPrGi1F00z1jLaGEUtlTLV65vY4/5iBa6eq6eAwQM4UyNJhyDcYsapw
         iVyQ==
X-Gm-Message-State: APjAAAWxe0G5QdeeTyW4EkfSe8O7RSvpTx2aKf8zgrSZ7rY3NT0VUoTG
        16OibZPsHvGu87ZwbzyQ2BQ=
X-Google-Smtp-Source: APXvYqy3Fm4JDVTP9GrHh3+OF4V5ZWDraUH2qwiVbaF3dDGgfnFPfjLowRrdmu70mRkDc4jqJKlN4g==
X-Received: by 2002:adf:c504:: with SMTP id q4mr10030753wrf.266.1567517686989;
        Tue, 03 Sep 2019 06:34:46 -0700 (PDT)
Received: from oberon.eng.vmware.com ([146.247.46.5])
        by smtp.gmail.com with ESMTPSA id r16sm33509833wrc.81.2019.09.03.06.34.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Sep 2019 06:34:46 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v3 0/4] Separate trace-cmd and libtracecmd code
Date:   Tue,  3 Sep 2019 16:34:41 +0300
Message-Id: <20190903133445.30486-1-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

libtracecmd is a library, containing functions that can be
used without the trace-cmd application. However, some of the
functions declared as libtracecmd APIs in trace-cmd.h
depend on trace-cmd context. That causes a problem when
other application uses the library. The problem can be
observed when running kerneshark and there is a python
module, loaded by the python plugin - there is a bunch
of warnings.
To resolve the problem, implementations of all trace-cmd
independent functions are moved into libtracecmd. All
libtracecmd functions, that depend on trace-cmd context
are removed from the library and from trace-cmd.h file.

[
  v3 changes:
   - Removed accepted patches from the series.
   - Added new patch: "Update descriptions of "debug" libtracecmd APIs".
   - Renamed "plog*" library APIs to "tracecmd_plog*".
   - Rmoved "tracecmd" prefix from local variables.
   - Renamed trace_set_log_file to tracecmd_set_logfile.
   - Changed tracecmd_set_quiet() and tracecmd_get_quiet() APIs to work
     per tracecmd_output handler.
 
  v2 changes:
   - Added a new patch: 
        Move trace-cmd-local.h from the application to the library.
   - Remove trace-output.c dependency of version.h. Moved FILE_VERSION_STRING
     define from top Makefile to trace-cmd-local.h.
]

Tzvetomir Stoyanov (VMware) (4):
  trace-cmd: Move trace-cmd global variable "quiet" to libtracecmd
  trace-cmd: Move plog() function to libtracecmd.
  trace-cmd: Move tracecmd_stack_tracer_status() function to libtracecmd
  trace-cmd: Update descriptions of "debug" libtracecmd APIs

 include/trace-cmd/trace-cmd.h           |   9 +-
 include/trace-cmd/trace-msg.h           |   3 -
 lib/trace-cmd/include/trace-cmd-local.h |   2 -
 lib/trace-cmd/trace-msg.c               |   8 +-
 lib/trace-cmd/trace-output.c            |  28 ++++-
 lib/trace-cmd/trace-util.c              | 139 ++++++++++++++++++++++--
 tracecmd/include/trace-local.h          |   2 -
 tracecmd/trace-cmd.c                    |   2 -
 tracecmd/trace-listen.c                 |  89 +++------------
 tracecmd/trace-record.c                 |  17 ++-
 tracecmd/trace-stack.c                  |  56 +---------
 11 files changed, 199 insertions(+), 156 deletions(-)

-- 
2.21.0

