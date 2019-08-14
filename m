Return-Path: <SRS0=RHP/=WK=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 03093C0650F
	for <linux-trace-devel@archiver.kernel.org>; Wed, 14 Aug 2019 08:47:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CF0E12083B
	for <linux-trace-devel@archiver.kernel.org>; Wed, 14 Aug 2019 08:47:28 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Goy44gOU"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725954AbfHNIr2 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 14 Aug 2019 04:47:28 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:41412 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726047AbfHNIr1 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 14 Aug 2019 04:47:27 -0400
Received: by mail-wr1-f67.google.com with SMTP id j16so8029199wrr.8
        for <linux-trace-devel@vger.kernel.org>; Wed, 14 Aug 2019 01:47:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=eO+ZlGA57I+1Xt2PS/AFx2C0VzLrMptA7460smuTgK4=;
        b=Goy44gOUDK9yfVQgs5ZaAQOyF6yLNY2a4/L1R/JmLGId3EQ1lufFeXpW7FPSGaWmoI
         Zv+1VpxINgr95oaUMy0FUJ6lopwaoruEz/xcCrWQrxW5YQDuTCnRa9Sm4SCvlSqPU3eF
         JY4fElL/ilT149siakVWUcrgV+oUQkUCqhaaDqoM8uW+TTr6U79PjjEplakiTIdimbb9
         f3mfveaVdyDx/pHrXWpFY/+FSXQxPOzzEj1bjE+gf2zaDNqCCpsDvpXkNXpYt8LA6GK0
         qDsdy/4NvZUkUAnWjwt9nYgfS/m/tfaTbDHe/EoByhFI7gAcHdPfWgeezm5DvU8Lj09D
         43rQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=eO+ZlGA57I+1Xt2PS/AFx2C0VzLrMptA7460smuTgK4=;
        b=npZkW4HhF5lj7JH5qFmN/IN05jeRMFrWtSOWbci7xO+ysjzvLrKsrwmmHp4GXjmNm7
         wujLNKAw0o4t0sxiIyCIsy9jVX9c5qX7zWi5LX5kfgsoEOqjvA8kt8iUliXnxhvOZqJV
         znBmuIu7t8WK1drNdPSKcEfti8HFQ0HOpNcZCDEWXlGkD0Oy9flNJiktO5F0MtC0UQg9
         v1oWSFFKx9+Q8UEn7l3oRVGpd+HcdwXOrvXP3rMvny+TtwINLSeBK3BhvbOQ3tjsWLBX
         hZonikOhRSZ6beLoFlzV98a7HGwTjKJYcRYYyQy2c2CzRN9rAmxyOq/mBZTQ0eGOC8tS
         HSnA==
X-Gm-Message-State: APjAAAWDukoAiNQ4UMcluN//k+q7LkBegebK096x41nA5BcQy/Z682EM
        uwYNXy94lUp/XHOvwgQYfaw=
X-Google-Smtp-Source: APXvYqwWALSXFKljtRROdlKXM85EAoLKB67oBoSJKC1UOg6bP1+kpdRrVXAM/h9G8q+SALTc3+ppcw==
X-Received: by 2002:adf:fc51:: with SMTP id e17mr48195271wrs.348.1565772445750;
        Wed, 14 Aug 2019 01:47:25 -0700 (PDT)
Received: from oberon.eng.vmware.com ([146.247.46.5])
        by smtp.gmail.com with ESMTPSA id c19sm2897481wml.13.2019.08.14.01.47.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Aug 2019 01:47:24 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v5 0/3] Add new trace-cmd record options: "--proc-map"
Date:   Wed, 14 Aug 2019 11:47:09 +0300
Message-Id: <20190814084712.28188-10-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190814084712.28188-1-tz.stoyanov@gmail.com>
References: <20190814084712.28188-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

New options to trace-cmd record are added:
  - "--proc-map" - Saves traced process(es) address map in trace.dat
    file.
  - "--user" - Executes the traced process as given user.

As "--proc-map" option uses trace-cmd ptrace logic, part of this code is
rewritten. There were some leftovers related to this logic, the code is
upadted.

[
   v5 changes:
        - Added new patch: 
            "Extend ptrace logic to work with multiple filtered pids"
          It resolves "filter_pid" leftover in ptrace related logic.
        - "--proc-map" does not depend on option -F, it works with any command,
          specified as trace-cmd argument or option -P.
        - Renamed "mmap" to "proc-map" - the option name and the names of
          the functions, variables and defines related to this feature.
   v4 changes:
	- Added check for strdup() failure.
	- Made input user string argument of change_user() and run_cmd()
	 constant.
        - Added description of the new "--mmap" trace-cmd option in the 
          program's help and the man page. (Suggested by Slavomir Kaslev)

      Problems, reported by Yordan Karadzhov:
        - Improved the parsing of /proc/<pid>/maps. Made it not so strict, as it
          failed on some machines due to different size of fields. 
        - Implemented trace_pid_mmap_free() cleanup function to free mmap
          related resources at trace-cmd exit.
        - Fixed potential problem with non-terminated string, returned by
          readlink().
        - Coding style fixes.
   v3 changes:
      - "--user" does not depend on option -F, it works with any command,
        specified as trace-cmd argument.
      - Changed tracecmd_search_task_mmap() API to return not only the library
     name, but also the start and end memory addresses.
      - Renamed *tracee* to *task*
      - Improved resources cleanup, in case of an error.
      - Removed (this) changelog from the commit message.
   v2 changes:
     - Check for errors in change_user(). If an error occurs while
       changing the user, the message is printed and the traced 
       process is not executed.
     - Replaced usage of tracecmd_add_option_v() with tracecmd_add_option() API.
     - Added checks to prevent buffer overflow when sscanf (... "%s", buf) is used.
     - Return error in case memory allocation fails.
     - Return error if option string is not in the expected format.
     - Sort memory maps and use binary search to find matching library in the map.
]

Tzvetomir Stoyanov (VMware) (3):
  trace-cmd: Extend ptrace logic to work with multiple filtered pids
  trace-cmd: Save the tracee address map into the trace.dat file.
  trace-cmd: Add option to execute traced process as given user

 Documentation/trace-cmd-record.1.txt |   6 +
 include/trace-cmd/trace-cmd.h        |  10 +
 lib/trace-cmd/trace-input.c          | 172 +++++++++++++++-
 tracecmd/include/trace-local.h       |  10 +
 tracecmd/trace-record.c              | 282 +++++++++++++++++++++++++--
 tracecmd/trace-usage.c               |   2 +
 6 files changed, 464 insertions(+), 18 deletions(-)

-- 
2.21.0

