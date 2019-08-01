Return-Path: <SRS0=bY76=V5=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D58C7C433FF
	for <linux-trace-devel@archiver.kernel.org>; Thu,  1 Aug 2019 07:50:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9D0682087E
	for <linux-trace-devel@archiver.kernel.org>; Thu,  1 Aug 2019 07:50:05 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="kzvz/yvs"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727837AbfHAHuF (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 1 Aug 2019 03:50:05 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:40651 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725946AbfHAHuF (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 1 Aug 2019 03:50:05 -0400
Received: by mail-wr1-f66.google.com with SMTP id r1so72436909wrl.7
        for <linux-trace-devel@vger.kernel.org>; Thu, 01 Aug 2019 00:50:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=7/WtxHwf1PtGtAyi9cdBzrEh6nGXbw8Dxi9/QmC/nLQ=;
        b=kzvz/yvsv71dWfAnXmE+DLoc1CENZq5VHdqVvO7zXRc1s0rzkJmh6so73ZO8EXcmhw
         jlMHYIptMwi+3OMw2vjD5BnlKSfxotlvSZ8bCwf5Ous1egWkaMWQgROz3V6lY1rPrcRD
         /YyKSyJtSHIh6730Ymqaa2vWoIXGiUndkWlmZYWk5/MQPD/bJnA1FMwr+VT1e7LJ4oh1
         rrUhT4IesSamMS4MrZReYvRk8wNtaihRF8JfB4HJsvEstIxqu9gP9/Rz73QUrrVo1I/K
         sc2hHdxQ8uMoQPdqCmrBxm4MhFCI1OuB0JLIkMRG9+rrF09kFLsVzLY1iTgNx/jTRhhR
         Eh7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=7/WtxHwf1PtGtAyi9cdBzrEh6nGXbw8Dxi9/QmC/nLQ=;
        b=JsfnLcm7k+SmQ4T9UjWwjoc5BEQGJKZv52LlZ/CmeEYfVLE3/sWQkaqiCLElLAPM0B
         AaLgOuIcsVPP5AyKz7nrFnz5c+gBMZqqfaA1vjcp9PlKCNALWn9yjid3+wgwDzuu6csz
         kBrcG4gpUIHru3tN/Ab5192HDDEXysocnGXZL87N9l5fMB6pbO/msWV3dvfZLxWeKygN
         1MCJTcPETyA+Tc64bBj4SB6FYEz0Vk5dN9PbDs9NRz29sjb7gSdc5bXi4LlKBdMUa3tI
         +Jb7u1z0jQClU1TqVXymLIVzF347OEShToSh3NxBi9wevOYAX3GG5RfYl6F0j8tDIyb5
         OCnA==
X-Gm-Message-State: APjAAAW+7B5ElTlbdUUenvGiliy1iIAenwByHTTi8TdLgju1B8kQVNkq
        bwHqucKYjdbqFLiXjmzPqmUUdFJeDJ0=
X-Google-Smtp-Source: APXvYqzngRP6RN3C8kvVBT6EjobJhkGfPJXiQxPnIAqvc/xzXnzHlcXPMjNFMDKwrbPWqKcUVe49+A==
X-Received: by 2002:a5d:5450:: with SMTP id w16mr91320867wrv.128.1564645802791;
        Thu, 01 Aug 2019 00:50:02 -0700 (PDT)
Received: from oberon.eng.vmware.com ([146.247.46.5])
        by smtp.gmail.com with ESMTPSA id u2sm4033483wmc.3.2019.08.01.00.50.01
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Thu, 01 Aug 2019 00:50:01 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v3 0/3] Changes in few libtraceevent APIs
Date:   Thu,  1 Aug 2019 10:49:56 +0300
Message-Id: <20190801074959.22023-1-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Before releasing libtraceevent as a standalone library, few
APIs must be changed:
 - Event printing interface is redesigned, to be more simple
   and user friendly. Now the tep_print_event() API can be used 
   to print various event information. All other event print APIs
   are removed.
 - Changed the user's plugin directory to 
   ~/.local/lib/traceevent/plugins/ to be XDG compliant.

[
 v3 changes:
   - The user's plugin directory is changed to ~/.local/lib/traceevent/plugins/,
     as Patrick McLean suggested.
   - New tep_print_event() item is added - TEP_PRINT_INFO_RAW, to print
     event information in raw format.
   - Removed prefix "tep_" from newly added static functions and few
     other changes, suggested by Steven Rostedt.
]
 
Tzvetomir Stoyanov (3):
  tools/lib/traceevent, tools/perf: Changes in tep_print_event_* APIs
  tools/lib/traceevent: Remove tep_register_trace_clock()
  tools/lib/traceevent: Change user's plugin directory

 tools/lib/traceevent/Makefile            |   6 +-
 tools/lib/traceevent/event-parse-api.c   |  40 ---
 tools/lib/traceevent/event-parse-local.h |   6 -
 tools/lib/traceevent/event-parse.c       | 333 +++++++++++++----------
 tools/lib/traceevent/event-parse.h       |  30 +-
 tools/lib/traceevent/event-plugin.c      |   2 +-
 tools/perf/builtin-kmem.c                |   3 +-
 tools/perf/util/sort.c                   |   3 +-
 tools/perf/util/trace-event-parse.c      |   2 +-
 9 files changed, 207 insertions(+), 218 deletions(-)

-- 
2.21.0

