Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B5007C56202
	for <linux-trace-devel@archiver.kernel.org>; Wed, 25 Nov 2020 10:44:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 53642206E0
	for <linux-trace-devel@archiver.kernel.org>; Wed, 25 Nov 2020 10:44:27 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="vFHrmp1X"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729074AbgKYKo1 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 25 Nov 2020 05:44:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33098 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727724AbgKYKo0 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 25 Nov 2020 05:44:26 -0500
Received: from mail-wr1-x443.google.com (mail-wr1-x443.google.com [IPv6:2a00:1450:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 79359C0613D4
        for <linux-trace-devel@vger.kernel.org>; Wed, 25 Nov 2020 02:44:26 -0800 (PST)
Received: by mail-wr1-x443.google.com with SMTP id 64so1395823wra.11
        for <linux-trace-devel@vger.kernel.org>; Wed, 25 Nov 2020 02:44:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=qkLUVknIRW1cGDO/G471gMABATE8oBgsFR39hwPr96s=;
        b=vFHrmp1XRC9hVH+dLJZ1iJvxt8MjnkAWII8V8+QywBG02llpQDwvrwhY1IqNl1Gh1P
         mtQbtOr44x7fhCHKzoIk5N9uI6iR4pCE8m7U4oUxmZJZ5ghETQJgRTEf4ZKKjnCBBA9C
         oCGVGTrIQF7ufOBX8OLnl5s/MwWGw6b268jT8NnDN8BYKDXbw6DLk2dfvwbcnYBP5Pg6
         gFBcojoJztv9yElvxXq2iOXT1a2SxIG01RARUu1805gJ3Cd8yzcWC2U3SpXmDZNyCIMp
         ybKkgbtNzmYoRjS5gfuO82VX+DaUEFIi5SUzv/t2iJiDp31sl9svYiSeGgdEyZDX6r0b
         uGiQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=qkLUVknIRW1cGDO/G471gMABATE8oBgsFR39hwPr96s=;
        b=KnmHV5MGVRrw12CiL/6qCkRQsXhbASLeWdegX3lr8DzgFKYCxV5VPgR9kNwpbs1yNj
         HIM87EKJkKGmrrMzeHFk/p0LnGf1F9JOSMO1nlW+tmY5XWVcTEKS8M3K7MM/DXPTtGdg
         8aja9IG07DtCLoTCAtZ6Y4rYw/N9ZxtLYaaL5wI3PBt8/fE3mHFn19GtVrSAmdEhljnh
         1AbPlbj0mQ1FM2mu43+/pY/ulR36QNO3NL+9GjvYQfhed2oQ4Uv7zXB48jM1n/N5s65j
         VcKBwr3dRUK4cdtYwDreJBoJ0D8qVrXgarf7YAkilaxBKnYpkLUIx+Bmt4tYlkpazeT4
         mO5g==
X-Gm-Message-State: AOAM530NZDjRv8AdQR2O2l+T9vl5t8bdK6LgnjyNbEp/cFWcibfcmKI9
        xQIdmOOl3fc9FgXA6ROm89HPjFwngRWff+t7
X-Google-Smtp-Source: ABdhPJyiOSyLPVbxfHuht4fh/+Ko7BZ1Md1IbMoGYBH6MhqcX9Y6+LzzqvkJs2iqW0JNr1qnu8g8jQ==
X-Received: by 2002:adf:9b95:: with SMTP id d21mr3366789wrc.335.1606301065183;
        Wed, 25 Nov 2020 02:44:25 -0800 (PST)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id s4sm4026243wro.10.2020.11.25.02.44.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Nov 2020 02:44:24 -0800 (PST)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v3 0/3] Initial trace-cmd support for ftrace uprobes
Date:   Wed, 25 Nov 2020 12:44:19 +0200
Message-Id: <20201125104422.823216-1-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.28.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Ftrace supports uprobes - trace events on user space applications.
Trace-cmd cannot configure uprobes, in order to support it this new
functionality is introduced:
 - Function name to file offset mapping, this information is extracted
  from the dwarf and ELF headers in the binary file.
 - New options are added to "trace-cmd record" for setting a uprobe on
   given file and the libraries it depends on:
    --uprobe file:function
    --uprobe-ret file:function
    --libs
    --no-libs

[
 v3 changes:
   - Added DEBUG_INTERNALS local define in trace-obj-debug.c, for printing
     debug information about resolving process.
   - Replaced function name regex match with simple wildcards match.
   - Implemented functionality to search for functions in the libraries that
     the given application depends on.
   - Added --libs and --no-libs arguments to trace-cmd record.
 v2 changes:
   - Renamed some internal trace-cmd functions, to not overlap the bfd
     library namespace. Suggested by Steven Rostedt.
]

Tzvetomir Stoyanov (VMware) (3):
  trace-cmd: Internal refactoring of pid address map logic
  trace-cmd: New internal APIs for reading ELF header
  trace-cmd: [POC] Add support for uprobes

 Makefile                       |  10 +
 tracecmd/Makefile              |   2 +
 tracecmd/include/trace-local.h |  56 +-
 tracecmd/trace-obj-debug.c     | 908 +++++++++++++++++++++++++++++++++
 tracecmd/trace-record.c        | 204 ++++----
 tracecmd/trace-uprobes.c       | 223 ++++++++
 tracecmd/trace-usage.c         |   8 +
 7 files changed, 1297 insertions(+), 114 deletions(-)
 create mode 100644 tracecmd/trace-obj-debug.c
 create mode 100644 tracecmd/trace-uprobes.c

-- 
2.28.0

