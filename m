Return-Path: <SRS0=sbuk=WY=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.7 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1303AC3A5A1
	for <linux-trace-devel@archiver.kernel.org>; Wed, 28 Aug 2019 11:25:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D73F22173E
	for <linux-trace-devel@archiver.kernel.org>; Wed, 28 Aug 2019 11:25:02 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="JiI2NwwS"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726555AbfH1LZC (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 28 Aug 2019 07:25:02 -0400
Received: from mail-wm1-f66.google.com ([209.85.128.66]:55310 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726382AbfH1LZC (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 28 Aug 2019 07:25:02 -0400
Received: by mail-wm1-f66.google.com with SMTP id f72so2368897wmf.5
        for <linux-trace-devel@vger.kernel.org>; Wed, 28 Aug 2019 04:25:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=ety9y5ggkXxa+ZJ775dgzyp7oKia2uaPH30UxM41wds=;
        b=JiI2NwwSmTFQ6Gh4JHlBzdQqdpubpmhYCOpd1E63Qu8PXrXm5UT1M29JkiFSO6HZX6
         YVEAxvuoqJ1N8RoAG9dYY6qjeX+A/8/Nfn8vwHLqj0QmXxcORYqNWYSsNGSLp5kPQCKA
         cnn7gQZ6Oe3oPtWyErSc4b5AOhzk2HwhHbrcA+l+09aM9MavNtuwhOwZyZ4yIZeOyfvt
         BQaVwkowwsuu9issoIi9ITtzwwCWL/L9a+f2mNOyloqYx+tCt/XxpbAU4BVt7Oy3+1sj
         WSZ0l1MN93uSFb1QmcKzK9e3NF1x9ET/L2TjUzNwOoBxUhWrAy0ya+Kf+gpTe3EtcUDf
         GXhw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=ety9y5ggkXxa+ZJ775dgzyp7oKia2uaPH30UxM41wds=;
        b=Re6gHcb0pyBY8QVArRWxzLGA5JpTgLvP5xiEFJfEPrzGF42yqoAKFywP9FmP8MYFMG
         /g7OKRzqkMMzsipqeQqqZCbfDdaiDAFsDDUnbLFwwpEOR93VG4xD98X8zGGcDpZhD5Xw
         8XKvMJ8T2UXnOOnFCNHbjhVNZ4ufGsoZvG4f0ERbnSkmAjel+ZO849Fhq1dFrsBkxsZr
         Mn5P+7JQGMyYvRgciGlNplObfhTcIRaroEyeREgG/dgcZZHN7nLYOY/aa6zk6Wg7KH2J
         v2ORX2b36mo96agNZBMEBYifqdKlkF27I4ijPql+rEnycVRzlNpeNt1pwR6U1TZAno8r
         znSg==
X-Gm-Message-State: APjAAAVSNxavdS/yOXY1QKgdP5L+QBIABZz17I3+UzW4wzIgBDtHg4xV
        n+6sfCxo0k7sCxL2m246IAnp+auw
X-Google-Smtp-Source: APXvYqz62L+N1QzpI0PdQ122cSYS/1h9KTfxVwuxHCbnR2OKF9+6OSsUVocvFKSZDJeHDbPGdOUsHw==
X-Received: by 2002:a1c:ef18:: with SMTP id n24mr756002wmh.29.1566991500441;
        Wed, 28 Aug 2019 04:25:00 -0700 (PDT)
Received: from oberon.eng.vmware.com ([146.247.46.5])
        by smtp.gmail.com with ESMTPSA id c132sm2846766wme.27.2019.08.28.04.24.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Aug 2019 04:24:59 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v6 0/3] Add new trace-cmd record options: "--proc-map"
Date:   Wed, 28 Aug 2019 14:24:54 +0300
Message-Id: <20190828112457.10533-1-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.21.0
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
   v6 changes:
        - Added warning message when allocation of pids array fails.
	- Put extra brackets around complex blocks in record_trace(),
          as Steven Rostedt suggested.
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


Tzvetomir Stoyanov (VMware) (3):
  trace-cmd: Extend ptrace logic to work with multiple filtered pids
  trace-cmd: Save the tracee address map into the trace.dat file.
  trace-cmd: Add option to execute traced process as given user

 Documentation/trace-cmd-record.1.txt |   6 +
 include/trace-cmd/trace-cmd.h        |  10 +
 lib/trace-cmd/trace-input.c          | 172 +++++++++++++++-
 tracecmd/include/trace-local.h       |  10 +
 tracecmd/trace-record.c              | 286 +++++++++++++++++++++++++--
 tracecmd/trace-usage.c               |   2 +
 6 files changed, 468 insertions(+), 18 deletions(-)

-- 
2.21.0

