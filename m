Return-Path: <SRS0=gJb8=4N=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2A718C35E01
	for <linux-trace-devel@archiver.kernel.org>; Tue, 25 Feb 2020 18:07:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 01DEB206E6
	for <linux-trace-devel@archiver.kernel.org>; Tue, 25 Feb 2020 18:07:40 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="tO5sA+w9"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728367AbgBYSHk (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 25 Feb 2020 13:07:40 -0500
Received: from mail-lj1-f195.google.com ([209.85.208.195]:40299 "EHLO
        mail-lj1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727983AbgBYSHk (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 25 Feb 2020 13:07:40 -0500
Received: by mail-lj1-f195.google.com with SMTP id n18so15088477ljo.7
        for <linux-trace-devel@vger.kernel.org>; Tue, 25 Feb 2020 10:07:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=leVvPJ2nhMZF38DYif7VEYS+o6O/a3fvu5zarB0zgvU=;
        b=tO5sA+w9HROZtS9fQiU0IfYj8q40ia1uQ3LyrrShy8fqS/GGUDdMRrC6Hnme2skvTh
         HDLIo7Yb/KDIy6IcLvk5dluZOF8C+0kuSp5xtdhHxqb/ka9SsXM2EZDv91kBpy9T6I9B
         McwiDzDRZk9RIw9unz62MrjKG+fhDO0G+xiapjtPf3CQdoKU2a/yUPgqnRIbc+evCskJ
         6Q0wwwjiDsxoiz00goF677Yo9JOrJa4Oc8m3vant3VnLXIBxuWUvcbKeiIqv1NqHyR8G
         HaIOT9MsfEUShZowRsavLdoOO03r6S7NYtXcnrQewt5qTOaoU2F14GGngNuVkP81eBos
         3qxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=leVvPJ2nhMZF38DYif7VEYS+o6O/a3fvu5zarB0zgvU=;
        b=XHQq6rnK9rcA5Dlh7VRz3Iop3i4l9tVdAPHqDI+Q6n9wmWpJkL4+d7DCcOXVaUh7tH
         Zm+hyqXPTU8IIngHY1ybMDXlppsMiO3Vu2VjZAeeAyqfUzxvO3k4laj+NGcOmGNfb079
         XQbVjz9l+CSAuUFnpIrJzc/1OXRSkeGwwAlQu7QmvgiWQuIwbwv5UUhOF9l7UcJ0YnIE
         IHetnt39i9cc3+YZ7Frb4bZRLxVfmuAYNoyslflYLzEU3OETrvJbVl+4ZKDhU1QygVQf
         Jk9nTDu03JPl+pksUc/6sk2rJ18l6x37lBO3ws9cTVb5wB9E2hnpNbdIcYxU2QKdim6b
         ZEKg==
X-Gm-Message-State: APjAAAWRY7mYy95ylOm2pIHLKkhdUenczNfa23UfNK2PUDcGOxA8gD+Z
        n+JUu5mEgOB/FWZia3LwvHq6njelqPQ=
X-Google-Smtp-Source: APXvYqzp0LztfNSWzk9lFzOKiKaL33Bu3NbIOPbMT8kUFbQKpXF7kAqBAthzkQbbeoDteLP9jwYR/Q==
X-Received: by 2002:a2e:8e91:: with SMTP id z17mr163106ljk.13.1582654058163;
        Tue, 25 Feb 2020 10:07:38 -0800 (PST)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id v15sm4141438lfg.51.2020.02.25.10.07.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Feb 2020 10:07:37 -0800 (PST)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v4 0/4] Extend coverage of "trace-cmd reset" command
Date:   Tue, 25 Feb 2020 20:07:29 +0200
Message-Id: <20200225180733.89344-1-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.24.1
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
 v2 changes:
  - Removed these patches from the "SQL-like syntax for ftrace histograms
    configuration" patch set, as they are not directly related to it.
 v3 changes:
  - Remove the warning in case there are no configured synthetic events.
 v4 chanegs:
 - Implemented new tracefs APIs to check if given ftrace file /
   directory exists. Use the new APIs to check if synthetic_events and
   error_log files exist, before accessing them.
]

Tzvetomir Stoyanov (VMware) (4):
  trace-cmd: Add new tracefs APIs for checking if a ftrace file /
    directory exists
  trace-cmd: Unit tests for new libtracefs APIs
  trace-cmd: Clear synthetic events on reset subcommand
  trace-cmd: Clear error log on reset subcommand

 include/tracefs/tracefs.h      |  3 ++
 lib/tracefs/tracefs-instance.c | 49 ++++++++++++++++++++++++++-
 tracecmd/trace-record.c        | 61 ++++++++++++++++++++++++++++++++++
 utest/tracefs-utest.c          | 16 +++++++++
 4 files changed, 128 insertions(+), 1 deletion(-)

-- 
2.24.1

