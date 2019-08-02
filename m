Return-Path: <SRS0=4i+i=V6=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EBA4CC433FF
	for <linux-trace-devel@archiver.kernel.org>; Fri,  2 Aug 2019 11:01:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B2F6D206A3
	for <linux-trace-devel@archiver.kernel.org>; Fri,  2 Aug 2019 11:01:07 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Pt1pHu0r"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729493AbfHBLBH (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 2 Aug 2019 07:01:07 -0400
Received: from mail-wm1-f68.google.com ([209.85.128.68]:54634 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729430AbfHBLBH (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 2 Aug 2019 07:01:07 -0400
Received: by mail-wm1-f68.google.com with SMTP id p74so67507984wme.4
        for <linux-trace-devel@vger.kernel.org>; Fri, 02 Aug 2019 04:01:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=CB/VEzv5MeTRH5BLAlLjRJrdUvPpTf1WvB41du/bduA=;
        b=Pt1pHu0rAK7PcuTjoPyx6XBfNjDgseTfHe7PaltnzGnG+zZeZYU9m2JWMxDajahfDL
         QIMKzSQpeNPDEwSgUY6ABZ/Mu6jwyKDhZ5y9iolK0OAUNy7sizGJAhB7marne1FILxX0
         ipkaMcFTJ5i+4NDaBgL3s7WcapxIMjKWDa9Gs5l/Lsd7dJTBayKgtUk1pXEtiXhunQnV
         7y7OWKbTXYBz72DSiPKnIHBGLOnKvxaSZHX+hXFkbplVY97cgPEh59a9WmiB4j+kc7w4
         kCqY+BlpJWHgKYRacax5t13Ab1RQArxyJ6LkW8aMqmHsEzOO/U8pXTuioxUJMXenX7Zu
         Lx3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=CB/VEzv5MeTRH5BLAlLjRJrdUvPpTf1WvB41du/bduA=;
        b=Dt/85p1gYRXde8WzVe2KZgXegCfKPm71SrpDKiNYP43HYqsxoPBY4/sFkEMahBfoWt
         4fVibhiHGL3NHd5s5obzbtHCJsXcZQcV5YnvWde+wo43AZxmOGdfnXSZZYexmv952plD
         /No0jCKeua+2SsOUNfpeoY2sdohDWEpi7bHMCQhm8HCo1nbq9f4vqAQg7creREFq9Me+
         e04Bexdc/eIynikZWOzkvb5f02LB3mVdEO7MAWxEWWyigJ0ThGTVLHcQ3H6ZlrOKZyNz
         CoMfkr7rMpq4BTW/BOLWNqBDkDIXDt02Yu8SJosPvu3VLsEgnJgfMShV5r044lNTsAux
         dlTQ==
X-Gm-Message-State: APjAAAVr2x9VV1ElPprW8BH+mus92Uxj9RUNHTLpIgG9C6C3wGkSDi2v
        25GIGi6ExQW5N5uqAPcCWdSiNdXKB1E=
X-Google-Smtp-Source: APXvYqwxcP5MkWOCaAMs0ifP+Ig7CLVXemBzCNnADKvFF1jmSzouTpgzd1txUZpsKVdt1j7SUx4mww==
X-Received: by 2002:a7b:cd94:: with SMTP id y20mr4285197wmj.94.1564743664882;
        Fri, 02 Aug 2019 04:01:04 -0700 (PDT)
Received: from oberon.eng.vmware.com ([146.247.46.5])
        by smtp.gmail.com with ESMTPSA id r15sm79511433wrj.68.2019.08.02.04.01.02
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Fri, 02 Aug 2019 04:01:03 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v2 0/6] Remove redundant trace-cmd plugin handling logic
Date:   Fri,  2 Aug 2019 14:00:55 +0300
Message-Id: <20190802110101.14759-1-tz.stoyanov@gmail.com>
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

All existing plugins are moved from plugins/ to plugins/traceevent/
directory, as all of them (except plugin_python) are designed to be
used with the traceevent library. This change paves the way for
implementing trace-cmd specific plugins.

Tzvetomir  Stoyanov (VMware) (1):
  trace-cmd: Remove trace-cmd plugin handling routines

Tzvetomir Stoyanov (1):
  trace-cmd: Change plugin install directories

Tzvetomir Stoyanov (VMware) (4):
  trace-cmd: Move kernel_stack event handler to "function" plugin.
  trace-cmd: Move plugin options from trace-cmd to libtraceevent.
  trace-cmd: Move libtraceevent plugins in its own directory.
  trace-cmd: Load libtraceevent plugins from build folder, if exists.

 .gitignore                                    |   2 +-
 Makefile                                      |  44 +-
 include/trace-cmd/trace-cmd.h                 |  24 -
 include/traceevent/event-parse.h              |   8 +
 kernel-shark/src/libkshark.c                  |   4 +-
 lib/trace-cmd/Makefile                        |   2 -
 lib/trace-cmd/trace-ftrace.c                  |  56 +-
 lib/trace-cmd/trace-input.c                   |   9 +-
 lib/trace-cmd/trace-util.c                    | 752 +-----------------
 lib/traceevent/event-plugin.c                 | 226 +++++-
 plugins/{ => traceevent}/Makefile             |  12 +-
 plugins/{ => traceevent}/plugin_blk.c         |   0
 plugins/{ => traceevent}/plugin_cfg80211.c    |   0
 plugins/{ => traceevent}/plugin_function.c    |  45 +-
 plugins/{ => traceevent}/plugin_futex.c       |   0
 plugins/{ => traceevent}/plugin_hrtimer.c     |   0
 plugins/{ => traceevent}/plugin_jbd2.c        |   0
 plugins/{ => traceevent}/plugin_kmem.c        |   0
 plugins/{ => traceevent}/plugin_kvm.c         |   0
 plugins/{ => traceevent}/plugin_mac80211.c    |   0
 plugins/{ => traceevent}/plugin_python.c      |   9 +-
 .../{ => traceevent}/plugin_sched_switch.c    |   0
 plugins/{ => traceevent}/plugin_scsi.c        |   0
 plugins/{ => traceevent}/plugin_tlb.c         |   0
 plugins/{ => traceevent}/plugin_xen.c         |   0
 tracecmd/trace-check-events.c                 |  10 +-
 tracecmd/trace-list.c                         |  23 +-
 tracecmd/trace-read.c                         |   2 +-
 28 files changed, 338 insertions(+), 890 deletions(-)
 rename plugins/{ => traceevent}/Makefile (86%)
 rename plugins/{ => traceevent}/plugin_blk.c (100%)
 rename plugins/{ => traceevent}/plugin_cfg80211.c (100%)
 rename plugins/{ => traceevent}/plugin_function.c (79%)
 rename plugins/{ => traceevent}/plugin_futex.c (100%)
 rename plugins/{ => traceevent}/plugin_hrtimer.c (100%)
 rename plugins/{ => traceevent}/plugin_jbd2.c (100%)
 rename plugins/{ => traceevent}/plugin_kmem.c (100%)
 rename plugins/{ => traceevent}/plugin_kvm.c (100%)
 rename plugins/{ => traceevent}/plugin_mac80211.c (100%)
 rename plugins/{ => traceevent}/plugin_python.c (91%)
 rename plugins/{ => traceevent}/plugin_sched_switch.c (100%)
 rename plugins/{ => traceevent}/plugin_scsi.c (100%)
 rename plugins/{ => traceevent}/plugin_tlb.c (100%)
 rename plugins/{ => traceevent}/plugin_xen.c (100%)

-- 
2.21.0

