Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8C290C433E0
	for <linux-trace-devel@archiver.kernel.org>; Wed, 23 Dec 2020 04:35:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6269320936
	for <linux-trace-devel@archiver.kernel.org>; Wed, 23 Dec 2020 04:35:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726361AbgLWEfN (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 22 Dec 2020 23:35:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56752 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726288AbgLWEfM (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 22 Dec 2020 23:35:12 -0500
Received: from mail-wm1-x32a.google.com (mail-wm1-x32a.google.com [IPv6:2a00:1450:4864:20::32a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 658BBC0613D3
        for <linux-trace-devel@vger.kernel.org>; Tue, 22 Dec 2020 20:34:32 -0800 (PST)
Received: by mail-wm1-x32a.google.com with SMTP id q75so4983594wme.2
        for <linux-trace-devel@vger.kernel.org>; Tue, 22 Dec 2020 20:34:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=oXFBQKCi/ut7hA1NhIS9Y6epSTyjelPSedCRYSg2F8w=;
        b=hcgC0ArQYarc7EuPIuhI8h0fAIs1S16NV8tEAm/8saAgeNy5JM4nkpUH+DcAh3aGb4
         eEHsUmOqu47cun4Ipv4fwHJsH2X1GS0m8Xp6CrLDBfN7bAS7brF746tjNDFmEaGc4ALj
         LDfS/hd0eS+50qd2njSYsu8fJ3g0IecIyoi1H1kP+9iK81VKaS9lN5wrQwMMeHTdciO2
         6gzeymugTeM3GEWNkuleg9Qkhiwl5EQb53WsSFDb7J1dlkbHh72bhGCxlgdXmi+zb8c5
         3qlCpX7vryFdHSaCl1U7M218dprHl6Q+6XXpk62l2deI1jM5D3BRJe9xBRlnxgmTILla
         re/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=oXFBQKCi/ut7hA1NhIS9Y6epSTyjelPSedCRYSg2F8w=;
        b=NHEfc2vlUHj0eI4gnapZl+SZGSter92hdElN3wczPDlrvgLKequpurLcoaHyaIGWeZ
         I/XjWyw2kXfehA+5rixwixAQ3dZHyEy0BdaSqQMFatO2KA1mOZgB6o1rcfi8xDgKFyif
         btE4w4tbb3Yzx7iJuLnKK/v6rNJZaA/RJxStJgytJ0WchZBqLjdh7VTJtN/SAWfmAiHK
         tbiohiWTZQ+zsYvBjJnAcVRzS+8gIjnCntA45RdXwyfAMEIEB4U+GYaixTFt6MfpLB+E
         vPhUxYEgjL7xFU0Ax6zAJtYp5+cmo//2zOVBQfLqWX/2K1o/6WbQNdi+OYqNNWEKWWs3
         +EVA==
X-Gm-Message-State: AOAM530F5j2Bq2fts2z39InO027gn6nTROZXJm+5mdYiTIvVWNeTP0og
        1jevBfov0jyG3uAMZZYYJGv4nDQf8mtiV/lw
X-Google-Smtp-Source: ABdhPJwmTPHxrKLrSvJWEtYtiIKdwUce0PeH0PH1rU5ag8Fqx60HyaX7aSd7jYSuq+rBfp+RWXw8yA==
X-Received: by 2002:a1c:bc88:: with SMTP id m130mr25280573wmf.82.1608698071055;
        Tue, 22 Dec 2020 20:34:31 -0800 (PST)
Received: from oberon.vmware.com ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id s13sm28909095wmj.28.2020.12.22.20.34.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Dec 2020 20:34:30 -0800 (PST)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH 0/6] libtracecmd man pages.
Date:   Wed, 23 Dec 2020 06:34:23 +0200
Message-Id: <20201223043429.586162-1-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.28.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Initial implementation of libtracecmd man pages.

Tzvetomir Stoyanov (VMware) (6):
  trace-cmd: libtracecmd man pages
  trace-cmd: Update the RESOURCES section of the trace-cmd man pages
  trace-cmd library man pages: Read recorded events from a trace file.
  trace-cmd library man pages: Open and close trace file.
  trace-cmd library man pages: Manage trace session with multiple trace
    peers.
  trace-cmd library man pages: Read tracing instances from a trace file.

 Documentation/Makefile                        |  97 ++---------
 Documentation/libtracecmd/Makefile            |  34 ++++
 .../libtracecmd/libtracecmd-files.3.txt       |  92 +++++++++++
 .../libtracecmd/libtracecmd-instances.3.txt   | 129 +++++++++++++++
 .../libtracecmd/libtracecmd-peer.3.txt        | 149 +++++++++++++++++
 .../libtracecmd/libtracecmd-record.3.txt      | 152 ++++++++++++++++++
 Documentation/libtracecmd/libtracecmd.3.txt   |  83 ++++++++++
 Documentation/trace-cmd/Makefile              |  44 +++++
 .../trace-cmd-check-events.1.txt              |   2 +-
 .../{ => trace-cmd}/trace-cmd-clear.1.txt     |   2 +-
 .../{ => trace-cmd}/trace-cmd-dump.1.txt      |   2 +-
 .../{ => trace-cmd}/trace-cmd-extract.1.txt   |   2 +-
 .../{ => trace-cmd}/trace-cmd-hist.1.txt      |   2 +-
 .../{ => trace-cmd}/trace-cmd-list.1.txt      |   2 +-
 .../{ => trace-cmd}/trace-cmd-listen.1.txt    |   2 +-
 .../{ => trace-cmd}/trace-cmd-mem.1.txt       |   2 +-
 .../{ => trace-cmd}/trace-cmd-options.1.txt   |   2 +-
 .../{ => trace-cmd}/trace-cmd-profile.1.txt   |   2 +-
 .../{ => trace-cmd}/trace-cmd-record.1.txt    |   2 +-
 .../{ => trace-cmd}/trace-cmd-report.1.txt    |   2 +-
 .../{ => trace-cmd}/trace-cmd-reset.1.txt     |   2 +-
 .../{ => trace-cmd}/trace-cmd-restore.1.txt   |   2 +-
 .../{ => trace-cmd}/trace-cmd-set.1.txt       |   2 +-
 .../{ => trace-cmd}/trace-cmd-show.1.txt      |   2 +-
 .../{ => trace-cmd}/trace-cmd-snapshot.1.txt  |   2 +-
 .../{ => trace-cmd}/trace-cmd-split.1.txt     |   2 +-
 .../{ => trace-cmd}/trace-cmd-stack.1.txt     |   2 +-
 .../{ => trace-cmd}/trace-cmd-start.1.txt     |   2 +-
 .../{ => trace-cmd}/trace-cmd-stat.1.txt      |   2 +-
 .../{ => trace-cmd}/trace-cmd-stop.1.txt      |   2 +-
 .../{ => trace-cmd}/trace-cmd-stream.1.txt    |   2 +-
 Documentation/{ => trace-cmd}/trace-cmd.1.txt |   2 +-
 .../{ => trace-cmd}/trace-cmd.dat.5.txt       |   2 +-
 scripts/utils.mk                              |  42 +++++
 34 files changed, 761 insertions(+), 111 deletions(-)
 create mode 100644 Documentation/libtracecmd/Makefile
 create mode 100644 Documentation/libtracecmd/libtracecmd-files.3.txt
 create mode 100644 Documentation/libtracecmd/libtracecmd-instances.3.txt
 create mode 100644 Documentation/libtracecmd/libtracecmd-peer.3.txt
 create mode 100644 Documentation/libtracecmd/libtracecmd-record.3.txt
 create mode 100644 Documentation/libtracecmd/libtracecmd.3.txt
 create mode 100644 Documentation/trace-cmd/Makefile
 rename Documentation/{ => trace-cmd}/trace-cmd-check-events.1.txt (94%)
 rename Documentation/{ => trace-cmd}/trace-cmd-clear.1.txt (95%)
 rename Documentation/{ => trace-cmd}/trace-cmd-dump.1.txt (98%)
 rename Documentation/{ => trace-cmd}/trace-cmd-extract.1.txt (97%)
 rename Documentation/{ => trace-cmd}/trace-cmd-hist.1.txt (95%)
 rename Documentation/{ => trace-cmd}/trace-cmd-list.1.txt (97%)
 rename Documentation/{ => trace-cmd}/trace-cmd-listen.1.txt (95%)
 rename Documentation/{ => trace-cmd}/trace-cmd-mem.1.txt (98%)
 rename Documentation/{ => trace-cmd}/trace-cmd-options.1.txt (91%)
 rename Documentation/{ => trace-cmd}/trace-cmd-profile.1.txt (99%)
 rename Documentation/{ => trace-cmd}/trace-cmd-record.1.txt (99%)
 rename Documentation/{ => trace-cmd}/trace-cmd-report.1.txt (99%)
 rename Documentation/{ => trace-cmd}/trace-cmd-reset.1.txt (98%)
 rename Documentation/{ => trace-cmd}/trace-cmd-restore.1.txt (98%)
 rename Documentation/{ => trace-cmd}/trace-cmd-set.1.txt (99%)
 rename Documentation/{ => trace-cmd}/trace-cmd-show.1.txt (97%)
 rename Documentation/{ => trace-cmd}/trace-cmd-snapshot.1.txt (95%)
 rename Documentation/{ => trace-cmd}/trace-cmd-split.1.txt (97%)
 rename Documentation/{ => trace-cmd}/trace-cmd-stack.1.txt (94%)
 rename Documentation/{ => trace-cmd}/trace-cmd-start.1.txt (95%)
 rename Documentation/{ => trace-cmd}/trace-cmd-stat.1.txt (96%)
 rename Documentation/{ => trace-cmd}/trace-cmd-stop.1.txt (96%)
 rename Documentation/{ => trace-cmd}/trace-cmd-stream.1.txt (95%)
 rename Documentation/{ => trace-cmd}/trace-cmd.1.txt (97%)
 rename Documentation/{ => trace-cmd}/trace-cmd.dat.5.txt (99%)

-- 
2.28.0

