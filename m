Return-Path: <SRS0=ULQB=4F=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4A46EC34022
	for <linux-trace-devel@archiver.kernel.org>; Mon, 17 Feb 2020 17:40:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1F8CB20725
	for <linux-trace-devel@archiver.kernel.org>; Mon, 17 Feb 2020 17:40:06 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="hUrE9RhR"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729076AbgBQRkF (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 17 Feb 2020 12:40:05 -0500
Received: from mail-lj1-f178.google.com ([209.85.208.178]:34751 "EHLO
        mail-lj1-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726818AbgBQRkF (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 17 Feb 2020 12:40:05 -0500
Received: by mail-lj1-f178.google.com with SMTP id x7so19794929ljc.1
        for <linux-trace-devel@vger.kernel.org>; Mon, 17 Feb 2020 09:40:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=MgLAXY6GF/h5YkEnw5R0kEUl3Zrjl7bF2LE2CqHhyFw=;
        b=hUrE9RhRl9MwV+qfLQVfoMRP26J2v/39U1ao9d5B9IgaSyT/ZYydWiHTtpFgfbjEE3
         HLGEBZV9drsRSsFxNr60ClnANgokQ1o5koFDAN+hoN8XA4gBEH7XjXWgQMTByloiNlFu
         XYipFmUSddTEyX9bVtfE1lSyePrrpVJRZJRbqPXvPENc1OVl6snMg0WxMeunv74BjbuY
         /VHD8LNu9yspk6SVUYiEgWgC3/ZWcyGSpeD2i/828OkGltK1BCxQGnA3Z4ibNICeKYc7
         njqnTB3/wOHT9Ac5ke2rZ5T9YGTk1qQMEU/MY/oAe17R7PFTwcQRxaVKWRJhj2XnnDkC
         y+OA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=MgLAXY6GF/h5YkEnw5R0kEUl3Zrjl7bF2LE2CqHhyFw=;
        b=XaKZgDWcASSiIwtRGqPvp3M7I3qOTcMVpIsvHmfV04xEprm0PpXrm1ZO+oeMIEEOe+
         cnb4mhPY+sJh7S7Ygp47blZP21qg/uXChSLs9c/vQnqQfeBI0Z2O+54SYdc+n9AmcNW3
         HXSSihDiuO26kDhfZCQQIRpo9yVq5vl5sE38e78F8sdMWcI1GqYBCcIrowspHcxQWFen
         rlo5V1le5ibpJiCPcEa/HHiay9kFqAuPuZHS1WzZXJKcx5BR0YDqOpgeqrw9PLwqUaUJ
         3hXehINP+X8jt9qUDzVSmqFxNArQEbgWFczJnwiEqzhRjdQdp8qCfZ0t/2+TBkg7rUz/
         T8sw==
X-Gm-Message-State: APjAAAWq/JbfLinBLuhY2zJ8rvhEdGjTsdMho+h+wdeIYN9mWMybumPY
        xaQn6JEYXFmTRye/fAgZUgx+kTMyWNk=
X-Google-Smtp-Source: APXvYqwAkZECx4Yt4ujgr/KVv4f7tZP+3tBa+ALwFxeytAVvWaLh0YktwTg1S4gpex5XTVTHDJ2PHQ==
X-Received: by 2002:a2e:6817:: with SMTP id c23mr10237512lja.263.1581961203709;
        Mon, 17 Feb 2020 09:40:03 -0800 (PST)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id e8sm933508ljb.45.2020.02.17.09.40.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Feb 2020 09:40:02 -0800 (PST)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH 0/4] trace-cmd: SQL-like syntax for ftrace histograms configuration
Date:   Mon, 17 Feb 2020 19:39:55 +0200
Message-Id: <20200217173959.385278-1-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Configuration of complex ftrace histograms could be hard, using the existing ftrace interface.
The "--sql" option is implemented to simplify this task. It uses a sql-like syntax to define
the histograms and generates necessary ftrace syntetic events and triggers. Each ftrace event
represents a sql tible, while the fields of this event are rows in the table.

The patch set is based on Steven Rostedt's PoC implementation:
   https://github.com/rostedt/sqlhist

Tzvetomir Stoyanov (VMware) (4):
  trace-cmd: Add new libtracefs API tracefs_instance_file_append()
  trace-cmd: Clear synthetic events on reset subcommand
  trace-cmd: Clear error log on reset subcommand
  trace-cmd: Add "--sql" option to trace-cmd start and record sub
    commands

 Documentation/trace-cmd-record.1.txt |   37 +
 Makefile                             |    1 +
 include/tracefs/tracefs.h            |    2 +
 lib/tracefs/tracefs-instance.c       |   40 +-
 tracecmd/Makefile                    |   12 +-
 tracecmd/include/trace-local.h       |    4 +
 tracecmd/sqlparser/Makefile          |   52 +
 tracecmd/sqlparser/sqlhist-api.h     |   29 +
 tracecmd/sqlparser/sqlhist-parse.c   | 1454 ++++++++++++++++++++++++++
 tracecmd/sqlparser/sqlhist.h         |   34 +
 tracecmd/sqlparser/sqlhist.l         |   59 ++
 tracecmd/sqlparser/sqlhist.y         |  175 ++++
 tracecmd/trace-record.c              |  172 ++-
 tracecmd/trace-usage.c               |    2 +
 14 files changed, 2066 insertions(+), 7 deletions(-)
 create mode 100644 tracecmd/sqlparser/Makefile
 create mode 100644 tracecmd/sqlparser/sqlhist-api.h
 create mode 100644 tracecmd/sqlparser/sqlhist-parse.c
 create mode 100644 tracecmd/sqlparser/sqlhist.h
 create mode 100644 tracecmd/sqlparser/sqlhist.l
 create mode 100644 tracecmd/sqlparser/sqlhist.y

-- 
2.24.1

