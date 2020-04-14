Return-Path: <SRS0=o21U=56=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 14E51C2BA19
	for <linux-trace-devel@archiver.kernel.org>; Tue, 14 Apr 2020 15:56:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DEF7A20732
	for <linux-trace-devel@archiver.kernel.org>; Tue, 14 Apr 2020 15:56:17 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="t86S2ed7"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732256AbgDNP4P (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 14 Apr 2020 11:56:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52064 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728935AbgDNP4J (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 14 Apr 2020 11:56:09 -0400
Received: from mail-lf1-x143.google.com (mail-lf1-x143.google.com [IPv6:2a00:1450:4864:20::143])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 48748C061A0C
        for <linux-trace-devel@vger.kernel.org>; Tue, 14 Apr 2020 08:56:09 -0700 (PDT)
Received: by mail-lf1-x143.google.com with SMTP id m19so104485lfq.13
        for <linux-trace-devel@vger.kernel.org>; Tue, 14 Apr 2020 08:56:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=zcRecDIH7PZdJWMaS0GKgPPi/dY/GnAXlt7uaV9gJdg=;
        b=t86S2ed7CQq9OjiIsXvD6W5iA01pdToOZ5ZtD46Is05pD76HCbyiwpY24sAuhO+Ld4
         RpTl49ZDZJU1pu1NC3SL1WeW0ikPxcvOaJeyapUvKKf3jSJ5YocqEkM7NAd1o9H59BZm
         Qg6r6pdc8YHJTThVEPVS+V0MhBVkT5/v77VXLVR75SKKIQmcuo7nRWpPSo77bUSCMK2Z
         OYnhdxDU7AdL/M+/CzIOe4/Md0uuEMqdjf9CC4GWLHQp6ufMcEOTbSxz/j5Uc2cndY2n
         Avmu4KjOIalyQv76K0UWkprubqdxAEXdD6HQUSIR0VBnw09K9wX0hKrLtllUaMfyKHFZ
         cvbg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=zcRecDIH7PZdJWMaS0GKgPPi/dY/GnAXlt7uaV9gJdg=;
        b=hFefsIU21sTS5EOlFBh3qI688bAQYJ1obPq0mJ/F+QDfSyZOfUUicdyrVdej+r0KCp
         X4AwjG18G208qBMMQ3KOb3pEjtDwOPya8V1jK+3vq1i8UYPwPuix1MYsxGNfMh58dGs+
         S8dABaxrCQDxNo/PPFXyEAUVAaeNWQ6Ep2I666jtE4ULBSnKXvpSAT3bBLic0cMO0HJD
         /a8rv5xmbuj9KbzoVD3eHr9MYfODf8bOMBR+4bGzHoqPNN8trU9I/zSyciRXJAE6KFlf
         yrcGYLkx7Yc5UFdM3X/vtseCrVrAIxf2Deq7Ts4k2B+FxBMOqtkwPc2pH0M+kdoHNBYM
         KwpQ==
X-Gm-Message-State: AGi0PuYkviNNTJE7A7DjKDHWDTpcL0IGCFLTBSaCQ64l7iI7PXDDJONi
        W6jgsQ9EsTRFJHeiFqKrZiTz8iBNLeI=
X-Google-Smtp-Source: APiQypJyKyv3lzmRitA+0g464SMxGsXRm6NsPHyO/LBWPRwS7B5y+4QY5oKMXiamvYyfwUDAS3WGKA==
X-Received: by 2002:ac2:57cc:: with SMTP id k12mr284079lfo.69.1586879767610;
        Tue, 14 Apr 2020 08:56:07 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id b2sm11408534ljp.63.2020.04.14.08.56.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Apr 2020 08:56:06 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v5 0/3] Extend coverage of "trace-cmd reset" command
Date:   Tue, 14 Apr 2020 18:56:01 +0300
Message-Id: <20200414155604.31401-1-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

The "trace-cmd reset" command is supposed to set the ftrace state to default.
However, some ftrace configurations are not reseted: synthetic events and
error_log file. The command is extended to clean these.
Two new tracefs APIs were also implemented, to check if given ftrace
file / directory exists:
  bool tracefs_file_exist(struct tracefs_instance *instance, char *name);
  bool tracefs_dir_exist(struct tracefs_instance *instance, char *name);

[
 v5 changes:
   Removed accepted patches from the set
   Address Steven's comments
 v4 chanegs:
   Implemented new tracefs APIs to check if given ftrace file /
   directory exists. Use the new APIs to check if synthetic_events and
   error_log files exist, before accessing them.
 v3 changes:
    Remove the warning in case there are no configured synthetic events.
 v2 changes:
    Removed these patches from the "SQL-like syntax for ftrace histograms
    configuration" patch set, as they are not directly related to it.
]

Tzvetomir Stoyanov (VMware) (3):
  trace-cmd: Add new tracefs APIs for checking if a ftrace file /
    directory exists
  trace-cmd: Unit tests for new libtracefs APIs
  trace-cmd: Clear error log on reset subcommand

 include/tracefs/tracefs.h      |  3 +++
 lib/tracefs/tracefs-instance.c | 46 +++++++++++++++++++++++++++++++++-
 tracecmd/trace-record.c        | 23 +++++++++++++++++
 utest/tracefs-utest.c          | 16 ++++++++++++
 4 files changed, 87 insertions(+), 1 deletion(-)

-- 
2.25.1

