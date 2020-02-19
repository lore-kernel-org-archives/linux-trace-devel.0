Return-Path: <SRS0=qXaB=4H=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 18A9CC34047
	for <linux-trace-devel@archiver.kernel.org>; Wed, 19 Feb 2020 13:15:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E051921D56
	for <linux-trace-devel@archiver.kernel.org>; Wed, 19 Feb 2020 13:15:28 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="XusWHAs9"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726891AbgBSNP2 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 19 Feb 2020 08:15:28 -0500
Received: from mail-lj1-f196.google.com ([209.85.208.196]:39751 "EHLO
        mail-lj1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726558AbgBSNP2 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 19 Feb 2020 08:15:28 -0500
Received: by mail-lj1-f196.google.com with SMTP id o15so317940ljg.6
        for <linux-trace-devel@vger.kernel.org>; Wed, 19 Feb 2020 05:15:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=jnJYC0dcbC4encScPEskFb3vaFzEZGHtMwSrkgF4W/c=;
        b=XusWHAs99kv6ATRlBGB4oeVLY9fJcuh8K3fs7KuP/E2ByZgDiTyrQYBLXRUfWqEnB4
         Uk6k2yuCmGEAr+iG2wO5XfFyRvZR2cgL33lnAiKqKW1rVZGDekIti+yRjHh3nszpoevv
         wMGX3SnyIQxl7XLxI7QFlHmh3sLkY6d4heBV0eg0XhgBJtdDxl88O0wu15Ia6UtD0yOp
         bE3mNZdhNMjIsld6ec9iXVqsgfBIIkpXk2lO6DDKmH2t2/emWQdlOdoFpDbS23rJSgSO
         Vq1+K1h78T6OjpdrXWrPybA8siUFmsbnhH30rJJKatZYnZq9egdNHdfcV7opQMJohs8W
         93bw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=jnJYC0dcbC4encScPEskFb3vaFzEZGHtMwSrkgF4W/c=;
        b=sde1YIHLMyplB5q3zGCCRoHwswqKwK32hM49sKd2o8rkO9MXcfeVVwclLTS4F8Lz4j
         l3c2KV5boGeQ/SYELJhYNgVknyQ/TZSyWSDZ4/KbgzU+EHHvw3O+5pRPy/wxm+8XFiEm
         S2LFpl+PrO+ZpzDhGVRgxKOlqj/Tgupaw+1AA5ng7NR7fBbgSGu4ShpxMkHZkRh82W7T
         T2+oi/fze8ICBgIIi+DapHA8cPS/ULRnYLGvt6J8L9BdNdsKL2uRoUvsvuTqhf4Zpzbf
         PbprV771nGML5hU2H1I4P3tejPUwiC/ZttebdPpnCqOk3uLQM0Co0MnIJNmyLtFAnAeW
         gyKA==
X-Gm-Message-State: APjAAAUtX0mlE5WGf+9Y4ckAEt2NnX+7owfSjkfjqP06jen7wD2lU3xk
        nYQLdCGOt/vWSrGCMSceDyWcrZvs
X-Google-Smtp-Source: APXvYqwX67ayFFEMfEPN+ic8Z/9LBvoxY7XxLkOIxH/Hsm5/HBCcHni3jFUslGnu5FuMKrAwApERmA==
X-Received: by 2002:a2e:8907:: with SMTP id d7mr16386304lji.71.1582118126435;
        Wed, 19 Feb 2020 05:15:26 -0800 (PST)
Received: from localhost.localdomain ([151.251.253.122])
        by smtp.gmail.com with ESMTPSA id f11sm1482766lfa.9.2020.02.19.05.15.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Feb 2020 05:15:25 -0800 (PST)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v2 0/2] trace-cmd: SQL-like syntax for ftrace histograms configuration
Date:   Wed, 19 Feb 2020 15:15:21 +0200
Message-Id: <20200219131523.447352-1-tz.stoyanov@gmail.com>
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

[
 v2 changes:
  - Removed patches for trace-cmd reset sub command from this patch set, as
    they are not directly related to the SQL-like syntax implementation.
  - Fixed the use case with more than one "--sql" argument. Added logic to
    clean up the parser state before parsing a new string.
  - Implemented API for freeing all resources, allocated by the parser.
  - Fixed the use case with ftrace instances.
]

Tzvetomir Stoyanov (VMware) (2):
  trace-cmd: Add new libtracefs API tracefs_instance_file_append()
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
 tracecmd/sqlparser/sqlhist-parse.c   | 1539 ++++++++++++++++++++++++++
 tracecmd/sqlparser/sqlhist.h         |   34 +
 tracecmd/sqlparser/sqlhist.l         |   59 +
 tracecmd/sqlparser/sqlhist.y         |  175 +++
 tracecmd/trace-record.c              |  121 +-
 tracecmd/trace-usage.c               |    2 +
 14 files changed, 2100 insertions(+), 7 deletions(-)
 create mode 100644 tracecmd/sqlparser/Makefile
 create mode 100644 tracecmd/sqlparser/sqlhist-api.h
 create mode 100644 tracecmd/sqlparser/sqlhist-parse.c
 create mode 100644 tracecmd/sqlparser/sqlhist.h
 create mode 100644 tracecmd/sqlparser/sqlhist.l
 create mode 100644 tracecmd/sqlparser/sqlhist.y

-- 
2.24.1

